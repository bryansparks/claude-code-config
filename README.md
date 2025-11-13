# Claude Code Configuration Framework

**Production-ready Claude Code configuration with persona-specific workflows, MCP server bundles, and vision-driven development.**

[![Version](https://img.shields.io/badge/version-2.3.0-blue.svg)](https://github.com/bryansparks/claude-code-config)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🚀 Quick Start

### Installation (Private Repository)

**Step 1: Clone the repository**
```bash
git clone git@github.com:bryansparks/claude-code-config.git
cd claude-code-config
```

**Step 2: Run installation for your persona**
```bash
# Software Engineer
./install.sh engineer

# QA Engineer
./install.sh qa

# Product Manager
./install.sh pm

# Engineering Manager
./install.sh em

# UX Designer
./install.sh ux
```

**Step 3: Clean up (optional)**
```bash
cd ..
rm -rf claude-code-config  # Remove cloned repo after installation
```

**After installation:**
1. Restart Claude Code
2. Try `/init-project` to create a new project
3. Check MCP servers: `claude mcp list`

---

## 👋 New to This Repository?

**What is this?** A production-ready configuration system for Claude Code that provides:
- **Role-specific workflows** (Engineer, QA, PM, EM, UX)
- **Intelligent AI assistants** (Skills that activate automatically)
- **External tool integrations** (GitHub, Linear, PostHog, Figma, etc.)
- **Enterprise standards** (OWASP, WCAG, ISO/IEC 25010)

**Who is this for?**
- Engineering teams wanting to standardize Claude Code usage
- Product managers needing AI-assisted PRD creation
- QA teams automating accessibility and testing workflows
- Organizations wanting consistent AI-assisted development

**What makes this different?**
1. **Auto-Invoked Skills**: Claude intelligently activates specialized assistants (no commands needed)
2. **Persona-Optimized**: Each role gets exactly the tools and workflows they need
3. **Data-Driven**: Auto-pulls metrics from PostHog, issues from Linear, designs from Figma
4. **AI-First**: Always suggests AI-powered solutions alongside traditional approaches
5. **Enterprise-Ready**: Org-wide standards that apply to all projects

**Quick Decision Guide:**

Choose **Software Engineer** if you:
- Write code (any language)
- Need code review assistance
- Want semantic code navigation
- Debug complex issues

Choose **QA Engineer** if you:
- Create test automation
- Run accessibility audits
- Do visual regression testing
- Manage test strategies

Choose **Product Manager** if you:
- Write PRDs and requirements
- Define success metrics
- Explore feature solutions
- Need to be more precise

Choose **Engineering Manager** if you:
- Track team metrics (DORA)
- Do sprint planning
- Monitor team performance
- Manage capacity

Choose **UX Designer** if you:
- Work with design systems
- Test accessibility (WCAG)
- Validate responsive designs
- Generate code from Figma

**First Steps After Installation:**

1. **Engineers**: Ask Claude to review some code → Watch `code-review` Skill activate
2. **PMs**: Try `/create-prd-interactive "Feature Name"` → Experience guided PRD creation
3. **QA**: Request an accessibility audit → See `accessibility-audit` Skill in action
4. **Everyone**: Run `/init-project` in your repository → Set up project context

**Need Help?**
- [Quick Start Guide](docs/QUICK_START.md) - 5-minute walkthrough
- [Skills Guide](docs/SKILLS.md) - How Skills work (Engineer)
- [PM Skills Guide](docs/PM_SKILLS_GUIDE.md) - PM-specific guidance
- [MCP Servers Guide](docs/MCP_SERVERS_BY_PERSONA.md) - Tool integrations

---

### Updating Your Installation

To get the latest updates:
```bash
git clone git@github.com:bryansparks/claude-code-config.git
cd claude-code-config
./install.sh --update
cd ..
rm -rf claude-code-config
```

## ✨ Features

- **🎭 5 Persona Configurations**: Engineer (8 skills), QA (4 skills), PM (4 skills + 4 commands), EM, UX
- **🧠 Auto-Invoked Skills**: 16 intelligent assistants that activate automatically
- **🔌 Persona-Specific MCP Bundles**: 6-7 optimized servers per role (GitHub, Linear, PostHog, Figma, etc.)
- **🤖 AI-First Approach**: Always explore AI solutions (LLMs, ML, Computer Vision) with cost estimates
- **📚 Vision-Driven Development**: PROJECT.md + VISION.md + ORGANIZATION.md three-tier architecture
- **🛡️ Enterprise Standards**: OWASP Top 10, WCAG 2.1, ISO/IEC 25010, TDD built-in
- **🚀 One-Command Install**: Sparse checkout, selective downloads, ~5 minutes setup
- **📊 Data-Driven**: Auto-pulls PostHog metrics, Linear issues, Figma designs, GitHub data
- **📖 Comprehensive Documentation**: 14+ guides covering every persona and workflow

## 🎭 Personas

Choose the persona that matches your role for optimized workflows, MCP servers, and skills.

| Persona | MCP Servers | Skills | Focus Areas |
|---------|-------------|--------|-------------|
| **Software Engineer** | 7 | 8 | Code review, debugging, performance, API design |
| **QA Engineer** | 7 | 4 | Test automation, accessibility, visual regression |
| **Product Manager** | 7 | 4 | PRD creation, success metrics, AI ideation |
| **Engineering Manager** | 7 | Coming soon | DORA metrics, team performance, capacity planning |
| **UX Designer** | 6 | Coming soon | Design systems, accessibility, responsive design |

### 👨‍💻 Software Engineer

**Who it's for:** Full-stack, backend, frontend, and API developers

**What you get:**
- **7 MCP Servers**: Serena (semantic code nav), GitHub, Filesystem, Memory, Sequential-thinking, Playwright, PostgreSQL
- **8 Auto-Invoked Skills**:
  - 🔍 Code Review - Quality, security, performance analysis
  - 🐛 Debug Analysis - Root cause analysis and fixes
  - ⚡ Performance Optimization - Bottleneck identification
  - 🔒 Security Analysis - OWASP Top 10 vulnerability detection
  - ♿ Accessibility Development - WCAG compliance checking
  - 🧪 Unit Test Generator - Test coverage and TDD
  - 🏗️ API Design Review - RESTful best practices
  - 📐 ISO Standards Compliance - Quality model adherence

**Key Workflows:**
- Navigate large codebases with Serena's LSP-based semantic search
- Create PRs with comprehensive descriptions
- Debug complex issues with AI-powered root cause analysis
- Optimize performance bottlenecks
- Generate unit tests automatically

**Best for:** Engineers who want AI-assisted code review, debugging, and architectural guidance

[Full Engineer Guide →](docs/ENGINEER_SKILLS_TRAINING.md)

---

### 🧪 QA Engineer

**Who it's for:** QA engineers, test automation specialists, accessibility testers

**What you get:**
- **7 MCP Servers**: Playwright (E2E testing), GitHub, Filesystem, A11y MCP (WCAG), Memory, Sequential-thinking, PostgreSQL
- **4 Auto-Invoked Skills**:
  - 🎭 Accessibility Audit - WCAG 2.0/2.1/2.2 compliance with Axe-core
  - 🐛 Bug Analysis - Systematic bug investigation and reproduction
  - 🤖 Test Automation - E2E test generation and coverage analysis
  - 👁️ Visual Regression - Screenshot comparison and UI validation

**Key Workflows:**
- Create Playwright E2E tests from user stories
- Run automated accessibility audits (WCAG 2.1 AA/AAA)
- Generate test plans and strategies
- Set up test data in databases
- Visual regression testing across browsers

**Best for:** QA teams focusing on test automation, accessibility, and quality assurance

---

### 📋 Product Manager (NEW ENHANCEMENTS!)

**Who it's for:** Product managers, product owners, technical program managers

**What you get:**
- **7 MCP Servers**: GitHub, Linear, PostHog (analytics), Figma, Memory, Filesystem, Playwright
- **4 Auto-Invoked Skills**:
  - 🧭 PRD Guide - Interactive 7-step PRD creation wizard
  - 📊 Success Criteria Builder - Converts vague goals → SMART metrics
  - 🔍 Requirements Refiner - Detects vague language, ensures precision
  - 🤖 AI Solution Ideation - Explores AI/ML opportunities with cost estimates
- **4 New Slash Commands**:
  - `/create-prd-interactive` - Guided PRD creation (saves 2-3 hours)
  - `/explore-ai-features` - AI feasibility analysis with ROI
  - `/ideate-solutions` - Brainstorm 5-8 approaches (traditional + AI)
  - `/validate-requirements` - Completeness scoring with actionable fixes

**Key Workflows:**
- Interactive PRD creation with real-time guidance
- Define SMART success metrics with PostHog baselines
- Explore AI-powered solutions (LLMs, ML, Computer Vision)
- Validate requirements for precision and completeness
- Track features with Linear and analyze with PostHog

**PM Skills Features:**
- ✅ **Precision by Default**: Detects vague terms ("fast" → "< 500ms")
- ✅ **AI-First Thinking**: Always suggests AI alongside traditional solutions
- ✅ **Data-Driven**: Auto-pulls PostHog metrics, Linear feedback, Figma designs
- ✅ **Interactive Guidance**: Step-by-step wizard with validation at each stage

**Expected Impact:**
- 60% faster PRD creation (3-4 hours → 1-1.5 hours)
- 75% fewer engineering clarification requests
- 200%+ increase in AI opportunities explored
- 50% improvement in requirements precision

**Best for:** PMs who need to write precise requirements and explore AI-powered solutions

[Full PM Skills Guide →](docs/PM_SKILLS_GUIDE.md) | [PM Enhancement Details →](docs/PM_ENHANCEMENT_PROPOSAL.md)

---

### 📊 Engineering Manager

**Who it's for:** Engineering managers, tech leads, team leads

**What you get:**
- **7 MCP Servers**: GitHub (PR metrics), Linear, PostHog (engineering analytics), Slack, Memory, PostgreSQL (DORA metrics), Sequential-thinking
- **Skills**: Coming soon (team performance, capacity planning, DORA metrics)

**Key Workflows:**
- Track DORA metrics (deployment frequency, lead time, MTTR, change failure rate)
- Monitor team velocity and sprint health
- Capacity planning and workload balancing
- Performance reviews with data
- Incident retrospectives

**Best for:** Managers who need data-driven insights into team performance and engineering metrics

---

### 🎨 UX Designer

**Who it's for:** UX designers, UI designers, product designers

**What you get:**
- **6 MCP Servers**: Figma (Code Connect), A11y MCP (WCAG), Playwright (responsive testing), Filesystem, Memory, Slack
- **Skills**: Coming soon (design systems, accessibility validation, responsive design)

**Key Workflows:**
- Design-to-code with Figma Code Connect
- Automated accessibility testing (WCAG 2.1 AA)
- Responsive design testing across breakpoints
- Design system documentation
- Visual regression testing

**Best for:** Designers who work closely with code and need accessibility validation

---

**Not sure which persona?** Start with **Software Engineer** - it's the most versatile and can be customized later.

## 📁 What Gets Installed

```
~/.claude/                     # Everything lives here!
├── CLAUDE.md                 # Your configuration
├── ORGANIZATION.md           # Company standards
├── config/
│   └── mcp-servers/         # Persona MCP configs
├── skills/                  # Auto-invoked Skills (NEW!)
├── templates/               # Project templates
├── commands/                # Slash commands
├── hooks/                   # Event hooks
└── scripts/                 # Helper scripts
```

**No clutter in your project root!** Everything stays in `~/.claude/`

## 🧠 Skills (Auto-Invoked Intelligence)

**Skills are AI assistants that automatically activate** when Claude detects specific tasks. No commands needed - just work naturally and Skills activate when helpful.

### 👨‍💻 Software Engineer Skills (8 Skills)

| Skill | Triggers | What It Does |
|-------|----------|--------------|
| 🔍 **code-review** | Code review requests | OWASP Top 10, performance, best practices analysis |
| 🐛 **debug-analysis** | Bug reports, errors | Root cause analysis with fixes |
| ⚡ **performance-optimization** | "Slow", "optimization" | Bottleneck identification, profiling guidance |
| 🔒 **security-analysis** | Authentication, data handling | OWASP vulnerability detection |
| ♿ **accessibility-development** | UI components | WCAG 2.1 compliance checking |
| 🧪 **unit-test-generator** | "Write tests" | TDD, coverage analysis, test generation |
| 🏗️ **api-design-review** | API endpoints | RESTful best practices, OpenAPI |
| 📐 **iso-standards-compliance** | Architecture discussions | ISO/IEC 25010 quality model |

### 🧪 QA Engineer Skills (4 Skills)

| Skill | Triggers | What It Does |
|-------|----------|--------------|
| 🎭 **accessibility-audit** | A11y testing requests | WCAG 2.0/2.1/2.2 compliance with Axe-core |
| 🐛 **bug-analysis** | Bug investigation | Systematic reproduction and root cause |
| 🤖 **test-automation** | Test creation | E2E test generation, coverage gaps |
| 👁️ **visual-regression** | UI testing | Screenshot comparison, visual validation |

### 📋 Product Manager Skills (4 Skills) ✨ NEW!

| Skill | Triggers | What It Does |
|-------|----------|--------------|
| 🧭 **prd-guide** | PRD writing | 7-step interactive PRD wizard |
| 📊 **success-criteria-builder** | Vague goals ("improve", "better") | Converts to SMART metrics with baselines |
| 🔍 **requirements-refiner** | Vague language ("fast", "easy") | Ensures precision, suggests specifics |
| 🤖 **ai-solution-ideation** | Problem descriptions | Explores AI/ML solutions with costs |

**PM Skills Example:**
```
You: "Goal: Improve checkout experience"

Claude (success-criteria-builder activates):
"Let's make this measurable. Checking PostHog...

Current: 35% abandonment, 4.2min checkout time

Which matters most?
A) Reduce abandonment 35% → 25% within 6 weeks
B) Reduce time 4.2min → 2.5min within 4 weeks

Also, have you considered AI?
✨ LLM assistant could guide users through shipping selection
   Cost: ~$600/mo, Examples: Shopify Sidekick"
```

**Skills are intelligent because they:**
- ✅ Activate automatically at the right moment
- ✅ Pull real data (PostHog metrics, Linear issues, Figma designs)
- ✅ Suggest solutions you might not consider (especially AI)
- ✅ Ensure precision (catch vague language immediately)
- ✅ Validate completeness before you proceed

[Engineer Skills Guide →](SKILLS.md) | [PM Skills Guide →](docs/PM_SKILLS_GUIDE.md)

---

## 🔌 MCP Servers by Persona

**MCP (Model Context Protocol) servers** extend Claude Code with external tool integrations. Each persona gets an optimized bundle of 6-7 servers.

### 👨‍💻 Software Engineer (7 servers)

| Server | Purpose | Priority | Use Cases |
|--------|---------|----------|-----------|
| **Serena** | LSP-based semantic code navigation | P1 | Navigate large codebases, find implementations, go-to-definition |
| **GitHub** | Issues, PRs, code reviews | P1 | Create PRs, review code, manage issues |
| **Filesystem** | Fast file operations | P1 | Read/write source files, search patterns |
| **Memory** | Persistent context across sessions | P2 | Remember architecture decisions, coding patterns |
| **Sequential-thinking** | Multi-phase planning | P2 | Architectural design, complex refactoring |
| **Playwright** | E2E testing, browser automation | P2 | Create E2E tests, debug frontend issues |
| **PostgreSQL** | Database queries, schema inspection | P2 | Query DB schema, test data setup |

**Setup:** Requires `GITHUB_TOKEN`, optional `POSTGRES_CONNECTION_STRING`

---

### 🧪 QA Engineer (7 servers)

| Server | Purpose | Priority | Use Cases |
|--------|---------|----------|-----------|
| **Playwright** | E2E browser automation (Microsoft) | P1 | Cross-browser testing, visual regression |
| **GitHub** | Test automation CI/CD | P1 | Bug tracking, test results on PRs |
| **Filesystem** | Test file management | P1 | Manage test files, fixtures, baselines |
| **A11y MCP** | Accessibility testing (Axe-core) | P1 | WCAG 2.0/2.1/2.2 compliance checks |
| **Memory** | Test case persistence | P2 | Store test scenarios, flaky test patterns |
| **Sequential-thinking** | Test strategy planning | P2 | Comprehensive test plans, root cause analysis |
| **PostgreSQL** | Test data management | P2 | Set up test data, validate database state |

**Setup:** Requires `GITHUB_TOKEN`, optional `POSTGRES_CONNECTION_STRING`

---

### 📋 Product Manager (7 servers)

| Server | Purpose | Priority | Use Cases |
|--------|---------|----------|-----------|
| **GitHub** | Issues, project boards | P1 | Manage backlog, track features |
| **Linear** | Modern issue tracking | P1 | Sprint planning, roadmap visualization |
| **PostHog** | Product analytics | P1 | Usage data, feature flags, A/B tests |
| **Figma** | Design specs, Code Connect | P1 | Reference designs in PRDs, generate user stories |
| **Memory** | Requirements persistence | P2 | Store user personas, successful patterns |
| **Filesystem** | PRD/document management | P2 | Read/write requirements, generate docs |
| **Playwright** | UX validation | P2 | Validate acceptance criteria, test user flows |

**Setup:** Requires `GITHUB_TOKEN`, `LINEAR_API_KEY`, `POSTHOG_API_KEY`, `FIGMA_ACCESS_TOKEN`

**PM Workflows Enhanced by MCP:**
- Pull PostHog metrics automatically when defining success criteria
- Check Linear for user feedback when writing PRDs
- Reference Figma designs when creating requirements
- Store successful PRD patterns in Memory

---

### 📊 Engineering Manager (7 servers)

| Server | Purpose | Priority | Use Cases |
|--------|---------|----------|-----------|
| **GitHub** | PR metrics, team velocity | P1 | Track DORA metrics, code review analytics |
| **Linear** | Sprint planning, capacity | P1 | Team workload, velocity tracking |
| **PostHog** | Engineering analytics | P1 | System health, feature performance |
| **Slack** | Team coordination | P1 | Updates, incident management |
| **Memory** | Team metrics history | P2 | Store 1:1 notes, performance baselines |
| **PostgreSQL** | DORA metrics database | P2 | Query deployment frequency, lead time |
| **Sequential-thinking** | Strategic planning | P2 | Team structure, technical debt prioritization |

**Setup:** Requires `GITHUB_TOKEN`, `LINEAR_API_KEY`, `POSTHOG_API_KEY`, `SLACK_BOT_TOKEN`

---

### 🎨 UX Designer (6 servers)

| Server | Purpose | Priority | Use Cases |
|--------|---------|----------|-----------|
| **Figma** | Design system, Code Connect | P1 | Extract tokens, generate code from designs |
| **A11y MCP** | WCAG compliance | P1 | Color contrast, ARIA validation |
| **Playwright** | Responsive testing | P1 | Test at mobile/tablet/desktop breakpoints |
| **Filesystem** | Design asset management | P1 | Manage SVGs, design tokens, documentation |
| **Memory** | Design pattern storage | P2 | Remember design system patterns, UX research |
| **Slack** | Design feedback | P2 | Share designs, coordinate with team |

**Setup:** Requires `FIGMA_ACCESS_TOKEN`, optional `SLACK_BOT_TOKEN`

---

### 🔑 MCP Server Quick Reference

**What is MCP?** Model Context Protocol allows Claude Code to interact with external tools and services.

**Installation:** MCP servers install automatically with your persona. Manual installation:
```bash
# See which servers are configured
claude mcp list

# Install specific server
npm install -g @modelcontextprotocol/server-github
```

**Configuration:** Set environment variables for API access:
```bash
# Common across personas
export GITHUB_TOKEN="ghp_your_token"

# PM-specific
export LINEAR_API_KEY="lin_your_key"
export POSTHOG_API_KEY="phc_your_key"
export FIGMA_ACCESS_TOKEN="figd_your_token"

# EM-specific
export SLACK_BOT_TOKEN="xoxb-your-token"
```

**Cost:** Most MCP servers are free (GitHub, Filesystem, Memory). Cloud services (PostHog, Linear) have their own pricing.

[Full MCP Server Guide →](MCP_SERVERS_BY_PERSONA.md) | [MCP Installation →](docs/MCP_INSTALLATION.md)

---

## 🏗️ Three-Tier Configuration Architecture

**Organization → Project → Vision** - Every Claude Code session has full context automatically.

### 1. ORGANIZATION.md (Company-Wide Standards)

**What it is**: Engineering best practices, security standards, and workflows that apply to ALL projects.

**What's included**:
- ✅ OWASP Top 10 security compliance
- ✅ WCAG 2.1 accessibility standards
- ✅ ISO/IEC 25010 quality model (8 characteristics)
- ✅ Test-Driven Development (TDD) requirements
- ✅ Code review standards and SLAs
- ✅ Git workflow and commit conventions
- ✅ API design standards (RESTful, OpenAPI)
- ✅ Documentation requirements

**Key principle**: Organization standards **never change per-project**. They provide consistency across your entire engineering organization.

**Customization**: Edit ORGANIZATION.md for your company, then distribute via `install.sh --update`.

### 2. PROJECT.md (Project-Specific Context)

**What it is**: Project architecture, tech stack, team structure, and file organization.

**What's included**:
- Project overview and business value
- Technology stack (frontend, backend, infrastructure)
- Team structure and communication channels
- Architecture patterns and design decisions
- File structure and important locations
- Development workflow and getting started guide
- Integration points (internal systems, external services)
- Environment configuration (dev, staging, production)
- Testing strategy and tools

**Key principle**: Stable during project lifetime. Changes infrequently.

**Creation**: Automatically created by `/init-project` command with auto-detection of tech stack, git repo, and team.

### 3. VISION.md (Product Goals & Roadmap)

**What it is**: Strategic direction, implementation phases, and success criteria.

**What's included**:
- Product vision and goals
- Implementation roadmap (phase by phase)
- Architectural decisions and rationale
- Success metrics and acceptance criteria
- Technical constraints and assumptions

**Key principle**: Living document, updated sprint-by-sprint as the project evolves.

**Creation**: Created by `/create-vision-doc` command or during `/init-project`.

### How It Works Together

```
┌─────────────────────────────────────────────────────────────┐
│ ORGANIZATION.md (Global)                                     │
│ "How we build software as an organization"                   │
│ • Security standards      • Testing requirements             │
│ • Code quality rules      • Documentation standards          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PROJECT.md (Per-Repository)                                  │
│ "What this project is and how it's structured"              │
│ • Architecture            • Tech stack                       │
│ • Team composition        • File structure                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ VISION.md (Per-Repository, Living)                           │
│ "Where we're going and how we'll get there"                 │
│ • Product goals           • Implementation phases            │
│ • Success criteria        • Architectural decisions          │
└─────────────────────────────────────────────────────────────┘
```

**On Claude Code startup**, all three layers are automatically loaded, giving Claude complete context without any manual setup.

### Example Workflow

```bash
# 1. Install Claude-Config with your persona
curl -fsSL https://url/install.sh | bash -s -- engineer

# This installs ORGANIZATION.md with your company's standards

# 2. Navigate to a project and initialize it
cd ~/my-project
claude-code /init-project my-api-service

# This creates:
# - ~/.claude/projects/my-api-service/PROJECT.md (auto-detected tech stack)
# - ~/.claude/projects/my-api-service/VISION.md (optional)

# 3. Start working - Claude has full context automatically
claude-code
> "Review my authentication code"
# Claude uses: Organization security standards + Project architecture + Vision goals
```

### Benefits

✅ **Consistency**: Organization standards apply everywhere
✅ **Context-Aware**: Claude knows your project architecture and goals
✅ **Zero Setup**: Auto-loading on startup, no manual configuration
✅ **Separation of Concerns**: Company standards vs project details vs product vision
✅ **Easy Updates**: Update organization standards centrally, push to all users

**Learn more**: [Vision System Guide](docs/VISION_SYSTEM.md)

## 📊 Metrics (Optional)

**Status**: ⚠️ **Disabled by default** - No metrics collected unless you enable them

Metrics are **completely optional** and designed for mature Claude Code adoption (6+ months). Most organizations should keep metrics disabled.

### Three Levels of Metrics

| Level | Infrastructure | When to Use | Cost |
|-------|---------------|-------------|------|
| **Disabled** (default) | None | Starting out (0-6 months) | $0 |
| **Local** (optional) | None | Early adoption (3-6 months) | $0 |
| **Centralized** (advanced) | PostgreSQL + 2 servers | Mature adoption (6+ months) | $500-2000/mo |

**To enable local metrics** (lightweight, no infrastructure):
```yaml
# Edit ~/.claude/config/metrics.yml
metrics_mode: local
local_metrics:
  enabled: true
```

**For centralized dashboard** (requires infrastructure):
- Read decision guide: [`docs/METRICS_DECISION_GUIDE.md`](docs/METRICS_DECISION_GUIDE.md)
- Installation: [`optional-features/metrics-dashboard/`](optional-features/metrics-dashboard/)

💡 **Recommendation**: Keep metrics disabled initially. Focus on getting value from skills first. Add metrics later if needed.

## 📖 Documentation

### Getting Started
- **[Quick Start Guide](docs/QUICK_START.md)** - 5-minute walkthrough for new users
- **[Installation Guide](docs/INSTALLATION.md)** - Detailed setup instructions
- **[Vision System](docs/VISION_SYSTEM.md)** - Three-tier configuration architecture

### Skills & Workflows
- **[Engineer Skills Guide](SKILLS.md)** - 8 auto-invoked skills for developers
- **[PM Skills Guide](docs/PM_SKILLS_GUIDE.md)** ✨ NEW! - 4 skills + 4 commands for product managers
- **[PM Enhancement Proposal](docs/PM_ENHANCEMENT_PROPOSAL.md)** - Technical details on PM features
- **[How to Use Skills](docs/HOW_TO_USE_SKILLS.md)** - Skills best practices
- **[Workflow Examples](docs/WORKFLOW_EXAMPLES.md)** - Real-world usage scenarios

### MCP Server Guides
- **[MCP Servers by Persona](docs/MCP_SERVERS_BY_PERSONA.md)** - Complete server reference (70+ pages)
- **[MCP Installation Reference](docs/MCP_INSTALLATION_REFERENCE.md)** - Detailed installation guide
- **[MCP Server Details](docs/MCP_SERVERS.md)** - Individual server documentation

### Organization Deployment
- **[Secrets Management](docs/SECRETS_MANAGEMENT.md)** - Handling API keys securely
- **[Skills Guide](docs/SKILLS.md)** - Auto-invoked task assistance

### Advanced Topics
- **[Metrics Decision Guide](docs/METRICS_DECISION_GUIDE.md)** - Should you enable metrics?
- **[Metrics Dashboard Spec](docs/METRICS_DASHBOARD_SPEC.md)** - Centralized analytics (optional)
- **[Claude.md Architecture](docs/CLAUDE_MD_ARCHITECTURE.md)** - Configuration system design

## 🔧 Advanced Usage

### Install All Personas
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --all
```

### Update Installation
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --update
```

### Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --uninstall
```

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

**Made with ❤️ for Claude Code** | Version 2.3.0
