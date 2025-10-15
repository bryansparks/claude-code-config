#!/bin/bash

# Team Velocity Calculator Hook
# Calculates team velocity and trends

set -euo pipefail

# Configuration
PROJECT="${1:-}"
NUM_SPRINTS="${2:-6}"
OUTPUT_FORMAT="${3:-text}"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Mock sprint data (replace with actual data from Jira/Linear/GitHub Projects)
# In production, fetch from API
SPRINT_DATA=$(cat <<EOF
[
  {"sprint": 1, "committed": 45, "completed": 42, "carryover": 3},
  {"sprint": 2, "committed": 48, "completed": 48, "carryover": 0},
  {"sprint": 3, "committed": 50, "completed": 45, "carryover": 5},
  {"sprint": 4, "committed": 47, "completed": 47, "carryover": 0},
  {"sprint": 5, "committed": 52, "completed": 50, "carryover": 2},
  {"sprint": 6, "committed": 50, "completed": 48, "carryover": 2}
]
EOF
)

# Calculate metrics
TOTAL_COMPLETED=$(echo "$SPRINT_DATA" | jq '[.[].completed] | add')
TOTAL_COMMITTED=$(echo "$SPRINT_DATA" | jq '[.[].committed] | add')
AVG_VELOCITY=$(awk "BEGIN {printf \"%.1f\", $TOTAL_COMPLETED / $NUM_SPRINTS}")
AVG_COMMITTED=$(awk "BEGIN {printf \"%.1f\", $TOTAL_COMMITTED / $NUM_SPRINTS}")
COMPLETION_RATE=$(awk "BEGIN {printf \"%.0f\", ($TOTAL_COMPLETED / $TOTAL_COMMITTED) * 100}")

# Last 3 sprints average
RECENT_COMPLETED=$(echo "$SPRINT_DATA" | jq '[.[-3:][].completed] | add')
RECENT_AVG=$(awk "BEGIN {printf \"%.1f\", $RECENT_COMPLETED / 3}")

# Calculate trend
FIRST_THREE=$(echo "$SPRINT_DATA" | jq '[.[0:3][].completed] | add / 3')
LAST_THREE=$(echo "$SPRINT_DATA" | jq '[.[-3:][].completed] | add / 3')
TREND=$(awk "BEGIN {
    diff = $LAST_THREE - $FIRST_THREE
    pct_change = (diff / $FIRST_THREE) * 100
    if (pct_change > 10) {
        print \"INCREASING\"
    } else if (pct_change < -10) {
        print \"DECREASING\"
    } else {
        print \"STABLE\"
    }
}")

TREND_PCT=$(awk "BEGIN {printf \"%.1f\", (($LAST_THREE - $FIRST_THREE) / $FIRST_THREE) * 100}")

# Calculate standard deviation (predictability)
MEAN=$AVG_VELOCITY
VARIANCE=$(echo "$SPRINT_DATA" | jq --argjson mean "$MEAN" '[.[].completed] | map(pow(. - $mean; 2)) | add / length')
STDDEV=$(awk "BEGIN {printf \"%.1f\", sqrt($VARIANCE)}")

# Determine predictability
PREDICTABILITY="HIGH"
if [ "$(echo "$STDDEV > 5" | bc)" -eq 1 ]; then
    PREDICTABILITY="MEDIUM"
fi
if [ "$(echo "$STDDEV > 10" | bc)" -eq 1 ]; then
    PREDICTABILITY="LOW"
fi

# Output
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "project": "$PROJECT",
  "sprints_analyzed": $NUM_SPRINTS,
  "velocity": {
    "average": $AVG_VELOCITY,
    "recent_3_sprints": $RECENT_AVG,
    "trend": "$TREND",
    "trend_percentage": $TREND_PCT
  },
  "commitment": {
    "average_committed": $AVG_COMMITTED,
    "completion_rate": $COMPLETION_RATE
  },
  "predictability": {
    "level": "$PREDICTABILITY",
    "standard_deviation": $STDDEV
  },
  "sprint_history": $(echo "$SPRINT_DATA")
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Team Velocity Report - $PROJECT

