#!/bin/bash

# Code Quality Trends Hook
# Tracks code quality metrics over time

set -euo pipefail

# Configuration
REPO_PATH="${1:-.}"
TIMEFRAME="${2:-30}" # days
OUTPUT_FORMAT="${3:-text}"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$REPO_PATH"

# Generate trend data (mock - in production, fetch from historical data)
generate_trend_data() {
    cat <<EOF
[
  {"date": "2025-09-05", "coverage": 72, "complexity": 8.5, "duplication": 3.2, "bugs": 45},
  {"date": "2025-09-12", "coverage": 73, "complexity": 8.8, "duplication": 3.4, "bugs": 42},
  {"date": "2025-09-19", "coverage": 75, "complexity": 8.6, "duplication": 3.1, "bugs": 38},
  {"date": "2025-09-26", "coverage": 76, "complexity": 8.4, "duplication": 2.9, "bugs": 35},
  {"date": "2025-10-03", "coverage": 78, "complexity": 8.2, "duplication": 2.7, "bugs": 32}
]
EOF
}

TREND_DATA=$(generate_trend_data)

# Calculate trends
FIRST_COVERAGE=$(echo "$TREND_DATA" | jq '.[0].coverage')
LAST_COVERAGE=$(echo "$TREND_DATA" | jq '.[-1].coverage')
COVERAGE_CHANGE=$(awk "BEGIN {printf \"%.1f\", $LAST_COVERAGE - $FIRST_COVERAGE}")

FIRST_COMPLEXITY=$(echo "$TREND_DATA" | jq '.[0].complexity')
LAST_COMPLEXITY=$(echo "$TREND_DATA" | jq '.[-1].complexity')
COMPLEXITY_CHANGE=$(awk "BEGIN {printf \"%.1f\", $LAST_COMPLEXITY - $FIRST_COMPLEXITY}")

FIRST_DUPLICATION=$(echo "$TREND_DATA" | jq '.[0].duplication')
LAST_DUPLICATION=$(echo "$TREND_DATA" | jq '.[-1].duplication')
DUPLICATION_CHANGE=$(awk "BEGIN {printf \"%.1f\", $LAST_DUPLICATION - $FIRST_DUPLICATION}")

FIRST_BUGS=$(echo "$TREND_DATA" | jq '.[0].bugs')
LAST_BUGS=$(echo "$TREND_DATA" | jq '.[-1].bugs')
BUGS_CHANGE=$((LAST_BUGS - FIRST_BUGS))

# Determine overall trend
IMPROVEMENTS=0
DEGRADATIONS=0

[ "$(echo "$COVERAGE_CHANGE > 0" | bc)" -eq 1 ] && IMPROVEMENTS=$((IMPROVEMENTS + 1))
[ "$(echo "$COVERAGE_CHANGE < 0" | bc)" -eq 1 ] && DEGRADATIONS=$((DEGRADATIONS + 1))

[ "$(echo "$COMPLEXITY_CHANGE < 0" | bc)" -eq 1 ] && IMPROVEMENTS=$((IMPROVEMENTS + 1))
[ "$(echo "$COMPLEXITY_CHANGE > 0" | bc)" -eq 1 ] && DEGRADATIONS=$((DEGRADATIONS + 1))

[ "$(echo "$DUPLICATION_CHANGE < 0" | bc)" -eq 1 ] && IMPROVEMENTS=$((IMPROVEMENTS + 1))
[ "$(echo "$DUPLICATION_CHANGE > 0" | bc)" -eq 1 ] && DEGRADATIONS=$((DEGRADATIONS + 1))

[ "$BUGS_CHANGE" -lt 0 ] && IMPROVEMENTS=$((IMPROVEMENTS + 1))
[ "$BUGS_CHANGE" -gt 0 ] && DEGRADATIONS=$((DEGRADATIONS + 1))

if [ "$IMPROVEMENTS" -gt "$DEGRADATIONS" ]; then
    OVERALL_TREND="IMPROVING"
    TREND_ICON="📈"
    TREND_COLOR=$GREEN
elif [ "$DEGRADATIONS" -gt "$IMPROVEMENTS" ]; then
    OVERALL_TREND="DECLINING"
    TREND_ICON="📉"
    TREND_COLOR=$RED
else
    OVERALL_TREND="STABLE"
    TREND_ICON="↔️"
    TREND_COLOR=$BLUE
fi

