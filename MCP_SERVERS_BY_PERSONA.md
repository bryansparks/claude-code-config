# MCP Servers by Persona - Comprehensive Guide

**Version**: 2.3.0
**Date**: 2025-10-04
**Purpose**: Role-optimized MCP server configurations for each persona

---

## 🎯 Philosophy

Different engineering roles have **different workflows and tools**. This document defines persona-specific MCP server bundles that match each role's daily tasks and responsibilities.

**Key Principle**: Install only what you need, optimized for your role.

---

## 📊 MCP Server Matrix

| MCP Server | Engineer | QA | PM | EM | UX | Purpose |
|------------|----------|----|----|----|----|---------|
| **Serena** | ✅ P1 | ⚪ | ⚪ | ⚪ | ⚪ | LSP-based semantic code navigation |
| **GitHub** | ✅ P1 | ✅ P1 | ✅ P1 | ✅ P1 | ⚪ | Issues, PRs, project boards |
| **Filesystem** | ✅ P1 | ✅ P1 | ⚪ | ⚪ | ✅ P1 | File operations, large file handling |
| **Memory** | ✅ P1 | ✅ P1 | ✅ P2 | ✅ P2 | ✅ P2 | Persistent context across sessions |
| **Sequential-thinking** | ✅ P2 | ✅ P2 | ⚪ | ⚪ | ⚪ | Multi-phase planning, architecture |
| **Playwright** | ✅ P2 | ✅ P1 | ⚪ | ⚪ | ✅ P1 | Browser automation, E2E testing |
| **PostgreSQL** | ✅ P2 | ✅ P2 | ⚪ | ✅ P2 | ⚪ | Database querying, test data |
| **A11y MCP** | ⚪ | ✅ P1 | ⚪ | ⚪ | ✅ P1 | Accessibility testing, WCAG compliance |
| **Linear** | ⚪ | ⚪ | ✅ P1 | ✅ P1 | ⚪ | Issue tracking, sprint planning |
| **Jira** | ⚪ | ⚪ | ✅ P2 | ✅ P2 | ⚪ | Enterprise project management |
| **PostHog** | ⚪ | ⚪ | ✅ P1 | ✅ P1 | ⚪ | Product analytics, feature flags |
| **Figma** | ⚪ | ⚪ | ✅ P1 | ⚪ | ✅ P1 | Design context, Code Connect |
| **Slack** | ⚪ | ⚪ | ✅ P2 | ✅ P1 | ✅ P2 | Team communication, notifications |

**Legend**: ✅ = Included | P1 = Priority 1 (Essential) | P2 = Priority 2 (Recommended) | ⚪ = Not included

---

## 👨‍💻 Software Engineer Bundle

### Servers Included (7 total)

#### Priority 1: Essential
1. **Serena** - Semantic code understanding via LSP
2. **GitHub** - Issues, PRs, code reviews
3. **Filesystem** - Advanced file operations

#### Priority 2: Recommended
4. **Memory** - Context persistence across sessions
5. **Sequential-thinking** - Architectural planning
6. **Playwright** - E2E testing and browser automation
7. **PostgreSQL** - Database schema and queries

### Common Workflows Enabled

**Daily Development:**
- Navigate large codebases with Serena's LSP-based semantic search
- Create PRs and manage issues via GitHub
- Read/write files with advanced filesystem operations
- Persist project context with Memory

**Architecture & Planning:**
- Use Sequential-thinking for multi-phase architectural design
- Query database schemas with PostgreSQL
- Set up E2E tests with Playwright

**Example Usage:**
```bash
# Navigate codebase semantically
"Find all implementations of the PaymentProcessor interface"

# Create PR with context
"Create a PR for the authentication refactor we discussed"

# Query database
"Show me the schema for the users and orders tables"
```

### Installation
```bash
./install-scripts/install-mcp-engineer.sh
# Or
./install-scripts/install-mcp-servers.sh --persona engineer
```

---

## 🧪 QA Engineer Bundle

### Servers Included (7 total)

