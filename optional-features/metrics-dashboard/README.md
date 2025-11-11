# Claude Code Metrics Dashboard

A comprehensive metrics dashboard for tracking Claude Code skill usage, code quality improvements, and team performance metrics.

## 🌟 Features

### Real-Time Metrics
- **Skill Adoption Tracking**: Monitor which skills are being used, by whom, and how frequently
- **Quality Metrics**: ISO/IEC 25010 quality scores, test coverage, security posture
- **Accessibility Compliance**: WCAG 2.1/2.2 compliance tracking
- **Performance Monitoring**: API response times, frontend Core Web Vitals
- **Security Scanning**: Vulnerability detection and tracking

### Interactive Dashboard
- Executive overview with high-level KPIs
- Quality metrics with trend visualization
- Skill usage analysis and heatmaps
- Team performance comparisons
- Real-time updates via WebSocket

### Data Collection
- Automated Git hooks for commit tracking
- Claude Code logging extension
- CI/CD integration for test coverage
- Security scanner integration
- Accessibility audit integration

### Alerting System
- Slack notifications for critical issues
- Email alerts for threshold breaches
- Customizable alert rules
- Alert acknowledgment and resolution tracking

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      DATA COLLECTION LAYER                      │
│  • Git Hooks  • Claude Code Logger  • CI/CD Webhooks           │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND API SERVER                         │
│  • REST API  • WebSocket  • Event Processing                   │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      POSTGRESQL DATABASE                        │
│  • Metrics Storage  • Materialized Views  • Time-series Data   │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FRONTEND DASHBOARD                         │
│  • React + TypeScript  • Recharts  • Tailwind CSS             │
└─────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ and npm
- **PostgreSQL** 14+
- **Git** (for Git hooks)
- **Unix-like OS** (Linux, macOS) or Windows with WSL

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd metrics-dashboard
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```

   The script will:
   - Check prerequisites
   - Set up PostgreSQL database
   - Install and build backend
   - Install and build frontend
   - Configure environment variables
   - Optionally create systemd services

3. **Start the services:**

   **Backend:**
   ```bash
   cd backend
   npm start
   ```

   **Frontend (in another terminal):**
   ```bash
   cd frontend
   npm run dev
   ```

4. **Access the dashboard:**
   Open http://localhost:3000 in your browser

## 📚 Manual Installation

If you prefer manual installation:

### 1. Database Setup

```bash
# Create database
createdb metrics_dashboard

# Apply schema
psql -d metrics_dashboard -f database/schema.sql
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Create .env file (copy from .env.example)
cp .env.example .env
# Edit .env with your database credentials

# Build
npm run build

# Start
npm start
```

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Create .env file
echo "VITE_API_BASE_URL=http://localhost:3001/api" > .env

# Start development server
npm run dev

# Or build for production
npm run build
npm run preview
```

## 🔧 Configuration

### Environment Variables

**Backend (backend/.env):**

```env
# Server
NODE_ENV=production
PORT=3001
LOG_LEVEL=info

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=metrics_dashboard
DB_USER=postgres
DB_PASSWORD=your_password

# CORS
CORS_ORIGIN=http://localhost:3000

# JWT
JWT_SECRET=your_secret_here
JWT_EXPIRES_IN=7d

# Slack (optional)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL

# Email (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@company.com
SMTP_PASSWORD=your_password
EMAIL_FROM=metrics-dashboard@company.com
```

**Frontend (frontend/.env):**

```env
VITE_API_BASE_URL=http://localhost:3001/api
```

### Slack Integration

1. Create a Slack incoming webhook:
   - Go to https://api.slack.com/apps
   - Create a new app
   - Enable Incoming Webhooks
   - Create a webhook for your channel

2. Add webhook URL to backend/.env:
   ```env
   SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
   SLACK_CHANNEL=#claude-code-alerts
   ```

3. Restart backend to apply changes

### Email Integration

1. Configure SMTP settings in backend/.env:
   ```env
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your_email@company.com
   SMTP_PASSWORD=your_app_password
   EMAIL_FROM=metrics-dashboard@company.com
   ALERT_EMAIL_TO=team@company.com
   ```

2. For Gmail, enable 2FA and create an App Password:
   https://support.google.com/accounts/answer/185833