# Output
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "timeframe_days": $TIMEFRAME,
  "overall_trend": "$OVERALL_TREND",
  "metrics": {
    "coverage": {
      "current": $LAST_COVERAGE,
      "change": $COVERAGE_CHANGE,
      "trend": "$([ "$(echo "$COVERAGE_CHANGE > 0" | bc)" -eq 1 ] && echo "UP" || echo "DOWN")"
    },
    "complexity": {
      "current": $LAST_COMPLEXITY,
      "change": $COMPLEXITY_CHANGE,
      "trend": "$([ "$(echo "$COMPLEXITY_CHANGE < 0" | bc)" -eq 1 ] && echo "DOWN" || echo "UP")"
    },
    "duplication": {
      "current": $LAST_DUPLICATION,
      "change": $DUPLICATION_CHANGE,
      "trend": "$([ "$(echo "$DUPLICATION_CHANGE < 0" | bc)" -eq 1 ] && echo "DOWN" || echo "UP")"
    },
    "bugs": {
      "current": $LAST_BUGS,
      "change": $BUGS_CHANGE,
      "trend": "$([ "$BUGS_CHANGE" -lt 0 ] && echo "DOWN" || echo "UP")"
    }
  },
  "trend_data": $TREND_DATA
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Code Quality Trends - Last $TIMEFRAME Days

## Overall Trend: $TREND_ICON $OVERALL_TREND

### Metrics Summary

| Metric | Current | Change | Trend |
|--------|---------|--------|-------|
| Coverage | ${LAST_COVERAGE}% | ${COVERAGE_CHANGE}% | $([ "$(echo "$COVERAGE_CHANGE > 0" | bc)" -eq 1 ] && echo "↑" || echo "↓") |
| Complexity | $LAST_COMPLEXITY | $COMPLEXITY_CHANGE | $([ "$(echo "$COMPLEXITY_CHANGE < 0" | bc)" -eq 1 ] && echo "↓" || echo "↑") |
| Duplication | ${LAST_DUPLICATION}% | ${DUPLICATION_CHANGE}% | $([ "$(echo "$DUPLICATION_CHANGE < 0" | bc)" -eq 1 ] && echo "↓" || echo "↑") |
| Open Bugs | $LAST_BUGS | $BUGS_CHANGE | $([ "$BUGS_CHANGE" -lt 0 ] && echo "↓" || echo "↑") |

### Historical Data
EOF
    echo "$TREND_DATA" | jq -r '.[] | "- **\(.date)**: Coverage \(.coverage)%, Complexity \(.complexity), Duplication \(.duplication)%, Bugs \(.bugs)"'

else
    # Text format
    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  CODE QUALITY TRENDS${NC}
${BLUE}═══════════════════════════════════════════════${NC}
Timeframe: Last $TIMEFRAME days

${TREND_COLOR}OVERALL TREND: $TREND_ICON $OVERALL_TREND${NC}

${GREEN}METRICS SUMMARY${NC}
────────────────────────────────────────────────
Test Coverage:
  Current:  ${LAST_COVERAGE}%
  Change:   ${COVERAGE_CHANGE}%
  Trend:    $([ "$(echo "$COVERAGE_CHANGE > 0" | bc)" -eq 1 ] && echo "↑ Improving" || echo "↓ Declining")

Code Complexity:
  Current:  $LAST_COMPLEXITY
  Change:   $COMPLEXITY_CHANGE
  Trend:    $([ "$(echo "$COMPLEXITY_CHANGE < 0" | bc)" -eq 1 ] && echo "↓ Improving" || echo "↑ Increasing")

Code Duplication:
  Current:  ${LAST_DUPLICATION}%
  Change:   ${DUPLICATION_CHANGE}%
  Trend:    $([ "$(echo "$DUPLICATION_CHANGE < 0" | bc)" -eq 1 ] && echo "↓ Improving" || echo "↑ Increasing")

Open Bugs:
  Current:  $LAST_BUGS
  Change:   $BUGS_CHANGE
  Trend:    $([ "$BUGS_CHANGE" -lt 0 ] && echo "↓ Decreasing" || echo "↑ Increasing")

${BLUE}HISTORICAL DATA${NC}
────────────────────────────────────────────────
Date         Coverage  Complexity  Duplication  Bugs
EOF
    echo "$TREND_DATA" | jq -r '.[] | "\(.date)   \(.coverage)%       \(.complexity)        \(.duplication)%         \(.bugs)"'

    echo ""

    # Recommendations
    if [ "$OVERALL_TREND" = "IMPROVING" ]; then
        echo -e "${GREEN}✅ Code quality is improving! Keep up the good work.${NC}\n"
    elif [ "$OVERALL_TREND" = "DECLINING" ]; then
        echo -e "${YELLOW}RECOMMENDATIONS${NC}"
        echo "────────────────────────────────────────────────"

        [ "$(echo "$COVERAGE_CHANGE < 0" | bc)" -eq 1 ] && echo "⚠️  Coverage declining - prioritize test writing"
        [ "$(echo "$COMPLEXITY_CHANGE > 0" | bc)" -eq 1 ] && echo "⚠️  Complexity increasing - schedule refactoring"
        [ "$(echo "$DUPLICATION_CHANGE > 0" | bc)" -eq 1 ] && echo "⚠️  Duplication increasing - extract shared code"
        [ "$BUGS_CHANGE" -gt 0 ] && echo "⚠️  Bug count rising - improve QA process"

        echo ""
    fi
fi
