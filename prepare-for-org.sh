#!/usr/bin/env bash
# prepare-for-org.sh - Prepare clean production branch for organization repository

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  Preparing Clean Production Branch                       ${BLUE}║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo

# Files to KEEP (production files)
PRODUCTION_FILES=(
    # Core files
    "install.sh"
    "README.md"
    "LICENSE"
    ".gitignore"

    # Installation directory structure
    ".claude/**"

    # Personas
    "personas/**"

    # Documentation (essential only)
    "docs/INSTALLATION.md"
    "docs/QUICK_START.md"
    "docs/MCP_SERVERS.md"
    "docs/MCP_INSTALLATION.md"
    "docs/VISION_SYSTEM.md"
)

# Files to EXCLUDE (interim documentation, dev files)
EXCLUDE_FILES=(
    "AGENT_ARCHITECTURE_ANALYSIS.md"
    "CONVERSION_SUMMARY.md"
    "DEPLOYMENT_GUIDE.md"
    "ENHANCEMENTS_V2.md"
    "FIXES_APPLIED.md"
    "GITHUB_SETUP_CHECKLIST.md"
    "INIT_PROJECT_COMPLETE.md"
    "INSTALLATION_GUIDE.md"
    "PERSONA_MCP_STATUS.md"
    "PLUGIN_ANALYSIS_REPORT.md"
    "PLUGIN_MIGRATION_GUIDE.md"
    "PROJECT_SUMMARY.md"
    "QUICK_START_PLUGINS.md"
    "README.old.md"
    "RESTRUCTURE_COMPLETE.md"
    "RESTRUCTURE_PLAN.md"
    "TEST_PLAN.md"
    "VISION_DOC_INTEGRATION_COMPLETE.md"
    "WCAG_ACCESSIBILITY_AUDIT_REPORT.md"
    "accessibility-audit-quickstart.md"
    "accessibility-test-suite.js"
    "convert-to-plugins.sh"
    "fix-plugins.sh"
    "PRD-Docs/**"
    "plugins/**"
    "templates/**"  # Using .claude/ instead
    "install-scripts/**"  # Using .claude/scripts/ instead
    ".claude-plugin/**"
)

echo -e "${BLUE}▶${NC} Creating production branch..."
git checkout -b production 2>/dev/null || git checkout production

echo -e "${BLUE}▶${NC} Removing interim documentation files..."

# Remove excluded files
for pattern in "${EXCLUDE_FILES[@]}"; do
    if [[ "$pattern" == *"**"* ]]; then
        # Handle glob patterns
        dir_pattern="${pattern//\*\*/}"
        if [ -d "$dir_pattern" ]; then
            echo "  Removing: $pattern"
            git rm -rf "$pattern" 2>/dev/null || true
        fi
    else
        if [ -f "$pattern" ] || [ -d "$pattern" ]; then
            echo "  Removing: $pattern"
            git rm -rf "$pattern" 2>/dev/null || true
        fi
    fi
done

echo
echo -e "${BLUE}▶${NC} Remaining files:"
git ls-files | head -20
echo "  ... ($(git ls-files | wc -l | xargs) total files)"
echo

# Create clean commit
echo -e "${BLUE}▶${NC} Creating clean production commit..."
git commit -m "chore: prepare production-ready branch for organization

Removed interim documentation and development files.
Keeping only essential production files:
- Core installation files (install.sh, README, LICENSE)
- .claude/ directory structure
- personas/ configurations
- Essential documentation

Ready for organization deployment.
" 2>/dev/null || echo "  (No changes to commit)"

echo
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  Production Branch Ready!                                ${GREEN}║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${YELLOW}Next Steps:${NC}"
echo
echo "1. Push production branch to GitHub:"
echo "   ${BLUE}git push -u origin production${NC}"
echo
echo "2. Make personal repo public (temporarily):"
echo "   • Go to: https://github.com/bryansparks/claude-code-config/settings"
echo "   • Scroll to 'Danger Zone'"
echo "   • Click 'Change visibility' → 'Make public'"
echo
echo "3. Import to organization repository (via GitHub web UI):"
echo "   • Go to: https://github.com/organizations/YOUR_ORG/repositories/new/import"
echo "   • Source URL: https://github.com/bryansparks/claude-code-config"
echo "   • Repository name: claude-code-config (or your choice)"
echo "   • Privacy: Private (for your org)"
echo "   • Click 'Begin import'"
echo
echo "4. After import, in organization repo:"
echo "   • Go to Settings → Branches"
echo "   • Change default branch to: production"
echo "   • Delete main branch (optional)"
echo
echo "5. Make personal repo private again (optional):"
echo "   • Go back to: https://github.com/bryansparks/claude-code-config/settings"
echo "   • Change visibility back to private"
echo
echo "6. Update install.sh in organization repo:"
echo "   • Edit line 25: Change URL to your org's repo"
echo "   • Commit and push"
echo
echo -e "${GREEN}✓${NC} Your organization will have a clean, production-ready configuration!"
echo
