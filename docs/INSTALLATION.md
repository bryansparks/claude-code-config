# Claude Code Persona Templates - Installation Guide

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Detailed Installation](#detailed-installation)
- [Persona Selection Guide](#persona-selection-guide)
- [Post-Installation](#post-installation)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)

## 🚀 Quick Start

### 1. Choose Your Persona

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

### 2. Restart Claude Code

After installation, restart Claude Code to load the new configuration.

### 3. Start Using

```bash
# Try a persona-specific command
/review --files src/
/test-coverage
/analyze-project
/write-user-story "As a user..."
/design-review --file component.tsx
```

## 📖 Detailed Installation

### Prerequisites

- **Claude Code** installed and working
- **Git** (optional, for version control)
- **jq** (optional, for JSON processing)
- **GitHub CLI** (`gh`) for GitHub integrations

### Installation Steps

#### Step 1: Preview Changes (Recommended)

Always run with `--dry-run` first to see what will be installed:

```bash
./install-scripts/claude-config.sh qa --dry-run
```

This shows:
- Which files will be copied
- Where they will go
- Number of files in each category
- No actual changes are made

#### Step 2: Run Installation

```bash
./install-scripts/claude-config.sh qa
```

The installer will:
1. ✅ Check prerequisites
2. 📦 Create backup of existing config (in `~/.claude/backups/`)
3. 📥 Install subagents (5-6 per persona)
4. 🪝 Install hooks (5-7 per persona)
5. ⌨️  Install commands (7-8 per persona)
6. 🔌 Install MCP server configs
7. ⚙️  Install settings.json

#### Step 3: Verify Installation

```bash
# Check installed files
ls ~/.claude/subagents/
ls ~/.claude/hooks/
ls ~/.claude/commands/

# Verify hooks are executable
ls -la ~/.claude/hooks/*.sh

# Check settings
cat ~/.claude/settings.json
```

### Installation Options

#### Component-Specific Installation

```bash
# Install only hooks
./install-scripts/claude-config.sh qa --hooks-only

# Install only subagents
./install-scripts/claude-config.sh engineer --subagents-only

# Install only commands
./install-scripts/claude-config.sh pm --commands-only

# Install only MCP server config
./install-scripts/claude-config.sh ux --mcp-only
```

#### Force Overwrite

If you want to overwrite existing files without prompting:

```bash
./install-scripts/claude-config.sh qa --force
```

#### Skip Backup

To skip creating a backup (not recommended):

```bash
./install-scripts/claude-config.sh engineer --no-backup
```

## 🎯 Persona Selection Guide

### 👨‍💻 Software Engineer

**Choose this if you:**
- Write code daily (frontend, backend, or full-stack)
- Care about code quality and testing
- Need debugging assistance
- Want automated code reviews
- Focus on performance optimization

**What you get:**
- **Subagents**: Code Reviewer, Debugger, Refactorer, API Designer, Performance Optimizer
- **Key hooks**: Auto test runner, lint on save, complexity checker
- **Top commands**: `/debug`, `/refactor`, `/optimize`, `/review`

**Example workflow:**
```bash
/review --files src/auth.ts --quality
/debug --error "Cannot read property 'map'"
/refactor --smell "long-method"
/optimize --database --query "getUserPosts"
```

### 🧪 QA Engineer

**Choose this if you:**
- Write and maintain tests
- Perform QA and testing
- Care about test coverage and quality
- Need accessibility testing
- Do performance/load testing
- Track bugs and regressions

**What you get:**
- **Subagents**: Test Automation Specialist, Bug Analyst, Performance Tester, Accessibility Auditor, Visual Regression Tester
- **Key hooks**: Auto test on change, coverage reporter, accessibility validator
- **Top commands**: `/test-coverage`, `/accessibility-audit`, `/performance-test`, `/bug-report`

**Example workflow:**
```bash
/test-coverage --full --threshold 80
/accessibility-audit --page /checkout --level AA
/performance-test --endpoint /api/users --load 1000
/bug-report --severity P1 --reproduce
```

### 👔 Engineering Manager

**Choose this if you:**
- Manage engineering teams
- Track sprint progress and velocity
- Care about technical debt
- Need team metrics and KPIs
- Do capacity and sprint planning
- Coordinate across teams

**What you get:**
- **Subagents**: Project Analyzer, Team Coordinator, Technical Debt Assessor, Metrics Reporter, Code Health Monitor
- **Key hooks**: Sprint health check, velocity calculator, blocker detector
- **Top commands**: `/analyze-project`, `/team-metrics`, `/sprint-planning`, `/technical-debt-audit`

**Example workflow:**
```bash
/analyze-project --depth full
/team-metrics --timeframe sprint --compare
/sprint-planning --sprint-number 48
/technical-debt-audit --export markdown
```

### 📊 Product Manager

**Choose this if you:**
- Write user stories and requirements
- Create product roadmaps
- Prioritize features
- Communicate with stakeholders
- Document product requirements
- Validate UX and user flows

**What you get:**
- **Subagents**: Feature Analyzer, Requirement Validator, User Story Writer, Roadmap Planner, UX Evaluator
- **Key hooks**: User story validator, acceptance criteria checker, feature impact analyzer
- **Top commands**: `/write-user-story`, `/analyze-feature`, `/roadmap-planning`, `/requirements-doc`

**Example workflow:**
```bash
/analyze-feature "Guest checkout" --rice
/write-user-story "Allow users to save payment methods"
/create-acceptance-criteria --format given-when-then
/roadmap-planning Q1-2025 --format now-next-later
```

### 🎨 UX Designer

**Choose this if you:**
- Design user interfaces
- Maintain design systems
- Care about accessibility
- Validate user flows
- Ensure visual consistency
- Test responsive designs
- Review component libraries

**What you get:**
- **Subagents**: UI Component Reviewer, Accessibility Specialist, Design System Expert, Interaction Designer, User Flow Architect
- **Key hooks**: Accessibility checker, design token validator, responsive tester
- **Top commands**: `/design-review`, `/accessibility-audit`, `/design-system-check`, `/user-flow`

**Example workflow:**
```bash
/design-review --file ProductCard.tsx --complete
/accessibility-audit --page /checkout --level AA
/design-system-check --score
/user-flow --analyze checkout --funnel
```

## 🔧 Post-Installation

### 1. Configure Environment Variables

#### For GitHub Integration (Most Personas)

```bash
# Add to ~/.zshrc or ~/.bashrc
export GITHUB_TOKEN="ghp_your_github_personal_access_token"

# Reload shell
source ~/.zshrc  # or source ~/.bashrc
```

Get your token at: https://github.com/settings/tokens

#### For Context7 (Optional)

```bash
export UPSTASH_REDIS_REST_URL="your_upstash_url"
export UPSTASH_REDIS_REST_TOKEN="your_upstash_token"
```

### 2. Install MCP Servers

#### GitHub CLI (Recommended for All)

```bash
# macOS
brew install gh
gh auth login

# Linux
# See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Windows
# See: https://github.com/cli/cli/releases
```

#### Playwright (QA Engineers, UX Designers)

```bash
npm install -g @executeautomation/playwright-mcp-server
```

#### Context7 (Optional, for All)

```bash
npm install -g @upstash/context7-mcp
```

### 3. Test Your Installation

```bash
# Test a hook manually
~/.claude/hooks/auto-test-runner.sh src/app.test.js

# Try a command
# (Open Claude Code and type)
/review --help
/test-coverage --help
```

### 4. Customize for Your Team

```bash
# Edit hooks
vim ~/.claude/hooks/auto-test-runner.sh

# Modify commands
vim ~/.claude/commands/review.md

# Update settings
vim ~/.claude/settings.json
```

## 🔍 Troubleshooting

### Installation Issues

**Problem:** `Permission denied` when running installer

```bash
chmod +x ./install-scripts/claude-config.sh
```

**Problem:** Template directory not found

```bash
# Verify you're in the correct directory
pwd  # Should show .../Claude-Config
ls templates/  # Should show persona directories
```

**Problem:** Hooks not executing

```bash
# Make hooks executable
chmod +x ~/.claude/hooks/*.sh

# Test a hook manually
~/.claude/hooks/auto-test-runner.sh test-file.js
```

### Hook Issues

**Problem:** Hook fails with "command not found"

```bash
# Check if required tools are installed
which npm  # For JavaScript hooks
which python  # For Python hooks
which jq  # For JSON processing
```

**Problem:** Hook runs but doesn't produce output

```bash
# Check hook logs
cat ~/.claude/hooks/*.log

# Run hook with debug output
bash -x ~/.claude/hooks/complexity-check.sh src/app.js
```

### MCP Server Issues

**Problem:** GitHub integration not working

```bash
# Verify token
echo $GITHUB_TOKEN

# Test GitHub CLI
gh auth status
gh repo list --limit 1

# Re-authenticate if needed
gh auth login
```

**Problem:** Playwright not found

```bash
# Install globally
npm install -g @executeautomation/playwright-mcp-server

# Or install in project
npx @executeautomation/playwright-mcp-server
```

### Command Issues

**Problem:** Command not recognized

```bash
# Verify command files exist
ls ~/.claude/commands/

# Check command format
cat ~/.claude/commands/review.md
```

**Problem:** Command runs but produces unexpected results

```bash
# Check command flags
/command-name --help

# Run with verbose output
/command-name --verbose
```

## 🎨 Customization

### Modifying Hooks

Hooks are shell scripts in `~/.claude/hooks/`. Edit them to customize behavior:

```bash
# Example: Customize test runner
vim ~/.claude/hooks/auto-test-runner.sh

# Change test framework detection
# Change coverage threshold
# Add custom reporting
```

### Customizing Commands

Commands are markdown files in `~/.claude/commands/`. Edit to add flags or change behavior:

```bash
# Example: Add custom flags to review command
vim ~/.claude/commands/review.md

# Add under "Command-Specific Flags":
# --custom-flag: "Description of what it does"
```

### Adjusting Settings

Edit `~/.claude/settings.json` to control hook execution:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/your-custom-hook.sh '{{file_path}}'"
          }
        ]
      }
    ]
  }
}
```

### Creating Custom Subagents

Copy an existing subagent and modify:

```bash
cp ~/.claude/subagents/code-reviewer.md ~/.claude/subagents/my-specialist.md
vim ~/.claude/subagents/my-specialist.md

