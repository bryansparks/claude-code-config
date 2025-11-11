# Secrets Management Guide

Complete guide for managing API tokens, credentials, and environment variables for Claude Code MCP servers.

---

## 🔒 Overview

MCP servers require API tokens and credentials to function. This guide explains:
- How to obtain tokens for each service
- How to store them securely
- How to validate they're configured correctly
- Best practices for security

**⚠️ NEVER commit secrets to version control**

---

## 📋 Required Secrets by Persona

### Software Engineer

**Required:**
- `GITHUB_TOKEN` - GitHub personal access token

**Optional:**
- `POSTGRES_CONNECTION_STRING` - Database connection (if using PostgreSQL server)

**Total MCP servers:** 7 (Serena, GitHub, Filesystem, Memory, Sequential-thinking, Playwright, PostgreSQL)

### QA Engineer

**Required:**
- `GITHUB_TOKEN` - GitHub personal access token

**Optional:**
- `POSTGRES_CONNECTION_STRING` - Test database connection
- `PLAYWRIGHT_BROWSERS_PATH` - Custom browser installation path (defaults to `0`)

**Total MCP servers:** 7 (Playwright, GitHub, Filesystem, A11y MCP, Memory, Sequential-thinking, PostgreSQL)

### Product Manager

**Required:**
- `GITHUB_TOKEN` - GitHub personal access token
- `LINEAR_API_KEY` - Linear issue tracking
- `POSTHOG_API_KEY` - PostHog analytics
- `FIGMA_ACCESS_TOKEN` - Figma design files

**Optional:**
- `JIRA_HOST` - Jira server URL (e.g., `your-domain.atlassian.net`)
- `JIRA_EMAIL` - Your Jira email
- `JIRA_API_TOKEN` - Jira API token
- `SLACK_BOT_TOKEN` - Slack bot token for notifications

**Total MCP servers:** 7 (GitHub, Linear, PostHog, Figma, Memory, Jira, Slack)

### Engineering Manager

**Required:**
- `GITHUB_TOKEN` - GitHub personal access token
- `LINEAR_API_KEY` - Linear issue tracking
- `POSTHOG_API_KEY` - PostHog analytics
- `SLACK_BOT_TOKEN` - Slack team communication

**Optional:**
- `POSTGRES_CONNECTION_STRING` - Metrics database access

**Total MCP servers:** 6 (GitHub, Linear, PostHog, Slack, Memory, PostgreSQL)

### UX Designer

**Required:**
- `FIGMA_ACCESS_TOKEN` - Figma design files

**Optional:**
- `GITHUB_TOKEN` - GitHub for design implementation tracking
- `SLACK_BOT_TOKEN` - Slack for design team communication

**Total MCP servers:** 6 (Figma, A11y MCP, Playwright, Filesystem, Memory, Slack)

---

## 🔑 Token Generation Guides

### GitHub Token

**Purpose:** Access GitHub APIs for PRs, issues, code search, and project management

**Scopes Required:**
- `repo` - Full control of private repositories
- `read:org` - Read org and team membership
- `workflow` - Update GitHub Actions workflows

**How to Generate:**

1. Go to: https://github.com/settings/tokens/new

2. Fill in:
   - **Note**: "Claude Code MCP Server"
   - **Expiration**: 90 days (recommended)
   - **Scopes**: Check `repo`, `read:org`, `workflow`

3. Click **"Generate token"**

