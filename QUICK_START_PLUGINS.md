# Quick Start: Claude Code Plugins

Your Claude-Config has been converted to official Claude Code plugins! Here's how to get started in under 5 minutes.

## ✅ What Was Done

- ✅ 5 role-specific plugins created (engineer, qa, pm, em, ux)
- ✅ 48 agents converted from subagents (with YAML frontmatter)
- ✅ 34 commands converted (with frontmatter)
- ✅ 31 hooks configured (referenced via hooks.json)
- ✅ Full marketplace.json created
- ✅ Comprehensive documentation written

## 🚀 Installation (3 Steps)

### Option 1: Local Testing (Recommended First)

```bash
# 1. Add local marketplace
/plugin marketplace add file:///Users/bryansparks/projects/Claude-Config

# 2. Install your role's plugin
/plugin install engineer-toolkit

# 3. Restart Claude Code
# Press Ctrl+C, then run: claude
```

### Option 2: From GitHub (After Publishing)

```bash
# 1. Add GitHub marketplace
/plugin marketplace add your-org/claude-config

# 2. Install plugin
/plugin install engineer-toolkit

# 3. Restart Claude Code
```

## 📦 Choose Your Plugin

### 🔧 engineer-toolkit
**For:** Software Engineers
**Install:** `/plugin install engineer-toolkit`
**Try:** `/debug --error "Sample error"`

### 🧪 qa-toolkit
**For:** QA Engineers
**Install:** `/plugin install qa-toolkit`
**Try:** `/test-coverage --threshold 80`

### 📊 pm-toolkit
**For:** Product Managers
**Install:** `/plugin install pm-toolkit`
**Try:** `/write-user-story --persona "user" --goal "login"`

### 👔 em-toolkit
**For:** Engineering Managers
**Install:** `/plugin install em-toolkit`
**Try:** `/team-metrics --period last-quarter`

### 🎨 ux-toolkit
**For:** UX Designers
**Install:** `/plugin install ux-toolkit`
**Try:** `/accessibility-audit --wcag AA`

## ✨ Quick Test

```bash
# After installation, test with:
/plugin list                    # Should show your installed plugin
/help                          # Should show new commands
/debug "Test error message"    # Try a command
```

## 📖 Key Files

- **[PLUGIN_MIGRATION_GUIDE.md](PLUGIN_MIGRATION_GUIDE.md)** - Complete migration guide
- **[CONVERSION_SUMMARY.md](CONVERSION_SUMMARY.md)** - What was converted
- **[plugins/README.md](plugins/README.md)** - Plugin documentation
- **[.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)** - Plugin catalog

## 🔍 Verification

```bash
# Validate plugin structure
/plugin validate ./plugins/engineer-toolkit

# Check an agent file has YAML frontmatter
head -10 plugins/engineer-toolkit/agents/code-reviewer.md
# Should show:
# ---
# name: code-reviewer
# description: ...
# ---

# Check hooks configuration
cat plugins/engineer-toolkit/hooks/hooks.json | jq .
```

## 🎯 What's Different?

| Old System | New Plugin System |
|------------|-------------------|
| `./claude-config.sh engineer` | `/plugin install engineer-toolkit` |
| Files in `~/.claude/` | Managed by Claude Code |
| Manual updates | `/plugin update` |
| Hard to remove | `/plugin uninstall engineer-toolkit` |
| Subagents | Agents (with YAML metadata) |

## 💡 Pro Tips

1. **Test Locally First**
   ```bash
   /plugin marketplace add file://$(pwd)
   ```

2. **Install Multiple Plugins**
   ```bash
   /plugin install engineer-toolkit qa-toolkit
   ```

3. **Enable/Disable**
   ```bash
   /plugin disable engineer-toolkit  # Temporarily disable
   /plugin enable engineer-toolkit   # Re-enable
   ```

4. **Check Logs**
   ```bash
   # Hooks run in background, check Claude Code output
   # Use CTRL-R for transcript mode to see hook output
   ```

## 🐛 Troubleshooting

### Plugin not found
```bash
/plugin marketplace list
# If not listed:
/plugin marketplace add file:///Users/bryansparks/projects/Claude-Config
```

### Commands not showing
```bash
# Restart Claude Code
# Press Ctrl+C, then: claude
```

### Hooks not triggering
```bash
# Check hooks.json exists
ls plugins/engineer-toolkit/hooks/hooks.json

# Verify bash scripts are executable
chmod +x plugins/engineer-toolkit/hooks/*.sh
```

### Agent not working
```bash
# Check YAML frontmatter
head -10 plugins/engineer-toolkit/agents/code-reviewer.md
```

## 📤 Publishing to GitHub

```bash
# 1. Create repo
git init
git add plugins/ .claude-plugin/
git commit -m "Add Claude Code plugins"

# 2. Push to GitHub
gh repo create claude-config-plugins --public
git push -u origin main

# 3. Team installs
/plugin marketplace add your-username/claude-config-plugins
/plugin install engineer-toolkit
```

## 🎉 Next Steps

1. ✅ Test local installation
2. ✅ Try all commands for your role
3. ✅ Verify hooks work (watch for auto-test, lint, etc.)
4. ⏳ Customize plugin.json (author info)
5. ⏳ Add README to each plugin directory
6. ⏳ Publish to GitHub
7. ⏳ Share with team

## 📞 Need Help?

- **Migration Guide:** [PLUGIN_MIGRATION_GUIDE.md](PLUGIN_MIGRATION_GUIDE.md) - Comprehensive guide
- **Plugin Docs:** [plugins/README.md](plugins/README.md) - Detailed documentation
- **Official Docs:** https://docs.claude.com/en/docs/claude-code/plugins
- **Examples:** https://github.com/anthropics/claude-code/tree/main/plugins

---

**Ready?** Start with: `/plugin marketplace add file:///Users/bryansparks/projects/Claude-Config`

Then: `/plugin install engineer-toolkit` 🚀
