# Enterprise Deployment Guide for Claude Code Plugins

## Overview

Best practices for deploying Claude Code plugins across a large organization with multiple teams and roles.

## Deployment Options

### ✅ **Option 1: GitHub Repository (RECOMMENDED)**

**Best for:** Organizations already using GitHub, teams familiar with git

#### Setup Steps

1. **Create Organization Repository**
```bash
# Create new repo (via GitHub UI or gh cli)
gh repo create your-org/claude-plugins --public --description "Claude Code plugins for engineering teams"

# Or use GitHub web interface:
# https://github.com/organizations/YOUR-ORG/repositories/new
```

2. **Push Your Plugins**
```bash
cd /Users/bryansparks/projects/Claude-Config

# Initialize if not already a git repo
git init

# Add files (only plugins and marketplace)
git add plugins/ .claude-plugin/ *.md
git commit -m "Initial release of Claude Code plugins v1.0.0"

# Add remote and push
git remote add origin https://github.com/your-org/claude-plugins.git
git branch -M main
git push -u origin main

# Tag the release
git tag v1.0.0
git push --tags
```

3. **Team Installation (ONE command!)**
```bash
# Each team member runs:
/plugin marketplace add your-org/claude-plugins

# Then install their role-specific plugin:
/plugin install engineer-toolkit    # Software engineers
/plugin install qa-toolkit          # QA engineers
/plugin install pm-toolkit          # Product managers
/plugin install em-toolkit          # Engineering managers
/plugin install ux-toolkit          # UX designers
```

**Advantages:**
- ✅ One-line installation for users
- ✅ Automatic updates via `/plugin update`
- ✅ Version control and history
- ✅ No local cloning required
- ✅ Centralized management
- ✅ Works with both public and private repos

---

### ✅ **Option 2: Private GitHub Repository**

**Best for:** Organizations requiring private/internal plugins

#### Setup Steps

1. **Create Private Repository**
```bash
gh repo create your-org/claude-plugins --private --description "Internal Claude Code plugins"
```

2. **Configure Access**
```bash
# Via GitHub web interface:
# Settings → Collaborators and teams → Add teams
# Grant read access to relevant teams
```

3. **Team Members Setup GitHub Authentication**

Each team member needs a GitHub Personal Access Token:

```bash
# Create token at: https://github.com/settings/tokens
# Scopes needed: repo (for private repos)

# Configure git credentials (one-time setup)
git config --global credential.helper store
```

4. **Installation**
```bash
# Each team member runs:
/plugin marketplace add your-org/claude-plugins

# Claude Code will prompt for GitHub credentials if private
# After authentication, install plugins normally:
/plugin install engineer-toolkit
```

**Advantages:**
- ✅ Keeps plugins private
- ✅ Access control via GitHub teams
- ✅ Same easy installation as public repos
- ✅ Audit logs via GitHub

---

### Option 3: Internal Package Registry

**Best for:** Organizations with existing npm/package registry infrastructure

#### Setup with npm Registry

1. **Publish to npm (or private registry)**
```bash
# Each plugin becomes an npm package
cd plugins/engineer-toolkit

# Create package.json
cat > package.json << EOF
{
  "name": "@your-org/claude-engineer-toolkit",
  "version": "1.0.0",
  "description": "Engineer toolkit for Claude Code",
  "main": ".claude-plugin/plugin.json",
  "files": [".claude-plugin", "agents", "commands", "hooks"]
}
EOF

# Publish to npm (or private registry)
npm publish --access restricted
```

2. **Installation**
```bash
# Users install via npm
npm install -g @your-org/claude-engineer-toolkit

# Then link to Claude Code
/plugin marketplace add file://$(npm root -g)/@your-org/claude-engineer-toolkit
/plugin install engineer-toolkit
```

**Note:** More complex, better suited for organizations with existing package management.

---

### Option 4: Shared Network Drive

**Best for:** Organizations with strict security requirements, no internet access

#### Setup Steps

1. **Copy to Shared Network Drive**
```bash
# Mount network drive
# Copy plugins directory
cp -r /Users/bryansparks/projects/Claude-Config /mnt/shared/claude-plugins
```

