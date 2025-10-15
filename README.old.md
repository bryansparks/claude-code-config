# Claude Code Persona Configuration Templates

A comprehensive collection of role-specific Claude Code configurations designed for engineering teams. Each persona includes specialized subagents, automation hooks, custom commands, and MCP server integrations tailored to specific roles.

## 🎯 Available Personas

| Persona | Icon | Description | Key Focus |
|---------|------|-------------|-----------|
| **Software Engineer** | 👨‍💻 | Full-stack development | Code quality, testing, debugging, optimization |
| **QA Engineer** | 🧪 | Quality assurance | Test automation, bug analysis, accessibility, performance |
| **Engineering Manager** | 👔 | Team leadership | Metrics, planning, technical debt, coordination |
| **Product Manager** | 📊 | Product strategy | User stories, roadmaps, requirements, stakeholder communication |
| **UX Designer** | 🎨 | User experience | Design systems, accessibility, user flows, visual consistency |

## 📦 What's Included

Each persona configuration contains:

### Subagents (5 per persona)
Specialized AI assistants with domain expertise:
- Focused knowledge areas
- Specific output formats
- Collaboration protocols
- Best practices embedded

### Hooks (5-7 per persona)
Automated workflows triggered by file operations:
- Pre/post tool use automation
- Quality checks
- Validation scripts
- Metric collection

### Commands (7-8 per persona)
Custom slash commands for common tasks:
- Role-specific operations
- Comprehensive documentation
- Flag-based options
- Example usage

### MCP Server Configurations
Optimized integrations for each role:
- GitHub (issues, PRs, repos)
- Playwright (browser automation, testing)
- Context7 (long-term memory)
- Sequential Thinking (complex workflows)
- Filesystem (local operations)

### Settings
Pre-configured Claude Code settings:
- Hook automation rules
- Subagent activation patterns
- Command definitions
- Workflow sequences

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
cd ~/projects/Claude-Config

# Make the installer executable
chmod +x install-scripts/claude-config.sh

# Install a persona (will backup existing config)
./install-scripts/claude-config.sh <persona>
```

### Available Personas

```bash
# Software Engineer
./install-scripts/claude-config.sh engineer

# QA Engineer
./install-scripts/claude-config.sh qa

# Engineering Manager
./install-scripts/claude-config.sh em

# Product Manager
./install-scripts/claude-config.sh pm

# UX Designer
./install-scripts/claude-config.sh ux
```

### Installation Options

```bash
# Preview changes without installing
./install-scripts/claude-config.sh qa --dry-run

# Install without creating backup
./install-scripts/claude-config.sh engineer --no-backup

# Force overwrite existing files
./install-scripts/claude-config.sh pm --force

