# 🚀 Quick Start Guide

## Install in 3 Steps

### 1️⃣ Choose Your Role

```bash
cd ~/projects/Claude-Config
./install-scripts/claude-config.sh --help
```

### 2️⃣ Install (with preview)

```bash
# Preview first (recommended)
./install-scripts/claude-config.sh <persona> --dry-run

# Then install
./install-scripts/claude-config.sh <persona>
```

### 3️⃣ Restart Claude Code

Restart Claude Code to load your new configuration!

---

## Personas Quick Reference

| Command | Persona | Best For |
|---------|---------|----------|
| `engineer` | 👨‍💻 Software Engineer | Code quality, debugging, testing |
| `qa` | 🧪 QA Engineer | Test automation, accessibility, quality |
| `em` | 👔 Engineering Manager | Metrics, planning, team coordination |
| `pm` | 📊 Product Manager | User stories, roadmaps, requirements |
| `ux` | 🎨 UX Designer | Design systems, accessibility, UX |

---

## Example Commands by Persona

### 👨‍💻 Engineer
```bash
/review --files src/
/debug --error "Cannot read property 'map'"
/refactor --smell "long-method"
/optimize --database
```

### 🧪 QA Engineer
```bash
/test-coverage --full
/accessibility-audit --page /checkout
/performance-test --load 1000
/bug-report --severity P1
```

### 👔 Engineering Manager
```bash
/analyze-project --depth full
/team-metrics --timeframe sprint
/sprint-planning --sprint-number 48
/technical-debt-audit
```

### 📊 Product Manager
```bash
/analyze-feature "Guest checkout"
/write-user-story "Payment methods"
/roadmap-planning Q1-2025
/stakeholder-update sprint 42
```

### 🎨 UX Designer
```bash
/design-review --file component.tsx
/accessibility-audit --level AA
/design-system-check --score
/user-flow --analyze checkout
```

---

## What Gets Installed

Each persona includes:

- **Subagents** (5): AI specialists for your role
- **Hooks** (5-7): Automated workflows
- **Commands** (3-8): Role-specific operations
- **MCP Configs**: Server integrations
- **Settings**: Pre-configured for your workflow

Total: **101 files**, **~30,200 lines** of specialized content

---

## Post-Install Setup

### Required (for GitHub integration)

```bash
export GITHUB_TOKEN="ghp_your_token"
brew install gh
gh auth login
```

### Optional (for advanced features)

```bash
# Context7 (long-term memory)
npm install -g @upstash/context7-mcp

# Playwright (QA, UX personas)
npm install -g @executeautomation/playwright-mcp-server
```

---

## Verify Installation

```bash
# Check installed files
ls ~/.claude/subagents/
ls ~/.claude/hooks/
ls ~/.claude/commands/

# Test a command in Claude Code
/review --help
```

---

## Need Help?

- **Full README**: `cat README.md`
- **Installation Guide**: `cat INSTALLATION_GUIDE.md`
- **Project Summary**: `cat PROJECT_SUMMARY.md`
- **Troubleshooting**: See INSTALLATION_GUIDE.md

---

## Rollback

Backups are automatic! To restore:

```bash
# List backups
ls ~/.claude/backups/

# Restore from backup
cp -r ~/.claude/backups/YYYYMMDD_HHMMSS/* ~/.claude/
```

---

**Ready to get started?** Pick your persona and run the installer! 🎉
