# GitHub Setup Checklist

## ✅ Pre-Push Checklist

### Files Created
- [x] `install.sh` - Main installer with sparse checkout
- [x] `README.md` - Comprehensive README
- [x] `LICENSE` - MIT License
- [x] `.gitignore` - Proper ignore patterns
- [x] `.claude/` directory structure
- [x] `personas/` directory structure
- [x] `docs/` directory structure

### Directory Structure
- [x] `.claude/config/mcp-servers/` - All 5 persona MCP configs
- [x] `.claude/templates/` - ORGANIZATION.md, PROJECT.md, CLAUDE.md
- [x] `.claude/commands/shared/` - Shared slash commands
- [x] `.claude/hooks/` - Event hooks
- [x] `.claude/scripts/` - Installation scripts
- [x] `personas/{engineer,qa,pm,em,ux}/` - Persona-specific files
- [x] `docs/` - All documentation moved

---

## 🔧 Before Creating GitHub Repo

### 1. Update Repository URL
Edit `install.sh` line 16:
```bash
# Change from:
REPO_URL="${CLAUDE_CONFIG_REPO:-https://github.com/your-org/claude-config}"

# To your actual GitHub URL:
REPO_URL="${CLAUDE_CONFIG_REPO:-https://github.com/YOUR_USERNAME/claude-config}"
```

### 2. Update README.md Links
Update all `your-org` references in `README.md`:
```bash
# Use sed to replace (macOS)
sed -i '' 's/your-org/YOUR_USERNAME/g' README.md

# Or manually search/replace:
# - All badge URLs
# - All installation command URLs
# - All documentation links
```

### 3. Verify File Permissions
```bash
# Make sure install.sh is executable
chmod +x install.sh

# Make sure all scripts are executable
chmod +x .claude/scripts/*.sh
chmod +x .claude/hooks/*.sh
```

### 4. Test Locally (Optional)
```bash
# Test install.sh syntax
bash -n install.sh

# Test sparse checkout paths
# (Will verify after pushing to GitHub)
```

---

## 📤 Creating GitHub Repository

### Step 1: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `claude-config`
3. Description: "Production-ready Claude Code configuration with persona-specific workflows"
4. Public or Private: **Public** (recommended)
5. **Do NOT** initialize with README, .gitignore, or license (we have them!)
6. Click "Create repository"

### Step 2: Initialize Git
```bash
cd /Users/bryansparks/projects/Claude-Config

# Initialize git (if not already)
git init

# Add all files
git add .

# Create initial commit
git commit -m "feat: initial release - persona-based Claude Code configuration

- Add persona-specific MCP server bundles (engineer, qa, pm, em, ux)
- Add one-command installation with sparse checkout
- Add vision-driven development system
- Add organization standards preservation
- Add comprehensive documentation
- Restructure for clean installation (everything in ~/.claude/)
"
```

### Step 3: Push to GitHub
```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/claude-config.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## ✅ Post-Push Verification

### 1. Verify Repository
- [ ] Go to `https://github.com/YOUR_USERNAME/claude-config`
- [ ] Check README renders correctly
- [ ] Check LICENSE is recognized by GitHub
- [ ] Check all directories are present

### 2. Test Installation

#### Test Engineer Persona
```bash
# From a fresh machine or directory
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- engineer

# Verify installation
ls -la ~/.claude/
ls -la ~/.claude/config/mcp-servers/engineer/
cat ~/.claude/CLAUDE.md
cat ~/.claude/config/persona.conf
```

#### Test QA Persona
```bash
# Uninstall first
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- --uninstall

# Install QA persona
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- qa

# Verify
ls -la ~/.claude/config/mcp-servers/qa/
```

#### Test All Personas
```bash
# Uninstall first
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- --uninstall

# Install all
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- --all

# Verify all configs present
ls -la ~/.claude/config/mcp-servers/
```

### 3. Test Update Functionality
```bash
# Make a small change to README.md and push
echo "Test update" >> README.md
git add README.md
git commit -m "test: update test"
git push

# Test update
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- --update

# Verify update worked
cat ~/.claude/../README.md | tail -1
```

