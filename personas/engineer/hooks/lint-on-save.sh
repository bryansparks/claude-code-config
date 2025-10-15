#!/bin/bash
# Lint on Save Hook - Auto-fix linting issues when files are saved

FILE_PATH="$1"
OPERATION="$2"

# Skip non-code files
if [[ ! "$FILE_PATH" =~ \.(js|ts|jsx|tsx|py|go|java|rb|css|scss|json|yaml|yml)$ ]]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Run appropriate linter with auto-fix
case "$EXT" in
    js|jsx|ts|tsx)
        if [ -f "node_modules/.bin/eslint" ]; then
            echo "🔍 Linting $(basename $FILE_PATH)..."
            npx eslint "$FILE_PATH" --fix --quiet 2>&1 | head -3

            # Also run Prettier if available
            if [ -f "node_modules/.bin/prettier" ]; then
                npx prettier "$FILE_PATH" --write --loglevel silent
                echo "✨ Formatted with Prettier"
            fi
        fi
        ;;
    py)
        # Try Black first (formatter)
        if command -v black &> /dev/null; then
            black "$FILE_PATH" --quiet 2>&1
            echo "✨ Formatted with Black"
        fi

        # Then Ruff or Flake8 (linter)
        if command -v ruff &> /dev/null; then
            ruff check "$FILE_PATH" --fix --quiet 2>&1 | head -3
        elif command -v flake8 &> /dev/null; then
            flake8 "$FILE_PATH" 2>&1 | head -3
        fi
        ;;
    go)
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH"
            echo "✨ Formatted with gofmt"
        fi

        if command -v golangci-lint &> /dev/null; then
            golangci-lint run "$FILE_PATH" --fix 2>&1 | head -3
        fi
        ;;
    json|yaml|yml)
        if [ -f "node_modules/.bin/prettier" ]; then
            npx prettier "$FILE_PATH" --write --loglevel silent
            echo "✨ Formatted JSON/YAML"
        fi
        ;;
    css|scss)
        if [ -f "node_modules/.bin/stylelint" ]; then
            npx stylelint "$FILE_PATH" --fix --quiet 2>&1 | head -3
        fi
        ;;
esac

echo "✅ Linting complete"
