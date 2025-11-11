#!/usr/bin/env bash

# validate-install.sh
# Validates Claude Code configuration installation
# Checks: files, environment variables, MCP config, persona config

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tracking
ERRORS=0
WARNINGS=0
CHECKS_PASSED=0

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Code Installation Validator        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS_PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 1. Check core installation files
echo -e "\n${BLUE}[1/6]${NC} Checking core installation files..."
echo "───────────────────────────────────────────"

if [ -d "$HOME/.claude" ]; then
    check_pass "Claude config directory exists: ~/.claude"
else
    check_fail "Claude config directory not found: ~/.claude"
    echo -e "${RED}      Run: curl -fsSL <install-url> | bash -s -- <persona>${NC}"
    exit 1
fi

if [ -f "$HOME/.claude/config/persona.conf" ]; then
    PERSONA=$(cat "$HOME/.claude/config/persona.conf")
    check_pass "Persona config exists: $PERSONA"
else
    check_fail "Persona config not found: ~/.claude/config/persona.conf"
fi

if [ -f "$HOME/CLAUDE.md" ]; then
    check_pass "Global CLAUDE.md symlink exists"
else
    check_warn "Global CLAUDE.md not found (optional but recommended)"
fi

if [ -f "$HOME/.claude/templates/ORGANIZATION.md" ]; then
    check_pass "ORGANIZATION.md template exists"
else
    check_warn "ORGANIZATION.md template not found"
fi

# 2. Check shared configuration files
echo -e "\n${BLUE}[2/6]${NC} Checking shared configuration files..."
echo "───────────────────────────────────────────"

SHARED_CONFIGS=(
    "superclaude-core.yml"
    "superclaude-personas.yml"
    "superclaude-mcp.yml"
    "superclaude-rules.yml"
)

for config in "${SHARED_CONFIGS[@]}"; do
    if [ -f "$HOME/.claude/shared/$config" ]; then
        check_pass "Found: ~/.claude/shared/$config"
    else
        check_fail "Missing: ~/.claude/shared/$config"
    fi
done

# 3. Check persona-specific files
echo -e "\n${BLUE}[3/6]${NC} Checking persona-specific files..."
echo "───────────────────────────────────────────"

if [ -n "$PERSONA" ]; then
    # Check commands
    if [ -d "$HOME/.claude/commands" ] && [ "$(ls -A $HOME/.claude/commands 2>/dev/null)" ]; then
        CMD_COUNT=$(ls -1 "$HOME/.claude/commands" | wc -l | tr -d ' ')
        check_pass "Found $CMD_COUNT slash commands"
    else
        check_warn "No slash commands found in ~/.claude/commands"
    fi

    # Check hooks
    if [ -d "$HOME/.claude/hooks" ] && [ "$(ls -A $HOME/.claude/hooks 2>/dev/null)" ]; then
        HOOK_COUNT=$(ls -1 "$HOME/.claude/hooks" | wc -l | tr -d ' ')
        check_pass "Found $HOOK_COUNT hooks"
    else
        check_warn "No hooks found in ~/.claude/hooks"
    fi

    # Check skills
    if [ -d "$HOME/.claude/skills" ] && [ "$(ls -A $HOME/.claude/skills 2>/dev/null)" ]; then
        SKILL_COUNT=$(ls -1 "$HOME/.claude/skills" 2>/dev/null | wc -l | tr -d ' ')
        check_pass "Found $SKILL_COUNT skills"
    else
        check_warn "No skills found in ~/.claude/skills (skills may not be available for $PERSONA)"
    fi
fi

# 4. Check MCP configuration
echo -e "\n${BLUE}[4/6]${NC} Checking MCP server configuration..."
echo "───────────────────────────────────────────"

if [ -f "$HOME/.claude/mcp-servers/mcp-config.json" ]; then
    check_pass "MCP config file exists"

    # Validate JSON syntax
    if command -v python3 &> /dev/null; then
        if python3 -m json.tool "$HOME/.claude/mcp-servers/mcp-config.json" > /dev/null 2>&1; then
            check_pass "MCP config JSON is valid"
        else
            check_fail "MCP config JSON is invalid"
        fi
    elif command -v jq &> /dev/null; then
        if jq empty "$HOME/.claude/mcp-servers/mcp-config.json" > /dev/null 2>&1; then
            check_pass "MCP config JSON is valid"
        else
            check_fail "MCP config JSON is invalid"
        fi
    else
        check_warn "Cannot validate JSON (install python3 or jq to enable)"
    fi
