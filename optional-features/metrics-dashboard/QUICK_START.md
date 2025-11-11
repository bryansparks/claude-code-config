# Quick Start Guide - 5 Minutes to Dashboard

## Prerequisites Check

```bash
# Verify you have the required tools
node --version  # Should be 18+
npm --version
psql --version  # PostgreSQL 14+
```

## Installation (3 minutes)

### 1. Run Installation Script

```bash
cd metrics-dashboard
./install.sh
```

**The script will ask you for:**
- Database host (press Enter for localhost)
- Database port (press Enter for 5432)
- Database name (press Enter for metrics_dashboard)
- Database user (press Enter for postgres)
- Database password (type your password)

### 2. Start Services (2 terminals)

**Terminal 1 - Backend:**
```bash
cd backend
npm start
```

You should see:
```
Server started on port 3001
Environment: development
Database connected
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

You should see:
```
  VITE v5.0.11  ready in 234 ms

  ➜  Local:   http://localhost:3000/
```

### 3. Access Dashboard

Open your browser to: **http://localhost:3000**

You should see the Claude Code Metrics Dashboard! 🎉

## First Steps

### Add Sample Data (Optional)

To see the dashboard in action with sample data:

```bash
psql -d metrics_dashboard -f database/sample-data.sql
```

Refresh the dashboard to see charts populated with data.

### Install Git Hooks in a Project

To start tracking metrics from a project:

```bash
# In your project directory
cp /path/to/metrics-dashboard/data-collection/git-hooks/* .git/hooks/
chmod +x .git/hooks/*

# Set environment variable
export METRICS_API_URL=http://localhost:3001/api
```

Now every commit and push will send data to the dashboard!

### Configure Slack Notifications (Optional)

1. Get a Slack webhook URL:
   - Go to https://api.slack.com/apps
   - Create app → Incoming Webhooks → Add webhook

2. Add to `backend/.env`:
   ```env
   SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
   SLACK_CHANNEL=#claude-code-alerts
   ```

3. Restart backend:
   ```bash
   cd backend
   npm start
   ```

## Verify Everything Works

### 1. Check Backend Health

```bash
curl http://localhost:3001/health
```

Should return:
```json
{
  "status": "healthy",
  "database": "connected",
  "uptime": 123.456
}
```

### 2. Check Frontend

Navigate to http://localhost:3000 - you should see:
- ✅ Header with "Claude Code Metrics Dashboard"
- ✅ Navigation tabs (Overview, Quality Metrics, Skill Usage, Team Performance)
- ✅ KPI cards showing metrics
- ✅ Live indicator in top-right

### 3. Check Database

```bash
psql -d metrics_dashboard -c "SELECT COUNT(*) FROM skills"
```

Should return:
```
 count
-------
    12
(1 row)
```

## Troubleshooting

### "Connection refused" error

**Backend not running:**
```bash
cd backend && npm start
```

**Wrong port:**
Check `backend/.env` - should have `PORT=3001`

### "Database connection failed"

**PostgreSQL not running:**
```bash
sudo systemctl start postgresql  # Linux
brew services start postgresql   # macOS
```

**Wrong credentials:**
Check `backend/.env` - verify DB_USER and DB_PASSWORD

### Dashboard shows "Loading..." forever

**Backend URL wrong:**
Check `frontend/.env` - should have `VITE_API_BASE_URL=http://localhost:3001/api`

**CORS error:**
Check `backend/.env` - should have `CORS_ORIGIN=http://localhost:3000`

## Next Steps

1. **Read the full README**: `./README.md`
2. **Configure alerts**: Edit `backend/.env` for Slack/Email
3. **Install Git hooks**: In all your projects
4. **Customize thresholds**: Edit `backend/src/services/aggregation.ts`
5. **Deploy to production**: See README "Production Deployment" section

## Common Commands

```bash
# Restart backend
cd backend && npm start

# Restart frontend
cd frontend && npm run dev

# View logs
tail -f backend/logs/combined.log

# Refresh materialized views manually
psql -d metrics_dashboard -c "SELECT refresh_all_materialized_views()"

# Check recent skill invocations
psql -d metrics_dashboard -c "SELECT * FROM skill_invocations ORDER BY created_at DESC LIMIT 5"
```

## Getting Help

- **Documentation**: See `README.md`
- **API Docs**: See `docs/API_DOCUMENTATION.md`
- **Issues**: Open an issue on GitHub
- **Slack**: #claude-code-skills

---

**Installation Time**: ~5 minutes
**First Data Visible**: Immediately with sample data, or after first commit with hooks installed
**Production Ready**: After configuring HTTPS reverse proxy (nginx)
