# MCP Server Installation Reference

**Version**: 2.3.0
**Date**: 2025-10-04
**Purpose**: Complete installation guide for all MCP servers across personas

---

## 📋 Quick Reference Table

| MCP Server | Package | Install Command | Env Variables | Personas |
|------------|---------|-----------------|---------------|----------|
| **Serena** | `@oraios/serena-mcp` | `uvx --from git+https://github.com/oraios/serena serena-mcp-server` | None | Engineer |
| **GitHub** | `@modelcontextprotocol/server-github` | `npx -y @modelcontextprotocol/server-github` | `GITHUB_TOKEN` | All except UX |
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | `npx -y @modelcontextprotocol/server-filesystem` | None | Engineer, QA, UX |
| **Memory** | `@modelcontextprotocol/server-memory` | `npx -y @modelcontextprotocol/server-memory` | None | All |
| **Sequential-thinking** | `@modelcontextprotocol/server-sequential-thinking` | `npx -y @modelcontextprotocol/server-sequential-thinking` | None | Engineer, QA |
| **Playwright** | `@modelcontextprotocol/server-playwright` | `npx -y @modelcontextprotocol/server-playwright` | None | Engineer, QA, UX |
| **PostgreSQL** | `@modelcontextprotocol/server-postgres` | `npx -y @modelcontextprotocol/server-postgres` | `POSTGRES_CONNECTION_STRING` | Engineer, QA, EM |
| **A11y MCP** | `a11y-mcp` | `npm install -g a11y-mcp` | None | QA, UX |
| **Linear** | `linear-mcp` | `npm install -g linear-mcp` | `LINEAR_API_KEY` | PM, EM |
| **Jira** | `jira-mcp` | `npm install -g jira-mcp` | `JIRA_API_TOKEN`, `JIRA_URL` | PM, EM |
| **PostHog** | `posthog-mcp` | `npm install -g posthog-mcp` | `POSTHOG_API_KEY` | PM, EM |
| **Figma** | `figma-mcp` | `npm install -g figma-mcp` | `FIGMA_ACCESS_TOKEN` | PM, UX |
| **Slack** | `@modelcontextprotocol/server-slack` | `npx -y @modelcontextprotocol/server-slack` | `SLACK_BOT_TOKEN` | PM, EM, UX |

---

## 🔧 Installation Methods

### Method 1: Persona-Specific Script (Recommended)
```bash
# Installs all servers for your role
./install-scripts/install-mcp-engineer.sh
./install-scripts/install-mcp-qa.sh
./install-scripts/install-mcp-pm.sh
./install-scripts/install-mcp-em.sh
./install-scripts/install-mcp-ux.sh
```

### Method 2: Main Script with Persona Flag
```bash
./install-scripts/install-mcp-servers.sh --persona engineer
```

### Method 3: Individual Server Installation
```bash
# Install specific server manually
npx -y @modelcontextprotocol/server-playwright
npm install -g a11y-mcp
```

---

## 📦 Server Details by Persona

### 🧑‍💻 Software Engineer (7 servers)

#### 1. Serena (Priority 1)
**What**: LSP-based semantic code navigation
**Why**: Only MCP server using Language Server Protocol - understands code structure, not just text
**Installation**:
```bash
uvx --from git+https://github.com/oraios/serena serena-mcp-server
```
**Languages**: Java, Python, JavaScript, TypeScript, Go, Rust
**Use Cases**:
- Find all implementations of an interface
- Go to definition across dependency injection
- Semantic code search (not keyword matching)
- Symbol-level code editing

#### 2. GitHub (Priority 1)
**What**: GitHub integration for PRs, issues, code reviews
**Installation**:
```bash
npx -y @modelcontextprotocol/server-github
```
**Requires**: `GITHUB_TOKEN` (personal access token with repo scope)
**Setup**:
```bash
export GITHUB_TOKEN="ghp_your_token_here"
```
**Use Cases**:
- Create PRs with AI-generated descriptions
- Review PRs and suggest improvements
- Manage issues and project boards

#### 3. Filesystem (Priority 1)
**What**: Fast file operations with large file handling
**Installation**:
```bash
npx -y @modelcontextprotocol/server-filesystem
```
**Use Cases**:
- Read/write source code files
- Navigate project directory structure
- Sequential reading for large files