4. **Copy the token immediately** (you won't see it again)

5. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export GITHUB_TOKEN="ghp_your_token_here"
   ```

6. Reload shell:
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

**Validation:**
```bash
# Verify token is set
echo $GITHUB_TOKEN

# Test token works
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

---

### Linear API Key

**Purpose:** Issue tracking, sprint planning, project management

**How to Generate:**

1. Go to Linear settings: https://linear.app/settings/api

2. Click **"Create new API key"**

3. Fill in:
   - **Label**: "Claude Code MCP Server"
   - **Permissions**: Read/Write

4. Copy the API key

5. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export LINEAR_API_KEY="lin_api_your_key_here"
   ```

6. Reload shell:
   ```bash
   source ~/.zshrc
   ```

**Validation:**
```bash
# Verify key is set
echo $LINEAR_API_KEY

# Test key works (replace YOUR_KEY)
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ viewer { id name } }"}'
```

---

### PostHog API Key

**Purpose:** Product analytics, feature flags, A/B testing

**How to Generate:**

1. Go to PostHog settings: https://app.posthog.com/project/settings

2. Navigate to **"Project API Key"** section

3. Copy the **"Project API Key"**

4. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export POSTHOG_API_KEY="phc_your_key_here"
   export POSTHOG_HOST="https://app.posthog.com"  # or your self-hosted URL
   ```

5. Reload shell:
   ```bash
   source ~/.zshrc
   ```

**Validation:**
```bash
# Verify key is set
echo $POSTHOG_API_KEY

# Test key works
curl https://app.posthog.com/api/projects/@current/ \
  -H "Authorization: Bearer $POSTHOG_API_KEY"
```

---

### Figma Access Token

**Purpose:** Design file access, component management, collaboration

**How to Generate:**

1. Go to Figma settings: https://www.figma.com/settings

2. Scroll to **"Personal access tokens"**

3. Click **"Create new token"**

4. Fill in:
   - **Description**: "Claude Code MCP Server"
   - **Expiration**: Optional (90 days recommended)
   - **Scopes**: File content (read)

5. Copy the token

6. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export FIGMA_ACCESS_TOKEN="figd_your_token_here"
   ```

7. Reload shell:
   ```bash
   source ~/.zshrc
   ```

**Validation:**
```bash
# Verify token is set
echo $FIGMA_ACCESS_TOKEN

# Test token works
curl -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN" \
  https://api.figma.com/v1/me
```

---

### Jira API Token

**Purpose:** Enterprise issue tracking and project management

**How to Generate:**

1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens

2. Click **"Create API token"**

3. Fill in:
   - **Label**: "Claude Code MCP Server"

4. Copy the token

5. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export JIRA_HOST="your-domain.atlassian.net"
   export JIRA_EMAIL="your-email@company.com"
   export JIRA_API_TOKEN="your_token_here"
   ```

6. Reload shell:
   ```bash
   source ~/.zshrc
   ```

**Validation:**
```bash
# Verify variables are set
echo $JIRA_HOST
echo $JIRA_EMAIL
echo $JIRA_API_TOKEN

# Test token works
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  https://$JIRA_HOST/rest/api/3/myself
```

---

### Slack Bot Token

**Purpose:** Team communication, notifications, status updates

**How to Generate:**

1. Go to: https://api.slack.com/apps

2. Click **"Create New App"** → **"From scratch"**

3. Fill in:
   - **App Name**: "Claude Code Bot"
   - **Workspace**: Select your workspace

4. Go to **"OAuth & Permissions"**

5. Add **Bot Token Scopes**:
   - `chat:write` - Send messages
   - `chat:write.public` - Send messages to public channels
   - `channels:read` - View channels
   - `users:read` - View users
   - `files:write` - Upload files

6. Click **"Install to Workspace"**

7. Copy the **"Bot User OAuth Token"** (starts with `xoxb-`)

8. Store in your shell profile:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export SLACK_BOT_TOKEN="xoxb-your-token-here"
   ```

9. Reload shell:
   ```bash
   source ~/.zshrc
   ```

**Validation:**
```bash
# Verify token is set
echo $SLACK_BOT_TOKEN

# Test token works
curl -X POST https://slack.com/api/auth.test \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

---

### PostgreSQL Connection String

**Purpose:** Database operations, test data management, schema inspection

**Format:**
```
postgresql://username:password@hostname:port/database_name
```

**Examples:**
```bash
# Local development database
export POSTGRES_CONNECTION_STRING="postgresql://postgres:password@localhost:5432/myapp"

# Docker database
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/testdb"

# Remote database (use read-only user for safety)
export POSTGRES_CONNECTION_STRING="postgresql://readonly:pass@db.example.com:5432/production"
```