### 4. Verify Sparse Checkout
```bash
# Check download size
# Should be ~2 MB for single persona vs ~10 MB for full clone

# Install engineer persona and check what was downloaded
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- engineer

# Verify only engineer files downloaded (not qa, pm, em, ux)
ls ~/.claude/config/mcp-servers/
# Should only show: engineer/
```

---

## 📝 Repository Settings

### GitHub Repository Settings

1. **About Section**
   - Description: "Production-ready Claude Code configuration with persona-specific workflows, MCP server bundles, and vision-driven development"
   - Website: (Your docs site if you have one)
   - Topics: `claude-code`, `ai`, `mcp`, `configuration`, `personas`, `development`

2. **Features**
   - [x] Issues
   - [x] Discussions (recommended)
   - [ ] Projects (optional)
   - [ ] Wiki (optional - we have docs/)

3. **Branch Protection** (Optional but recommended)
   - Require pull request reviews
   - Require status checks
   - Don't allow force push

---

## 📚 Documentation Updates

### Update Documentation Links
After pushing to GitHub, update these files with correct URLs:

1. **README.md**
   - [x] Installation URLs
   - [x] Badge URLs
   - [x] Documentation links

2. **docs/*.md**
   - [ ] Update any relative links
   - [ ] Add link to main repo

3. **CONTRIBUTING.md** (Create this)
   ```bash
   cat > CONTRIBUTING.md << 'EOF'
   # Contributing to Claude Config

   We welcome contributions! Please see our guidelines below.

   ## How to Contribute

   1. Fork the repository
   2. Create a feature branch
   3. Make your changes
   4. Test your changes
   5. Submit a pull request

   ## Adding a New Persona

   1. Create directory: `personas/new-persona/`
   2. Add MCP config: `.claude/config/mcp-servers/new-persona/mcp-config.json`
   3. Update `install.sh` with new persona
   4. Add documentation
   5. Submit PR

   ## Development Setup

   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-config.git
   cd claude-config
   ./install.sh engineer
   ```

   ## Code of Conduct

   Be respectful and constructive.
   EOF
   ```

---

## 🎯 Post-Release Tasks

### Create GitHub Release
1. Go to Releases
2. Click "Create a new release"
3. Tag: `v2.3.0`
4. Title: "Claude Config v2.3.0 - Initial Release"
5. Description:
   ```markdown
   # Claude Config v2.3.0

   Production-ready Claude Code configuration with persona-specific workflows.

   ## 🎭 Personas
   - Software Engineer
   - QA Engineer
   - Product Manager
   - Engineering Manager
   - UX Designer

   ## ✨ Features
   - One-command installation
   - Persona-specific MCP server bundles
   - Vision-driven development system
   - Organization standards preservation
   - Clean installation (everything in ~/.claude/)

   ## 🚀 Quick Start

   ```bash
   curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- engineer
   ```

   See [README](https://github.com/YOUR_USERNAME/claude-config) for full documentation.
   ```

### Promote Repository
- [ ] Share on Twitter/X
- [ ] Share on LinkedIn
- [ ] Post in Claude Code community
- [ ] Add to Awesome Claude lists
- [ ] Add to MCP server lists

---

## ✅ Final Checklist

### Before Going Live
- [ ] Repository URL updated in install.sh
- [ ] README.md links updated
- [ ] All URLs tested
- [ ] Git repository initialized
- [ ] Pushed to GitHub
- [ ] Installation tested (engineer)
- [ ] Installation tested (qa)
- [ ] Installation tested (--all)
- [ ] Update functionality tested
- [ ] Uninstall functionality tested
- [ ] Sparse checkout verified
- [ ] Documentation complete
- [ ] CONTRIBUTING.md created
- [ ] GitHub release created

### Success Criteria
- [ ] One-command installation works
- [ ] All personas install correctly
- [ ] No files left in project root
- [ ] Everything installs to ~/.claude/
- [ ] MCP servers install automatically
- [ ] Documentation is clear
- [ ] README renders beautifully on GitHub

---

## 🎉 Ready to Launch!

Once all checkboxes are checked, your Claude Config repository is ready for public use!

**Share the installation command:**
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-config/main/install.sh | bash -s -- engineer
```

---

*Last updated: October 2025*
