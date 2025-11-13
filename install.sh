#!/usr/bin/env bash
# install.sh - Claude Code Configuration Installer
# One-command installation with persona-specific setup
#
# Usage:
#   cd /path/to/your/project
#   curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- <persona>
#
# Personas: engineer | qa | pm | em | ux
#
# Options:
#   --all          Install all personas
#   --update       Update existing installation
#   --uninstall    Remove installation
#
# Environment Variables:
#   CLAUDE_INSTALL_DIR    Override installation directory (default: $PWD/.claude)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="${CLAUDE_CONFIG_REPO:-https://github.com/bryansparks/claude-code-config}"
INSTALL_DIR="${CLAUDE_INSTALL_DIR:-$PWD/.claude}"
TMP_DIR="/tmp/claude-config-install-$$"
VERSION="2.3.0"

# Helper functions
print_header() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  Claude Code Configuration Installer v${VERSION}        ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()

    for cmd in git curl; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install: brew install ${missing_deps[*]}"
        exit 1
    fi
}

# Backup existing installation
backup_existing() {
    if [ -d "$INSTALL_DIR" ]; then
        local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing installation to: $backup_dir"
        mv "$INSTALL_DIR" "$backup_dir"
        print_success "Backup created"
    fi
}

# Clone repository with sparse checkout
clone_repo() {
    local persona="$1"

    print_info "Cloning repository..."

    # Create temp directory
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"

    # Initialize sparse checkout
    git clone --filter=blob:none --sparse "$REPO_URL" . || {
        print_error "Failed to clone repository"
        exit 1
    }

    # Set sparse checkout paths based on persona
    if [ "$persona" = "all" ]; then
        print_info "Installing all personas..."
        git sparse-checkout set \
            .claude \
            personas \
            docs
    else
        print_info "Installing $persona persona..."
        git sparse-checkout set \
            .claude/config \
            .claude/templates \
            .claude/commands \
            .claude/hooks \
            .claude/shared \
            .claude/scripts \
            ".claude/config/mcp-servers/$persona" \
            "personas/$persona"
    fi

    print_success "Repository cloned"
}

