import { Router, Request, Response } from 'express';
import { db } from '../database/connection';
import { logger } from '../utils/logger';
import { query, validationResult } from 'express-validator';

const router = Router();

// Get overall quality score trend
router.get(
  '/quality-trend',
  [
    query('repository_id').optional().isUUID(),
    query('period').optional().isIn(['7d', '30d', '90d']),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const period = (req.query.period as string) || '30d';
      const repositoryId = req.query.repository_id as string;

      const intervalMap: Record<string, string> = {
        '7d': '7 days',
        '30d': '30 days',
        '90d': '90 days',
      };

      let whereClause = '';
      const params: any[] = [intervalMap[period]];

      if (repositoryId) {
        whereClause = 'AND ia.repository_id = $2';
        params.push(repositoryId);
      }

      const query = `
        SELECT
          DATE(ia.created_at) AS date,
          AVG(ia.overall_quality_score) AS avg_quality_score,
          AVG(ia.functional_suitability) AS avg_functional_suitability,
          AVG(ia.performance_efficiency) AS avg_performance_efficiency,
          AVG(ia.security) AS avg_security,
          AVG(ia.maintainability) AS avg_maintainability
        FROM iso_assessments ia
        WHERE ia.created_at >= NOW() - INTERVAL $1
        ${whereClause}
        GROUP BY DATE(ia.created_at)
        ORDER BY date ASC
      `;

      const trend = await db.query(query, params);

      res.json({ data: trend, period });
    } catch (error) {
      logger.error('Error fetching quality trend', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get test coverage trend
router.get(
  '/test-coverage-trend',
  [
    query('repository_id').optional().isUUID(),
    query('branch').optional().isString(),
    query('period').optional().isIn(['7d', '30d', '90d']),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const period = (req.query.period as string) || '30d';
      const repositoryId = req.query.repository_id as string;
      const branch = req.query.branch as string || 'main';

      const intervalMap: Record<string, string> = {
        '7d': '7 days',
        '30d': '30 days',
        '90d': '90 days',
      };

      let whereConditions = [`tch.created_at >= NOW() - INTERVAL $1`, `tch.branch = $2`];
      const params: any[] = [intervalMap[period], branch];

      if (repositoryId) {
        whereConditions.push(`tch.repository_id = $${params.length + 1}`);
        params.push(repositoryId);
      }

      const query = `
        SELECT
          DATE(tch.created_at) AS date,
          AVG(tch.coverage_statements) AS avg_coverage_statements,
          AVG(tch.coverage_branches) AS avg_coverage_branches,
          AVG(tch.coverage_functions) AS avg_coverage_functions,
          AVG(tch.coverage_lines) AS avg_coverage_lines,
          AVG(tch.total_tests) AS avg_total_tests,
          AVG(tch.execution_time_seconds) AS avg_execution_time
        FROM test_coverage_history tch
        WHERE ${whereConditions.join(' AND ')}
        GROUP BY DATE(tch.created_at)
        ORDER BY date ASC
      `;

      const trend = await db.query(query, params);

      res.json({ data: trend, period, branch });
    } catch (error) {
      logger.error('Error fetching test coverage trend', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get security score trend
router.get(
  '/security-trend',
  [
    query('repository_id').optional().isUUID(),
    query('period').optional().isIn(['7d', '30d', '90d']),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const period = (req.query.period as string) || '30d';
      const repositoryId = req.query.repository_id as string;

      const intervalMap: Record<string, string> = {
        '7d': '7 days',
        '30d': '30 days',
        '90d': '90 days',
      };

      let whereClause = '';
      const params: any[] = [intervalMap[period]];

      if (repositoryId) {
        whereClause = 'AND ssr.repository_id = $2';
        params.push(repositoryId);
      }

      const query = `
        SELECT
          DATE(ssr.created_at) AS date,
          AVG(ssr.overall_score) AS avg_security_score,
          SUM(ssr.critical_count) AS total_critical,
          SUM(ssr.high_count) AS total_high,
          SUM(ssr.medium_count) AS total_medium,
          SUM(ssr.low_count) AS total_low
        FROM security_scan_results ssr
        WHERE ssr.created_at >= NOW() - INTERVAL $1
        ${whereClause}
        GROUP BY DATE(ssr.created_at)
        ORDER BY date ASC
      `;

      const trend = await db.query(query, params);

      res.json({ data: trend, period });
    } catch (error) {
      logger.error('Error fetching security trend', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get accessibility score trend
router.get(
  '/accessibility-trend',
  [
    query('repository_id').optional().isUUID(),
    query('period').optional().isIn(['7d', '30d', '90d']),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const period = (req.query.period as string) || '30d';
      const repositoryId = req.query.repository_id as string;

      const intervalMap: Record<string, string> = {
        '7d': '7 days',
        '30d': '30 days',
        '90d': '90 days',
      };

      let whereClause = '';
      const params: any[] = [intervalMap[period]];

      if (repositoryId) {
        whereClause = 'AND aar.repository_id = $2';
        params.push(repositoryId);
      }

      const query = `
        SELECT
          DATE(aar.created_at) AS date,
          AVG(aar.wcag_compliance_score) AS avg_wcag_score,
          SUM(aar.level_a_violations) AS total_level_a,
          SUM(aar.level_aa_violations) AS total_level_aa,
          SUM(aar.level_aaa_violations) AS total_level_aaa
        FROM accessibility_audit_results aar
        WHERE aar.created_at >= NOW() - INTERVAL $1
        ${whereClause}
        GROUP BY DATE(aar.created_at)
        ORDER BY date ASC
      `;

      const trend = await db.query(query, params);

      res.json({ data: trend, period });
    } catch (error) {
      logger.error('Error fetching accessibility trend', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get performance metrics
router.get(
  '/performance',
  [
    query('repository_id').optional().isUUID(),
    query('environment').optional().isString(),
    query('period').optional().isIn(['7d', '30d', '90d']),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const period = (req.query.period as string) || '30d';
      const repositoryId = req.query.repository_id as string;
      const environment = (req.query.environment as string) || 'production';

      const intervalMap: Record<string, string> = {
        '7d': '7 days',
        '30d': '30 days',
        '90d': '90 days',
      };

      let whereConditions = [
        `pm.created_at >= NOW() - INTERVAL $1`,
        `pm.environment = $2`,
      ];
      const params: any[] = [intervalMap[period], environment];

      if (repositoryId) {
        whereConditions.push(`pm.repository_id = $${params.length + 1}`);
        params.push(repositoryId);
      }

      const query = `
        SELECT
          DATE(pm.created_at) AS date,
          pm.measurement_type,
          pm.metric_name,
          AVG(pm.value) AS avg_value,
          PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY pm.value) AS p95_value,
          PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY pm.value) AS p99_value
        FROM performance_measurements pm
        WHERE ${whereConditions.join(' AND ')}
        GROUP BY DATE(pm.created_at), pm.measurement_type, pm.metric_name
        ORDER BY date ASC, pm.measurement_type, pm.metric_name
      `;

      const metrics = await db.query(query, params);

      res.json({ data: metrics, period, environment });
    } catch (error) {
      logger.error('Error fetching performance metrics', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get team-wide dashboard summary
router.get('/dashboard-summary', async (req: Request, res: Response) => {
  try {
    const teamId = req.query.team_id as string;

    // Get skill adoption
    const skillAdoptionQuery = `
      SELECT
        COUNT(DISTINCT u.id) FILTER (WHERE si.id IS NOT NULL) AS active_users,
        COUNT(DISTINCT u.id) AS total_users,
        ROUND(
          COUNT(DISTINCT u.id) FILTER (WHERE si.id IS NOT NULL)::numeric /
          NULLIF(COUNT(DISTINCT u.id), 0) * 100,
          1
        ) AS adoption_rate
      FROM users u
      LEFT JOIN skill_invocations si ON u.id = si.user_id
        AND si.created_at >= NOW() - INTERVAL '30 days'
      ${teamId ? 'WHERE u.team_id = $1' : ''}
    `;

    const skillAdoption = await db.queryOne(
      skillAdoptionQuery,
      teamId ? [teamId] : []
    );

    // Get latest quality scores
    const latestQualityQuery = `
      SELECT
        AVG(ia.overall_quality_score) AS avg_quality_score
      FROM iso_assessments ia
      WHERE ia.created_at >= NOW() - INTERVAL '7 days'
    `;

    const latestQuality = await db.queryOne(latestQualityQuery);

    // Get latest test coverage
    const latestCoverageQuery = `
      SELECT
        AVG(tch.coverage_statements) AS avg_coverage
      FROM test_coverage_history tch
      WHERE tch.created_at >= NOW() - INTERVAL '7 days'
    `;

    const latestCoverage = await db.queryOne(latestCoverageQuery);

    // Get latest security score
    const latestSecurityQuery = `
      SELECT
        AVG(ssr.overall_score) AS avg_security_score,
        SUM(ssr.critical_count) AS critical_vulns,
        SUM(ssr.high_count) AS high_vulns
      FROM security_scan_results ssr
      WHERE ssr.created_at >= NOW() - INTERVAL '7 days'
    `;

    const latestSecurity = await db.queryOne(latestSecurityQuery);

    // Get latest accessibility score
    const latestA11yQuery = `
      SELECT
        AVG(aar.wcag_compliance_score) AS avg_wcag_score,
        SUM(aar.level_a_violations) AS level_a_violations,
        SUM(aar.level_aa_violations) AS level_aa_violations
      FROM accessibility_audit_results aar
      WHERE aar.created_at >= NOW() - INTERVAL '7 days'
    `;

    const latestA11y = await db.queryOne(latestA11yQuery);

    // Get active alerts
    const activeAlertsQuery = `
      SELECT
        COUNT(*) FILTER (WHERE severity = 'critical') AS critical_alerts,
        COUNT(*) FILTER (WHERE severity = 'high') AS high_alerts,
        COUNT(*) FILTER (WHERE severity = 'medium') AS medium_alerts
      FROM alerts
      WHERE status = 'active'
    `;

    const activeAlerts = await db.queryOne(activeAlertsQuery);

    res.json({
      data: {
        skillAdoption,
        quality: latestQuality,
        testCoverage: latestCoverage,
        security: latestSecurity,
        accessibility: latestA11y,
        alerts: activeAlerts,
      },
    });
  } catch (error) {
    logger.error('Error fetching dashboard summary', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
