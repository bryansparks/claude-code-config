#!/bin/bash

# Sprint Health Check Hook
# Analyzes current sprint progress and health indicators

set -euo pipefail

# Configuration
PROJECT="${1:-}"
SPRINT_NUMBER="${2:-}"
OUTPUT_FORMAT="${3:-text}" # text, json, markdown

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check dependencies
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

# Get current date info
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_WEEK=$(date +%U)

# Function to calculate sprint health score
calculate_health_score() {
    local completed=$1
    local total=$2
    local days_elapsed=$3
    local sprint_days=$4

    if [ "$total" -eq 0 ]; then
        echo "0"
        return
    fi

    local completion_rate=$(awk "BEGIN {printf \"%.0f\", ($completed / $total) * 100}")
    local time_elapsed_pct=$(awk "BEGIN {printf \"%.0f\", ($days_elapsed / $sprint_days) * 100}")

    # Ideal: completion_rate should be >= time_elapsed_pct
    local health=$(awk "BEGIN {printf \"%.0f\", ($completion_rate / $time_elapsed_pct) * 100}")

    # Cap at 100
    if [ "$health" -gt 100 ]; then
        echo "100"
    else
        echo "$health"
    fi
}

# Function to get sprint status
get_sprint_status() {
    local health=$1

    if [ "$health" -ge 80 ]; then
        echo "ON_TRACK"
    elif [ "$health" -ge 60 ]; then
        echo "AT_RISK"
    else
        echo "OFF_TRACK"
    fi
}

# Mock data for demonstration (replace with actual API calls)
# In production, this would query Jira, Linear, or GitHub Projects
if [ -z "$PROJECT" ]; then
    PROJECT="current-project"
fi

if [ -z "$SPRINT_NUMBER" ]; then
    SPRINT_NUMBER=$(date +%U)
fi

# Example: Fetch from GitHub Projects (if available)
# Or parse from Jira/Linear API
SPRINT_DATA=$(cat <<EOF
{
  "sprint": {
    "number": $SPRINT_NUMBER,
    "start_date": "2025-09-30",
    "end_date": "2025-10-14",
    "total_days": 14,
    "days_elapsed": 5
  },
  "stories": {
    "total": 25,
    "completed": 8,
    "in_progress": 7,
    "not_started": 10,
    "blocked": 2,
    "added_after_start": 3
  },
  "points": {
    "committed": 50,
    "completed": 18,
    "in_progress": 15,
    "not_started": 17,
    "added": 8
  },
  "quality": {
    "bugs_created": 3,
    "bugs_fixed": 5,
    "code_reviews_pending": 4,
    "failed_builds": 2
  }
}
EOF
)

# Extract data
TOTAL_STORIES=$(echo "$SPRINT_DATA" | jq '.stories.total')
COMPLETED_STORIES=$(echo "$SPRINT_DATA" | jq '.stories.completed')
IN_PROGRESS=$(echo "$SPRINT_DATA" | jq '.stories.in_progress')
NOT_STARTED=$(echo "$SPRINT_DATA" | jq '.stories.not_started')
BLOCKED=$(echo "$SPRINT_DATA" | jq '.stories.blocked')
ADDED=$(echo "$SPRINT_DATA" | jq '.stories.added_after_start')

COMMITTED_POINTS=$(echo "$SPRINT_DATA" | jq '.points.committed')
COMPLETED_POINTS=$(echo "$SPRINT_DATA" | jq '.points.completed')
IN_PROGRESS_POINTS=$(echo "$SPRINT_DATA" | jq '.points.in_progress')

BUGS_CREATED=$(echo "$SPRINT_DATA" | jq '.quality.bugs_created')
BUGS_FIXED=$(echo "$SPRINT_DATA" | jq '.quality.bugs_fixed')
PENDING_REVIEWS=$(echo "$SPRINT_DATA" | jq '.quality.code_reviews_pending')

SPRINT_DAYS=$(echo "$SPRINT_DATA" | jq '.sprint.total_days')
DAYS_ELAPSED=$(echo "$SPRINT_DATA" | jq '.sprint.days_elapsed')
DAYS_REMAINING=$((SPRINT_DAYS - DAYS_ELAPSED))

# Calculate metrics
COMPLETION_PCT=$(awk "BEGIN {printf \"%.0f\", ($COMPLETED_POINTS / $COMMITTED_POINTS) * 100}")
HEALTH_SCORE=$(calculate_health_score "$COMPLETED_POINTS" "$COMMITTED_POINTS" "$DAYS_ELAPSED" "$SPRINT_DAYS")
STATUS=$(get_sprint_status "$HEALTH_SCORE")

# Projected completion
VELOCITY=$(awk "BEGIN {printf \"%.1f\", $COMPLETED_POINTS / $DAYS_ELAPSED}")
PROJECTED=$(awk "BEGIN {printf \"%.0f\", $VELOCITY * $SPRINT_DAYS}")