**Security Recommendations:**
1. **Use read-only user for production:**
   ```sql
   CREATE USER claude_readonly WITH PASSWORD 'secure_password';
   GRANT CONNECT ON DATABASE your_db TO claude_readonly;
   GRANT USAGE ON SCHEMA public TO claude_readonly;
   GRANT SELECT ON ALL TABLES IN SCHEMA public TO claude_readonly;
   ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO claude_readonly;
   ```

2. **Use dedicated test database for QA:**
   ```bash
   export POSTGRES_CONNECTION_STRING="postgresql://testuser:testpass@localhost:5432/testdb"
   ```

**Validation:**
```bash
# Verify connection string is set
echo $POSTGRES_CONNECTION_STRING

# Test connection (requires psql)
psql "$POSTGRES_CONNECTION_STRING" -c "SELECT version();"
```

---

## 🔐 Security Best Practices

### Storage

**✅ DO:**
- Store secrets in environment variables
- Use shell profile files (`~/.zshrc`, `~/.bashrc`)
- Use secret management services (AWS Secrets Manager, HashiCorp Vault)
- Encrypt config files if storing locally
- Use `.env.local` files (add to `.gitignore`)

**❌ DON'T:**
- Commit secrets to Git repositories
- Share secrets in Slack/email
- Store in plain-text files without encryption
- Use the same token across multiple services
- Store in code or configuration files

### Token Rotation

**Rotation Schedule:**
- **GitHub Token**: Every 90 days
- **Linear API Key**: Every 90 days
- **PostHog API Key**: Every 90 days
- **Figma Access Token**: Every 90 days
- **Jira API Token**: Every 90 days
- **Slack Bot Token**: Annually (or if compromised)
- **Database Passwords**: Every 90 days

**Immediate Rotation Required If:**
- Token accidentally committed to Git
- Team member with access leaves
- Suspicious activity detected
- Token appears in logs
- Service reports unauthorized access

### Principle of Least Privilege

**Grant only necessary permissions:**
- GitHub: Use `repo` scope, not `admin:org` unless needed
- Database: Read-only user for production
- Jira: Project-level access, not admin
- Slack: Minimal scopes for bot functionality

### Monitoring

**Track token usage:**
- Review GitHub token usage: https://github.com/settings/tokens
- Monitor Linear API key usage in Linear settings
- Check Slack app analytics
- Review database connection logs

**Set up alerts for:**
- Unexpected API usage spikes
- Failed authentication attempts
- Access from unusual locations
- Rate limit violations

---

## ✅ Validation Checklist

### Manual Validation

After setting environment variables, verify each one:

```bash
# Check all required variables for your persona

# Engineer
echo "GitHub Token: ${GITHUB_TOKEN:0:10}..."  # Shows first 10 chars

# PM (includes Engineer tokens)
echo "GitHub Token: ${GITHUB_TOKEN:0:10}..."
echo "Linear API Key: ${LINEAR_API_KEY:0:10}..."
echo "PostHog API Key: ${POSTHOG_API_KEY:0:10}..."
echo "Figma Access Token: ${FIGMA_ACCESS_TOKEN:0:10}..."

# EM (includes Engineer tokens)
echo "GitHub Token: ${GITHUB_TOKEN:0:10}..."
echo "Linear API Key: ${LINEAR_API_KEY:0:10}..."
echo "PostHog API Key: ${POSTHOG_API_KEY:0:10}..."
echo "Slack Bot Token: ${SLACK_BOT_TOKEN:0:10}..."

# UX
echo "Figma Access Token: ${FIGMA_ACCESS_TOKEN:0:10}..."
```

### Automated Validation Script

Run the validation script (included in installation):

```bash
# Validate your persona's required tokens
~/.claude/scripts/validate-install.sh
```

