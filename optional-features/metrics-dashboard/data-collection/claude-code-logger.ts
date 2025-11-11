#!/usr/bin/env ts-node

/**
 * Claude Code Logger
 *
 * This script hooks into Claude Code to log skill invocations to the metrics dashboard.
 * It can be integrated as a Claude Code hook or run as a standalone monitoring service.
 *
 * Usage:
 *   1. As a hook: Place in .claude/hooks/post-skill-invocation.sh
 *   2. As a service: Run continuously with `ts-node claude-code-logger.ts`
 */

import * as fs from 'fs';
import * as path from 'path';
import axios from 'axios';

const API_BASE_URL = process.env.METRICS_API_URL || 'http://localhost:3001/api';
const LOG_FILE = process.env.CLAUDE_LOG_FILE || path.join(process.env.HOME || '', '.claude', 'logs', 'invocations.log');

interface SkillInvocationData {
  skill_id?: string;
  skill_name: string;
  user_id?: string;
  user_email: string;
  repository_id?: string;
  repository_name?: string;
  branch?: string;
  commit_sha?: string;
  trigger_method: 'manual' | 'automatic';
  input_files?: string[];
  output_files?: string[];
  duration_seconds?: number;
  tokens_used?: number;
  status: 'success' | 'error' | 'partial';
  error_message?: string;
  metadata?: Record<string, any>;
}

class ClaudeCodeLogger {
  private apiUrl: string;
  private userId: string | null = null;
  private userEmail: string | null = null;

  constructor(apiUrl: string = API_BASE_URL) {
    this.apiUrl = apiUrl;
    this.loadUserInfo();
  }

  private loadUserInfo(): void {
    try {
      // Try to get user info from Git config
      const { execSync } = require('child_process');
      this.userEmail = execSync('git config user.email', { encoding: 'utf-8' }).trim();

      // Try to load user ID from cache
      const cacheFile = path.join(process.env.HOME || '', '.claude', '.user-cache.json');
      if (fs.existsSync(cacheFile)) {
        const cache = JSON.parse(fs.readFileSync(cacheFile, 'utf-8'));
        this.userId = cache.user_id;
      }
    } catch (error) {
      console.error('Failed to load user info:', error);
    }
  }

  private async lookupUserId(email: string): Promise<string | null> {
    try {
      // This would need a backend endpoint to lookup user ID by email
      const response = await axios.get(`${this.apiUrl}/users/by-email/${encodeURIComponent(email)}`);
      return response.data.data.id;
    } catch (error) {
      console.error('Failed to lookup user ID:', error);
      return null;
    }
  }

  private async lookupSkillId(skillName: string): Promise<string | null> {
    try {
      const response = await axios.get(`${this.apiUrl}/skills/by-name/${encodeURIComponent(skillName)}`);
      return response.data.data.id;
    } catch (error) {
      console.error('Failed to lookup skill ID:', error);
      return null;
    }
  }

  private async lookupRepositoryId(repoName: string): Promise<string | null> {
    try {
      const response = await axios.get(`${this.apiUrl}/repositories/by-name/${encodeURIComponent(repoName)}`);
      return response.data.data.id;
    } catch (error) {
      console.error('Failed to lookup repository ID:', error);
      return null;
    }
  }

  async logInvocation(data: SkillInvocationData): Promise<void> {
    try {
      // Lookup IDs if not provided
      if (!data.user_id && data.user_email) {
        data.user_id = await this.lookupUserId(data.user_email) || undefined;
      }

      if (!data.skill_id && data.skill_name) {
        data.skill_id = await this.lookupSkillId(data.skill_name) || undefined;
      }

      if (!data.repository_id && data.repository_name) {
        data.repository_id = await this.lookupRepositoryId(data.repository_name) || undefined;
      }

      // Send to API
      const response = await axios.post(`${this.apiUrl}/skill-invocations`, data);

      console.log('✓ Skill invocation logged:', {
        skill: data.skill_name,
        user: data.user_email,
        status: data.status,
      });

      // Also append to local log file for backup
      this.appendToLogFile(data);

    } catch (error) {
      console.error('✗ Failed to log skill invocation:', error);

      // Fallback: Write to log file
      this.appendToLogFile(data);
    }
  }