## Summary
**Sprints Analyzed:** $NUM_SPRINTS
**Average Velocity:** $AVG_VELOCITY points/sprint
**Recent Velocity:** $RECENT_AVG points/sprint (last 3 sprints)
**Trend:** $TREND ($TREND_PCT%)

## Metrics
- **Commitment Rate:** $COMPLETION_RATE%
- **Average Committed:** $AVG_COMMITTED points/sprint
- **Predictability:** $PREDICTABILITY (σ=$STDDEV)

## Sprint History
| Sprint | Committed | Completed | Carryover | Rate |
|--------|-----------|-----------|-----------|------|
EOF
    echo "$SPRINT_DATA" | jq -r '.[] | "| \(.sprint) | \(.committed) | \(.completed) | \(.carryover) | \((.completed / .committed * 100) | floor)% |"'

    cat <<EOF

## Trend Analysis
EOF

    if [ "$TREND" = "INCREASING" ]; then
        echo "✅ Velocity is **increasing** by $TREND_PCT% - team efficiency improving"
    elif [ "$TREND" = "DECREASING" ]; then
        echo "⚠️  Velocity is **decreasing** by $TREND_PCT% - investigate bottlenecks"
    else
        echo "↔️  Velocity is **stable** - consistent delivery"
    fi

else
    # Text format
    TREND_ICON="↔️"
    TREND_COLOR=$BLUE

    if [ "$TREND" = "INCREASING" ]; then
        TREND_ICON="📈"
        TREND_COLOR=$GREEN
    elif [ "$TREND" = "DECREASING" ]; then
        TREND_ICON="📉"
        TREND_COLOR=$RED
    fi

    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  TEAM VELOCITY REPORT - $PROJECT${NC}
${BLUE}═══════════════════════════════════════════════${NC}

${GREEN}VELOCITY METRICS${NC}
────────────────────────────────────────────────
Average Velocity:      $AVG_VELOCITY points/sprint
Recent (3 sprints):    $RECENT_AVG points/sprint
${TREND_COLOR}Trend:                 $TREND_ICON $TREND ($TREND_PCT%)${NC}

${BLUE}COMMITMENT${NC}
────────────────────────────────────────────────
Average Committed:     $AVG_COMMITTED points/sprint
Completion Rate:       $COMPLETION_RATE%

${BLUE}PREDICTABILITY${NC}
────────────────────────────────────────────────
Level:                 $PREDICTABILITY
Standard Deviation:    $STDDEV points

${BLUE}SPRINT HISTORY (Last $NUM_SPRINTS)${NC}
────────────────────────────────────────────────
Sprint  Committed  Completed  Carryover  Rate
EOF

    echo "$SPRINT_DATA" | jq -r '.[] | "  \(.sprint)       \(.committed)        \(.completed)         \(.carryover)        \((.completed / .committed * 100) | floor)%"'

    echo ""
    echo -e "${BLUE}VELOCITY CHART${NC}"
    echo "────────────────────────────────────────────────"

    # Simple text-based chart
    echo "$SPRINT_DATA" | jq -r '.[] | "Sprint \(.sprint): \("█" * (.completed / 5 | floor)) \(.completed)"'

    echo ""

    if [ "$TREND" = "INCREASING" ]; then
        echo -e "${GREEN}✅ Velocity trending upward - team efficiency improving${NC}"
    elif [ "$TREND" = "DECREASING" ]; then
        echo -e "${YELLOW}⚠️  Velocity declining - investigate bottlenecks:${NC}"
        echo "   - Team capacity changes?"
        echo "   - Increased complexity?"
        echo "   - Process friction?"
    else
        echo -e "${BLUE}↔️  Velocity stable - consistent delivery${NC}"
    fi

    if [ "$PREDICTABILITY" = "LOW" ]; then
        echo -e "\n${YELLOW}⚠️  Low predictability (σ=$STDDEV)${NC}"
        echo "   Consider breaking down stories more consistently"
    fi

    echo ""
fi