# Output
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "sprint_number": $SPRINT_NUMBER,
  "project": "$PROJECT",
  "health_score": $HEALTH_SCORE,
  "status": "$STATUS",
  "days_remaining": $DAYS_REMAINING,
  "completion_pct": $COMPLETION_PCT,
  "projected_completion": $PROJECTED,
  "stories": {
    "total": $TOTAL_STORIES,
    "completed": $COMPLETED_STORIES,
    "in_progress": $IN_PROGRESS,
    "not_started": $NOT_STARTED,
    "blocked": $BLOCKED,
    "scope_change": $ADDED
  },
  "points": {
    "committed": $COMMITTED_POINTS,
    "completed": $COMPLETED_POINTS,
    "in_progress": $IN_PROGRESS_POINTS,
    "projected": $PROJECTED
  },
  "quality": {
    "bugs_created": $BUGS_CREATED,
    "bugs_fixed": $BUGS_FIXED,
    "pending_reviews": $PENDING_REVIEWS
  }
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Sprint $SPRINT_NUMBER Health Check - $PROJECT

## Overall Status: **$STATUS**
Health Score: $HEALTH_SCORE/100
Days Remaining: $DAYS_REMAINING/$SPRINT_DAYS

## Progress
- **Completion:** $COMPLETION_PCT% ($COMPLETED_POINTS/$COMMITTED_POINTS points)
- **Projected:** $PROJECTED points (target: $COMMITTED_POINTS)

## Stories
- ✅ Completed: $COMPLETED_STORIES
- 🔄 In Progress: $IN_PROGRESS
- 📋 Not Started: $NOT_STARTED
- 🚫 Blocked: $BLOCKED
- ➕ Added (scope change): $ADDED

## Quality
- Bugs Created: $BUGS_CREATED
- Bugs Fixed: $BUGS_FIXED
- Pending Reviews: $PENDING_REVIEWS

## Recommendations
EOF
    if [ "$BLOCKED" -gt 0 ]; then
        echo "- ⚠️  Address $BLOCKED blocked stories immediately"
    fi
    if [ "$STATUS" = "OFF_TRACK" ]; then
        echo "- 🔴 Sprint is off track - consider descoping or requesting help"
    fi
    if [ "$PENDING_REVIEWS" -gt 3 ]; then
        echo "- ⏰ High number of pending reviews - prioritize code review time"
    fi
else
    # Text format
    STATUS_ICON="✅"
    STATUS_COLOR=$GREEN

    if [ "$STATUS" = "AT_RISK" ]; then
        STATUS_ICON="⚠️"
        STATUS_COLOR=$YELLOW
    elif [ "$STATUS" = "OFF_TRACK" ]; then
        STATUS_ICON="🔴"
        STATUS_COLOR=$RED
    fi

    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  SPRINT $SPRINT_NUMBER HEALTH CHECK - $PROJECT${NC}
${BLUE}═══════════════════════════════════════════════${NC}

${STATUS_COLOR}OVERALL STATUS: $STATUS_ICON $STATUS${NC}
Health Score:     $HEALTH_SCORE/100
Days Remaining:   $DAYS_REMAINING/$SPRINT_DAYS

${GREEN}PROGRESS${NC}
────────────────────────────────────────────────
Completion:       $COMPLETION_PCT% ($COMPLETED_POINTS/$COMMITTED_POINTS points)
Projected:        $PROJECTED points (target: $COMMITTED_POINTS)
Current Velocity: $VELOCITY points/day

${BLUE}STORIES${NC}
────────────────────────────────────────────────
✅ Completed:     $COMPLETED_STORIES
🔄 In Progress:   $IN_PROGRESS
📋 Not Started:   $NOT_STARTED
🚫 Blocked:       $BLOCKED
➕ Added:         $ADDED (scope change)

${BLUE}QUALITY METRICS${NC}
────────────────────────────────────────────────
Bugs Created:     $BUGS_CREATED
Bugs Fixed:       $BUGS_FIXED
Pending Reviews:  $PENDING_REVIEWS

EOF

    if [ "$BLOCKED" -gt 0 ] || [ "$STATUS" != "ON_TRACK" ] || [ "$PENDING_REVIEWS" -gt 3 ]; then
        echo -e "${YELLOW}RECOMMENDATIONS${NC}"
        echo "────────────────────────────────────────────────"

        if [ "$BLOCKED" -gt 0 ]; then
            echo "⚠️  Address $BLOCKED blocked stories immediately"
        fi

        if [ "$STATUS" = "OFF_TRACK" ]; then
            echo "🔴 Sprint is off track - consider descoping or requesting help"
        elif [ "$STATUS" = "AT_RISK" ]; then
            echo "⚠️  Sprint at risk - monitor closely and identify risks"
        fi

        if [ "$PENDING_REVIEWS" -gt 3 ]; then
            echo "⏰ High number of pending reviews - prioritize code review time"
        fi

        if [ "$ADDED" -gt 5 ]; then
            echo "📊 Significant scope creep - review sprint commitment process"
        fi
        echo ""
    fi
fi