#### 4. Memory (Priority 2)
**What**: Persistent context across sessions
**Installation**:
```bash
npx -y @modelcontextprotocol/server-memory
```
**Use Cases**:
- Remember architecture decisions
- Store project coding patterns
- Cache frequently used code snippets

#### 5. Sequential-thinking (Priority 2)
**What**: Multi-phase planning for complex tasks
**Installation**:
```bash
npx -y @modelcontextprotocol/server-sequential-thinking
```
**Use Cases**:
- Architectural design and system decomposition
- Complex refactoring with dependency analysis
- Migration planning (monolith → microservices)

#### 6. Playwright (Priority 2)
**What**: Browser automation and E2E testing
**Installation**:
```bash
npx -y @modelcontextprotocol/server-playwright
```
**Use Cases**:
- Create E2E tests for features
- Automate browser testing across browsers
- Debug frontend issues with screenshots

#### 7. PostgreSQL (Priority 2)
**What**: Database querying and schema inspection
**Installation**:
```bash
npx -y @modelcontextprotocol/server-postgres
```
**Requires**: `POSTGRES_CONNECTION_STRING`
**Setup**:
```bash
export POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/dbname"
```
**Security**: Use read-only database user
**Use Cases**:
- Query database schema
- Write and test SQL queries
- Inspect database performance

---

### 🧪 QA Engineer (7 servers)

#### 1. Playwright (Priority 1)
**What**: E2E browser automation (Microsoft official)
**Installation**:
```bash
npx -y @modelcontextprotocol/server-playwright
```
**Use Cases**:
- Create and run E2E tests across browsers
- Automated visual regression testing
- Cross-browser compatibility (Chrome, Firefox, Safari)
- Mobile emulation and responsive testing

#### 2. GitHub (Priority 1)
**Same as Engineer bundle**

#### 3. Filesystem (Priority 1)
**What**: Test file management and fixture handling
**Use Cases**:
- Manage test files and test suites
- Read/write test fixtures and mock data
- Organize visual regression baselines

#### 4. A11y MCP (Priority 1)
**What**: AI-powered accessibility testing with Axe-core
**Installation**:
```bash
npm install -g a11y-mcp
```
**Standards**: WCAG 2.0, 2.1, 2.2 (wcag2a, wcag2aa, wcag2aaa)
**Use Cases**:
- Run WCAG compliance checks
- Automated color contrast analysis
- ARIA validation and keyboard navigation testing

**Configuration Example**:
```json
{
  "mcpServers": {
    "a11y-mcp": {
      "command": "a11y-mcp",
      "args": []
    }
  }
}
```

#### 5. Memory (Priority 2)
**Use Cases** (QA-specific):
- Store test scenarios and edge cases
- Remember flaky test patterns
- Track bug investigation history

#### 6. Sequential-thinking (Priority 2)
**Use Cases** (QA-specific):
- Comprehensive test strategy planning
- Systematic bug root cause analysis
- Risk-based test prioritization

#### 7. PostgreSQL (Priority 2)
**Use Cases** (QA-specific):
- Set up test data in databases
- Validate data migrations in testing
- Query database state for test assertions

---

### 📋 Product Manager (7 servers)

#### 1. GitHub (Priority 1)
**Use Cases** (PM-specific):
- Manage issues and project boards
- Track feature requests
- Link requirements to implementation

#### 2. Linear (Priority 1)
**What**: Modern issue tracking and sprint planning
**Installation**:
```bash
npm install -g linear-mcp
```
**Requires**: `LINEAR_API_KEY`
**Setup**:
```bash
export LINEAR_API_KEY="lin_api_your_key_here"
```
**Use Cases**:
- Create and prioritize issues
- Sprint planning and tracking
- Roadmap visualization
- Team velocity metrics

**Configuration Example**:
```json
{
  "mcpServers": {
    "linear": {
      "command": "linear-mcp",
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    }
  }
}
```

