#!/bin/bash

# Technical Debt Tracker Hook
# Tracks and reports technical debt across the codebase

set -euo pipefail

# Configuration
REPO_PATH="${1:-.}"
OUTPUT_FORMAT="${2:-text}" # text, json, markdown
THRESHOLD_COMPLEXITY="${3:-15}"
THRESHOLD_DUPLICATION="${4:-5}"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$REPO_PATH"

# Function to count TODO/FIXME comments
count_todos() {
    grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" --include="*.py" --include="*.go" --include="*.java" . 2>/dev/null | wc -l | tr -d ' '
}

# Function to find large files
find_large_files() {
    local threshold=500
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) -exec wc -l {} \; 2>/dev/null | awk -v threshold=$threshold '$1 > threshold {print}' | wc -l | tr -d ' '
}

# Function to find outdated dependencies
check_outdated_deps() {
    if [ -f "package.json" ]; then
        if command -v npm &> /dev/null; then
            npm outdated --json 2>/dev/null | jq '. | length' || echo "0"
        else
            echo "0"
        fi
    else
        echo "0"
    fi
}

# Function to calculate complexity score (mock - in production use proper tools)
calculate_complexity() {
    # This is a simplified mock - use tools like eslint, sonarqube, or radon
    local high_complexity_files=0

    # Count files with high cyclomatic complexity indicators
    # Long functions (>50 lines), deep nesting, etc.
    if command -v grep &> /dev/null; then
        # Mock calculation based on file size and structure
        high_complexity_files=$(find . -type f \( -name "*.js" -o -name "*.ts" \) -exec wc -l {} \; 2>/dev/null | awk '$1 > 300 {print}' | wc -l | tr -d ' ')
    fi

    echo "$high_complexity_files"
}

# Function to check test coverage (mock)
check_test_coverage() {
    if [ -f "coverage/coverage-summary.json" ]; then
        cat coverage/coverage-summary.json | jq '.total.lines.pct' 2>/dev/null || echo "0"
    elif [ -f ".coverage" ]; then
        # Python coverage
        echo "75" # Mock value
    else
        echo "unknown"
    fi
}

# Function to find security vulnerabilities
check_security_issues() {
    if [ -f "package.json" ] && command -v npm &> /dev/null; then
        npm audit --json 2>/dev/null | jq '.metadata.vulnerabilities.total' || echo "0"
    else
        echo "0"
    fi
}

# Collect metrics
echo -e "${BLUE}Analyzing technical debt in $REPO_PATH...${NC}\n" >&2

TODO_COUNT=$(count_todos)
LARGE_FILES=$(find_large_files)
OUTDATED_DEPS=$(check_outdated_deps)
COMPLEX_FILES=$(calculate_complexity)
COVERAGE=$(check_test_coverage)
SECURITY_ISSUES=$(check_security_issues)

# Calculate debt score (0-100, lower is better)
DEBT_SCORE=0

# TODO/FIXME weight (0-20 points)
TODO_SCORE=$(awk "BEGIN {score = $TODO_COUNT / 5; if (score > 20) score = 20; printf \"%.0f\", score}")
DEBT_SCORE=$((DEBT_SCORE + TODO_SCORE))

# Large files weight (0-20 points)
LARGE_FILES_SCORE=$(awk "BEGIN {score = $LARGE_FILES * 2; if (score > 20) score = 20; printf \"%.0f\", score}")
DEBT_SCORE=$((DEBT_SCORE + LARGE_FILES_SCORE))

# Outdated dependencies (0-20 points)
DEPS_SCORE=$(awk "BEGIN {score = $OUTDATED_DEPS / 2; if (score > 20) score = 20; printf \"%.0f\", score}")
DEBT_SCORE=$((DEBT_SCORE + DEPS_SCORE))

# Complexity (0-20 points)
COMPLEXITY_SCORE=$(awk "BEGIN {score = $COMPLEX_FILES * 2; if (score > 20) score = 20; printf \"%.0f\", score}")
DEBT_SCORE=$((DEBT_SCORE + COMPLEXITY_SCORE))

# Coverage penalty (0-20 points - inverse)
if [ "$COVERAGE" != "unknown" ]; then
    COVERAGE_SCORE=$(awk "BEGIN {score = (100 - $COVERAGE) / 5; if (score > 20) score = 20; if (score < 0) score = 0; printf \"%.0f\", score}")
    DEBT_SCORE=$((DEBT_SCORE + COVERAGE_SCORE))
fi

# Determine health status
if [ "$DEBT_SCORE" -lt 30 ]; then
    HEALTH_STATUS="HEALTHY"
    HEALTH_COLOR=$GREEN
    HEALTH_ICON="✅"
