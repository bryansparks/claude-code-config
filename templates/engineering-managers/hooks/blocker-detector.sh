#!/bin/bash

# Blocker Detector Hook
# Detects and reports blockers across projects

set -euo pipefail

# Configuration
REPO="${1:-}"
OUTPUT_FORMAT="${2:-text}"
NOTIFY="${3:-false}"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check dependencies
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI not installed${NC}" >&2
    exit 1
fi

# Get repository
if [ -z "$REPO" ]; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    else
        echo -e "${RED}Error: No repository specified${NC}" >&2
        exit 1
    fi
fi

# Fetch blocker data from issues and PRs
echo -e "${BLUE}Scanning for blockers in $REPO...${NC}\n" >&2

# Find issues with "blocked" label or keyword
BLOCKED_ISSUES=$(gh issue list --repo "$REPO" --label "blocked" --json number,title,labels,createdAt,assignees --limit 100 2>/dev/null || echo "[]")

# Find issues mentioning "blocked" in title or body
KEYWORD_BLOCKERS=$(gh issue list --repo "$REPO" --search "blocked in:title,body" --json number,title,labels,createdAt,assignees --limit 50 2>/dev/null || echo "[]")

# Find PRs that are blocked
BLOCKED_PRS=$(gh pr list --repo "$REPO" --search "blocked in:title" --json number,title,author,createdAt,reviewRequests --limit 50 2>/dev/null || echo "[]")

# Combine and deduplicate
ALL_BLOCKERS=$(jq -s 'add | unique_by(.number)' <(echo "$BLOCKED_ISSUES") <(echo "$KEYWORD_BLOCKERS"))

# Calculate metrics
TOTAL_BLOCKERS=$(echo "$ALL_BLOCKERS" | jq 'length')
BLOCKED_PRS_COUNT=$(echo "$BLOCKED_PRS" | jq 'length')
CRITICAL_BLOCKERS=$(echo "$ALL_BLOCKERS" | jq '[.[] | select(.labels | map(.name) | contains(["critical", "p0", "urgent"]))] | length')

# Calculate blocker age
CURRENT_DATE=$(date +%s)
OLD_BLOCKERS=$(echo "$ALL_BLOCKERS" | jq --arg now "$CURRENT_DATE" '[.[] | select((.createdAt | fromdateiso8601) < (($now | tonumber) - (7 * 86400)))] | length')

# Determine severity
if [ "$CRITICAL_BLOCKERS" -gt 0 ] || [ "$TOTAL_BLOCKERS" -gt 10 ]; then
    SEVERITY="CRITICAL"
    SEVERITY_COLOR=$RED
    SEVERITY_ICON="🔴"
elif [ "$TOTAL_BLOCKERS" -gt 5 ] || [ "$OLD_BLOCKERS" -gt 2 ]; then
    SEVERITY="HIGH"
    SEVERITY_COLOR=$YELLOW
    SEVERITY_ICON="🟡"
elif [ "$TOTAL_BLOCKERS" -gt 0 ]; then
    SEVERITY="MEDIUM"
    SEVERITY_COLOR=$YELLOW
    SEVERITY_ICON="🟡"
else
    SEVERITY="NONE"
    SEVERITY_COLOR=$GREEN
    SEVERITY_ICON="✅"
fi

# Output
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "repository": "$REPO",
  "severity": "$SEVERITY",
  "total_blockers": $TOTAL_BLOCKERS,
  "blocked_prs": $BLOCKED_PRS_COUNT,
  "critical_blockers": $CRITICAL_BLOCKERS,
  "old_blockers": $OLD_BLOCKERS,
  "blockers": $ALL_BLOCKERS,
  "blocked_prs_list": $BLOCKED_PRS
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Blocker Report - $REPO

## Status: $SEVERITY_ICON $SEVERITY

### Summary
- **Total Blockers:** $TOTAL_BLOCKERS
- **Blocked PRs:** $BLOCKED_PRS_COUNT
- **Critical:** $CRITICAL_BLOCKERS
- **Old (>7 days):** $OLD_BLOCKERS

### Active Blockers
EOF

    if [ "$TOTAL_BLOCKERS" -eq 0 ]; then
        echo "No blockers found! 🎉"
    else
        echo "$ALL_BLOCKERS" | jq -r '.[] | "- #\(.number): \(.title)\n  Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n  Assigned: \(.assignees | map(.login) | join(", ") // "Unassigned")\n"' | head -20
    fi

    if [ "$BLOCKED_PRS_COUNT" -gt 0 ]; then
        cat <<EOF

