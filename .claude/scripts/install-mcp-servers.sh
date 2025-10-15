#!/usr/bin/env bash

#############################################
# MCP Servers Installation Script
# Installs and configures MCP servers for Claude Code
#############################################

set -eo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Helper functions
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_step() { echo -e "${CYAN}▶${NC} $1"; }

# Installation functions
install_serena() {
    print_step "Installing Serena MCP Server (Large Codebase Analysis)..."

    if command -v npm &> /dev/null; then
        npm install -g @oraios/serena-mcp
        print_success "Serena MCP Server installed"

        print_info "Serena provides:"
        echo "  • Semantic code understanding via Language Server Protocol"
        echo "  • Symbol-level code navigation and editing"
        echo "  • Multi-language support (Java, Python, JavaScript, TypeScript)"
        echo "  • Perfect for large codebases with complex structure"
    else
        print_error "npm not found. Install Node.js first: https://nodejs.org/"
        return 1
    fi
}

install_claude_context() {
    print_step "Installing Claude Context MCP Server (Semantic Search)..."

    if [ -z "$MILVUS_CLUSTER_ENDPOINT" ] || [ -z "$MILVUS_API_KEY" ]; then
        print_warning "Skipping claude-context: MILVUS_CLUSTER_ENDPOINT and MILVUS_API_KEY required"
        print_info "Set these environment variables to enable semantic codebase search"
        return 0
    fi

    if command -v npm &> /dev/null; then
        npm install -g @anthropic/claude-context-mcp
        print_success "Claude Context MCP Server installed"

        print_info "Claude Context provides:"
        echo "  • Semantic search over your entire codebase"
        echo "  • Vector-based code retrieval with Milvus"
        echo "  • Context-aware code suggestions"
    else
        print_error "npm not found"
        return 1
    fi
}

install_filesystem() {
    print_step "Installing Filesystem MCP Server..."

    if command -v npx &> /dev/null; then
        # Filesystem server is typically used via npx
        print_success "Filesystem MCP Server available via npx"
        print_info "Use: npx @modelcontextprotocol/server-filesystem <path>"
    else
        print_error "npx not found. Install Node.js first"
        return 1
    fi
}

install_memory() {
    print_step "Installing Memory MCP Server..."

    if command -v npm &> /dev/null; then
        npm install -g @anthropic/mcp-server-memory
        print_success "Memory MCP Server installed"

        print_info "Memory server provides:"
        echo "  • Persistent conversation memory"
        echo "  • Context retention across sessions"
        echo "  • Knowledge graph storage"
    else
        print_error "npm not found"
        return 1
    fi
}

install_sequential_thinking() {
    print_step "Installing Sequential Thinking MCP Server..."

    if command -v npm &> /dev/null; then
        npm install -g @anthropic/mcp-server-sequential-thinking
        print_success "Sequential Thinking MCP Server installed"

        print_info "Sequential Thinking provides:"
        echo "  • Multi-step reasoning workflows"
        echo "  • Complex task decomposition"
        echo "  • Decision tree analysis"
    else
        print_error "npm not found"
        return 1
    fi
}

install_github() {
    print_step "Installing GitHub CLI (for GitHub MCP integration)..."

    if command -v gh &> /dev/null; then
        print_success "GitHub CLI already installed"
        gh version
    else
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install gh
                print_success "GitHub CLI installed"
            else
                print_error "Homebrew not found. Install from: https://brew.sh/"
                return 1
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            print_info "Install GitHub CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
            return 1
        else
            print_warning "Unsupported OS. Install GitHub CLI manually: https://cli.github.com/"
            return 1
        fi
    fi

    # Check authentication
    if ! gh auth status &> /dev/null; then
        print_warning "GitHub CLI not authenticated"
        print_info "Run: gh auth login"
    else
        print_success "GitHub CLI authenticated"
    fi
}

