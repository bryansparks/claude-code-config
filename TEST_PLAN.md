# Test Plan: Persona-Specific MCP Configurations

**Version**: 2.3.0
**Date**: 2025-10-04
**Status**: Ready to Test

---

## 🎯 Test Objectives

1. Verify persona configuration installation works correctly
2. Validate MCP server bundles install and activate properly
3. Test `/init-project` command preserves organization standards
4. Verify vision document system integration
5. Confirm MCP servers are accessible and functional

---

## ✅ Pre-Test Checklist

### Environment Setup
- [ ] `npm` and `npx` installed and working
- [ ] `git` configured
- [ ] Claude Code installed and running
- [ ] Terminal with bash/zsh shell

### Backup Current Config
```bash
# Backup existing Claude configuration
cp -r ~/.claude ~/.claude.backup-$(date +%Y%m%d-%H%M%S)
echo "Backup created at ~/.claude.backup-*"
```

---

## 🧪 Test Suite

### Test 1: Software Engineer Configuration

**Duration**: ~10 minutes

**Steps**:
```bash
# 1. Install persona configuration
cd /Users/bryansparks/projects/Claude-Config
./install-scripts/claude-config.sh engineer --dry-run

# Expected Output:
# - Shows what would be installed
# - Lists 9 subagents
# - Lists ORGANIZATION.md creation
# - Lists shared resources

# 2. Actual installation
./install-scripts/claude-config.sh engineer

# Expected Output:
# ✓ Installing organization standards...
# ✓ Installing shared resources...
# ✓ Subagents installed
# ✓ Hooks installed
# ✓ Commands installed
# ✓ MCP Servers installed
# ✓ settings.json installed
```

**Verification**:
```bash
# Check files created
ls -la ~/.claude/ORGANIZATION.md          # Should exist
ls -la ~/.claude/subagents/                # Should have 9 .md files
ls -la ~/.claude/hooks/                    # Should have hooks
ls -la ~/.claude/shared/                   # Should have shared resources

# Check MCP config
cat ~/.claude/templates/engineers/mcp-servers/mcp-config.json | jq '.bundle_size'
# Expected: 7

cat ~/.claude/templates/engineers/mcp-servers/mcp-config.json | jq '.servers | keys'
# Expected: ["filesystem", "github", "memory", "playwright", "postgres", "sequential-thinking", "serena"]
```

**Expected Results**:
- ✅ ORGANIZATION.md created with org standards
- ✅ 9 engineer subagents installed
- ✅ Shared hooks installed (load-project-context.sh, post-init-project.sh)
- ✅ MCP config shows 7 servers
- ✅ settings.json updated with vision_doc_support

---

### Test 2: MCP Server Installation (Engineer Bundle)

**Duration**: ~15 minutes

**Steps**:
```bash
# Note: We don't have install-mcp-engineer.sh yet, so test individual servers

# 1. Set required environment variables
export GITHUB_TOKEN="ghp_YOUR_TOKEN_HERE"

# 2. Install Priority 1 servers manually
npx -y @modelcontextprotocol/server-github
npx -y @modelcontextprotocol/server-filesystem
uvx --from git+https://github.com/oraios/serena serena-mcp-server

# 3. Install Priority 2 servers
npx -y @modelcontextprotocol/server-memory
npx -y @modelcontextprotocol/server-sequential-thinking
npx -y @modelcontextprotocol/server-playwright
npx -y @modelcontextprotocol/server-postgres
```

**Verification**:
```bash
# Check Claude MCP servers
claude mcp list

# Expected Output (should show installed servers):
# - github
# - filesystem
# - serena
# - memory
# - sequential-thinking
# - playwright
# - postgres
```

**Expected Results**:
- ✅ All 7 servers show in `claude mcp list`
- ✅ GitHub server requires GITHUB_TOKEN
- ✅ Serena installed via uvx
- ✅ Other servers via npx

---

### Test 3: Project Initialization with `/init-project`

**Duration**: ~5 minutes

