# Copying This Repository to Another Organization

This guide walks you through copying this Claude Code configuration repository to another company's GitHub account or organization.

---

## 📋 Prerequisites

Before starting, ensure you have:
- ✅ Access to the target organization's GitHub account
- ✅ Permission to create repositories in that organization
- ✅ Git installed on your local machine
- ✅ SSH key configured for GitHub (or use HTTPS with token)

---

## 🚀 Method 1: Using GitHub Web Interface (Recommended)

### Option A: Import Repository (Easiest)

**Best for**: Creating a complete copy with full history

1. **Go to the target organization on GitHub**
   - Navigate to: `https://github.com/organizations/YOUR-ORG-NAME/repositories/new/import`
   - Or: Click "New" → "Import repository"

2. **Enter repository details**
   - **Old repository URL**: `https://github.com/bryansparks/claude-code-config`
   - **Owner**: Select the target organization
   - **Repository name**: `claude-code-config` (or your preferred name)
   - **Privacy**: Private (recommended)

3. **Start import**
   - Click "Begin import"
   - Wait for GitHub to copy all commits and branches
   - You'll receive an email when complete

4. **Verify the import**
   - Check that all branches are present (main, production)
   - Verify files are intact
   - Review commit history

### Option B: Fork Repository

**Best for**: Maintaining connection to original repo for updates

1. **Fork via GitHub web interface**
   - Go to: `https://github.com/bryansparks/claude-code-config`
   - Click "Fork" button (top right)
   - Select the target organization
   - Choose repository name and privacy settings

2. **Note about forks**
   - ⚠️ Forks of private repos remain linked to the original
   - Updates from original can be pulled
   - Good if you want to contribute back or stay in sync

---

## 🔧 Method 2: Using Git Command Line (Manual)

### Step 1: Clone the Original Repository

```bash
# Clone with full history
git clone --mirror git@github.com:bryansparks/claude-code-config.git claude-code-mirror
cd claude-code-mirror
```

**Why `--mirror`?**
- Copies all branches, tags, and refs
- Creates a bare repository
- Preserves complete history

### Step 2: Create New Repository in Target Organization

**On GitHub:**
1. Go to: `https://github.com/organizations/YOUR-ORG-NAME/repositories/new`
2. Repository name: `claude-code-config` (or your choice)
3. Privacy: Private
4. **Do NOT initialize** with README, license, or .gitignore
5. Click "Create repository"

**Copy the SSH URL** (e.g., `git@github.com:YOUR-ORG/claude-code-config.git`)

### Step 3: Push to New Repository

```bash
# Set the new remote URL
git remote set-url origin git@github.com:YOUR-ORG/claude-code-config.git

# Push all branches and tags
git push --mirror

# Verify all branches pushed
git push --all
git push --tags
```

### Step 4: Clean Up

```bash
cd ..
rm -rf claude-code-mirror
```

### Step 5: Clone the New Repository (Normal Clone)

```bash
# Clone from new location
git clone git@github.com:YOUR-ORG/claude-code-config.git
cd claude-code-config

# Verify branches
git branch -a
# Should see: main, production, and any others

# Verify recent commits
git log --oneline -5
```

---

## 📝 Method 3: Fresh Start (No History)

**Best for**: Starting fresh without commit history

### Step 1: Download Source Code

```bash
# Download latest from main branch
git clone git@github.com:bryansparks/claude-code-config.git claude-code-fresh
cd claude-code-fresh

# Remove git history
rm -rf .git

# Initialize new repository
git init
git add .
git commit -m "Initial commit: Claude Code configuration framework

Imported from bryansparks/claude-code-config

Features:
- Three-tier configuration architecture (Organization/Project/Vision)
- 5 persona configurations (Engineer, QA, PM, EM, UX)
- 12 skills (8 Engineer + 4 QA)
- 14 subagents
- Optional metrics dashboard
- Comprehensive documentation
"
```

### Step 2: Create New Repository

1. Create repository on GitHub (as in Method 2, Step 2)
2. Copy the SSH URL

### Step 3: Push to New Repository

```bash
# Add remote
git remote add origin git@github.com:YOUR-ORG/claude-code-config.git

# Push to main branch
git branch -M main
git push -u origin main
```

---

## 🔄 Post-Copy Customization

After copying to your organization, customize these files:

### 1. Update ORGANIZATION.md

**Location**: `ORGANIZATION.md`

**What to customize**:
```bash
# Edit organization-specific details
vi ORGANIZATION.md

# Replace:
# - Organization name
# - Engineering leadership contacts
# - Approved technology stack
# - Compliance requirements
# - Code coverage thresholds
# - Team communication tools
```

### 2. Update README.md

**Location**: `README.md`

**Update the repository URL** in installation instructions:
```bash
# Find and replace
OLD: git@github.com:bryansparks/claude-code-config.git
NEW: git@github.com:YOUR-ORG/claude-code-config.git
```

### 3. Update install.sh (if needed)

**Location**: `install.sh`

**Check if any hardcoded URLs** need updating:
```bash
grep -r "bryansparks" install.sh
# Update any found references to your organization
```

### 4. Commit Customizations

```bash
git add ORGANIZATION.md README.md install.sh
git commit -m "chore: customize for [YOUR-ORG-NAME]

- Update ORGANIZATION.md with company standards
- Update README with organization repository URL
- Update installation references
"
git push origin main
```