  private appendToLogFile(data: SkillInvocationData): void {
    try {
      const logDir = path.dirname(LOG_FILE);
      if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
      }

      const logEntry = {
        timestamp: new Date().toISOString(),
        ...data,
      };

      fs.appendFileSync(LOG_FILE, JSON.stringify(logEntry) + '\n');
    } catch (error) {
      console.error('Failed to write to log file:', error);
    }
  }

  /**
   * Parse Claude Code output to detect skill invocations
   */
  parseClaudeOutput(output: string): SkillInvocationData | null {
    try {
      // Try to detect skill invocation patterns in output
      // This is a simplified parser - adjust based on actual Claude Code output format

      // Example pattern: "🤖 Invoked skill: unit-test-generator"
      const skillMatch = output.match(/🤖\s+Invoked skill:\s+(.+)/);
      if (!skillMatch) return null;

      const skillName = skillMatch[1].trim();

      // Detect duration: "⏱️ Duration: 27 seconds"
      const durationMatch = output.match(/⏱️\s+Duration:\s+(\d+)\s+seconds/);
      const duration = durationMatch ? parseInt(durationMatch[1]) : undefined;

      // Detect status
      const isError = output.includes('❌') || output.includes('Error');
      const status = isError ? 'error' : 'success';

      // Detect files
      const inputFilesMatch = output.match(/Input files?:\s+(.+)/);
      const outputFilesMatch = output.match(/Output files?:\s+(.+)/);

      const inputFiles = inputFilesMatch ? inputFilesMatch[1].split(',').map(f => f.trim()) : undefined;
      const outputFiles = outputFilesMatch ? outputFilesMatch[1].split(',').map(f => f.trim()) : undefined;

      return {
        skill_name: skillName,
        user_email: this.userEmail || 'unknown@company.com',
        trigger_method: 'manual', // Can be detected from context
        duration_seconds: duration,
        input_files: inputFiles,
        output_files: outputFiles,
        status: status as 'success' | 'error',
        metadata: {
          raw_output: output.substring(0, 500), // First 500 chars for debugging
        },
      };
    } catch (error) {
      console.error('Failed to parse Claude output:', error);
      return null;
    }
  }

  /**
   * Monitor Claude Code log file for new invocations
   */
  async monitorLogFile(logFilePath: string): Promise<void> {
    console.log(`📊 Monitoring Claude Code log file: ${logFilePath}`);

    let lastPosition = 0;

    const checkForNewLogs = () => {
      try {
        if (!fs.existsSync(logFilePath)) {
          return;
        }

        const stats = fs.statSync(logFilePath);
        if (stats.size > lastPosition) {
          const stream = fs.createReadStream(logFilePath, {
            start: lastPosition,
            encoding: 'utf-8',
          });

          let buffer = '';
          stream.on('data', (chunk) => {
            buffer += chunk;
          });

          stream.on('end', () => {
            const lines = buffer.split('\n');
            lines.forEach((line) => {
              if (line.trim()) {
                const invocationData = this.parseClaudeOutput(line);
                if (invocationData) {
                  this.logInvocation(invocationData);
                }
              }
            });

            lastPosition = stats.size;
          });
        }
      } catch (error) {
        console.error('Error reading log file:', error);
      }
    };

    // Check every 5 seconds
    setInterval(checkForNewLogs, 5000);
    checkForNewLogs(); // Initial check
  }
}

// CLI usage
if (require.main === module) {
  const logger = new ClaudeCodeLogger();

  const args = process.argv.slice(2);

  if (args.length === 0) {
    // Monitor mode
    const logFilePath = process.env.CLAUDE_LOG_FILE || path.join(process.env.HOME || '', '.claude', 'logs', 'claude.log');
    console.log('Starting Claude Code Logger in monitor mode...');
    logger.monitorLogFile(logFilePath);
  } else if (args[0] === 'log') {
    // Direct logging mode (for use in hooks)
    const data: SkillInvocationData = JSON.parse(args[1]);
    logger.logInvocation(data).then(() => {
      console.log('Logged successfully');
      process.exit(0);
    }).catch((error) => {
      console.error('Failed to log:', error);
      process.exit(1);
    });
  } else {
    console.log('Usage:');
    console.log('  claude-code-logger             # Monitor mode');
    console.log('  claude-code-logger log \'<json>\' # Log a single invocation');
  }
}

export default ClaudeCodeLogger;
