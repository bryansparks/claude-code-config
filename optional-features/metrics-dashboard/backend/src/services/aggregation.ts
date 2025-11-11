import { db } from '../database/connection';
import { logger } from '../utils/logger';
import cron from 'node-cron';

/**
 * Metrics Aggregation Service
 *
 * Periodically refreshes materialized views and calculates aggregate statistics
 */
export class AggregationService {
  private isRunning: boolean = false;

  constructor() {}

  /**
   * Start the aggregation service with scheduled jobs
   */
  start(): void {
    logger.info('Starting Aggregation Service');

    // Refresh materialized views every hour
    cron.schedule('0 * * * *', () => {
      this.refreshMaterializedViews();
    });

    // Calculate daily aggregates at 1 AM
    cron.schedule('0 1 * * *', () => {
      this.calculateDailyAggregates();
    });

    // Check for alerts every 5 minutes
    cron.schedule('*/5 * * * *', () => {
      this.checkForAlerts();
    });

    // Run initial refresh
    this.refreshMaterializedViews();

    this.isRunning = true;
    logger.info('Aggregation Service started successfully');
  }

  /**
   * Stop the aggregation service
   */
  stop(): void {
    this.isRunning = false;
    logger.info('Aggregation Service stopped');
  }

  /**
   * Refresh all materialized views
   */
  async refreshMaterializedViews(): Promise<void> {
    try {
      logger.info('Refreshing materialized views...');

      await db.query('REFRESH MATERIALIZED VIEW CONCURRENTLY mv_team_skill_adoption');
      await db.query('REFRESH MATERIALIZED VIEW CONCURRENTLY mv_user_skill_summary');
      await db.query('REFRESH MATERIALIZED VIEW CONCURRENTLY mv_repository_quality');

      logger.info('✓ Materialized views refreshed successfully');
    } catch (error) {
      logger.error('Failed to refresh materialized views', error);
    }
  }

  /**
   * Calculate daily aggregate statistics
   */
  async calculateDailyAggregates(): Promise<void> {
    try {
      logger.info('Calculating daily aggregates...');

      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      const yesterdayStr = yesterday.toISOString().split('T')[0];

      // Calculate skill usage aggregates
      await this.calculateSkillUsageAggregates(yesterdayStr);

      // Calculate quality score aggregates
      await this.calculateQualityAggregates(yesterdayStr);

      // Calculate coverage aggregates
      await this.calculateCoverageAggregates(yesterdayStr);

      logger.info('✓ Daily aggregates calculated successfully');
    } catch (error) {
      logger.error('Failed to calculate daily aggregates', error);
    }
  }

  /**
   * Calculate skill usage aggregates for a specific date
   */
  private async calculateSkillUsageAggregates(date: string): Promise<void> {
    const query = `
      INSERT INTO daily_skill_usage_aggregates (date, skill_id, total_invocations, unique_users, avg_duration, success_rate)
      SELECT
        DATE('${date}') as date,
        skill_id,
        COUNT(*) as total_invocations,
        COUNT(DISTINCT user_id) as unique_users,
        AVG(duration_seconds) as avg_duration,
        (COUNT(*) FILTER (WHERE status = 'success')::float / COUNT(*)) * 100 as success_rate
      FROM skill_invocations
      WHERE DATE(created_at) = '${date}'
      GROUP BY skill_id
      ON CONFLICT (date, skill_id) DO UPDATE SET
        total_invocations = EXCLUDED.total_invocations,
        unique_users = EXCLUDED.unique_users,
        avg_duration = EXCLUDED.avg_duration,
        success_rate = EXCLUDED.success_rate
    `;

    await db.query(query);
  }

  /**
   * Calculate quality score aggregates for a specific date
   */
  private async calculateQualityAggregates(date: string): Promise<void> {
    const query = `
      INSERT INTO daily_quality_aggregates (date, avg_quality_score, repositories_measured)
      SELECT
        DATE('${date}') as date,
        AVG(overall_quality_score) as avg_quality_score,
        COUNT(DISTINCT repository_id) as repositories_measured
      FROM iso_assessments
      WHERE DATE(created_at) = '${date}'
      ON CONFLICT (date) DO UPDATE SET
        avg_quality_score = EXCLUDED.avg_quality_score,
        repositories_measured = EXCLUDED.repositories_measured
    `;

    await db.query(query);
  }

  /**
   * Calculate coverage aggregates for a specific date
   */
  private async calculateCoverageAggregates(date: string): Promise<void> {
    const query = `
      INSERT INTO daily_coverage_aggregates (date, avg_coverage_statements, repositories_measured)
      SELECT
        DATE('${date}') as date,
        AVG(coverage_statements) as avg_coverage_statements,
        COUNT(DISTINCT repository_id) as repositories_measured
      FROM test_coverage_history
      WHERE DATE(created_at) = '${date}'
      ON CONFLICT (date) DO UPDATE SET
        avg_coverage_statements = EXCLUDED.avg_coverage_statements,
        repositories_measured = EXCLUDED.repositories_measured
    `;

    await db.query(query);
  }

  /**
   * Check for alert conditions and create alerts
   */
  async checkForAlerts(): Promise<void> {
    try {
      // Check for critical security vulnerabilities
      await this.checkSecurityAlerts();

      // Check for coverage drops
      await this.checkCoverageAlerts();

      // Check for quality score drops
      await this.checkQualityAlerts();

      // Check for accessibility violations
      await this.checkAccessibilityAlerts();

    } catch (error) {
      logger.error('Failed to check for alerts', error);
    }
  }