#### 3. PostHog (Priority 1)
**What**: Product analytics and feature flags
**Installation**:
```bash
npm install -g posthog-mcp
```
**Requires**: `POSTHOG_API_KEY`, `POSTHOG_PROJECT_ID`
**Setup**:
```bash
export POSTHOG_API_KEY="phc_your_key_here"
export POSTHOG_PROJECT_ID="12345"
```
**Use Cases**:
- Product usage analytics
- Feature flag management
- User cohort analysis
- Funnel tracking

#### 4. Figma (Priority 1)
**What**: Design system integration and Code Connect
**Installation**:
```bash
npm install -g figma-mcp
```
**Requires**: `FIGMA_ACCESS_TOKEN`
**Setup**:
```bash
export FIGMA_ACCESS_TOKEN="fig_your_token_here"
```
**Use Cases**:
- Access Figma components and variables
- Generate user stories from designs
- Reference designs in PRDs
- Extract design tokens

**Configuration Example**:
```json
{
  "mcpServers": {
    "figma": {
      "command": "figma-mcp",
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}"
      }
    }
  }
}
```

#### 5. Memory (Priority 2)
**Use Cases** (PM-specific):
- Store requirements and user personas
- Remember feature prioritization rationale
- Cache product roadmap context

#### 6. Jira (Priority 2)
**What**: Enterprise project management
**Installation**:
```bash
npm install -g jira-mcp
```
**Requires**: `JIRA_API_TOKEN`, `JIRA_URL`, `JIRA_PROJECT_KEY`
**Setup**:
```bash
export JIRA_API_TOKEN="your_api_token"
export JIRA_URL="https://yourcompany.atlassian.net"
export JIRA_PROJECT_KEY="PROJ"
```
**Use Cases**:
- Create epics and stories
- Sprint management
- Advanced JQL queries

#### 7. Slack (Priority 2)
**What**: Team communication and notifications
**Installation**:
```bash
npx -y @modelcontextprotocol/server-slack
```
**Requires**: `SLACK_BOT_TOKEN`
**Setup**:
```bash
export SLACK_BOT_TOKEN="xoxb-your-bot-token"
```
**Use Cases**:
- Send team updates
- Stakeholder communication
- Feature announcement

---

### 📊 Engineering Manager (6-7 servers)

Same as PM bundle with focus on:
- **GitHub**: PR metrics, team velocity
- **Linear/Jira**: Sprint planning
- **PostHog**: Engineering analytics
- **Slack**: Team coordination
- **PostgreSQL**: DORA metrics queries
- **Memory**: Team metrics history

---

### 🎨 UX Designer (6 servers)

#### 1. Figma (Priority 1)
**Use Cases** (UX-specific):
- Design system integration
- Generate code from Figma designs
- Code Connect mappings
- Design token extraction

#### 2. A11y MCP (Priority 1)
**Use Cases** (UX-specific):
- Validate accessibility compliance
- Check color contrast in design system
- WCAG 2.1 AA compliance

#### 3. Playwright (Priority 1)
**Use Cases** (UX-specific):
- Responsive design testing
- Test navigation at different breakpoints
- Visual regression testing

#### 4. Filesystem (Priority 1)
**Use Cases** (UX-specific):
- Manage design asset files
- Handle component documentation

#### 5. Memory (Priority 2)
**Use Cases** (UX-specific):
- Remember design system patterns
- Store component library context

#### 6. Slack (Priority 2)
**Use Cases** (UX-specific):
- Design feedback and reviews
- Collaboration with developers

---

## 🔐 Environment Variables Setup

### Create .env file
```bash
# ~/.env
GITHUB_TOKEN="ghp_your_github_token"
LINEAR_API_KEY="lin_api_your_key"
JIRA_API_TOKEN="your_jira_token"
JIRA_URL="https://yourcompany.atlassian.net"
JIRA_PROJECT_KEY="PROJ"
POSTHOG_API_KEY="phc_your_posthog_key"
POSTHOG_PROJECT_ID="12345"
FIGMA_ACCESS_TOKEN="fig_your_figma_token"
SLACK_BOT_TOKEN="xoxb-your-slack-bot-token"
POSTGRES_CONNECTION_STRING="postgresql://user:pass@localhost:5432/dbname"
```

### Load in shell profile
```bash
# Add to ~/.zshrc or ~/.bashrc
if [ -f ~/.env ]; then
    export $(cat ~/.env | xargs)
fi
```

---

## ✅ Verification

