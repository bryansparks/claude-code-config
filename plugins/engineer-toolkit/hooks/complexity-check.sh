#!/bin/bash
# Complexity Check Hook - Warns about high code complexity

FILE_PATH="$1"

# Skip non-code files
if [[ ! "$FILE_PATH" =~ \.(js|ts|jsx|tsx|py|go|java)$ ]]; then
    exit 0
fi

# Thresholds
MAX_COMPLEXITY=10
MAX_LINES=300
MAX_PARAMS=5

echo "📊 Analyzing complexity of $(basename $FILE_PATH)..."

# Get file extension
EXT="${FILE_PATH##*.}"

# Function to count lines of code (excluding comments and blanks)
count_loc() {
    grep -v "^\s*$" "$1" | grep -v "^\s*//" | grep -v "^\s*#" | wc -l | tr -d ' '
}

# Basic complexity checks
LOC=$(count_loc "$FILE_PATH")

if [ "$LOC" -gt "$MAX_LINES" ]; then
    echo "⚠️  File length: $LOC lines (recommended: <$MAX_LINES)"
    echo "   Consider splitting into smaller modules"
fi

# Language-specific complexity analysis
case "$EXT" in
    js|ts|jsx|tsx)
        # Use complexity-report or eslint if available
        if [ -f "node_modules/.bin/eslint" ]; then
            COMPLEX_FUNCTIONS=$(npx eslint "$FILE_PATH" --rule 'complexity: ["error", '$MAX_COMPLEXITY']' --format json 2>/dev/null | \
                jq -r '.[] | .messages[] | select(.ruleId == "complexity") | "\(.message)"' 2>/dev/null)

            if [ -n "$COMPLEX_FUNCTIONS" ]; then
                echo "⚠️  High complexity functions detected:"
                echo "$COMPLEX_FUNCTIONS" | head -3 | sed 's/^/   /'
            fi
        fi

        # Check for long parameter lists
        LONG_PARAMS=$(grep -o "function.*(" "$FILE_PATH" | grep -o "(.*)" | \
            awk -F',' '{if (NF > '$MAX_PARAMS') print NR": "$0}' | head -3)

        if [ -n "$LONG_PARAMS" ]; then
            echo "⚠️  Long parameter lists (>$MAX_PARAMS params):"
            echo "$LONG_PARAMS" | sed 's/^/   Line /'
            echo "   Consider using options object"
        fi
        ;;

    py)
        # Use radon if available
        if command -v radon &> /dev/null; then
            COMPLEXITY=$(radon cc "$FILE_PATH" -s -n B 2>/dev/null)
            if [ -n "$COMPLEXITY" ]; then
                echo "⚠️  Complex functions (complexity > 10):"
                echo "$COMPLEXITY" | head -5 | sed 's/^/   /'
            fi

            # Check maintainability index
            MI=$(radon mi "$FILE_PATH" -s 2>/dev/null | grep -o "[0-9.]*" | head -1)
            if [ -n "$MI" ]; then
                if (( $(echo "$MI < 20" | bc -l) )); then
                    echo "⚠️  Low maintainability index: $MI (target: >20)"
                elif (( $(echo "$MI < 65" | bc -l) )); then
                    echo "ℹ️  Maintainability index: $MI (acceptable)"
                else
                    echo "✅ Good maintainability index: $MI"
                fi
            fi
        else
            # Basic Python complexity checks
            LONG_FUNCS=$(grep -n "^def " "$FILE_PATH" | while read line; do
                LINENUM=$(echo "$line" | cut -d: -f1)
                NEXT_DEF=$(tail -n +$((LINENUM+1)) "$FILE_PATH" | grep -n "^def \|^class " | head -1 | cut -d: -f1)
                if [ -n "$NEXT_DEF" ]; then
                    FUNC_LINES=$NEXT_DEF
                else
                    FUNC_LINES=$(tail -n +$LINENUM "$FILE_PATH" | wc -l)
                fi
                if [ "$FUNC_LINES" -gt 50 ]; then
                    FUNCNAME=$(echo "$line" | sed 's/.*def \([^(]*\).*/\1/')
                    echo "   Line $LINENUM: $FUNCNAME() - $FUNC_LINES lines"
                fi
            done)

            if [ -n "$LONG_FUNCS" ]; then
                echo "⚠️  Long functions (>50 lines):"
                echo "$LONG_FUNCS" | head -3
            fi
        fi
        ;;

    go)
        # Use gocyclo if available
        if command -v gocyclo &> /dev/null; then
            COMPLEX=$(gocyclo -over $MAX_COMPLEXITY "$FILE_PATH" 2>/dev/null)
            if [ -n "$COMPLEX" ]; then
                echo "⚠️  High complexity functions:"
                echo "$COMPLEX" | head -5 | sed 's/^/   /'
            fi
        fi
        ;;
esac

# Check for deeply nested code
MAX_INDENT=4
DEEP_NESTING=$(awk '{
    indent = match($0, /[^ \t]/);
    if (indent > 0) {
        indent_level = int((indent - 1) / 4);
        if (indent_level > '$MAX_INDENT') {
            print NR": Nesting level", indent_level;
        }
    }
}' "$FILE_PATH" | head -3)

if [ -n "$DEEP_NESTING" ]; then
    echo "⚠️  Deep nesting detected (>$MAX_INDENT levels):"
    echo "$DEEP_NESTING" | sed 's/^/   Line /'
    echo "   Consider extracting to functions"
fi

# Summary
if [ "$LOC" -le "$MAX_LINES" ] && [ -z "$COMPLEX_FUNCTIONS" ] && [ -z "$DEEP_NESTING" ]; then
    echo "✅ Code complexity looks good"
fi
