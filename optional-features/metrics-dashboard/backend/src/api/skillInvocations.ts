import { Router, Request, Response } from 'express';
import { db } from '../database/connection';
import { logger } from '../utils/logger';
import { body, query, validationResult } from 'express-validator';

const router = Router();

// Get all skill invocations with pagination and filters
router.get(
  '/',
  [
    query('page').optional().isInt({ min: 1 }).toInt(),
    query('limit').optional().isInt({ min: 1, max: 100 }).toInt(),
    query('skill_id').optional().isUUID(),
    query('user_id').optional().isUUID(),
    query('repository_id').optional().isUUID(),
    query('start_date').optional().isISO8601(),
    query('end_date').optional().isISO8601(),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 50;
      const offset = (page - 1) * limit;

      let whereConditions: string[] = [];
      let params: any[] = [];
      let paramIndex = 1;

      if (req.query.skill_id) {
        whereConditions.push(`si.skill_id = $${paramIndex++}`);
        params.push(req.query.skill_id);
      }

      if (req.query.user_id) {
        whereConditions.push(`si.user_id = $${paramIndex++}`);
        params.push(req.query.user_id);
      }

      if (req.query.repository_id) {
        whereConditions.push(`si.repository_id = $${paramIndex++}`);
        params.push(req.query.repository_id);
      }

      if (req.query.start_date) {
        whereConditions.push(`si.created_at >= $${paramIndex++}`);
        params.push(req.query.start_date);
      }

      if (req.query.end_date) {
        whereConditions.push(`si.created_at <= $${paramIndex++}`);
        params.push(req.query.end_date);
      }

      const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

      const query = `
        SELECT
          si.id,
          si.skill_id,
          s.name AS skill_name,
          s.display_name AS skill_display_name,
          si.user_id,
          u.email AS user_email,
          u.name AS user_name,
          si.repository_id,
          r.name AS repository_name,
          si.branch,
          si.commit_sha,
          si.trigger_method,
          si.input_files,
          si.output_files,
          si.duration_seconds,
          si.tokens_used,
          si.status,
          si.metadata,
          si.created_at
        FROM skill_invocations si
        JOIN skills s ON si.skill_id = s.id
        JOIN users u ON si.user_id = u.id
        LEFT JOIN repositories r ON si.repository_id = r.id
        ${whereClause}
        ORDER BY si.created_at DESC
        LIMIT $${paramIndex++} OFFSET $${paramIndex++}
      `;

      params.push(limit, offset);

      const invocations = await db.query(query, params);

      // Get total count
      const countQuery = `
        SELECT COUNT(*) as total
        FROM skill_invocations si
        ${whereClause}
      `;
      const countResult = await db.queryOne<{ total: string }>(countQuery, params.slice(0, -2));
      const total = parseInt(countResult?.total || '0');

      res.json({
        data: invocations,
        pagination: {
          page,
          limit,
          total,
          totalPages: Math.ceil(total / limit),
        },
      });
    } catch (error) {
      logger.error('Error fetching skill invocations', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Record a new skill invocation
router.post(
  '/',
  [
    body('skill_id').isUUID(),
    body('user_id').isUUID(),
    body('repository_id').optional().isUUID(),
    body('branch').optional().isString(),
    body('commit_sha').optional().isString().isLength({ max: 40 }),
    body('trigger_method').isIn(['manual', 'automatic']),
    body('input_files').optional().isArray(),
    body('output_files').optional().isArray(),
    body('duration_seconds').optional().isInt({ min: 0 }),
    body('tokens_used').optional().isInt({ min: 0 }),
    body('status').optional().isIn(['success', 'error', 'partial']),
    body('error_message').optional().isString(),
    body('metadata').optional().isObject(),
  ],
  async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const {
        skill_id,
        user_id,
        repository_id,
        branch,
        commit_sha,
        trigger_method,
        input_files,
        output_files,
        duration_seconds,
        tokens_used,
        status,
        error_message,
        metadata,
      } = req.body;

      const query = `
        INSERT INTO skill_invocations (
          skill_id, user_id, repository_id, branch, commit_sha,
          trigger_method, input_files, output_files, duration_seconds,
          tokens_used, status, error_message, metadata
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING *
      `;

      const params = [
        skill_id,
        user_id,
        repository_id || null,
        branch || null,
        commit_sha || null,
        trigger_method,
        input_files || null,
        output_files || null,
        duration_seconds || null,
        tokens_used || null,
        status || 'success',
        error_message || null,
        metadata ? JSON.stringify(metadata) : null,
      ];

      const result = await db.queryOne(query, params);

      logger.info('Skill invocation recorded', { id: result?.id, skill_id, user_id });

      res.status(201).json({ data: result });
    } catch (error) {
      logger.error('Error recording skill invocation', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Get skill usage statistics
router.get('/stats', async (req: Request, res: Response) => {
  try {
    const period = (req.query.period as string) || '30d';
    let interval: string;

    switch (period) {
      case '7d':
        interval = '7 days';
        break;
      case '30d':
        interval = '30 days';
        break;
      case '90d':
        interval = '90 days';
        break;
      default:
        interval = '30 days';
    }

    const query = `
      SELECT
        s.id,
        s.name,
        s.display_name,
        s.category,
        COUNT(si.id) AS invocation_count,
        COUNT(DISTINCT si.user_id) AS unique_users,
        AVG(si.duration_seconds) AS avg_duration,
        COUNT(CASE WHEN si.status = 'success' THEN 1 END) AS success_count,
        COUNT(CASE WHEN si.status = 'error' THEN 1 END) AS error_count
      FROM skills s
      LEFT JOIN skill_invocations si ON s.id = si.skill_id
        AND si.created_at >= NOW() - INTERVAL '${interval}'
      GROUP BY s.id, s.name, s.display_name, s.category
      ORDER BY invocation_count DESC
    `;

    const stats = await db.query(query);

    res.json({ data: stats, period });
  } catch (error) {
    logger.error('Error fetching skill statistics', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