## 📡 Data Collection Setup

### Git Hooks (Per Repository)

Install Git hooks in each repository you want to track:

```bash
# Copy hooks to your project
cp data-collection/git-hooks/* /path/to/your/project/.git/hooks/

# Make them executable
chmod +x /path/to/your/project/.git/hooks/*
```

**Available hooks:**
- `post-commit` - Logs commit data after each commit
- `pre-push` - Checks test coverage before push

Configure the hooks with environment variables:

```bash
# In your shell profile (~/.bashrc, ~/.zshrc):
export METRICS_API_URL=http://localhost:3001/api
export COVERAGE_THRESHOLD=90
```

### Claude Code Logger

The Claude Code logger can run in two modes:

#### 1. Monitor Mode (Continuous)

```bash
cd data-collection
ts-node claude-code-logger.ts
```

This will continuously monitor Claude Code logs and send skill invocations to the dashboard.

#### 2. Hook Mode (Event-driven)

Add to `.claude/hooks/post-skill-invocation.sh`:

```bash
#!/usr/bin/env bash
ts-node /path/to/claude-code-logger.ts log '{
  "skill_name": "'$SKILL_NAME'",
  "user_email": "'$USER_EMAIL'",
  "trigger_method": "automatic",
  "status": "success"
}'
```

### CI/CD Integration

#### GitHub Actions

Add to `.github/workflows/metrics.yml`:

```yaml
name: Send Metrics

on:
  push:
    branches: [main]
  pull_request:

jobs:
  metrics:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run tests with coverage
        run: npm test -- --coverage

      - name: Send coverage to dashboard
        run: |
          curl -X POST http://your-dashboard/api/test-coverage \
            -H "Content-Type: application/json" \
            -d @coverage/coverage-summary.json
```

#### Jenkins

Add to Jenkinsfile:

```groovy
post {
  always {
    script {
      def coverage = readJSON file: 'coverage/coverage-summary.json'
      httpRequest(
        url: 'http://your-dashboard/api/test-coverage',
        httpMode: 'POST',
        contentType: 'APPLICATION_JSON',
        requestBody: coverage
      )
    }
  }
}
```

## 📊 Dashboard Usage

### Executive Dashboard

The main overview showing:
- Skill adoption rate (target: ≥80%)
- Overall quality score (target: ≥85/100)
- Test coverage (target: ≥90%)
- Security posture (target: ≥90/100)
- Active alerts by severity

### Quality Metrics Panel

Tracks ISO/IEC 25010 quality characteristics:
- Functional Suitability
- Performance Efficiency
- Compatibility
- Usability
- Reliability
- Security
- Maintainability
- Portability

Visualizations:
- Trend line charts (7d, 30d, 90d views)
- Individual characteristic scores
- Target line comparison

### Skill Usage Analysis

Shows which skills are being used:
- Invocation counts per skill
- Unique users per skill
- Average duration
- Success/error rates
- Skill adoption heatmap

### Team Performance

Compare team members:
- Skills used per engineer
- Quality score by engineer
- Test coverage contributions
- Security issues found/fixed

## 🔔 Alert Configuration

### Alert Types

| Alert Type | Trigger Condition | Default Severity |
|------------|-------------------|------------------|
| Security | Critical vulnerabilities detected | Critical |
| Coverage | Test coverage <90% | High |
| Quality | ISO quality score <85 | Medium |
| Accessibility | Level A WCAG violations | High |
| Performance | API p95 >500ms | Medium |

### Alert Rules

Edit `backend/src/services/aggregation.ts` to customize alert rules:

```typescript
private async checkSecurityAlerts(): Promise<void> {
  const query = `
    SELECT ... FROM security_scan_results
    WHERE critical_count > 0  // Change threshold here
  `;
  // ...
}
```

### Alert Notifications

Notifications are sent to all configured channels:
- **Slack**: Real-time alerts to designated channel
- **Email**: Alerts to team distribution list
- **Dashboard**: In-app alert panel

## 🧪 Testing

### Backend Tests

```bash
cd backend
npm test
```

### Frontend Tests

```bash
cd frontend
npm test
```

### Database Tests