install_playwright() {
    print_step "Installing Playwright MCP Server..."

    if command -v npm &> /dev/null; then
        npm install -g @executeautomation/playwright-mcp-server
        print_success "Playwright MCP Server installed"

        print_info "Playwright provides:"
        echo "  • Browser automation for testing"
        echo "  • Visual regression testing"
        echo "  • Accessibility auditing"
        echo "  • Screenshot capture"
    else
        print_error "npm not found"
        return 1
    fi
}

install_context7() {
    print_step "Installing Context7 MCP Server (Long-term Memory)..."

    if [ -z "$UPSTASH_REDIS_REST_URL" ] || [ -z "$UPSTASH_REDIS_REST_TOKEN" ]; then
        print_warning "Skipping Context7: UPSTASH_REDIS_REST_URL and UPSTASH_REDIS_REST_TOKEN required"
        print_info "Get Upstash Redis at: https://upstash.com/"
        return 0
    fi

    if command -v npm &> /dev/null; then
        npm install -g @upstash/context7-mcp
        print_success "Context7 MCP Server installed"

        print_info "Context7 provides:"
        echo "  • Long-term conversation memory via Upstash Redis"
        echo "  • Historical context retrieval"
        echo "  • Cross-session knowledge persistence"
    else
        print_error "npm not found"
        return 1
    fi
}

# Main installation menu
show_menu() {
    cat << EOF
${CYAN}
╔══════════════════════════════════════════════════╗
║     MCP Server Installation Menu                ║
╚══════════════════════════════════════════════════╝
${NC}
Available MCP Servers:

${GREEN}Core Servers (Recommended for All):${NC}
  1. Filesystem       - Local file operations
  2. Memory          - Session memory and context
  3. Sequential      - Multi-step reasoning
  4. GitHub          - Repository and PR management

${BLUE}Large Codebase Servers (Engineers/Managers):${NC}
  5. Serena          - Semantic code analysis (RECOMMENDED)
  6. Claude Context  - Semantic codebase search (requires Milvus)

${YELLOW}Specialized Servers:${NC}
  7. Playwright      - Browser automation (QA/UX)
  8. Context7        - Long-term memory (requires Upstash)

${CYAN}Installation Options:${NC}
  all-core          - Install core servers (1-4)
  all-engineer      - Install engineer servers (1-6)
  all-qa            - Install QA servers (1-4, 7)
  all-pm            - Install PM servers (1-4, 8)
  all               - Install everything

${NC}Usage:
  $0 <server-number|option>

Examples:
  $0 5              # Install Serena only
  $0 all-engineer   # Install all engineer servers
  $0 all            # Install everything

EOF
}

# Main script
if [ $# -eq 0 ]; then
    show_menu
    exit 0
fi

case "$1" in
    1) install_filesystem ;;
    2) install_memory ;;
    3) install_sequential_thinking ;;
    4) install_github ;;
    5) install_serena ;;
    6) install_claude_context ;;
    7) install_playwright ;;
    8) install_context7 ;;

    all-core)
        install_filesystem
        install_memory
        install_sequential_thinking
        install_github
        ;;

    all-engineer)
        install_filesystem
        install_memory
        install_sequential_thinking
        install_github
        install_serena
        install_claude_context
        ;;

    all-qa)
        install_filesystem
        install_memory
        install_sequential_thinking
        install_github
        install_playwright
        ;;

    all-pm)
        install_filesystem
        install_memory
        install_sequential_thinking
        install_github
        install_context7
        ;;

    all)
        install_filesystem
        install_memory
        install_sequential_thinking
        install_github
        install_serena
        install_claude_context
        install_playwright
        install_context7
        ;;

    --help|-h)
        show_menu
        ;;

    *)
        print_error "Unknown option: $1"
        echo ""
        show_menu
        exit 1
        ;;
esac

echo ""
print_success "Installation complete!"
print_info "Configure MCP servers in Claude Desktop or Claude Code settings"

exit 0
