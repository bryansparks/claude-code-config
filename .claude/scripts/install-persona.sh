#!/usr/bin/env bash

#############################################
# Claude Code Persona Configuration Installer
# Version: 1.0.0
# Description: Install persona-specific Claude Code configurations
#############################################

set -eo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/templates"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d_%H%M%S)"

# Get persona template directory
get_persona_dir() {
    case "$1" in
        engineer) echo "engineers" ;;
        qa) echo "qa-engineers" ;;
        em) echo "engineering-managers" ;;
        pm) echo "product-managers" ;;
        ux) echo "ux-designers" ;;
        *) echo "" ;;
    esac
}

# Get persona display name
get_persona_name() {
    case "$1" in
        engineer) echo "Software Engineer" ;;
        qa) echo "QA Engineer" ;;
        em) echo "Engineering Manager" ;;
        pm) echo "Product Manager" ;;
        ux) echo "UX Designer" ;;
        *) echo "" ;;
    esac
}

#############################################
# Helper Functions
#############################################

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║   Claude Code Persona Configuration Installer v1.0.0    ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_step() {
    echo -e "${MAGENTA}▶${NC} $1"
}

show_usage() {
    cat << EOF
${CYAN}Usage:${NC}
    $(basename $0) <persona> [options]

${CYAN}Available Personas:${NC}
    engineer    Software Engineer (backend/frontend development)
    qa          QA Engineer (testing, automation, quality)
    em          Engineering Manager (team metrics, planning)
    pm          Product Manager (roadmaps, requirements, stories)
    ux          UX Designer (design systems, accessibility, flows)

${CYAN}Options:${NC}
    --dry-run           Show what would be installed without making changes
    --no-backup         Skip creating backup of existing configuration
    --force             Overwrite existing files without prompting
    --hooks-only        Install only hooks
    --subagents-only    Install only subagents
    --commands-only     Install only commands
    --mcp-only          Install only MCP server configuration
    --help              Show this help message

${CYAN}Examples:${NC}
    # Install complete QA Engineer configuration
    $(basename $0) qa

    # Dry run for Engineering Manager persona
    $(basename $0) em --dry-run

    # Install only hooks for Software Engineer
    $(basename $0) engineer --hooks-only

    # Force install Product Manager configuration
    $(basename $0) pm --force

${CYAN}Post-Installation:${NC}
    After installation, restart Claude Code to load the new configuration.
    Run '$(basename $0) <persona> --dry-run' to preview changes first.

EOF
}

