# Claude-Config Plugin Migration Guide

## Overview

Your Claude-Config has been successfully converted to **official Anthropic Claude Code plugins**! This guide explains the new structure, how to install plugins, and differences from the previous system.

## What Changed?

### Before (Old System)
```
~/.claude/
├── CLAUDE.md (with @include directives)
├── shared/ (YAML configs)
└── personas/ (subagents, commands, hooks per role)
```

Manual installation via `claude-config.sh` script copying files to `~/.claude/`

### After (Plugin System)
```
plugins/
├── engineer-toolkit/
│   ├── .claude-plugin/plugin.json
│   ├── agents/ (YAML frontmatter)
│   ├── commands/
│   └── hooks/
├── qa-toolkit/
├── pm-toolkit/
├── em-toolkit/
└── ux-toolkit/
```

Install with: `/plugin marketplace add` + `/plugin install <name>`

## New Plugin Structure

### 1. **Plugin Manifest** (`.claude-plugin/plugin.json`)
```json
{
  "name": "engineer-toolkit",
  "version": "1.0.0",
  "description": "Comprehensive toolkit for software engineers",
  "author": {
    "name": "Bryan Sparks",
    "email": "bryan@example.com"
  }
}
```

### 2. **Agents** (formerly "subagents")
Agents now have YAML frontmatter:
```yaml
---
name: code-reviewer
description: Senior code reviewer
tools: Read, Grep, TodoWrite
model: sonnet
color: blue
---
# Agent instructions follow...
```

**Key Changes:**
- Renamed from "subagents" to "agents"
- YAML frontmatter defines metadata
- Tools explicitly listed
- Color and model specified

### 3. **Commands**
Optional frontmatter added:
```yaml
---
description: Debug code issues systematically
---
# Command content...
```

### 4. **Hooks**
Bash scripts stay the same, but referenced via `hooks/hooks.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/lint-on-save.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Installation Instructions

### Step 1: Add Marketplace

If hosting on GitHub:
```bash
/plugin marketplace add your-org/claude-config
```

If hosting locally (during development):
```bash
/plugin marketplace add file:///absolute/path/to/Claude-Config
```

### Step 2: Install Plugin(s)

Install a single role:
```bash
/plugin install engineer-toolkit
```

Or install multiple:
```bash
/plugin install engineer-toolkit qa-toolkit
```

### Step 3: Restart Claude Code
```bash
# Press Ctrl+C to exit
claude
```

### Step 4: Verify Installation
```bash
/plugin list
```

## Available Plugins

### 🔧 engineer-toolkit
**For:** Software Engineers
**Includes:**
- 9 specialized agents (code-reviewer, debugger, api-designer, etc.)
- 3 commands (debug, optimize, refactor)
- 5 automation hooks (auto-test, lint, complexity, dependency-check, commit-helper)

**Install:** `/plugin install engineer-toolkit`

### 🧪 qa-toolkit
**For:** QA Engineers
**Includes:**
- 5 specialized agents (test-automation, bug-analyst, performance-tester, etc.)
- 7 commands (test-coverage, accessibility-audit, performance-test, etc.)
- 7 automation hooks (test-on-change, coverage-reporter, accessibility-validator, etc.)

**Install:** `/plugin install qa-toolkit`

### 📊 pm-toolkit
**For:** Product Managers
**Includes:**
- 5 specialized agents (feature-analyzer, requirement-validator, user-story-writer, etc.)
- 8 commands (analyze-feature, write-user-story, roadmap-planning, etc.)
- 6 automation hooks (story-validator, acceptance-criteria-checker, etc.)

**Install:** `/plugin install pm-toolkit`

### 👔 em-toolkit
**For:** Engineering Managers
**Includes:**
- 5 specialized agents (project-analyzer, team-coordinator, tech-debt-assessor, etc.)
- 8 commands (analyze-project, sprint-planning, team-metrics, etc.)
- 7 automation hooks (PR review summary, sprint health check, velocity calculator, etc.)

**Install:** `/plugin install em-toolkit`

### 🎨 ux-toolkit
**For:** UX Designers
**Includes:**
- 5 specialized agents (ui-component-reviewer, accessibility-specialist, design-system-expert, etc.)
- 8 commands (design-review, accessibility-audit, user-flow, etc.)
- 6 automation hooks (accessibility-checker, design-token-validator, contrast-checker, etc.)

**Install:** `/plugin install ux-toolkit`

## Plugin Management Commands

```bash
# List marketplaces
/plugin marketplace list

