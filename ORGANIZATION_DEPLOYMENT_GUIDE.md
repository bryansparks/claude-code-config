# Organization Deployment Guide

**Goal**: Transfer clean, production-ready code from personal repo to organization repo

---

## 📋 Overview

**Current State**: Code in personal repo with development/interim files
**Desired State**: Clean production code in organization repo
**Method**: GitHub web import (no CLI needed)

---

## 🎯 Step-by-Step Process

### Phase 1: Prepare Clean Production Branch

**Run the preparation script**:
```bash
cd /Users/bryansparks/projects/Claude-Config
./prepare-for-org.sh
```

This will:
- ✅ Create `production` branch
- ✅ Remove interim documentation files
- ✅ Keep only essential production files
- ✅ Create clean commit

**What gets removed**:
- Development documentation (AGENT_ARCHITECTURE_ANALYSIS.md, RESTRUCTURE_*.md, etc.)
- Interim guides (GITHUB_SETUP_CHECKLIST.md, TEST_PLAN.md, etc.)
- Test files (accessibility-test-suite.js, etc.)
- Old templates/ and install-scripts/ (using .claude/ instead)
- plugins/ directory (old structure)
- PRD-Docs/ (development artifacts)

**What stays**:
- ✅ `install.sh` - Main installer
- ✅ `README.md` - User-facing documentation
- ✅ `LICENSE` - MIT License
- ✅ `.gitignore` - Git ignore patterns
- ✅ `.claude/` - Complete installation structure
- ✅ `personas/` - All 5 persona configurations
- ✅ `docs/` - Essential user documentation only

---

### Phase 2: Push Production Branch

```bash
git push -u origin production
```

---

### Phase 3: Make Personal Repo Public (Temporarily)

1. Go to: https://github.com/bryansparks/claude-code-config/settings

2. Scroll down to **"Danger Zone"**

3. Click **"Change visibility"**

4. Select **"Make public"**

5. Type repository name to confirm: `claude-code-config`

6. Click **"I understand, change repository visibility"**

⏱️ Wait 1-2 minutes for GitHub to process

---

### Phase 4: Import to Organization Repository

#### Option A: GitHub Import (Recommended)

1. **Go to import page**:
   ```
   https://github.com/organizations/YOUR_ORG_NAME/repositories/new/import
   ```
   *(Replace YOUR_ORG_NAME with your actual organization)*

2. **Fill in details**:
   - **Your old repository's clone URL**:
     ```
     https://github.com/bryansparks/claude-code-config
     ```
   - **Repository name**: `claude-code-config` (or your choice)
   - **Privacy**: ⚪ Private (recommended for organization)
   - **Description**:
     ```
     Claude Code configuration framework with persona-specific workflows
     ```

3. **Click**: "Begin import"

4. **Wait**: GitHub will import (usually 1-2 minutes)

5. **Success**: You'll see "Import complete!"

#### Option B: Manual Fork (Alternative)

If import doesn't work:

1. Go to: https://github.com/bryansparks/claude-code-config

2. Click **"Fork"** button (top right)

3. Select **your organization** as owner

4. Click **"Create fork"**

---

### Phase 5: Configure Organization Repository

#### 5.1 Set Production Branch as Default

1. Go to: `https://github.com/YOUR_ORG/claude-code-config/settings/branches`

2. Under **"Default branch"**, click pencil icon

3. Select: `production`

4. Click **"Update"**

5. Confirm: **"I understand, update the default branch"**

#### 5.2 Delete Main Branch (Optional)

1. Go to: `https://github.com/YOUR_ORG/claude-code-config/branches`

2. Find `main` branch

3. Click trash icon

4. Confirm deletion

#### 5.3 Update install.sh URL

**IMPORTANT**: Update the installer to point to your organization repo

1. Go to: `https://github.com/YOUR_ORG/claude-code-config/edit/production/install.sh`

2. Find line 25:
   ```bash
   REPO_URL="${CLAUDE_CONFIG_REPO:-https://github.com/bryansparks/claude-code-config}"
   ```

3. Change to:
   ```bash
   REPO_URL="${CLAUDE_CONFIG_REPO:-https://github.com/YOUR_ORG/claude-code-config}"
   ```

4. Scroll down, add commit message:
   ```
   chore: update repo URL to organization repository
   ```

5. Click **"Commit changes"**

#### 5.4 Update README.md (Optional)

Update any references to personal repo:

1. Go to: `https://github.com/YOUR_ORG/claude-code-config/edit/production/README.md`

2. Find/Replace:
   - Find: `bryansparks/claude-code-config`
   - Replace: `YOUR_ORG/claude-code-config`

3. Commit changes

---

### Phase 6: Make Personal Repo Private Again (Optional)

Once import is complete:

1. Go to: https://github.com/bryansparks/claude-code-config/settings

2. Scroll to **"Danger Zone"**

3. Click **"Change visibility"** → **"Make private"**

4. Confirm

---