  /**
   * Check for critical security vulnerabilities
   */
  private async checkSecurityAlerts(): Promise<void> {
    const query = `
      SELECT
        ssr.id,
        ssr.repository_id,
        r.name as repository_name,
        ssr.critical_count,
        ssr.high_count
      FROM security_scan_results ssr
      JOIN repositories r ON ssr.repository_id = r.id
      WHERE ssr.created_at >= NOW() - INTERVAL '1 hour'
        AND (ssr.critical_count > 0 OR ssr.high_count > 10)
      AND NOT EXISTS (
        SELECT 1 FROM alerts a
        WHERE a.repository_id = ssr.repository_id
          AND a.alert_type = 'security'
          AND a.status = 'active'
          AND a.created_at >= NOW() - INTERVAL '24 hours'
      )
    `;

    const results = await db.query(query);

    for (const result of results) {
      const severity = result.critical_count > 0 ? 'critical' : 'high';
      const title = result.critical_count > 0
        ? `${result.critical_count} Critical Security Vulnerabilities Detected`
        : `${result.high_count} High Severity Security Vulnerabilities Detected`;

      const message = `Repository: ${result.repository_name}\nCritical: ${result.critical_count}\nHigh: ${result.high_count}`;

      await this.createAlert('security', severity, title, message, result.repository_id);
    }
  }

  /**
   * Check for test coverage drops
   */
  private async checkCoverageAlerts(): Promise<void> {
    const query = `
      SELECT
        tch.repository_id,
        r.name as repository_name,
        tch.coverage_statements
      FROM test_coverage_history tch
      JOIN repositories r ON tch.repository_id = r.id
      WHERE tch.created_at >= NOW() - INTERVAL '1 hour'
        AND tch.coverage_statements < 90
        AND tch.branch = r.default_branch
      AND NOT EXISTS (
        SELECT 1 FROM alerts a
        WHERE a.repository_id = tch.repository_id
          AND a.alert_type = 'coverage'
          AND a.status = 'active'
          AND a.created_at >= NOW() - INTERVAL '24 hours'
      )
    `;

    const results = await db.query(query);

    for (const result of results) {
      const title = `Test Coverage Below Threshold`;
      const message = `Repository: ${result.repository_name}\nCurrent Coverage: ${result.coverage_statements.toFixed(1)}%\nTarget: ≥90%`;

      await this.createAlert('coverage', 'high', title, message, result.repository_id);
    }
  }

  /**
   * Check for quality score drops
   */
  private async checkQualityAlerts(): Promise<void> {
    const query = `
      SELECT
        ia.repository_id,
        r.name as repository_name,
        ia.overall_quality_score
      FROM iso_assessments ia
      JOIN repositories r ON ia.repository_id = r.id
      WHERE ia.created_at >= NOW() - INTERVAL '1 hour'
        AND ia.overall_quality_score < 85
      AND NOT EXISTS (
        SELECT 1 FROM alerts a
        WHERE a.repository_id = ia.repository_id
          AND a.alert_type = 'quality'
          AND a.status = 'active'
          AND a.created_at >= NOW() - INTERVAL '24 hours'
      )
    `;

    const results = await db.query(query);

    for (const result of results) {
      const title = `Quality Score Below Target`;
      const message = `Repository: ${result.repository_name}\nCurrent Score: ${result.overall_quality_score.toFixed(0)}/100\nTarget: ≥85`;

      await this.createAlert('quality', 'medium', title, message, result.repository_id);
    }
  }

  /**
   * Check for accessibility violations
   */
  private async checkAccessibilityAlerts(): Promise<void> {
    const query = `
      SELECT
        aar.repository_id,
        r.name as repository_name,
        aar.level_a_violations,
        aar.level_aa_violations
      FROM accessibility_audit_results aar
      JOIN repositories r ON aar.repository_id = r.id
      WHERE aar.created_at >= NOW() - INTERVAL '1 hour'
        AND aar.level_a_violations > 0
      AND NOT EXISTS (
        SELECT 1 FROM alerts a
        WHERE a.repository_id = aar.repository_id
          AND a.alert_type = 'accessibility'
          AND a.status = 'active'
          AND a.created_at >= NOW() - INTERVAL '24 hours'
      )
    `;

    const results = await db.query(query);

    for (const result of results) {
      const title = `Critical Accessibility Violations Detected`;
      const message = `Repository: ${result.repository_name}\nLevel A Violations: ${result.level_a_violations}\nLevel AA Violations: ${result.level_aa_violations}`;

      await this.createAlert('accessibility', 'high', title, message, result.repository_id);
    }
  }

  /**
   * Create a new alert
   */
  private async createAlert(
    alertType: string,
    severity: string,
    title: string,
    message: string,
    repositoryId?: string
  ): Promise<void> {
    const query = `
      INSERT INTO alerts (alert_type, severity, title, message, repository_id, status)
      VALUES ($1, $2, $3, $4, $5, 'active')
      RETURNING id
    `;

    const result = await db.queryOne(query, [alertType, severity, title, message, repositoryId || null]);

    logger.info('Alert created', {
      id: result?.id,
      type: alertType,
      severity,
      title,
    });

    // TODO: Trigger notification service (Slack, email, etc.)
  }
}

export const aggregationService = new AggregationService();
