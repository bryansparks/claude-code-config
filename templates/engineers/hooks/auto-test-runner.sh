#!/bin/bash
# Auto Test Runner Hook - Runs relevant tests when code changes

FILE_PATH="$1"
OPERATION="$2"  # 'write' or 'edit'

# Skip if not a code file
if [[ ! "$FILE_PATH" =~ \.(js|ts|jsx|tsx|py|go|java|rb|php|cs)$ ]]; then
    exit 0
fi

# Determine test framework
detect_framework() {
    if [ -f "package.json" ]; then
        if grep -q "\"jest\"" package.json; then
            echo "jest"
        elif grep -q "\"vitest\"" package.json; then
            echo "vitest"
        elif grep -q "\"mocha\"" package.json; then
            echo "mocha"
        fi
    elif [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
        echo "pytest"
    elif [ -f "go.mod" ]; then
        echo "go"
    fi
}

# Find related test file
find_test_file() {
    local file="$1"
    local base=$(basename "$file" | sed 's/\.[^.]*$//')
    local dir=$(dirname "$file")

    # Common test file patterns
    local patterns=(
        "${dir}/${base}.test.*"
        "${dir}/${base}.spec.*"
        "${dir}/__tests__/${base}.*"
        "$(dirname $dir)/tests/test_${base}.*"
        "${dir}/${base}_test.*"
    )

    for pattern in "${patterns[@]}"; do
        local matches=$(find . -path "$pattern" 2>/dev/null | head -1)
        if [ -n "$matches" ]; then
            echo "$matches"
            return 0
        fi
    done
}

# Run tests
FRAMEWORK=$(detect_framework)
TEST_FILE=$(find_test_file "$FILE_PATH")

if [ -n "$FRAMEWORK" ] && [ -n "$TEST_FILE" ]; then
    echo "🧪 Running tests for $(basename $FILE_PATH)..."

    case "$FRAMEWORK" in
        jest)
            npx jest "$TEST_FILE" --passWithNoTests 2>&1 | tail -5
            ;;
        vitest)
            npx vitest run "$TEST_FILE" 2>&1 | tail -5
            ;;
        pytest)
            python -m pytest "$TEST_FILE" -v 2>&1 | tail -5
            ;;
        go)
            go test -run "$(basename ${FILE_PATH%.*})" ./... 2>&1 | tail -5
            ;;
    esac

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "✅ Tests passed"
    else
        echo "⚠️  Some tests failed - review before committing"
    fi
else
    echo "ℹ️  No tests found for $(basename $FILE_PATH)"
fi
