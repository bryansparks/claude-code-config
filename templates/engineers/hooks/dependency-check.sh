#!/bin/bash
# Dependency Check Hook - Alerts on outdated or vulnerable dependencies

FILE_PATH="$1"

# Only run on package files
if [[ ! "$FILE_PATH" =~ (package\.json|requirements\.txt|go\.mod|Gemfile|pom\.xml|build\.gradle)$ ]]; then
    exit 0
fi

echo "📦 Checking dependencies in $(basename $FILE_PATH)..."

case "$FILE_PATH" in
    *package.json)
        # Check for outdated packages
        if command -v npm &> /dev/null; then
            OUTDATED=$(npm outdated --json 2>/dev/null | jq -r 'keys[]' 2>/dev/null | head -5)
            if [ -n "$OUTDATED" ]; then
                echo "⚠️  Outdated packages detected:"
                echo "$OUTDATED" | sed 's/^/  • /'
                echo "  Run 'npm outdated' for details"
            fi

            # Check for vulnerabilities
            VULNS=$(npm audit --json 2>/dev/null | jq -r '.metadata | "\(.vulnerabilities.high // 0) high, \(.vulnerabilities.moderate // 0) moderate"' 2>/dev/null)
            if [ -n "$VULNS" ] && [ "$VULNS" != "0 high, 0 moderate" ]; then
                echo "🔒 Security vulnerabilities: $VULNS"
                echo "  Run 'npm audit fix' to resolve"
            else
                echo "✅ No known vulnerabilities"
            fi
        fi
        ;;
    *requirements.txt)
        if command -v pip &> /dev/null; then
            # Check for outdated packages
            echo "  Checking Python packages..."
            OUTDATED=$(pip list --outdated --format=json 2>/dev/null | jq -r '.[].name' 2>/dev/null | head -5)
            if [ -n "$OUTDATED" ]; then
                echo "⚠️  Outdated packages:"
                echo "$OUTDATED" | sed 's/^/  • /'
            fi

            # Check for known vulnerabilities with safety if installed
            if command -v safety &> /dev/null; then
                safety check --json --file="$FILE_PATH" 2>/dev/null | jq -r '.vulnerabilities[] | "  ⚠️  \(.package): \(.vulnerability)"' 2>/dev/null | head -3
            fi
        fi
        ;;
    *go.mod)
        if command -v go &> /dev/null; then
            echo "  Checking Go modules..."
            go list -u -m -json all 2>/dev/null | jq -r 'select(.Update) | .Path' | head -5 | while read pkg; do
                echo "  ⚠️  Update available: $pkg"
            done

            # Check for vulnerabilities
            if command -v govulncheck &> /dev/null; then
                govulncheck ./... 2>&1 | grep "Vulnerability" | head -3
            fi
        fi
        ;;
esac

echo "✅ Dependency check complete"