# Install only specific components
./install-scripts/claude-config.sh ux --hooks-only
./install-scripts/claude-config.sh engineer --subagents-only
./install-scripts/claude-config.sh qa --commands-only
```

## 📚 Persona Details

### 👨‍💻 Software Engineer

**Components:**
- **Subagents**: Code Reviewer, Debugger, Refactorer, API Designer, Performance Optimizer
- **Hooks**: Auto test runner, lint on save, dependency check, commit helper, complexity check
- **Commands**: `/debug`, `/refactor`, `/optimize`, `/review`, `/test`
- **MCP Servers**: GitHub, Filesystem, Sequential Thinking, Playwright

**Best For:**
- Writing clean, maintainable code
- Test-driven development
- Debugging complex issues
- API design and implementation
- Performance optimization
- Code reviews

### 🧪 QA Engineer

**Components:**
- **Subagents**: Test Automation Specialist, Bug Analyst, Performance Tester, Accessibility Auditor, Visual Regression Tester
- **Hooks**: Auto test on change, coverage reporter, visual regression, accessibility validator, flakiness detector
- **Commands**: `/test-coverage`, `/accessibility-audit`, `/performance-test`, `/bug-report`, `/test-plan`
- **MCP Servers**: Playwright (priority 1), GitHub, Sequential Thinking, Context7

**Best For:**
- Test automation (unit, integration, E2E)
- Bug reproduction and analysis
- Accessibility compliance (WCAG 2.1)
- Performance and load testing
- Visual regression testing
- Test coverage tracking

### 👔 Engineering Manager

**Components:**
- **Subagents**: Project Analyzer, Team Coordinator, Technical Debt Assessor, Metrics Reporter, Code Health Monitor
- **Hooks**: PR review summary, sprint health check, technical debt tracker, velocity calculator, blocker detector
- **Commands**: `/analyze-project`, `/team-metrics`, `/sprint-planning`, `/technical-debt-audit`, `/dependency-map`
- **MCP Servers**: GitHub (priority 1), Context7, Memory, Sequential Thinking

**Best For:**
- Team velocity tracking
- Sprint planning and execution
- Technical debt management
- Code quality monitoring
- Blocker identification
- Capacity planning
- Cross-team coordination

### 📊 Product Manager

**Components:**
- **Subagents**: Feature Analyzer, Requirement Validator, User Story Writer, Roadmap Planner, UX Evaluator
- **Hooks**: User story validator, acceptance criteria checker, feature impact analyzer, documentation generator
- **Commands**: `/analyze-feature`, `/write-user-story`, `/roadmap-planning`, `/requirements-doc`, `/stakeholder-update`
- **MCP Servers**: GitHub, Context7, Memory, Playwright

**Best For:**
- Writing user stories (As a/I want/So that)
- Creating acceptance criteria (Given/When/Then)
- Feature prioritization (RICE framework)
- Roadmap planning (now/next/later)
- Requirements documentation (PRD, specs)
- Stakeholder communication
- UX validation

### 🎨 UX Designer

**Components:**
- **Subagents**: UI Component Reviewer, Accessibility Specialist, Design System Expert, Interaction Designer, User Flow Architect
- **Hooks**: Accessibility checker, design token validator, component documentation, responsive test, contrast checker
- **Commands**: `/design-review`, `/accessibility-audit`, `/component-library`, `/design-system-check`, `/user-flow`
- **MCP Servers**: Playwright (priority 1), GitHub, Filesystem, Context7

**Best For:**
- Design system compliance
- Accessibility compliance (WCAG 2.1 AA/AAA)
- Component library management
- User flow optimization
- Interaction design
- Responsive design validation
- Visual consistency

## 🔧 Configuration Structure

```
~/.claude/
├── subagents/           # AI specialists for your role
├── hooks/               # Automated workflows
├── commands/            # Custom slash commands
├── mcp-servers/         # MCP server configurations
└── settings.json        # Claude Code settings
```

## 💡 Usage Examples

### Software Engineer Workflow

```bash
# Start coding
/review --files src/auth.ts
/debug --error "TypeError: Cannot read property 'map'"
/refactor --file src/utils/helpers.js --dry-pattern
/optimize --database --query "getUsersWithPosts"
/test --coverage --files src/
```

### QA Engineer Workflow

```bash
# Testing workflow
/test-coverage --full
/accessibility-audit --page /checkout --level AA
/performance-test --endpoint /api/users --load 1000
/visual-test --component ProductCard
/bug-report --severity P1 --issue "Checkout fails on mobile"
```

### Engineering Manager Workflow

```bash
# Management tasks
/analyze-project --depth full
/team-metrics --timeframe sprint
/sprint-planning --sprint-number 48
/technical-debt-audit --export markdown
/dependency-map --scope team
```

### Product Manager Workflow

```bash
# Product workflows
/analyze-feature "Guest checkout"
/write-user-story "Allow users to save payment methods"
/roadmap-planning Q1-2025 --format now-next-later
/requirements-doc --type PRD
/stakeholder-update sprint 42
```

### UX Designer Workflow

```bash
# Design workflows
/design-review --file ProductCard.tsx --complete
/accessibility-audit --page /checkout --level AA
/component-library --audit
/design-system-check --score
/user-flow --analyze checkout --funnel
```

## 🔌 MCP Server Setup

### Required Environment Variables

```bash
# GitHub integration (required for most personas)
export GITHUB_TOKEN="ghp_your_token_here"

