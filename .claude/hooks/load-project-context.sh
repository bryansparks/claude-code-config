#!/usr/bin/env bash
# load-project-context.sh - Auto-loads project context and vision document
# Part of Vision Document System for Claude Code

# Detect project name
PROJECT_NAME="${CLAUDE_PROJECT:-$(basename "$(pwd)")}"
CLAUDE_DIR="$HOME/.claude"
PROJECT_DIR="$CLAUDE_DIR/projects/$PROJECT_NAME"

# Auto-detect from git if no CLAUDE_PROJECT set
if [ -z "$CLAUDE_PROJECT" ] && command -v git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null 2>&1; then
    GIT_REMOTE=$(git remote -v 2>/dev/null | grep origin | head -1)
    if [ -n "$GIT_REMOTE" ]; then
        PROJECT_NAME=$(echo "$GIT_REMOTE" | sed 's|.*/||' | sed 's|\.git.*||')
        PROJECT_DIR="$CLAUDE_DIR/projects/$PROJECT_NAME"
    fi
fi

# Function to display file info
show_context_loaded() {
    local file_path=$1
    local file_type=$2
    local emoji=$3

    if [ -f "$file_path" ]; then
        echo "$emoji Loaded $file_type: $PROJECT_NAME"
        return 0
    fi
    return 1
}

# Display session header
echo "═══════════════════════════════════════════════════════════"
echo "🎯 Claude Code session started"
echo "═══════════════════════════════════════════════════════════"

# Load PROJECT.md if exists
if show_context_loaded "$PROJECT_DIR/PROJECT.md" "project context" "📂"; then
    CONTEXT_LOADED=true
fi

# Load VISION.md if exists
if show_context_loaded "$PROJECT_DIR/VISION.md" "vision document" "🎯"; then
    VISION_LOADED=true
fi

# Show project info if loaded
if [ "$CONTEXT_LOADED" = true ] || [ "$VISION_LOADED" = true ]; then
    echo "───────────────────────────────────────────────────────────"
    echo "Project: $PROJECT_NAME"

    # Show current persona if set
    if [ -n "$CLAUDE_PERSONA" ]; then
        case "$CLAUDE_PERSONA" in
            engineer) echo "Persona: 👨‍💻 Software Engineer" ;;
            qa) echo "Persona: 🧪 QA Engineer" ;;
            em) echo "Persona: 📊 Engineering Manager" ;;
            pm) echo "Persona: 📋 Product Manager" ;;
            ux) echo "Persona: 🎨 UX Designer" ;;
            *) echo "Persona: $CLAUDE_PERSONA" ;;
        esac
    fi

    # Show vision document commands
    if [ "$VISION_LOADED" = true ]; then
        echo ""
        echo "💡 Vision-driven development active"
        echo "   Use: /implement --phase N"
        echo "   Update: /update-vision"
    else
        echo ""
        echo "💡 No vision document found"
        echo "   Create: /create-vision-doc --project $PROJECT_NAME"
    fi
else
    echo "Working directory: $(pwd)"
    echo ""
    echo "💡 Start vision-driven development:"
    echo "   /create-vision-doc --project <name> --type <greenfield|enhancement|refactor>"
fi

echo "═══════════════════════════════════════════════════════════"