**Steps**:
```bash
# 1. Create test project directory
mkdir -p ~/test-projects/test-api-service
cd ~/test-projects/test-api-service

# 2. Initialize git (for auto-detection)
git init
git remote add origin https://github.com/test/test-api-service.git

# 3. Test /init-project (Note: This is a spec, not implemented yet)
# For now, test that ORGANIZATION.md is protected

# Simulate what /init-project would do:
export CLAUDE_PROJECT="test-api-service"

# Check if ORGANIZATION.md exists and is protected
ls -la ~/.claude/ORGANIZATION.md
cat ~/.claude/ORGANIZATION.md | head -20

# Expected: Organization standards preserved
```

**Expected Results**:
- ✅ ORGANIZATION.md exists at ~/.claude/
- ✅ Contains organization-wide standards
- ✅ Project directory ready for initialization

---

### Test 4: QA Engineer Configuration

**Duration**: ~10 minutes

**Steps**:
```bash
# 1. Clean previous persona (optional)
# rm -rf ~/.claude/subagents/*.md

# 2. Install QA configuration
cd /Users/bryansparks/projects/Claude-Config
./install-scripts/claude-config.sh qa

# Expected Output:
# ✓ ORGANIZATION.md already exists (preserving)
# ✓ QA subagents installed
# ✓ QA hooks installed
# ✓ QA commands installed
```

**Verification**:
```bash
# Check QA-specific subagents
ls ~/.claude/subagents/test-automation-specialist.md
ls ~/.claude/subagents/bug-analyst.md
ls ~/.claude/subagents/accessibility-auditor.md

# Check MCP config
cat ~/.claude/templates/qa-engineers/mcp-servers/mcp-config.json | jq '.servers | keys'
# Expected: ["a11y-mcp", "filesystem", "github", "memory", "playwright", "postgres", "sequential-thinking"]
```

**Install QA MCP Bundle**:
```bash
# Priority 1 servers
npx -y @modelcontextprotocol/server-playwright
npx -y @modelcontextprotocol/server-github
npx -y @modelcontextprotocol/server-filesystem
npm install -g a11y-mcp

# Priority 2 servers
npx -y @modelcontextprotocol/server-memory
npx -y @modelcontextprotocol/server-sequential-thinking
npx -y @modelcontextprotocol/server-postgres
```

**Expected Results**:
- ✅ ORGANIZATION.md preserved (not overwritten)
- ✅ 5 QA-specific subagents installed
- ✅ QA MCP config shows 7 servers including A11y MCP
- ✅ A11y MCP installs via npm (not npx)

---

### Test 5: Vision Document System Integration

**Duration**: ~5 minutes

**Steps**:
```bash
# 1. Check vision doc support in settings
cat ~/.claude/templates/engineers/settings.json | jq '.vision_doc_support'

# Expected Output:
# {
#   "enabled": true,
#   "auto_load": true,
#   "session_hook": "load-project-context.sh",
#   ...
# }

# 2. Check session hook exists
ls -la ~/.claude/hooks/load-project-context.sh
chmod +x ~/.claude/hooks/load-project-context.sh

# 3. Test session hook (simulate)
~/.claude/hooks/load-project-context.sh

# Expected Output:
# ═══════════════════════════════════════════════════════════
# 🎯 Claude Code session started
# ═══════════════════════════════════════════════════════════
# Working directory: /current/path
#
# 💡 Start vision-driven development:
#    /create-vision-doc --project <name> --type <type>
# ═══════════════════════════════════════════════════════════
```

**Expected Results**:
- ✅ Vision doc support configured in all persona settings
- ✅ Session hook executable and working
- ✅ Hook displays project context when available

---

### Test 6: Documentation Validation

**Duration**: ~5 minutes

**Steps**:
```bash
# 1. Check all documentation exists
ls -la MCP_SERVERS_BY_PERSONA.md
ls -la MCP_INSTALLATION_REFERENCE.md
ls -la VISION_DOC_SYSTEM.md
ls -la INIT_PROJECT_COMPLETE.md
ls -la VISION_DOC_INTEGRATION_COMPLETE.md

# 2. Validate documentation completeness
grep -c "Software Engineer" MCP_SERVERS_BY_PERSONA.md    # Should be > 5
grep -c "QA Engineer" MCP_SERVERS_BY_PERSONA.md          # Should be > 5
grep -c "Product Manager" MCP_SERVERS_BY_PERSONA.md      # Should be > 5

# 3. Check installation reference has all servers
grep -c "Serena" MCP_INSTALLATION_REFERENCE.md           # Should be > 3
grep -c "A11y MCP" MCP_INSTALLATION_REFERENCE.md         # Should be > 3
grep -c "PostgreSQL" MCP_INSTALLATION_REFERENCE.md       # Should be > 3
```