# Update:
# - Name and identity
# - Core expertise
# - Output format
# - Collaboration requirements
```

## 📚 Next Steps

1. **Read the README**: `cat README.md`
2. **Explore persona configs**: `ls templates/qa-engineers/`
3. **Try sample commands**: Start with `--help` flags
4. **Join discussions**: Share your customizations
5. **Contribute**: Create custom personas or improvements

## 🆘 Getting Help

- **Documentation**: See README.md and persona-specific docs
- **Issues**: Check existing GitHub issues
- **Discussions**: Ask in GitHub Discussions
- **Examples**: See `/examples` directory (if available)

## 📊 Verification Checklist

After installation, verify:

- [ ] Subagents installed (`ls ~/.claude/subagents/`)
- [ ] Hooks installed and executable (`ls -la ~/.claude/hooks/`)
- [ ] Commands installed (`ls ~/.claude/commands/`)
- [ ] Settings.json updated (`cat ~/.claude/settings.json`)
- [ ] MCP servers configured (if applicable)
- [ ] Environment variables set (`echo $GITHUB_TOKEN`)
- [ ] Claude Code restarted
- [ ] Test command works (`/review --help`)
- [ ] Test hook works (edit a file, check output)

## 🎉 You're Ready!

Your Claude Code is now configured for your specific role. Start using persona-specific commands and enjoy automated workflows tailored to your needs.

**Happy coding!** 👨‍💻🧪👔📊🎨