2. **Team Installation**
```bash
# Each team member runs:
/plugin marketplace add file:///mnt/shared/claude-plugins

# Then install:
/plugin install engineer-toolkit
```

**Advantages:**
- ✅ Works in air-gapped environments
- ✅ No external dependencies
- ✅ Centralized updates

**Disadvantages:**
- ❌ Manual update process
- ❌ Network drive must be accessible
- ❌ Path differences (Windows vs Unix)

---

## Recommended Approach for Large Organizations

### 🏆 **GitHub Repository (Option 1 or 2)**

**Why GitHub is Best:**

1. **Simple Installation**
   - One command: `/plugin marketplace add your-org/claude-plugins`
   - No git clone needed
   - No manual file copying
   - Claude Code handles everything

2. **Built-in Version Management**
   - Tag releases: `v1.0.0`, `v1.1.0`, etc.
   - Users get updates automatically
   - Rollback capability via tags

3. **Access Control**
   - Public repo: Anyone can use
   - Private repo: Team-based access control
   - Audit logs for compliance

4. **Zero Maintenance for Users**
   - Claude Code auto-updates plugins
   - No manual syncing required
   - Always get latest approved version

5. **Team Collaboration**
   - Pull requests for improvements
   - Issues for bug reports
   - Discussions for feedback
   - Code reviews for quality

---

## Implementation Plan

### Phase 1: Initial Setup (1 hour)

```bash
# 1. Create GitHub repo
gh repo create your-org/claude-plugins --public

# 2. Push plugins
cd /Users/bryansparks/projects/Claude-Config
git init
git add plugins/ .claude-plugin/ README.md QUICK_START_PLUGINS.md
git commit -m "Initial release v1.0.0"
git remote add origin https://github.com/your-org/claude-plugins.git
git push -u origin main
git tag v1.0.0
git push --tags

# 3. Update marketplace.json with correct repo URL
# Edit .claude-plugin/marketplace.json
# Change owner.name and owner.email
```

### Phase 2: Documentation (30 minutes)

Create a simple README for your team:

```markdown
# Claude Code Plugins - Your Organization

Official Claude Code plugins for [Your Company Name].

## Quick Start

### 1. Add Marketplace
```bash
/plugin marketplace add your-org/claude-plugins
```

### 2. Install Your Role's Plugin

**Software Engineers:**
```bash
/plugin install engineer-toolkit
```

**QA Engineers:**
```bash
/plugin install qa-toolkit
```

**Product Managers:**
```bash
/plugin install pm-toolkit
```

**Engineering Managers:**
```bash
/plugin install em-toolkit
```

**UX Designers:**
```bash
/plugin install ux-toolkit
```

### 3. Restart Claude Code
Press Ctrl+C, then run `claude` to restart.

## Support
- Issues: [GitHub Issues](https://github.com/your-org/claude-plugins/issues)
- Questions: #claude-code-help Slack channel
```

### Phase 3: Rollout (Phased)

**Week 1: Pilot Group (5-10 users)**
- 1-2 engineers from each role
- Gather feedback
- Fix any issues

**Week 2: Department Rollout (50-100 users)**
- Engineering team by team
- Monitor adoption
- Provide support

**Week 3: Company-wide**
- Announce in company all-hands
- Send installation guide
- Offer office hours for help

---

## Team Communication Template

### Email Announcement

```
Subject: New: Claude Code Plugins for [Your Company]

Team,

We're excited to announce official Claude Code plugins for our engineering organization!

🎯 What are they?
Role-specific AI assistants, commands, and automation for Claude Code that follow our company standards and best practices.

📦 Available Plugins:
- Engineer Toolkit: Code review, debugging, API design
- QA Toolkit: Test automation, accessibility auditing
- PM Toolkit: User stories, roadmaps, PRDs
- EM Toolkit: Sprint planning, team metrics
- UX Toolkit: Design systems, accessibility

🚀 Installation (2 minutes):
1. Open Claude Code
2. Run: /plugin marketplace add your-org/claude-plugins
3. Run: /plugin install <your-role>-toolkit
4. Restart Claude Code

📚 Documentation: https://github.com/your-org/claude-plugins

💬 Questions? Post in #claude-code-help

Thanks!
[Your Name]
```