else
    check_fail "MCP config not found: ~/.claude/mcp-servers/mcp-config.json"
fi

# 5. Check environment variables
echo -e "\n${BLUE}[5/6]${NC} Checking environment variables..."
echo "───────────────────────────────────────────"

if [ -z "$PERSONA" ]; then
    check_warn "Cannot check env vars: persona unknown"
else
    case "$PERSONA" in
        "engineer")
            # Required
            if [ -n "$GITHUB_TOKEN" ]; then
                TOKEN_PREFIX=$(echo "$GITHUB_TOKEN" | cut -c1-10)
                check_pass "GITHUB_TOKEN is set ($TOKEN_PREFIX...)"
            else
                check_fail "GITHUB_TOKEN is not set (required)"
            fi

            # Optional
            if [ -n "$POSTGRES_CONNECTION_STRING" ]; then
                check_pass "POSTGRES_CONNECTION_STRING is set (optional)"
            else
                check_info "POSTGRES_CONNECTION_STRING not set (optional for PostgreSQL server)"
            fi
            ;;

        "qa")
            # Required
            if [ -n "$GITHUB_TOKEN" ]; then
                TOKEN_PREFIX=$(echo "$GITHUB_TOKEN" | cut -c1-10)
                check_pass "GITHUB_TOKEN is set ($TOKEN_PREFIX...)"
            else
                check_fail "GITHUB_TOKEN is not set (required)"
            fi

            # Optional
            if [ -n "$POSTGRES_CONNECTION_STRING" ]; then
                check_pass "POSTGRES_CONNECTION_STRING is set (optional)"
            fi
            if [ -n "$PLAYWRIGHT_BROWSERS_PATH" ]; then
                check_pass "PLAYWRIGHT_BROWSERS_PATH is set (optional)"
            fi
            ;;

        "pm")
            # Required
            REQUIRED_TOKENS=("GITHUB_TOKEN" "LINEAR_API_KEY" "POSTHOG_API_KEY" "FIGMA_ACCESS_TOKEN")
            for token in "${REQUIRED_TOKENS[@]}"; do
                if [ -n "${!token}" ]; then
                    TOKEN_PREFIX=$(echo "${!token}" | cut -c1-10)
                    check_pass "$token is set ($TOKEN_PREFIX...)"
                else
                    check_fail "$token is not set (required)"
                fi
            done

            # Optional
            OPTIONAL_TOKENS=("JIRA_HOST" "JIRA_EMAIL" "JIRA_API_TOKEN" "SLACK_BOT_TOKEN")
            for token in "${OPTIONAL_TOKENS[@]}"; do
                if [ -n "${!token}" ]; then
                    check_pass "$token is set (optional)"
                fi
            done
            ;;

        "em")
            # Required
            REQUIRED_TOKENS=("GITHUB_TOKEN" "LINEAR_API_KEY" "POSTHOG_API_KEY" "SLACK_BOT_TOKEN")
            for token in "${REQUIRED_TOKENS[@]}"; do
                if [ -n "${!token}" ]; then
                    TOKEN_PREFIX=$(echo "${!token}" | cut -c1-10)
                    check_pass "$token is set ($TOKEN_PREFIX...)"
                else
                    check_fail "$token is not set (required)"
                fi
            done

            # Optional
            if [ -n "$POSTGRES_CONNECTION_STRING" ]; then
                check_pass "POSTGRES_CONNECTION_STRING is set (optional)"
            fi
            ;;

        "ux")
            # Required
            if [ -n "$FIGMA_ACCESS_TOKEN" ]; then
                TOKEN_PREFIX=$(echo "$FIGMA_ACCESS_TOKEN" | cut -c1-10)
                check_pass "FIGMA_ACCESS_TOKEN is set ($TOKEN_PREFIX...)"
            else
                check_fail "FIGMA_ACCESS_TOKEN is not set (required)"
            fi

            # Optional
            OPTIONAL_TOKENS=("GITHUB_TOKEN" "SLACK_BOT_TOKEN")
            for token in "${OPTIONAL_TOKENS[@]}"; do
                if [ -n "${!token}" ]; then
                    TOKEN_PREFIX=$(echo "${!token}" | cut -c1-10)
                    check_pass "$token is set (optional, $TOKEN_PREFIX...)"
                fi
            done
            ;;

        *)
            check_warn "Unknown persona: $PERSONA"
            ;;
    esac