# Upstash Redis (optional, for Context7)
export UPSTASH_REDIS_REST_URL="your_url"
export UPSTASH_REDIS_REST_TOKEN="your_token"
```

### Install MCP Servers

```bash
# GitHub CLI (recommended)
brew install gh
gh auth login

# Playwright (for QA and UX personas)
npx @executeautomation/playwright-mcp-server

# Context7 (for long-term memory)
npm install -g @upstash/context7-mcp
```

## 📋 Hook Automation

Hooks run automatically on file operations:

### Pre-Tool Use Hooks
- **Write/Edit**: Linting, validation, complexity checks
- **Bash**: Command logging, safety checks

### Post-Tool Use Hooks
- **Write/Edit**: Auto-testing, coverage reports, commit messages
- **Test completion**: Metrics, reporting

### Session Hooks
- **SessionStart**: Welcome message, environment check
- **Stop**: Cleanup, final reports

## 🎓 Best Practices

### For All Personas

1. **Start with dry-run**: Test installation before applying
   ```bash
   ./install-scripts/claude-config.sh qa --dry-run
   ```

2. **Backup regularly**: Installer creates automatic backups
   ```bash
   ls ~/.claude/backups/
   ```

3. **Customize for your team**: Edit hooks and commands as needed
   ```bash
   vim ~/.claude/hooks/auto-test-runner.sh
   ```

4. **Use flags effectively**: Commands support multiple options
   ```bash
   /review --files src/ --quality --evidence
   ```

### Persona-Specific Tips

**Engineers**: Use `/debug` with `--trace` for deep analysis
**QA**: Run `/test-coverage` before each PR
**Managers**: Schedule hooks (e.g., sprint health check on Mondays)
**PMs**: Use `/analyze-feature` with RICE scores for prioritization
**UX**: Always run `/accessibility-audit` before launch

## 🛠️ Troubleshooting

### Installation Issues

```bash
# Verify template directory exists
ls templates/

# Check permissions
chmod +x install-scripts/claude-config.sh

# Use force flag if needed
./install-scripts/claude-config.sh qa --force
```

### Hook Issues

```bash
# Make hooks executable
chmod +x ~/.claude/hooks/*.sh

# Test a hook manually
~/.claude/hooks/auto-test-runner.sh src/app.js

# Check hook output
cat ~/.claude/hooks/*.log
```

### MCP Server Issues

```bash
# Verify GitHub CLI
gh auth status

# Test MCP server
npx @executeautomation/playwright-mcp-server --help

# Check environment variables
echo $GITHUB_TOKEN
```

## 📊 Metrics & Analytics

Each persona tracks relevant metrics:

- **Engineers**: Code quality, test coverage, complexity
- **QA**: Test pass rate, coverage, flakiness, accessibility scores
- **Managers**: Velocity, DORA metrics, technical debt, team health
- **PMs**: Story completion, RICE scores, feature impact
- **UX**: Accessibility scores, design token compliance, contrast ratios

## 🔄 Updating Configurations

```bash
# Pull latest templates
cd ~/projects/Claude-Config
git pull

# Reinstall persona (creates new backup)
./install-scripts/claude-config.sh qa

# Or update specific component
./install-scripts/claude-config.sh engineer --hooks-only
```

## 🤝 Contributing

To create a custom persona:

1. Copy an existing template directory
2. Modify subagents, hooks, commands
3. Update MCP server configuration
4. Add to `persona-configs.json`
5. Test installation

## 📄 License

MIT License - See LICENSE file for details

## 🆘 Support

- **Issues**: Open a GitHub issue
- **Discussions**: Start a discussion
- **Documentation**: See `/docs` for detailed guides

## 📈 Version History

- **v1.0.0**: Initial release with 5 personas
  - Software Engineer
  - QA Engineer
  - Engineering Manager
  - Product Manager
  - UX Designer

---

**Made with ❤️ for engineering teams using Claude Code**