---

## Maintenance & Updates

### Updating Plugins

```bash
# 1. Make changes to plugins locally
cd /Users/bryansparks/projects/Claude-Config

# 2. Test changes
/plugin validate ./plugins/engineer-toolkit

# 3. Commit and tag
git add .
git commit -m "Add new features to engineer-toolkit"
git push

# 4. Create new release
git tag v1.1.0
git push --tags

# 5. Announce update
# Users run: /plugin update
```

### Monitoring Adoption

Track via GitHub:
- Stars/watches on repository
- Issues opened
- Pull requests submitted
- Clone statistics (if public)

Internal tracking:
- Survey after 2 weeks
- Usage analytics (if available)
- Slack channel activity

---

## Troubleshooting Guide for Teams

### Common Issues

**Issue: "Plugin not found"**
```bash
# Solution: Verify marketplace is added
/plugin marketplace list

# If not listed, add again:
/plugin marketplace add your-org/claude-plugins
```

**Issue: "Permission denied" (private repo)**
```bash
# Solution: Setup GitHub authentication
# 1. Create Personal Access Token: https://github.com/settings/tokens
# 2. Scopes: repo (full control of private repositories)
# 3. Save token securely
# 4. Try installation again, paste token when prompted
```

**Issue: "Hooks not working"**
```bash
# Solution: Make hooks executable
cd ~/.claude/plugins/<plugin-name>/hooks
chmod +x *.sh
```

**Issue: "Command not found after install"**
```bash
# Solution: Restart Claude Code
# Press Ctrl+C, then run: claude
```

---

## Security Considerations

### Public Repository
✅ Use for: General-purpose plugins, open-source contributions
❌ Avoid: Proprietary business logic, internal tools, secrets

### Private Repository
✅ Use for: Company-specific plugins, internal workflows
✅ Benefits: Access control, audit logs, compliance
⚠️ Requires: GitHub authentication for team members

### Best Practices
- ✅ Never commit secrets, API keys, or credentials
- ✅ Use environment variables for configuration
- ✅ Review changes via pull requests
- ✅ Tag stable releases
- ✅ Document breaking changes

---

## Cost Analysis

### GitHub Repository (Public)
- **Cost:** Free
- **Limits:** Unlimited plugins, unlimited users
- **Best for:** Open-source, community plugins

### GitHub Repository (Private)
- **Cost:** Free for GitHub Team/Enterprise
- **Limits:** Based on GitHub plan
- **Best for:** Internal company plugins

### Self-Hosted Solutions
- **Cost:** Infrastructure + maintenance time
- **Complexity:** High
- **Best for:** Air-gapped environments only

**Recommendation:** Use GitHub (public or private) for 99% of use cases.

---

## FAQ

**Q: Do users need to clone the repository?**
A: No! Claude Code handles everything. Users just run two commands.

**Q: How do users get updates?**
A: Automatic via `/plugin update` command.

**Q: Can we use multiple marketplaces?**
A: Yes! Teams can add multiple marketplaces and mix plugins.

**Q: What if someone leaves the company?**
A: Private repos: Remove from GitHub team. Public repos: N/A (public).

**Q: Can we customize plugins per team?**
A: Yes! Create team-specific branches or separate plugins.

**Q: How do we track who's using what?**
A: GitHub analytics (stars, clones) or internal surveys.

---

## Next Steps

1. ✅ Create GitHub repository
2. ✅ Push plugins to repository
3. ✅ Update marketplace.json with repo info
4. ✅ Test installation yourself
5. ✅ Create team documentation
6. ✅ Pilot with small group (5-10 users)
7. ✅ Gather feedback and iterate
8. ✅ Roll out to entire organization
9. ✅ Announce and provide support

---

**Recommended Timeline:** 2-3 weeks from setup to full rollout

**Effort Required:**
- Setup: 2-3 hours
- Pilot: 1 week
- Rollout: 1-2 weeks
- Ongoing: 1-2 hours/month for updates

---

*Ready to deploy? Start with creating the GitHub repository!*