---

## 🔐 Access Control

### Team Access

**For the new repository**, set up access:

1. **Go to repository settings**
   - Navigate to: `https://github.com/YOUR-ORG/claude-code-config/settings/access`

2. **Add teams or individuals**
   - **Admins**: Engineering leadership (maintain)
   - **Write**: Senior engineers (contribute)
   - **Read**: All engineers (use)

3. **Branch protection** (recommended)
   - Protect `main` branch
   - Require pull request reviews
   - Require status checks
   - Restrict force pushes

### Repository Settings

**Recommended settings**:
- ✅ **Private**: Keep configuration internal
- ✅ **Require 2FA**: For contributors
- ✅ **Disable forking**: Prevent external copies
- ✅ **Branch protection**: On main branch

---

## 📢 Announcing to Your Organization

### 1. Update Internal Wiki

Create a page: "Claude Code Configuration"

**Include**:
- Installation instructions
- Link to repository
- Getting started guide
- Who to contact for help

### 2. Send Announcement Email

**Sample email**:

```
Subject: Claude Code Configuration Now Available

Hi Team,

We've deployed a standardized Claude Code configuration for our organization.
This provides:

✅ Organization-wide engineering standards (ORGANIZATION.md)
✅ Persona-specific configurations (Engineer, QA, PM, EM, UX)
✅ Auto-invoked skills for common tasks
✅ Comprehensive documentation

Installation:
1. git clone git@github.com:YOUR-ORG/claude-code-config.git
2. cd claude-code-config
3. ./install.sh engineer  # or qa, pm, em, ux
4. Restart Claude Code

Documentation: [Link to internal wiki page]
Questions: #engineering-tools Slack channel

Thanks,
Engineering Leadership
```

### 3. Add to Onboarding

**Include in new hire checklist**:
- [ ] Install Claude Code
- [ ] Clone claude-code-config repository
- [ ] Run install.sh for your role
- [ ] Review ORGANIZATION.md standards

---

## 🔄 Keeping In Sync (Optional)

If you want to **pull updates from the original** bryansparks repo:

### Setup Upstream Remote

```bash
cd claude-code-config

# Add original repo as upstream
git remote add upstream git@github.com:bryansparks/claude-code-config.git

# Verify remotes
git remote -v
# origin:   YOUR-ORG/claude-code-config.git
# upstream: bryansparks/claude-code-config.git
```

### Pull Updates from Upstream

```bash
# Fetch updates from original repo
git fetch upstream

# View what's changed
git log --oneline upstream/main ^main

# Merge updates (review carefully!)
git checkout main
git merge upstream/main

# Resolve any conflicts with your customizations
# Then push to your organization
git push origin main
```

**⚠️ Important**:
- Always review changes before merging
- Your ORGANIZATION.md customizations may conflict
- Test thoroughly after merging updates

---

## ✅ Verification Checklist

After copying, verify:

- [ ] Repository created in target organization
- [ ] All branches present (main, production)
- [ ] All files intact (check ORGANIZATION.md, install.sh, README.md)
- [ ] Commit history preserved (if using Method 1 or 2)
- [ ] Access permissions configured
- [ ] Branch protection enabled
- [ ] ORGANIZATION.md customized for your company
- [ ] README.md updated with new repository URL
- [ ] Test installation works:
  ```bash
  git clone git@github.com:YOUR-ORG/claude-code-config.git test-install
  cd test-install
  ./install.sh engineer
  # Verify: ls ~/.claude/ORGANIZATION.md
  ```

---

## 🆘 Troubleshooting

### "Permission denied" when cloning

**Cause**: SSH key not configured or no repository access

**Solution**:
```bash
# Test SSH connection
ssh -T git@github.com

# If fails, add SSH key:
ssh-keygen -t ed25519 -C "your_email@company.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub: Settings → SSH and GPG keys
```

### "Repository not found" after copy

**Cause**: Repository is private and you don't have access

**Solution**:
- Verify you're logged in to correct GitHub account
- Check organization membership
- Ask organization admin for access

### Installation fails after copy

**Cause**: Repository URLs in scripts still point to old location

**Solution**:
```bash
# Search for old references
grep -r "bryansparks" .

# Update found files
# Then commit and push changes
```

---

## 📚 Next Steps

After successfully copying:

1. **Customize** ORGANIZATION.md for your company
2. **Test** installation with a team member
3. **Document** internal processes (wiki page)
4. **Announce** to your organization
5. **Support** team members during adoption
6. **Gather feedback** and iterate

---

## 🤝 Contributing Back

If you make improvements that would benefit others:

1. **Fork** the original bryansparks/claude-code-config repo
2. **Create a branch** with your improvement
3. **Submit a pull request** to the original repo
4. **Document** your changes clearly

**Examples of good contributions**:
- New skills for different workflows
- Additional MCP server integrations
- Documentation improvements
- Bug fixes

---

## 📞 Support

**For issues with**:
- **Original repository**: Open issue at bryansparks/claude-code-config
- **Your copy**: Contact your engineering leadership
- **Claude Code itself**: https://github.com/anthropics/claude-code

---

**Good luck with your deployment!** 🚀