**Expected Results**:
- ✅ All documentation files present
- ✅ Each persona documented thoroughly
- ✅ All MCP servers documented with install commands

---

## 🐛 Troubleshooting Guide

### Issue 1: ORGANIZATION.md not created
**Solution**:
```bash
# Manually create from template
cp /Users/bryansparks/projects/Claude-Config/templates/ORGANIZATION-template.md ~/.claude/ORGANIZATION.md
```

### Issue 2: MCP server not found
**Solution**:
```bash
# Check npm/npx installation
which npm
which npx

# Reinstall specific server
npx -y @modelcontextprotocol/server-<name>
```

### Issue 3: Environment variables not set
**Solution**:
```bash
# Check if variables are set
echo $GITHUB_TOKEN
echo $LINEAR_API_KEY

# Set in shell profile
echo 'export GITHUB_TOKEN="ghp_..."' >> ~/.zshrc
source ~/.zshrc
```

### Issue 4: Serena installation fails
**Solution**:
```bash
# Install uv first
curl -LsSf https://astral.sh/uv/install.sh | sh

# Then install Serena
uvx --from git+https://github.com/oraios/serena serena-mcp-server
```

### Issue 5: A11y MCP not found
**Solution**:
```bash
# Install globally via npm (not npx)
npm install -g a11y-mcp

# Verify installation
which a11y-mcp
```

---

## ✅ Success Criteria

### Persona Configuration
- [ ] Engineer persona installs with 9 subagents
- [ ] QA persona installs with 5 subagents
- [ ] ORGANIZATION.md created on first install
- [ ] ORGANIZATION.md preserved on subsequent installs
- [ ] Shared resources (hooks, commands) installed

### MCP Servers
- [ ] Engineer bundle: 7 servers installed
- [ ] QA bundle: 7 servers installed
- [ ] All servers show in `claude mcp list`
- [ ] Priority 1 servers install without errors
- [ ] Environment variables properly configured

### Vision Document System
- [ ] Vision doc support in all persona settings
- [ ] Session hook loads project context
- [ ] /init-project spec documented (implementation pending)
- [ ] Documentation comprehensive and accurate

### Documentation
- [ ] MCP_SERVERS_BY_PERSONA.md complete
- [ ] MCP_INSTALLATION_REFERENCE.md complete
- [ ] All install commands tested and working
- [ ] Troubleshooting guide helpful

---

## 📊 Test Results Template

```markdown
## Test Results: [Date]

### Test 1: Software Engineer Configuration
- Status: [ ] Pass / [ ] Fail
- Issues:
- Notes:

### Test 2: MCP Server Installation (Engineer)
- Status: [ ] Pass / [ ] Fail
- Servers Installed:
- Issues:

### Test 3: Project Initialization
- Status: [ ] Pass / [ ] Fail
- ORGANIZATION.md preserved: [ ] Yes / [ ] No
- Issues:

### Test 4: QA Engineer Configuration
- Status: [ ] Pass / [ ] Fail
- Issues:

### Test 5: Vision Document System
- Status: [ ] Pass / [ ] Fail
- Issues:

### Test 6: Documentation Validation
- Status: [ ] Pass / [ ] Fail
- Issues:

## Overall Result: [ ] Pass / [ ] Fail

## Recommendations:
```

---

## 🚀 Next Steps After Testing

1. **If tests pass**:
   - Complete remaining 3 persona configs (PM, EM, UX)
   - Create 5 persona-specific installation scripts
   - Implement `/init-project` command
   - Test with all 5 personas

2. **If tests fail**:
   - Document issues in test results
   - Fix critical bugs
   - Re-test failed scenarios
   - Update documentation as needed

3. **Production Readiness**:
   - All 5 personas tested
   - All MCP bundles functional
   - Documentation verified
   - Installation scripts complete

---

**Status**: ✅ Ready to Test
**Priority**: Test Engineer and QA bundles first
**ETA**: ~50 minutes for complete test suite

*Comprehensive test plan for persona-specific MCP configurations* 🧪
