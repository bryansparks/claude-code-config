import axios from 'axios';
import { logger } from '../utils/logger';

export interface NotificationPayload {
  title: string;
  message: string;
  severity: 'critical' | 'high' | 'medium' | 'low';
  metadata?: Record<string, any>;
}

/**
 * Notification Service
 *
 * Sends alerts via Slack, Email, and other channels
 */
export class NotificationService {
  private slackWebhookUrl: string | null = null;
  private emailEnabled: boolean = false;

  constructor() {
    this.slackWebhookUrl = process.env.SLACK_WEBHOOK_URL || null;
    this.emailEnabled = !!process.env.SMTP_HOST;
  }

  /**
   * Send notification to all configured channels
   */
  async sendNotification(payload: NotificationPayload): Promise<void> {
    try {
      const promises: Promise<any>[] = [];

      if (this.slackWebhookUrl) {
        promises.push(this.sendSlackNotification(payload));
      }

      if (this.emailEnabled) {
        promises.push(this.sendEmailNotification(payload));
      }

      await Promise.allSettled(promises);
    } catch (error) {
      logger.error('Failed to send notifications', error);
    }
  }

  /**
   * Send notification to Slack
   */
  private async sendSlackNotification(payload: NotificationPayload): Promise<void> {
    if (!this.slackWebhookUrl) {
      return;
    }

    try {
      const emoji = this.getSeverityEmoji(payload.severity);
      const color = this.getSeverityColor(payload.severity);

      const slackPayload = {
        username: 'Claude Code Metrics',
        icon_emoji: ':robot_face:',
        attachments: [
          {
            color,
            title: `${emoji} ${payload.title}`,
            text: payload.message,
            fields: payload.metadata
              ? Object.entries(payload.metadata).map(([key, value]) => ({
                  title: key,
                  value: String(value),
                  short: true,
                }))
              : undefined,
            footer: 'Claude Code Metrics Dashboard',
            ts: Math.floor(Date.now() / 1000),
          },
        ],
      };

      await axios.post(this.slackWebhookUrl, slackPayload);
      logger.info('Slack notification sent', { title: payload.title });
    } catch (error) {
      logger.error('Failed to send Slack notification', error);
    }
  }

  /**
   * Send notification via Email
   */
  private async sendEmailNotification(payload: NotificationPayload): Promise<void> {
    try {
      // This is a placeholder - implement with nodemailer or your email service
      const nodemailer = require('nodemailer');

      const transporter = nodemailer.createTransporter({
        host: process.env.SMTP_HOST,
        port: parseInt(process.env.SMTP_PORT || '587'),
        secure: false,
        auth: {
          user: process.env.SMTP_USER,
          pass: process.env.SMTP_PASSWORD,
        },
      });

      const emoji = this.getSeverityEmoji(payload.severity);

      const html = `
        <h2>${emoji} ${payload.title}</h2>
        <p>${payload.message.replace(/\n/g, '<br>')}</p>
        ${
          payload.metadata
            ? `
          <h3>Details:</h3>
          <ul>
            ${Object.entries(payload.metadata)
              .map(([key, value]) => `<li><strong>${key}:</strong> ${value}</li>`)
              .join('')}
          </ul>
        `
            : ''
        }
        <hr>
        <p style="color: #666; font-size: 12px;">
          Sent by Claude Code Metrics Dashboard
        </p>
      `;

      await transporter.sendMail({
        from: process.env.EMAIL_FROM || 'metrics-dashboard@company.com',
        to: process.env.ALERT_EMAIL_TO || 'team@company.com',
        subject: `[${payload.severity.toUpperCase()}] ${payload.title}`,
        html,
      });

      logger.info('Email notification sent', { title: payload.title });
    } catch (error) {
      logger.error('Failed to send email notification', error);
    }
  }

  /**
   * Get emoji for severity level
   */
  private getSeverityEmoji(severity: string): string {
    const emojiMap: Record<string, string> = {
      critical: '🔴',
      high: '🟠',
      medium: '🟡',
      low: '🟢',
    };
    return emojiMap[severity] || '⚪';
  }

  /**
   * Get color code for severity level (for Slack)
   */
  private getSeverityColor(severity: string): string {
    const colorMap: Record<string, string> = {
      critical: '#dc2626', // red-600
      high: '#ea580c', // orange-600
      medium: '#ca8a04', // yellow-600
      low: '#16a34a', // green-600
    };
    return colorMap[severity] || '#6b7280'; // gray-500
  }
}

export const notificationService = new NotificationService();