#### Priority 1: Essential
1. **Playwright** - E2E browser automation
2. **GitHub** - Test automation CI/CD
3. **Filesystem** - Test file management
4. **A11y MCP** - Accessibility testing

#### Priority 2: Recommended
5. **Memory** - Test case persistence
6. **Sequential-thinking** - Test strategy planning
7. **PostgreSQL** - Test data setup and validation

### Common Workflows Enabled

**Test Automation:**
- Create and run E2E tests with Playwright
- Automate accessibility audits with A11y MCP (Axe-core integration)
- Manage test files and fixtures with Filesystem
- Persist test scenarios with Memory

**Quality Assurance:**
- Run WCAG compliance checks
- Set up test databases with PostgreSQL
- Plan comprehensive test strategies with Sequential-thinking
- Integrate tests into GitHub Actions CI/CD

**Example Usage:**
```bash
# Create E2E test
"Create a Playwright test for the checkout flow"

# Run accessibility audit
"Audit the product page for WCAG 2.1 AA compliance"

# Set up test data
"Create test data in the staging database for user registration flow"

# Plan test strategy
"Create a test strategy for the new payment integration"
```

### Installation
```bash
./install-scripts/install-mcp-qa.sh
# Or
./install-scripts/install-mcp-servers.sh --persona qa
```

---

## 📋 Product Manager Bundle

### Servers Included (7 total)

#### Priority 1: Essential
1. **GitHub** - Issues and project boards
2. **Linear** - Issue tracking and sprint planning
3. **PostHog** - Product analytics
4. **Figma** - Design context for PRDs

#### Priority 2: Recommended
5. **Memory** - Requirements persistence
6. **Jira** - Enterprise project management (if org uses Jira)
7. **Slack** - Team communication

### Common Workflows Enabled

**Product Planning:**
- Create and prioritize issues in Linear/GitHub
- Analyze product usage with PostHog
- Reference designs from Figma in PRDs
- Track sprint progress across tools

**Requirements Management:**
- Generate user stories with acceptance criteria
- Create PRDs from Figma designs
- Track feature rollout with PostHog feature flags
- Communicate with team via Slack

**Example Usage:**
```bash
# Analyze feature performance
"Show PostHog analytics for the guest checkout feature"

# Create user stories from design
"Generate user stories from the Figma checkout redesign"

# Plan sprint
"Create Linear issues for Q1 roadmap priorities"

# Track feature flag
"What's the rollout percentage for the new recommendation engine?"
```

### Installation
```bash
./install-scripts/install-mcp-pm.sh
# Or
./install-scripts/install-mcp-servers.sh --persona pm
```

---

## 📊 Engineering Manager Bundle

### Servers Included (6 total)

#### Priority 1: Essential
1. **GitHub** - PR reviews, team velocity
2. **Linear** - Sprint planning and tracking
3. **PostHog** - Engineering analytics
4. **Slack** - Team communication

#### Priority 2: Recommended
5. **Memory** - Team metrics history
6. **PostgreSQL** - DORA metrics queries
7. **Jira** - Enterprise sprint management (if org uses Jira)

### Common Workflows Enabled

**Team Management:**
- Track PR review times via GitHub
- Monitor sprint progress in Linear
- Calculate DORA metrics from GitHub + PostgreSQL
- Coordinate team via Slack

**Performance Tracking:**
- Query deployment frequency (DORA)
- Analyze team velocity trends
- Track blocker resolution time
- Monitor engineering productivity with PostHog

**Example Usage:**
```bash
# Calculate DORA metrics
"Show DORA metrics for the team over the last quarter"

# Track sprint health
"What's our current sprint burndown in Linear?"

# Team coordination
"Send a Slack message about tomorrow's architecture review"

# PR analytics
"Show average PR review time by team member this month"
```

### Installation
```bash
./install-scripts/install-mcp-em.sh
# Or
./install-scripts/install-mcp-servers.sh --persona em
```

---

## 🎨 UX Designer Bundle

### Servers Included (6 total)