### Check Installed Servers
```bash
claude mcp list
```

### Test Individual Server
```bash
# Test GitHub connection
claude mcp test github

# Test Playwright
claude mcp test playwright
```

### Verify Configuration
```bash
# Check settings.json
cat ~/.claude/settings.json | jq '.mcpServers'
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue: "Server not found"
**Solution**: Install the package globally
```bash
npm install -g <package-name>
# or
npx -y <package-name>
```

#### Issue: "Authentication failed" (GitHub/Linear/etc.)
**Solution**: Check environment variables
```bash
echo $GITHUB_TOKEN
# If empty, set it:
export GITHUB_TOKEN="ghp_..."
```

#### Issue: "Command not found: uvx" (Serena)
**Solution**: Install uv first
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Issue: Playwright browsers not installed
**Solution**:
```bash
npx playwright install
```

#### Issue: PostgreSQL connection refused
**Solution**: Check connection string format
```bash
# Correct format:
postgresql://username:password@hostname:5432/database_name
```

---

## 📚 Additional Resources

### Official Documentation
- **MCP Specification**: https://modelcontextprotocol.io/
- **MCP Servers GitHub**: https://github.com/modelcontextprotocol/servers
- **Awesome MCP Servers**: https://github.com/punkpeye/awesome-mcp-servers

### Server-Specific Docs
- **Serena**: https://github.com/oraios/serena
- **Playwright MCP**: https://github.com/microsoft/playwright-mcp
- **Figma MCP**: https://help.figma.com/hc/en-us/articles/32132100833559
- **A11y MCP**: https://medium.com/@ronantech/a11y-mcp

### Getting API Tokens

#### GitHub Token
1. Go to https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `workflow`
4. Copy token to `GITHUB_TOKEN`

#### Linear API Key
1. Go to Linear Settings → API
2. Create Personal API Key
3. Copy to `LINEAR_API_KEY`

#### Figma Access Token
1. Go to Figma → Settings → Personal Access Tokens
2. Create new token
3. Copy to `FIGMA_ACCESS_TOKEN`

#### PostHog API Key
1. Go to PostHog → Project Settings → API Keys
2. Copy Personal API Key
3. Set `POSTHOG_API_KEY`

#### Slack Bot Token
1. Go to https://api.slack.com/apps
2. Create new app or use existing
3. Add OAuth scopes: `chat:write`, `channels:history`
4. Install to workspace
5. Copy Bot User OAuth Token (`xoxb-...`)

---

## 🎯 Quick Start by Persona

### Software Engineer
```bash
# 1. Install persona config
./install-scripts/claude-config.sh engineer

# 2. Set environment variables
export GITHUB_TOKEN="ghp_..."
export POSTGRES_CONNECTION_STRING="postgresql://..."

# 3. Install MCP servers
./install-scripts/install-mcp-engineer.sh

# 4. Restart Claude Code
# Done! 🎉
```

### QA Engineer
```bash
./install-scripts/claude-config.sh qa
export GITHUB_TOKEN="ghp_..."
./install-scripts/install-mcp-qa.sh
# Restart Claude Code
```

### Product Manager
```bash
./install-scripts/claude-config.sh pm
export GITHUB_TOKEN="ghp_..."
export LINEAR_API_KEY="lin_..."
export FIGMA_ACCESS_TOKEN="fig_..."
export POSTHOG_API_KEY="phc_..."
./install-scripts/install-mcp-pm.sh
# Restart Claude Code
```

### Engineering Manager
```bash
./install-scripts/claude-config.sh em
export GITHUB_TOKEN="ghp_..."
export LINEAR_API_KEY="lin_..."
export POSTHOG_API_KEY="phc_..."
export SLACK_BOT_TOKEN="xoxb-..."
./install-scripts/install-mcp-em.sh
# Restart Claude Code
```

### UX Designer
```bash
./install-scripts/claude-config.sh ux
export FIGMA_ACCESS_TOKEN="fig_..."
./install-scripts/install-mcp-ux.sh
# Restart Claude Code
```

---

**Version**: 2.3.0
**Status**: ✅ Complete
**Ready to Use**: Yes - Follow persona-specific quick start

---

*Complete MCP server installation reference for all engineering personas* 🚀
