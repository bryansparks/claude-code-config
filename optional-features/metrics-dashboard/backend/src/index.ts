import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { Server } from 'ws';
import { logger } from './utils/logger';
import { db } from './database/connection';

// Import routes
import skillInvocationsRouter from './api/skillInvocations';
import metricsRouter from './api/metrics';

// Load environment variables
dotenv.config();

const app: Application = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
});
app.use('/api/', limiter);

// Request logging middleware
app.use((req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info('HTTP Request', {
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration,
      ip: req.ip,
    });
  });
  next();
});

// Routes
app.get('/health', async (req: Request, res: Response) => {
  const dbHealthy = await db.healthCheck();
  const status = dbHealthy ? 200 : 503;

  res.status(status).json({
    status: dbHealthy ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    database: dbHealthy ? 'connected' : 'disconnected',
  });
});

app.get('/api', (req: Request, res: Response) => {
  res.json({
    name: 'Metrics Dashboard API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      skillInvocations: '/api/skill-invocations',
      metrics: '/api/metrics',
    },
  });
});

// Mount API routes
app.use('/api/skill-invocations', skillInvocationsRouter);
app.use('/api/metrics', metricsRouter);

// 404 handler
app.use((req: Request, res: Response) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error('Unhandled error', {
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
  });

  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined,
  });
});

// Start server
const server = app.listen(PORT, () => {
  logger.info(`Server started on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
  logger.info(`CORS origin: ${process.env.CORS_ORIGIN || 'http://localhost:3000'}`);
});

// WebSocket server for real-time updates
const wss = new Server({ server, path: '/ws' });

wss.on('connection', (ws) => {
  logger.info('WebSocket client connected');

  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message.toString());
      logger.debug('WebSocket message received', data);

      // Handle subscribe requests
      if (data.type === 'subscribe') {
        // Client subscribes to specific metric updates
        ws.send(JSON.stringify({
          type: 'subscribed',
          topic: data.topic,
        }));
      }
    } catch (error) {
      logger.error('WebSocket message error', error);
    }
  });

  ws.on('close', () => {
    logger.info('WebSocket client disconnected');
  });

  ws.on('error', (error) => {
    logger.error('WebSocket error', error);
  });

  // Send initial connection message
  ws.send(JSON.stringify({
    type: 'connected',
    timestamp: new Date().toISOString(),
  }));
});

// Broadcast function for real-time updates
export function broadcastMetricUpdate(metricType: string, data: any): void {
  wss.clients.forEach((client) => {
    if (client.readyState === client.OPEN) {
      client.send(JSON.stringify({
        type: 'metric_update',
        metricType,
        data,
        timestamp: new Date().toISOString(),
      }));
    }
  });
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM received, shutting down gracefully');

  server.close(() => {
    logger.info('HTTP server closed');
  });

  wss.close(() => {
    logger.info('WebSocket server closed');
  });

  await db.close();
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('SIGINT received, shutting down gracefully');

  server.close(() => {
    logger.info('HTTP server closed');
  });

  wss.close(() => {
    logger.info('WebSocket server closed');
  });

  await db.close();
  process.exit(0);
});

export default app;