#### Priority 1: Essential
1. **Figma** - Design system integration, Code Connect
2. **A11y MCP** - Accessibility auditing
3. **Playwright** - Responsive testing
4. **Filesystem** - Design file management

#### Priority 2: Recommended
5. **Memory** - Design system persistence
6. **Slack** - Design feedback and collaboration

### Common Workflows Enabled

**Design System:**
- Access Figma components and variables
- Generate code from Figma with Code Connect
- Validate accessibility with A11y MCP
- Test responsive designs with Playwright

**Collaboration:**
- Share design feedback via Slack
- Persist design system patterns with Memory
- Manage design asset files with Filesystem
- Run WCAG compliance checks

**Example Usage:**
```bash
# Generate code from Figma
"Generate React components from the Figma button variants"

# Check accessibility
"Audit the color contrast in our design system"

# Test responsive
"Test the navigation component at mobile, tablet, and desktop breakpoints"

# Share with team
"Post to Slack: New design system tokens are ready for review"
```

### Installation
```bash
./install-scripts/install-mcp-ux.sh
# Or
./install-scripts/install-mcp-servers.sh --persona ux
```

---

## 🔧 Server Descriptions

### Core Infrastructure

#### Filesystem
**Package**: `@modelcontextprotocol/server-filesystem`
**Purpose**: Fast file operations with large file handling
**Features**:
- Fast file reading/writing
- Sequential reading for large files
- Directory operations
- File search with patterns
- Streaming writes with backup & recovery

**Use Cases**:
- Engineers: Read/write source code
- QA: Manage test files and fixtures
- UX: Handle design asset files

---

#### Memory
**Package**: `@modelcontextprotocol/server-memory`
**Purpose**: Persistent context across Claude sessions
**Features**:
- Store and recall information between sessions
- Navigate large codebases with consistent context
- Remember project-specific patterns
- Cache frequently accessed data

**Use Cases**:
- Engineers: Remember architecture decisions
- QA: Persist test scenarios and edge cases
- PM: Store requirements and user personas
- EM: Track team metrics history
- UX: Remember design system patterns

---

### Code Development

#### Serena
**Package**: `@oraios/serena-mcp`
**Purpose**: LSP-based semantic code navigation (100x better than text search)
**Features**:
- Symbol-level code understanding
- Go to definition/implementation
- Find all references
- Semantic code search
- Multi-language support (Java, Python, JS, TS, Go, Rust)

**Use Cases**:
- Engineers: Navigate large codebases semantically
- "Find all callers of this function"
- "Show implementations of this interface"

**Why It's Amazing**:
- Uses Language Server Protocol (LSP) not text search
- Understands code structure and semantics
- Works with dependency injection frameworks (Spring, etc.)
- Free and open-source

---

#### Sequential-thinking
**Package**: `@modelcontextprotocol/server-sequential-thinking`
**Purpose**: Multi-phase planning and problem decomposition
**Features**:
- Break down complex problems into phases
- Structured thought sequences
- Goal-oriented planning
- Architectural design support

**Use Cases**:
- Engineers: Architectural planning, system design
- QA: Comprehensive test strategy planning
- "Design the architecture for microservices migration"
- "Create a phased rollout plan for the new feature"

---

### Version Control & Project Management

#### GitHub
**Package**: `@modelcontextprotocol/server-github`
**Purpose**: GitHub integration for issues, PRs, repos
**Features**:
- Create and manage issues
- Create and review PRs
- Access project boards
- Search code and commits
- Manage releases

**Use Cases**:
- Engineers: Code reviews, PR creation
- QA: Test automation CI/CD integration
- PM: Issue tracking, project boards
- EM: PR metrics, team velocity

**Setup**: Requires `GITHUB_TOKEN` environment variable

---

#### Linear
**Package**: `linear-mcp` or via Linear API
**Purpose**: Modern issue tracking and sprint planning
**Features**:
- Create and prioritize issues
- Sprint planning and tracking
- Roadmap visualization
- Team velocity metrics
- Cycle automation