list_files() {
    local persona_dir="$1"
    local component="$2"

    if [ -d "$persona_dir/$component" ]; then
        find "$persona_dir/$component" -type f | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

#############################################
# Validation Functions
#############################################

validate_persona() {
    local persona="$1"
    local persona_dir=$(get_persona_dir "$persona")

    if [ -z "$persona_dir" ]; then
        print_error "Invalid persona: $persona"
        echo ""
        show_usage
        exit 1
    fi
}

check_prerequisites() {
    print_step "Checking prerequisites..."

    local missing=0

    # Check for required commands
    if ! command -v git &> /dev/null; then
        print_warning "git is not installed (recommended for version control)"
    fi

    if ! command -v jq &> /dev/null; then
        print_warning "jq is not installed (recommended for JSON processing)"
    fi

    # Check Claude directory exists
    if [ ! -d "$CLAUDE_DIR" ]; then
        print_info "Creating Claude directory: $CLAUDE_DIR"
        mkdir -p "$CLAUDE_DIR"
    fi

    print_success "Prerequisites check complete"
}

#############################################
# Backup Functions
#############################################

create_backup() {
    if [ "$NO_BACKUP" = true ]; then
        print_info "Skipping backup (--no-backup flag)"
        return 0
    fi

    print_step "Creating backup of existing configuration..."

    mkdir -p "$BACKUP_DIR"

    local backed_up=0

    # Backup existing directories
    for dir in subagents hooks commands mcp-servers; do
        if [ -d "$CLAUDE_DIR/$dir" ]; then
            cp -r "$CLAUDE_DIR/$dir" "$BACKUP_DIR/"
            ((backed_up++))
        fi
    done

    # Backup settings.json
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"
        ((backed_up++))
    fi

    if [ $backed_up -gt 0 ]; then
        print_success "Backup created at: $BACKUP_DIR"
    else
        print_info "No existing configuration to backup"
    fi
}

#############################################
# Installation Functions
#############################################

install_component() {
    local persona_dir="$1"
    local component="$2"
    local display_name="$3"

    local src="$persona_dir/$component"
    local dest="$CLAUDE_DIR/$component"

    if [ ! -d "$src" ]; then
        print_warning "No $display_name found for this persona"
        return 0
    fi

    local file_count=$(list_files "$persona_dir" "$component")

    if [ "$file_count" = "0" ]; then
        print_warning "No files in $display_name"
        return 0
    fi

    print_step "Installing $display_name ($file_count files)..."

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would copy: $src → $dest"
        find "$src" -type f | while read file; do
            echo "  - $(basename $file)"
        done
        return 0
    fi

    # Create destination directory
    mkdir -p "$dest"

    # Copy files
    cp -r "$src"/* "$dest/" 2>/dev/null || true

    # Make hooks executable
    if [ "$component" = "hooks" ]; then
        chmod +x "$dest"/*.sh 2>/dev/null || true
    fi

    print_success "$display_name installed"
}

install_settings() {
    local persona_dir="$1"
    local src="$persona_dir/settings.json"
    local dest="$CLAUDE_DIR/settings.json"

    if [ ! -f "$src" ]; then
        print_warning "No settings.json found for this persona"
        return 0
    fi

    print_step "Installing settings.json..."

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would install: $src → $dest"
        return 0
    fi

    if [ -f "$dest" ] && [ "$FORCE" = false ]; then
        print_warning "settings.json already exists"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping settings.json installation"
            return 0
        fi
    fi

    cp "$src" "$dest"
    print_success "settings.json installed"
}

install_organization_standards() {
    local org_template="$TEMPLATE_DIR/ORGANIZATION-template.md"
    local dest="$CLAUDE_DIR/ORGANIZATION.md"

    print_step "Installing organization standards..."

    if [ ! -f "$org_template" ]; then
        print_warning "ORGANIZATION-template.md not found, skipping"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would install: $org_template → $dest"
        return 0
    fi

    # Only install if doesn't exist (preserve existing org standards)
    if [ -f "$dest" ]; then
        print_info "ORGANIZATION.md already exists (preserving)"
        return 0
    fi

    cp "$org_template" "$dest"
    print_success "Organization standards installed"
}

install_shared_resources() {
    local shared_dir="$TEMPLATE_DIR/shared"
    local dest="$CLAUDE_DIR/shared"

    print_step "Installing shared resources..."

    if [ ! -d "$shared_dir" ]; then
        print_warning "Shared resources directory not found, skipping"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would copy: $shared_dir → $dest"
        return 0
    fi

    mkdir -p "$dest"

    # Copy hooks and commands
    if [ -d "$shared_dir/hooks" ]; then
        mkdir -p "$CLAUDE_DIR/hooks"
        cp -r "$shared_dir/hooks"/* "$CLAUDE_DIR/hooks/" 2>/dev/null || true
        chmod +x "$CLAUDE_DIR/hooks"/*.sh 2>/dev/null || true
    fi

    if [ -d "$shared_dir/commands" ]; then
        mkdir -p "$CLAUDE_DIR/commands"
        cp -r "$shared_dir/commands"/* "$CLAUDE_DIR/commands/" 2>/dev/null || true
    fi

    print_success "Shared resources installed"
}

install_persona() {
    local persona="$1"
    local template_subdir=$(get_persona_dir "$persona")
    local persona_dir="$TEMPLATE_DIR/$template_subdir"
    local persona_name=$(get_persona_name "$persona")

    if [ ! -d "$persona_dir" ]; then
        print_error "Persona template directory not found: $persona_dir"
        exit 1
    fi

    print_header
    echo -e "${CYAN}Installing $persona_name persona...${NC}"
    echo ""

    # Install organization standards first (protected)
    install_organization_standards

    # Install shared resources (hooks, commands)
    install_shared_resources

    # Install components based on flags
    if [ "$HOOKS_ONLY" = false ] && [ "$COMMANDS_ONLY" = false ] && [ "$MCP_ONLY" = false ]; then
        # Install everything
        install_component "$persona_dir" "subagents" "Subagents"
        install_component "$persona_dir" "hooks" "Hooks"
        install_component "$persona_dir" "commands" "Commands"
        install_component "$persona_dir" "mcp-servers" "MCP Servers"
        install_settings "$persona_dir"
    else
        # Install only specified components
        if [ "$SUBAGENTS_ONLY" = true ]; then
            install_component "$persona_dir" "subagents" "Subagents"
        fi
        if [ "$HOOKS_ONLY" = true ]; then
            install_component "$persona_dir" "hooks" "Hooks"
        fi
        if [ "$COMMANDS_ONLY" = true ]; then
            install_component "$persona_dir" "commands" "Commands"
        fi
        if [ "$MCP_ONLY" = true ]; then
            install_component "$persona_dir" "mcp-servers" "MCP Servers"
        fi
    fi

    echo ""

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] No changes were made"
    else
        print_success "Installation complete!"
        echo ""
        print_info "Next steps:"
        print_info "  1. Restart Claude Code to load the configuration"
        print_info "  2. Navigate to a project directory"
        print_info "  3. Run: /init-project <project-name>"
        print_info ""
        print_info "The /init-project command will preserve your organization"
        print_info "standards while setting up project-specific context."
    fi
}

#############################################
# Main Script
#############################################

# Parse arguments
PERSONA=""
DRY_RUN=false
NO_BACKUP=false
FORCE=false
HOOKS_ONLY=false
SUBAGENTS_ONLY=false
COMMANDS_ONLY=false
MCP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        engineer|qa|em|pm|ux)
            PERSONA="$1"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-backup)
            NO_BACKUP=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --hooks-only)
            HOOKS_ONLY=true
            shift
            ;;
        --subagents-only)
            SUBAGENTS_ONLY=true
            shift
            ;;
        --commands-only)
            COMMANDS_ONLY=true
            shift
            ;;
        --mcp-only)
            MCP_ONLY=true
            shift
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
done

# Validate persona argument
if [ -z "$PERSONA" ]; then
    print_error "Persona argument is required"
    echo ""
    show_usage
    exit 1
fi

validate_persona "$PERSONA"
check_prerequisites
create_backup
install_persona "$PERSONA"

exit 0