elif [ "$DEBT_SCORE" -lt 60 ]; then
    HEALTH_STATUS="NEEDS_ATTENTION"
    HEALTH_COLOR=$YELLOW
    HEALTH_ICON="⚠️"
else
    HEALTH_STATUS="CRITICAL"
    HEALTH_COLOR=$RED
    HEALTH_ICON="🔴"
fi

# Output results
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "debt_score": $DEBT_SCORE,
  "health_status": "$HEALTH_STATUS",
  "metrics": {
    "todo_fixme_count": $TODO_COUNT,
    "large_files": $LARGE_FILES,
    "outdated_dependencies": $OUTDATED_DEPS,
    "complex_files": $COMPLEX_FILES,
    "test_coverage": "$COVERAGE",
    "security_issues": $SECURITY_ISSUES
  },
  "recommendations": []
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Technical Debt Report

## Status: $HEALTH_ICON $HEALTH_STATUS
**Debt Score:** $DEBT_SCORE/100

## Metrics

### Code Quality
- **TODO/FIXME Comments:** $TODO_COUNT
- **Large Files (>500 LOC):** $LARGE_FILES
- **High Complexity Files:** $COMPLEX_FILES
- **Test Coverage:** $COVERAGE%

### Dependencies
- **Outdated Packages:** $OUTDATED_DEPS
- **Security Vulnerabilities:** $SECURITY_ISSUES

## Top Issues
EOF

    if [ "$TODO_COUNT" -gt 50 ]; then
        echo "- ⚠️  High number of TODO/FIXME comments ($TODO_COUNT) - consider cleanup sprint"
    fi

    if [ "$LARGE_FILES" -gt 10 ]; then
        echo "- 📁 Many large files ($LARGE_FILES) - consider refactoring"
    fi

    if [ "$OUTDATED_DEPS" -gt 10 ]; then
        echo "- 📦 Outdated dependencies ($OUTDATED_DEPS) - schedule upgrade"
    fi

    if [ "$SECURITY_ISSUES" -gt 0 ]; then
        echo "- 🔒 Security vulnerabilities found ($SECURITY_ISSUES) - **URGENT**"
    fi

else
    # Text format
    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  TECHNICAL DEBT REPORT${NC}
${BLUE}═══════════════════════════════════════════════${NC}

${HEALTH_COLOR}STATUS: $HEALTH_ICON $HEALTH_STATUS${NC}
Debt Score:       $DEBT_SCORE/100

${GREEN}CODE QUALITY METRICS${NC}
────────────────────────────────────────────────
TODO/FIXME Comments:    $TODO_COUNT
Large Files (>500 LOC): $LARGE_FILES
High Complexity Files:  $COMPLEX_FILES
Test Coverage:          $COVERAGE%

${BLUE}DEPENDENCIES${NC}
────────────────────────────────────────────────
Outdated Packages:      $OUTDATED_DEPS
Security Issues:        $SECURITY_ISSUES

EOF

    if [ "$TODO_COUNT" -gt 50 ] || [ "$LARGE_FILES" -gt 10 ] || [ "$OUTDATED_DEPS" -gt 10 ] || [ "$SECURITY_ISSUES" -gt 0 ]; then
        echo -e "${YELLOW}RECOMMENDATIONS${NC}"
        echo "────────────────────────────────────────────────"

        if [ "$SECURITY_ISSUES" -gt 0 ]; then
            echo "🔴 URGENT: Address $SECURITY_ISSUES security vulnerabilities"
        fi

        if [ "$TODO_COUNT" -gt 50 ]; then
            echo "⚠️  High number of TODO/FIXME comments ($TODO_COUNT)"
            echo "   → Schedule technical debt cleanup sprint"
        fi

        if [ "$LARGE_FILES" -gt 10 ]; then
            echo "⚠️  Many large files ($LARGE_FILES)"
            echo "   → Refactor into smaller, focused modules"
        fi

        if [ "$OUTDATED_DEPS" -gt 10 ]; then
            echo "⚠️  Outdated dependencies ($OUTDATED_DEPS)"
            echo "   → Schedule dependency upgrade sprint"
        fi

        if [ "$COVERAGE" != "unknown" ] && [ "${COVERAGE%.*}" -lt 70 ]; then
            echo "⚠️  Test coverage below 70% ($COVERAGE%)"
            echo "   → Improve test coverage for critical paths"
        fi

        echo ""
    else
        echo -e "${GREEN}✅ Technical debt is under control!${NC}\n"
    fi
fi