**Use Cases**:
- PM: Feature prioritization, sprint planning
- EM: Team coordination, velocity tracking
- "Create Linear issues for the Q1 roadmap"
- "Show sprint progress for current cycle"

**Setup**: Requires Linear API key

---

#### Jira
**Package**: `jira-mcp`
**Purpose**: Enterprise project management
**Features**:
- Create epics and stories
- Sprint management
- Advanced JQL queries
- Workflow automation
- Custom fields

**Use Cases**:
- PM: Enterprise-scale project management
- EM: Sprint planning, dependency tracking
- "Create Jira epic from Figma design with user stories"

**Setup**: Requires Jira API token and project key

---

### Testing & Quality

#### Playwright
**Package**: `@modelcontextprotocol/server-playwright` (Microsoft official)
**Purpose**: Browser automation and E2E testing
**Features**:
- Cross-browser testing (Chromium, Firefox, WebKit)
- Network interception
- Screenshot and video capture
- Accessibility tree navigation
- Mobile emulation

**Use Cases**:
- Engineers: E2E testing for features
- QA: Automated test creation and execution
- UX: Responsive design testing
- "Create Playwright test for the checkout flow"
- "Test navigation at mobile and desktop breakpoints"

---

#### A11y MCP
**Package**: `a11y-mcp`
**Purpose**: AI-powered accessibility testing with Axe-core
**Features**:
- WCAG 2.0, 2.1, 2.2 compliance checking
- Color contrast analysis
- ARIA validation
- Keyboard navigation testing
- Comprehensive accessibility reports

**Use Cases**:
- QA: Automated accessibility testing
- UX: WCAG compliance validation
- "Audit the product page for WCAG 2.1 AA compliance"
- "Check color contrast in our design system"

**Standards Supported**:
- wcag2a, wcag2aa, wcag2aaa
- wcag21a, wcag21aa, wcag22aa
- Categories: cat.aria, cat.color, cat.forms, cat.keyboard

---

### Databases & Analytics

#### PostgreSQL
**Package**: `@modelcontextprotocol/server-postgres` or `postgres-mcp`
**Purpose**: Database querying and schema inspection
**Features**:
- Read-only SQL queries (secure)
- Schema inspection (tables, columns, indexes)
- Query performance analysis
- Execution plan analysis
- Connection health checks

**Use Cases**:
- Engineers: Database schema inspection, query optimization
- QA: Test data setup and validation
- EM: DORA metrics queries (deployment frequency from DB)
- "Show me the schema for users and orders tables"
- "Set up test data for the registration flow"

**Setup**: Requires PostgreSQL connection string (read-only user recommended)

---

#### PostHog
**Package**: `posthog-mcp`
**Purpose**: Product analytics and feature flags
**Features**:
- Product usage analytics
- Feature flag management
- User cohort analysis
- Funnel tracking
- A/B test results

**Use Cases**:
- PM: Product analytics, feature performance
- EM: Engineering productivity metrics
- "Show analytics for the guest checkout feature"
- "What's the rollout percentage for the new recommendation engine?"

**Setup**: Requires PostHog API key and project ID

---

### Design & Collaboration

#### Figma
**Package**: `figma-mcp` (official Figma server)
**Purpose**: Design system integration and Code Connect
**Features**:
- Access Figma components and variables
- Code Connect mappings (Figma → code)
- Design token extraction
- Auto-generate code from designs
- Accessibility annotations

**Use Cases**:
- PM: Reference designs in PRDs, generate user stories from designs
- UX: Design-to-code generation, design system management
- "Generate React components from Figma button variants"
- "Create PRD from the checkout redesign in Figma"

**Setup**: Requires Figma API token, file/frame access

**Key Innovation**: When Figma frames use Code Connect and variables, generated code uses REAL component libraries and design tokens, not generic divs!

---

#### Slack
**Package**: `@modelcontextprotocol/server-slack` or `slack-mcp`
**Purpose**: Team communication and notifications
**Features**:
- Send messages to channels/DMs
- Thread replies
- Fetch conversation history
- Channel management
- Smart history fetch

