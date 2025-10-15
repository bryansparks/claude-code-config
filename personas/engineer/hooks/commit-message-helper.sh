#!/bin/bash
# Commit Message Helper - Suggests conventional commit messages

FILE_PATH="$1"
OPERATION="$2"

# Cache directory for tracking changes
CACHE_DIR="$HOME/.claude/cache/commits"
mkdir -p "$CACHE_DIR"

# Detect change type based on file patterns and content
detect_change_type() {
    local file="$1"
    local basename=$(basename "$file")

    # Test files
    if [[ "$file" =~ test|spec ]]; then
        echo "test"
        return
    fi

    # Documentation
    if [[ "$file" =~ \.(md|txt|rst)$ ]] || [[ "$file" =~ docs/ ]]; then
        echo "docs"
        return
    fi

    # Configuration
    if [[ "$file" =~ \.(json|yaml|yml|toml|ini|env)$ ]] || [[ "$basename" =~ ^\..*rc$ ]]; then
        echo "chore"
        return
    fi

    # CI/CD
    if [[ "$file" =~ \.github/|\.gitlab-ci|jenkins|circle ]]; then
        echo "ci"
        return
    fi

    # Check git status if available
    if [ -d .git ]; then
        # New file
        if ! git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
            echo "feat"
            return
        fi

        # Check diff for keywords
        local diff=$(git diff "$file" 2>/dev/null)
        if echo "$diff" | grep -qi "fix\|bug\|issue\|error"; then
            echo "fix"
            return
        fi

        if echo "$diff" | grep -qi "refactor\|cleanup\|improve"; then
            echo "refactor"
            return
        fi

        if echo "$diff" | grep -qi "performance\|optimize\|speed"; then
            echo "perf"
            return
        fi
    fi

    # Default to feat for new code
    echo "feat"
}

# Get scope from file path
get_scope() {
    local file="$1"

    # Try to get component/module name
    if [[ "$file" =~ src/([^/]+)/ ]]; then
        echo "${BASH_REMATCH[1]}"
    elif [[ "$file" =~ /([^/]+)/[^/]+$ ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "core"
    fi
}

# Main logic
CHANGE_TYPE=$(detect_change_type "$FILE_PATH")
SCOPE=$(get_scope "$FILE_PATH")
BASENAME=$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')

# Generate commit message suggestion
cat << EOF

💡 Suggested commit message:
   $CHANGE_TYPE($SCOPE): update $BASENAME

   Common types:
   • feat: New feature
   • fix: Bug fix
   • docs: Documentation
   • style: Formatting
   • refactor: Code restructuring
   • perf: Performance
   • test: Tests
   • chore: Maintenance

EOF

# Store suggestion for later use
echo "$CHANGE_TYPE($SCOPE): update $BASENAME" > "$CACHE_DIR/last-suggestion.txt"