### Phase 7: Test Organization Installation

**Test the installation from organization repo**:

```bash
# Test engineer persona
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- engineer

# Verify installation
ls -la ~/.claude/
cat ~/.claude/config/persona.conf
```

---

## 🎯 Quick Reference

### Files in Production Branch

```
claude-code-config/
├── install.sh                    # Main installer
├── README.md                     # User documentation
├── LICENSE                       # MIT License
├── .gitignore                    # Git ignore
│
├── .claude/                      # Installation structure
│   ├── config/
│   │   ├── personas/
│   │   └── mcp-servers/         # 5 persona configs
│   ├── templates/               # ORGANIZATION, PROJECT, CLAUDE
│   ├── commands/                # Slash commands
│   ├── hooks/                   # Event hooks
│   ├── shared/                  # YAML configs
│   └── scripts/                 # Helper scripts
│
├── personas/                     # Persona-specific files
│   ├── engineer/
│   ├── qa/
│   ├── pm/
│   ├── em/
│   └── ux/
│
└── docs/                        # Essential docs only
    ├── INSTALLATION.md
    ├── QUICK_START.md
    ├── MCP_SERVERS.md
    ├── MCP_INSTALLATION.md
    └── VISION_SYSTEM.md
```

### Installation Commands (After Setup)

```bash
# Software Engineer
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- engineer

# QA Engineer
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- qa

# Product Manager
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- pm

# Engineering Manager
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- em

# UX Designer
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- ux
```

---

## ✅ Checklist

### Preparation
- [ ] Run `./prepare-for-org.sh`
- [ ] Verify production branch created
- [ ] Push production branch to GitHub
- [ ] Make personal repo public

### Import
- [ ] Import to organization repository
- [ ] Set production branch as default
- [ ] Delete main branch (optional)
- [ ] Update install.sh URL to organization repo
- [ ] Update README.md references (optional)

### Cleanup
- [ ] Make personal repo private again
- [ ] Test installation from organization repo
- [ ] Share installation command with team

### Documentation
- [ ] Update organization repo README with:
  - [ ] Installation instructions for your team
  - [ ] MCP server setup guides
  - [ ] Links to internal documentation
  - [ ] Support/contact information

---

## 🔒 Security Considerations

### Secrets and Tokens

**DO NOT commit**:
- API tokens (GitHub, Linear, PostHog, Figma, Slack)
- Database credentials
- Private keys
- `.env` files

**Instruct users to set**:
```bash
# In ~/.zshrc or ~/.bashrc
export GITHUB_TOKEN="your_token_here"
export LINEAR_API_KEY="your_key_here"
export POSTHOG_API_KEY="your_key_here"
export FIGMA_ACCESS_TOKEN="your_token_here"
export SLACK_BOT_TOKEN="your_token_here"
```

### Repository Access

**Recommended settings** for organization repo:
- **Visibility**: Private
- **Branch protection**: Enable for production branch
  - Require pull request reviews
  - Require status checks to pass
  - No force pushes
- **Access**: Limit to team members only

---

## 🎓 Training Your Team

### Internal Documentation to Create

1. **Getting Started Guide**
   - Prerequisites (Claude Code installed)
   - Installation steps for your org
   - First project setup

2. **Persona Selection Guide**
   - Which persona for which role
   - How to switch personas
   - Persona-specific features

3. **MCP Server Setup Guide**
   - How to get API tokens (internal process)
   - Environment variable configuration
   - Testing MCP servers work

4. **Best Practices**
   - Organization standards (ORGANIZATION.md)
   - Project initialization workflow
   - Vision document creation

### Team Onboarding

**Suggested onboarding flow**:
1. Install Claude Code
2. Run organization installation script
3. Set up environment variables (tokens)
4. Initialize first project with `/init-project`
5. Review organization standards

---

## 📞 Support

### If Issues Occur

**Installation fails**:
1. Check GitHub repo is accessible
2. Verify install.sh URL is correct
3. Check internet connectivity
4. Try manual installation (clone + run script)

**MCP servers don't work**:
1. Verify environment variables set
2. Check token permissions
3. Test individual servers: `claude mcp test <server>`
4. Review MCP_INSTALLATION.md

**Commands not working**:
1. Restart Claude Code
2. Verify .claude/CLAUDE.md exists
3. Check persona.conf shows correct persona
4. Review command syntax in docs

---

## 🚀 Future Updates

### Updating Team Installations

When you update the organization repo:

```bash
# Users can update with:
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-code-config/production/install.sh | bash -s -- --update
```

### Version Management

Consider tagging releases:
```bash
git tag -a v1.0.0 -m "Initial production release"
git push origin v1.0.0
```

Users can then install specific versions:
```bash
export CLAUDE_CONFIG_REPO="https://github.com/YOUR_ORG/claude-code-config@v1.0.0"
curl -fsSL ... | bash -s -- engineer
```

---

**Last Updated**: October 2025
**Version**: 2.3.0