**Use Cases**:
- PM: Team updates, stakeholder communication
- EM: Team coordination, blockers notification
- UX: Design feedback and reviews
- "Send Slack message about tomorrow's architecture review"
- "Post to #design: New tokens ready for review"

**Setup**: Requires Slack Bot Token (`SLACK_BOT_TOKEN`)

---

## 🚀 Installation Guide

### Quick Start

#### 1. Install Persona Configuration
```bash
./install-scripts/claude-config.sh engineer
```

#### 2. Install Persona-Specific MCP Servers
```bash
# Option A: Persona-specific script
./install-scripts/install-mcp-engineer.sh

# Option B: Main script with persona flag
./install-scripts/install-mcp-servers.sh --persona engineer

# Option C: Auto-detect from environment
export CLAUDE_PERSONA="engineer"
./install-scripts/install-mcp-servers.sh
```

### Individual Server Installation

```bash
# Install specific server manually
npm install -g @oraios/serena-mcp
npm install -g @modelcontextprotocol/server-playwright
npm install -g a11y-mcp
```

### Configuration

Add to `~/.claude/settings.json` or persona-specific MCP config:

```json
{
  "mcpServers": {
    "serena": {
      "command": "serena-mcp-server",
      "args": [],
      "env": {}
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

---

## 📊 Comparison: Universal vs Persona-Specific

### Before (Universal)
```bash
# Every persona gets same 8 servers
- Serena (engineers only need this)
- Claude Context (large codebases)
- Filesystem (everyone)
- Memory (everyone)
- Sequential-thinking (engineers, QA)
- GitHub (engineers, PM, EM)
- Playwright (engineers, QA, UX)
- Context7 (analytics - PM, EM only need this)

Result: 8 servers per person, many unused
```

### After (Persona-Specific)
```bash
# Engineer: 7 servers (all useful)
# QA: 7 servers (testing-focused)
# PM: 7 servers (product-focused)
# EM: 6 servers (management-focused)
# UX: 6 servers (design-focused)

Result: Fewer servers, ALL relevant to role
```

---

## 💡 Best Practices

### 1. Start with Priority 1 Servers
Install essential servers first, add Priority 2 as needed.

### 2. Environment Variables
Store API keys in `.zshrc` or `.bashrc`:
```bash
export GITHUB_TOKEN="ghp_..."
export LINEAR_API_KEY="lin_..."
export FIGMA_ACCESS_TOKEN="fig_..."
export SLACK_BOT_TOKEN="xoxb-..."
export POSTHOG_API_KEY="phc_..."
```

### 3. Security
- Use read-only database users for PostgreSQL
- Limit GitHub token scope to necessary permissions
- Use workspace-specific Slack tokens

### 4. Performance
- Only install servers you'll actually use
- Disable unused servers in MCP config
- Monitor MCP server memory usage

---

## 🔄 Updates

### Adding New Server
```bash
# 1. Install package
npm install -g @scope/new-mcp-server

# 2. Add to persona MCP config
vim ~/.claude/templates/<persona>/mcp-servers/mcp-config.json

# 3. Test
claude mcp list
```

### Updating Servers
```bash
# Update all npm-based servers
npm update -g

# Update specific server
npm update -g @oraios/serena-mcp
```

---

## 📚 Resources

### Official MCP Documentation
- [MCP Specification](https://modelcontextprotocol.io/)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)

### Server-Specific Docs
- [Serena GitHub](https://github.com/oraios/serena)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP Guide](https://help.figma.com/hc/en-us/articles/32132100833559)
- [A11y MCP](https://medium.com/@ronantech/a11y-mcp-an-mcp-server-for-web-accessibility-testing-e5aeeb322af3)

---

**Version**: 2.3.0
**Status**: ✅ Complete
**Role-Optimized**: Each persona gets exactly what they need

---

*Optimized MCP server bundles for maximum productivity per role* 🚀