### Blocked Pull Requests
EOF
        echo "$BLOCKED_PRS" | jq -r '.[] | "- #\(.number): \(.title) (@\(.author.login))"'
    fi

else
    # Text format
    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  BLOCKER DETECTION REPORT${NC}
${BLUE}═══════════════════════════════════════════════${NC}
Repository: $REPO

${SEVERITY_COLOR}SEVERITY: $SEVERITY_ICON $SEVERITY${NC}

${RED}BLOCKER SUMMARY${NC}
────────────────────────────────────────────────
Total Blockers:       $TOTAL_BLOCKERS
Blocked PRs:          $BLOCKED_PRS_COUNT
Critical Blockers:    $CRITICAL_BLOCKERS
Old Blockers (>7d):   $OLD_BLOCKERS

EOF

    if [ "$TOTAL_BLOCKERS" -eq 0 ]; then
        echo -e "${GREEN}✅ No blockers found!${NC}\n"
    else
        echo -e "${RED}ACTIVE BLOCKERS${NC}"
        echo "────────────────────────────────────────────────"

        # Show critical first
        if [ "$CRITICAL_BLOCKERS" -gt 0 ]; then
            echo -e "\n${RED}🔴 CRITICAL${NC}"
            echo "$ALL_BLOCKERS" | jq -r '.[] | select(.labels | map(.name) | contains(["critical", "p0", "urgent"])) | "  #\(.number): \(.title)\n  Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n  Assigned: \(.assignees | map(.login) | join(", ") // "Unassigned")\n"'
        fi

        # Show old blockers
        if [ "$OLD_BLOCKERS" -gt 0 ]; then
            echo -e "\n${YELLOW}⏰ OLD BLOCKERS (>7 days)${NC}"
            echo "$ALL_BLOCKERS" | jq -r --arg now "$CURRENT_DATE" '.[] | select((.createdAt | fromdateiso8601) < (($now | tonumber) - (7 * 86400))) | "  #\(.number): \(.title)\n  Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n  Assigned: \(.assignees | map(.login) | join(", ") // "Unassigned")\n"'
        fi

        # Show recent blockers
        RECENT=$(echo "$ALL_BLOCKERS" | jq --arg now "$CURRENT_DATE" '[.[] | select((.createdAt | fromdateiso8601) >= (($now | tonumber) - (7 * 86400)))] | length')
        if [ "$RECENT" -gt 0 ]; then
            echo -e "\n${BLUE}RECENT BLOCKERS (<7 days)${NC}"
            echo "$ALL_BLOCKERS" | jq -r --arg now "$CURRENT_DATE" '.[] | select((.createdAt | fromdateiso8601) >= (($now | tonumber) - (7 * 86400))) | "  #\(.number): \(.title)\n  Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n  Assigned: \(.assignees | map(.login) | join(", ") // "Unassigned")\n"'
        fi
    fi

    if [ "$BLOCKED_PRS_COUNT" -gt 0 ]; then
        echo -e "\n${YELLOW}BLOCKED PULL REQUESTS${NC}"
        echo "────────────────────────────────────────────────"
        echo "$BLOCKED_PRS" | jq -r '.[] | "  #\(.number): \(.title)\n  Author: @\(.author.login)\n"'
    fi

    # Recommendations
    if [ "$TOTAL_BLOCKERS" -gt 0 ]; then
        echo -e "\n${YELLOW}RECOMMENDATIONS${NC}"
        echo "────────────────────────────────────────────────"

        [ "$CRITICAL_BLOCKERS" -gt 0 ] && echo "🔴 Escalate $CRITICAL_BLOCKERS critical blockers immediately"
        [ "$OLD_BLOCKERS" -gt 0 ] && echo "⏰ Review $OLD_BLOCKERS stale blockers (>7 days old)"
        [ "$TOTAL_BLOCKERS" -gt 10 ] && echo "⚠️  High blocker count - review process and capacity"

        echo ""
    fi
fi

# Notification (if enabled)
if [ "$NOTIFY" = "true" ] && [ "$SEVERITY" = "CRITICAL" ]; then
    echo -e "${RED}🚨 Critical blockers detected! Sending notification...${NC}" >&2
    # Add notification logic here (Slack, email, etc.)
fi