This script checks:
- ✅ All required environment variables are set
- ✅ Tokens have correct format
- ✅ MCP configuration files exist
- ✅ Persona config is correct

### Test MCP Server Connections

Test that MCP servers can connect with your tokens:

```bash
# Test GitHub connection
gh auth status

# Test Linear (requires linear CLI)
linear whoami

# Test PostgreSQL connection
psql "$POSTGRES_CONNECTION_STRING" -c "SELECT 1;"
```

---

## 🛠️ Troubleshooting

### "Token not found" errors

**Symptom:** MCP server reports token is missing

**Solution:**
1. Verify environment variable is set:
   ```bash
   echo $GITHUB_TOKEN  # or other token
   ```

2. If empty, add to shell profile:
   ```bash
   # Edit ~/.zshrc or ~/.bashrc
   export GITHUB_TOKEN="your_token_here"
   ```

3. Reload shell:
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

4. Restart Claude Code:
   ```bash
   # Close and reopen Claude Code terminal
   ```

### "Authentication failed" errors

**Symptom:** Token is set but authentication fails

**Solution:**
1. Verify token is valid:
   ```bash
   # Test GitHub token
   curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
   ```

2. Check token expiration in service settings

3. Regenerate token if expired

4. Verify token has required scopes/permissions

### "Permission denied" errors

**Symptom:** Token works but specific operations fail

**Solution:**
1. Check token scopes/permissions in service settings

2. For GitHub:
   - Go to: https://github.com/settings/tokens
   - Edit token, ensure `repo`, `read:org`, `workflow` are checked

3. For database:
   - Verify user has required permissions
   - Use read-only user for production

### MCP servers not loading

**Symptom:** MCP servers don't appear in Claude Code

**Solution:**
1. Verify MCP config file exists:
   ```bash
   ls -la ~/.claude/mcp-servers/mcp-config.json
   ```

2. Validate JSON syntax:
   ```bash
   cat ~/.claude/mcp-servers/mcp-config.json | python -m json.tool
   ```

3. Check Claude Code logs for errors

4. Restart Claude Code

---

## 📚 Additional Resources

### Token Documentation

- **GitHub**: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
- **Linear**: https://developers.linear.app/docs/graphql/working-with-the-graphql-api#authentication
- **PostHog**: https://posthog.com/docs/api/overview
- **Figma**: https://www.figma.com/developers/api#authentication
- **Jira**: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
- **Slack**: https://api.slack.com/authentication/token-types

### Secret Management Tools

- **AWS Secrets Manager**: https://aws.amazon.com/secrets-manager/
- **HashiCorp Vault**: https://www.vaultproject.io/
- **Azure Key Vault**: https://azure.microsoft.com/en-us/services/key-vault/
- **1Password CLI**: https://developer.1password.com/docs/cli/
- **Doppler**: https://www.doppler.com/

---

## 🔄 Quick Reference

### Environment Variable Template

Create `~/.claude/.env.template` with your required tokens:

```bash
# Required for all personas
export GITHUB_TOKEN="ghp_xxxxx"

# PM/EM personas
export LINEAR_API_KEY="lin_api_xxxxx"
export POSTHOG_API_KEY="phc_xxxxx"

# PM/UX personas
export FIGMA_ACCESS_TOKEN="figd_xxxxx"

# EM persona
export SLACK_BOT_TOKEN="xoxb-xxxxx"

# Optional - Database access
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/db"

# Optional - Jira (PM/EM)
export JIRA_HOST="your-domain.atlassian.net"
export JIRA_EMAIL="you@company.com"
export JIRA_API_TOKEN="xxxxx"
```

### Shell Profile Locations

```bash
# macOS/Linux with Zsh (default on macOS 10.15+)
~/.zshrc

# macOS/Linux with Bash
~/.bashrc

# macOS with Bash (login shell)
~/.bash_profile

# Fish shell
~/.config/fish/config.fish
```

---

**Version**: 1.0.0
**Last Updated**: 2025-11-11
**Maintained by**: Engineering Team