fi

# 6. Test token validity (basic format check)
echo -e "\n${BLUE}[6/6]${NC} Validating token formats..."
echo "───────────────────────────────────────────"

if [ -n "$GITHUB_TOKEN" ]; then
    if [[ "$GITHUB_TOKEN" =~ ^(ghp_|github_pat_) ]]; then
        check_pass "GITHUB_TOKEN format is valid"
    else
        check_warn "GITHUB_TOKEN format may be invalid (should start with ghp_ or github_pat_)"
    fi
fi

if [ -n "$LINEAR_API_KEY" ]; then
    if [[ "$LINEAR_API_KEY" =~ ^lin_api_ ]]; then
        check_pass "LINEAR_API_KEY format is valid"
    else
        check_warn "LINEAR_API_KEY format may be invalid (should start with lin_api_)"
    fi
fi

if [ -n "$POSTHOG_API_KEY" ]; then
    if [[ "$POSTHOG_API_KEY" =~ ^phc_ ]]; then
        check_pass "POSTHOG_API_KEY format is valid"
    else
        check_warn "POSTHOG_API_KEY format may be invalid (should start with phc_)"
    fi
fi

if [ -n "$FIGMA_ACCESS_TOKEN" ]; then
    if [[ "$FIGMA_ACCESS_TOKEN" =~ ^figd_ ]]; then
        check_pass "FIGMA_ACCESS_TOKEN format is valid"
    else
        check_warn "FIGMA_ACCESS_TOKEN format may be invalid (should start with figd_)"
    fi
fi

if [ -n "$SLACK_BOT_TOKEN" ]; then
    if [[ "$SLACK_BOT_TOKEN" =~ ^xoxb- ]]; then
        check_pass "SLACK_BOT_TOKEN format is valid"
    else
        check_warn "SLACK_BOT_TOKEN format may be invalid (should start with xoxb-)"
    fi
fi

if [ -n "$POSTGRES_CONNECTION_STRING" ]; then
    if [[ "$POSTGRES_CONNECTION_STRING" =~ ^postgresql:// ]]; then
        check_pass "POSTGRES_CONNECTION_STRING format is valid"
    else
        check_warn "POSTGRES_CONNECTION_STRING format may be invalid (should start with postgresql://)"
    fi
fi

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║             Validation Summary             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Checks Passed:${NC}  $CHECKS_PASSED"
echo -e "${YELLOW}Warnings:${NC}       $WARNINGS"
echo -e "${RED}Errors:${NC}         $ERRORS"
echo ""

if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}✓ Installation is valid! All checks passed.${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Restart Claude Code to apply configuration"
        echo "  2. Test MCP servers in Claude Code"
        echo "  3. Try a slash command (e.g., /review, /test-plan)"
        echo ""
        exit 0
    else
        echo -e "${YELLOW}⚠ Installation is mostly valid, but has warnings.${NC}"
        echo ""
        echo -e "${BLUE}Recommendations:${NC}"
        echo "  - Review warnings above"
        echo "  - Set optional environment variables if you'll use those MCP servers"
        echo "  - See: docs/SECRETS_MANAGEMENT.md"
        echo ""
        exit 0
    fi
else
    echo -e "${RED}✗ Installation has errors that must be fixed.${NC}"
    echo ""
    echo -e "${BLUE}Action required:${NC}"
    echo "  - Fix errors listed above"
    echo "  - Review: docs/INSTALLATION.md"
    echo "  - Setup tokens: docs/SECRETS_MANAGEMENT.md"
    echo "  - Re-run validation: ~/.claude/scripts/validate-install.sh"
    echo ""
    exit 1
fi