# Install files
install_files() {
    local persona="$1"

    print_info "Installing files to $INSTALL_DIR..."

    # Create installation directory
    mkdir -p "$INSTALL_DIR"

    # Copy base .claude/ structure
    cp -r .claude/* "$INSTALL_DIR/" || {
        print_error "Failed to copy files"
        exit 1
    }

    # Copy persona-specific files if not installing all
    if [ "$persona" != "all" ]; then
        if [ -d "personas/$persona" ]; then
            # Copy persona commands
            if [ -d "personas/$persona/commands" ]; then
                cp -r personas/$persona/commands/* "$INSTALL_DIR/commands/" 2>/dev/null || true
            fi

            # Copy persona hooks
            if [ -d "personas/$persona/hooks" ]; then
                cp -r personas/$persona/hooks/* "$INSTALL_DIR/hooks/" 2>/dev/null || true
                chmod +x "$INSTALL_DIR/hooks"/*.sh 2>/dev/null || true
            fi

            # Copy persona subagents
            if [ -d "personas/$persona/subagents" ]; then
                mkdir -p "$INSTALL_DIR/agents/$persona"
                cp -r personas/$persona/subagents/* "$INSTALL_DIR/agents/$persona/" 2>/dev/null || true
            fi

            # Copy persona skills
            if [ -d "personas/$persona/skills" ]; then
                mkdir -p "$INSTALL_DIR/skills/$persona"
                cp -r personas/$persona/skills/* "$INSTALL_DIR/skills/$persona/" 2>/dev/null || true
            fi
        fi
    else
        # Install all personas
        for p in engineer qa pm em ux; do
            if [ -d "personas/$p" ]; then
                cp -r personas/$p/commands/* "$INSTALL_DIR/commands/" 2>/dev/null || true
                cp -r personas/$p/hooks/* "$INSTALL_DIR/hooks/" 2>/dev/null || true
                mkdir -p "$INSTALL_DIR/agents/$p"
                cp -r personas/$p/subagents/* "$INSTALL_DIR/agents/$p/" 2>/dev/null || true
                # Copy skills if they exist
                if [ -d "personas/$p/skills" ]; then
                    mkdir -p "$INSTALL_DIR/skills/$p"
                    cp -r personas/$p/skills/* "$INSTALL_DIR/skills/$p/" 2>/dev/null || true
                fi
            fi
        done
        chmod +x "$INSTALL_DIR/hooks"/*.sh 2>/dev/null || true
    fi

    print_success "Files installed"
}

# Setup organization standards
setup_organization() {
    print_info "Setting up organization standards..."

    if [ ! -f "$INSTALL_DIR/ORGANIZATION.md" ]; then
        cp "$INSTALL_DIR/templates/ORGANIZATION.md" "$INSTALL_DIR/ORGANIZATION.md"
        print_success "Organization standards created"
    else
        print_warning "ORGANIZATION.md already exists (preserving)"
    fi
}

# Create CLAUDE.md
create_claude_md() {
    print_info "Creating CLAUDE.md..."

    cat > "$INSTALL_DIR/CLAUDE.md" << 'EOF'
# CLAUDE.md - Claude Code Configuration

## 🛡️ Organization Standards (Protected)
@include ORGANIZATION.md

## 📚 SuperClaude Core Configuration
@include shared/superclaude-core.yml#Core_Philosophy
@include shared/superclaude-core.yml#Advanced_Token_Economy
@include shared/superclaude-core.yml#Task_Management

## 🎭 Personas & Workflows
@include shared/superclaude-personas.yml#All_Personas
@include shared/superclaude-personas.yml#Intelligent_Activation_Patterns

## 🔌 MCP Integration
@include shared/superclaude-mcp.yml#Server_Capabilities_Extended
@include shared/superclaude-mcp.yml#Workflows

## 📋 Rules & Standards
@include shared/superclaude-rules.yml#Development_Practices
@include shared/superclaude-rules.yml#Security_Standards
@include shared/superclaude-rules.yml#Efficiency_Management

## 📂 Project Context (Auto-loaded when in project)
# @include projects/${PROJECT_NAME}/PROJECT.md
# @include projects/${PROJECT_NAME}/VISION.md
EOF

    print_success "CLAUDE.md created"
}

# Set active persona
set_persona() {
    local persona="$1"

    if [ "$persona" != "all" ]; then
        print_info "Setting active persona: $persona"
        echo "$persona" > "$INSTALL_DIR/config/persona.conf"
        print_success "Active persona set to: $persona"
    fi
}

# Install MCP servers
install_mcp_servers() {
    local persona="$1"

    print_info "Installing MCP servers for $persona persona..."

    if [ -f "$INSTALL_DIR/scripts/install-mcp-servers.sh" ]; then
        bash "$INSTALL_DIR/scripts/install-mcp-servers.sh" "$persona" || {
            print_warning "MCP server installation encountered issues (non-fatal)"
        }
    else
        print_warning "MCP install script not found (skipping)"
    fi
}

# Create symlink to project CLAUDE.md
setup_project_config() {
    print_info "Setting up project Claude Code configuration..."

    # Get the project directory (parent of .claude)
    local project_dir="$(dirname "$INSTALL_DIR")"

    # Create CLAUDE.md in project root if it doesn't exist
    if [ ! -f "$project_dir/CLAUDE.md" ]; then
        ln -s ".claude/CLAUDE.md" "$project_dir/CLAUDE.md"
        print_success "Project CLAUDE.md symlink created"
    else
        print_info "CLAUDE.md already exists in project root"
    fi
}

# Cleanup
cleanup() {
    print_info "Cleaning up..."
    rm -rf "$TMP_DIR"
    print_success "Cleanup complete"
}

# Print installation summary
print_summary() {
    local persona="$1"
    local project_dir="$(cd "$(dirname "$INSTALL_DIR")" && pwd)"

    echo
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  Installation Complete!                                  ${GREEN}║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo
    print_info "Project directory: $project_dir"
    print_info "Installation directory: $INSTALL_DIR"
    print_info "Active persona: $persona"
    echo
    print_success "Next steps:"
    echo "  1. Open Claude Code in this directory: cd $project_dir"
    echo "  2. Configuration will auto-load from CLAUDE.md"
    echo "  3. Try persona commands (check .claude/commands/)"
    echo
    print_info "Project config: $project_dir/CLAUDE.md"
    print_info "Agents: $INSTALL_DIR/agents/$persona/"
    print_info "Skills: $INSTALL_DIR/skills/$persona/"
    echo
}

# Uninstall
uninstall() {
    local project_dir="$(dirname "$INSTALL_DIR")"
    print_warning "Uninstalling Claude Code configuration..."

    if [ -d "$INSTALL_DIR" ]; then
        read -p "Are you sure you want to uninstall? This will remove $INSTALL_DIR (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_existing
            rm -rf "$INSTALL_DIR"
            # Remove CLAUDE.md symlink if it exists in project root
            if [ -L "$project_dir/CLAUDE.md" ]; then
                rm -f "$project_dir/CLAUDE.md"
            fi
            print_success "Uninstallation complete"
        else
            print_info "Uninstall cancelled"
        fi
    else
        print_warning "No installation found at $INSTALL_DIR"
    fi
}

# Update existing installation
update_installation() {
    local persona="${1:-$(cat "$INSTALL_DIR/config/persona.conf" 2>/dev/null || echo "engineer")}"

    print_info "Updating existing installation..."
    backup_existing

    # Re-run installation
    clone_repo "$persona"
    install_files "$persona"
    setup_organization
    create_claude_md
    set_persona "$persona"
    cleanup

    print_success "Update complete"
}

# Main installation flow
main() {
    local persona="${1:-}"
    local action="${2:-install}"

    print_header

    # Handle options
    case "$persona" in
        --uninstall)
            uninstall
            exit 0
            ;;
        --update)
            check_dependencies
            update_installation "${2:-}"
            print_summary "$(cat "$INSTALL_DIR/config/persona.conf" 2>/dev/null || echo "updated")"
            exit 0
            ;;
        --all)
            persona="all"
            ;;
        engineer|qa|pm|em|ux)
            # Valid persona
            ;;
        "")
            print_error "No persona specified"
            echo
            echo "Usage: $0 <persona>"
            echo
            echo "Personas:"
            echo "  engineer    Software Engineer"
            echo "  qa          QA Engineer"
            echo "  pm          Product Manager"
            echo "  em          Engineering Manager"
            echo "  ux          UX Designer"
            echo "  --all       Install all personas"
            echo
            echo "Options:"
            echo "  --update    Update existing installation"
            echo "  --uninstall Remove installation"
            exit 1
            ;;
        *)
            print_error "Invalid persona: $persona"
            echo "Valid personas: engineer, qa, pm, em, ux, --all"
            exit 1
            ;;
    esac

    # Run installation
    check_dependencies
    backup_existing
    clone_repo "$persona"
    install_files "$persona"
    setup_organization
    create_claude_md
    set_persona "$persona"
    install_mcp_servers "$persona"
    setup_project_config
    cleanup
    print_summary "$persona"
}

# Run main with all arguments
main "$@"