# Add marketplace
/plugin marketplace add <repo>

# Browse available plugins
/plugin

# Install plugin
/plugin install <plugin-name>

# List installed plugins
/plugin list

# Enable/disable plugin
/plugin enable <plugin-name>
/plugin disable <plugin-name>

# Uninstall plugin
/plugin uninstall <plugin-name>

# Validate plugin structure
/plugin validate <path-to-plugin>
```

## Key Differences

### Agents vs Subagents
| Feature | Old (Subagents) | New (Agents) |
|---------|----------------|--------------|
| Location | `personas/<role>/subagents/` | `plugins/<toolkit>/agents/` |
| Format | Markdown only | YAML frontmatter + Markdown |
| Metadata | In content | In YAML header |
| Tools | Implicit | Explicit list |

### Installation
| Feature | Old System | New System |
|---------|-----------|------------|
| Method | Shell script | Claude Code commands |
| Location | Copies to `~/.claude/` | Plugin-managed |
| Updates | Re-run script | `/plugin update` |
| Uninstall | Manual deletion | `/plugin uninstall` |

### Hooks
| Feature | Old System | New System |
|---------|-----------|------------|
| Format | Bash scripts only | Bash + hooks.json config |
| Location | Direct in `hooks/` | Referenced via JSON |
| Environment | Manual vars | `$CLAUDE_PLUGIN_ROOT` |

## Migration Benefits

✅ **Official Support** - Follows Anthropic's standards
✅ **Version Management** - Built-in versioning
✅ **Easy Updates** - `/plugin update` command
✅ **Cleaner Separation** - Each role is independent
✅ **Mix & Match** - Install multiple plugins
✅ **Better Discovery** - Marketplace browsing
✅ **Uninstall Support** - Easy removal

## Backward Compatibility

The old system still works! You can:
1. Keep using `~/.claude/CLAUDE.md` + personas
2. Gradually migrate to plugins
3. Run both simultaneously (not recommended)

## Troubleshooting

### Plugin not found
```bash
# Verify marketplace is added
/plugin marketplace list

# Re-add marketplace
/plugin marketplace add your-org/claude-config
```

### Hooks not working
```bash
# Check hooks.json syntax
cat plugins/<toolkit>/hooks/hooks.json | jq .

# Verify bash scripts are executable
chmod +x plugins/<toolkit>/hooks/*.sh
```

### Agents not showing up
```bash
# Validate plugin structure
/plugin validate ./plugins/<toolkit>

# Check YAML frontmatter
head -10 plugins/<toolkit>/agents/<agent>.md
```

## Testing Your Plugin

### Local Development
```bash
# Add local directory as marketplace
/plugin marketplace add file://$(pwd)

# Install from local
/plugin install engineer-toolkit

# Make changes and reload
# (Restart Claude Code after changes)
```

### Validation
```bash
# Validate plugin structure
/plugin validate ./plugins/engineer-toolkit

# Test specific agent
# Use the agent in a conversation

# Test command
/debug --error "Sample error"
```

## Publishing to GitHub

### 1. Create Repository
```bash
git init
git add .
git commit -m "Initial plugin conversion"
git remote add origin https://github.com/your-org/claude-config.git
git push -u origin main
```

### 2. Tag Release
```bash
git tag v1.0.0
git push --tags
```

### 3. Share with Team
```bash
# Team members add marketplace
/plugin marketplace add your-org/claude-config

# Install desired plugin
/plugin install engineer-toolkit
```

## Next Steps

1. ✅ Review converted agents in `plugins/*/agents/`
2. ✅ Test commands with `/command-name`
3. ✅ Verify hooks trigger correctly
4. ✅ Create README.md for each plugin
5. ✅ Publish to GitHub (optional)
6. ✅ Share with team

## Support

- **Official Docs:** https://docs.claude.com/en/docs/claude-code/plugins
- **Plugin Examples:** https://github.com/anthropics/claude-code/tree/main/plugins
- **Community:** https://github.com/hesreallyhim/awesome-claude-code

---

**Migration completed!** Your plugins are ready to use. Start with `/plugin install engineer-toolkit` and explore the new system.