```bash
# Run test schema
psql -d metrics_dashboard_test -f database/schema.sql

# Run migrations
psql -d metrics_dashboard_test -f database/test-data.sql
```

## 🛠️ Development

### Backend Development

```bash
cd backend

# Development mode with hot reload
npm run dev

# Run linter
npm run lint

# Type checking
npx tsc --noEmit
```

### Frontend Development

```bash
cd frontend

# Development server
npm run dev

# Run linter
npm run lint

# Type checking
npm run type-check
```

### Database Changes

1. Edit `database/schema.sql`
2. Create migration script if needed
3. Test on development database
4. Apply to production

## 📈 Performance Optimization

### Backend
- Uses connection pooling (max 20 connections)
- Materialized views for expensive queries
- Indexes on frequently queried columns
- Rate limiting (100 requests/15min per IP)

### Frontend
- Code splitting with Vite
- Lazy loading of components
- React Query for caching
- WebSocket for real-time updates

### Database
- Composite indexes on common queries
- Partial indexes for filtered queries
- JSONB indexes for metadata searches
- Automatic vacuum and analysis

## 🔐 Security

### Best Practices
- Environment variables for secrets
- JWT authentication for API
- HTTPS in production (use reverse proxy)
- Rate limiting on all endpoints
- SQL injection prevention (parameterized queries)
- CORS configuration
- Helmet.js security headers

### Production Deployment

**Use a reverse proxy (nginx):**

```nginx
server {
    listen 443 ssl;
    server_name metrics.company.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
    }

    location /api {
        proxy_pass http://localhost:3001;
    }

    location /ws {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

## 🐛 Troubleshooting

### Database Connection Errors

```bash
# Check PostgreSQL is running
systemctl status postgresql

# Check connection
psql -h localhost -U postgres -d metrics_dashboard

# Check logs
tail -f /var/log/postgresql/postgresql-*.log
```

### Backend Not Starting

```bash
# Check logs
cd backend
npm start 2>&1 | tee debug.log

# Common issues:
# - Port 3001 already in use: Change PORT in .env
# - Database connection failed: Check DB credentials
# - Missing dependencies: Run npm install
```

### Frontend Not Loading

```bash
# Check browser console for errors
# Common issues:
# - API URL wrong: Check VITE_API_BASE_URL in .env
# - Backend not running: Start backend first
# - CORS errors: Check CORS_ORIGIN in backend/.env
```

### No Data Showing

1. Check if backend is receiving data:
   ```bash
   tail -f backend/logs/combined.log
   ```

2. Check database has data:
   ```sql
   SELECT COUNT(*) FROM skill_invocations;
   SELECT COUNT(*) FROM quality_metrics;
   ```

3. Check materialized views are refreshed:
   ```sql
   SELECT * FROM mv_user_skill_summary LIMIT 5;
   ```

4. Manually refresh if needed:
   ```sql
   REFRESH MATERIALIZED VIEW CONCURRENTLY mv_team_skill_adoption;
   REFRESH MATERIALIZED VIEW CONCURRENTLY mv_user_skill_summary;
   REFRESH MATERIALIZED VIEW CONCURRENTLY mv_repository_quality;
   ```

## 📝 API Documentation

See [API_DOCUMENTATION.md](./docs/API_DOCUMENTATION.md) for complete API reference.

**Quick Examples:**

```bash
# Get skill invocations
curl http://localhost:3001/api/skill-invocations?limit=10

# Get skill statistics
curl http://localhost:3001/api/skill-invocations/stats?period=30d

# Get quality trend
curl http://localhost:3001/api/metrics/quality-trend?period=30d

# Get dashboard summary
curl http://localhost:3001/api/metrics/dashboard-summary
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details.

## 📧 Support

- **Issues**: https://github.com/your-org/metrics-dashboard/issues
- **Email**: engineering-tools@company.com
- **Slack**: #claude-code-skills

## 🙏 Acknowledgments

- Built for tracking [Claude Code](https://claude.com/claude-code) skill usage
- Uses [Recharts](https://recharts.org/) for visualizations
- Database schema inspired by ISO/IEC 25010 quality model
- Alert system based on industry best practices

---

**Version**: 1.0.0
**Last Updated**: 2025-11-11
