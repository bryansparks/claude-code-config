#!/bin/bash

# PR Review Summary Hook
# Summarizes PR activity and review status across repositories

set -euo pipefail

# Configuration
REPO="${1:-}"
DAYS="${2:-7}"
OUTPUT_FORMAT="${3:-text}" # text, json, markdown

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    echo "Install with: brew install gh"
    exit 1
fi

# Check if logged in
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not logged in to GitHub${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Get repository context
if [ -z "$REPO" ]; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    else
        echo -e "${RED}Error: No repository specified and not in a git repo${NC}"
        echo "Usage: $0 [REPO] [DAYS] [FORMAT]"
        exit 1
    fi
fi

echo -e "${BLUE}Fetching PR review data for $REPO (last $DAYS days)...${NC}\n"

# Get PR data
SINCE_DATE=$(date -v-${DAYS}d +%Y-%m-%d 2>/dev/null || date -d "$DAYS days ago" +%Y-%m-%d)

# Fetch open PRs
OPEN_PRS=$(gh pr list --repo "$REPO" --json number,title,author,createdAt,reviews,reviewRequests,isDraft,mergeable --limit 100)

# Fetch recently closed PRs
CLOSED_PRS=$(gh pr list --repo "$REPO" --state merged --json number,title,author,createdAt,mergedAt,reviews --limit 50 --search "merged:>=$SINCE_DATE")

# Calculate metrics
TOTAL_OPEN=$(echo "$OPEN_PRS" | jq '. | length')
DRAFT_PRS=$(echo "$OPEN_PRS" | jq '[.[] | select(.isDraft == true)] | length')
NEEDS_REVIEW=$(echo "$OPEN_PRS" | jq '[.[] | select(.reviews | length == 0) | select(.isDraft == false)] | length')
APPROVED=$(echo "$OPEN_PRS" | jq '[.[] | select(.reviews | map(select(.state == "APPROVED")) | length > 0)] | length')
CHANGES_REQUESTED=$(echo "$OPEN_PRS" | jq '[.[] | select(.reviews | map(select(.state == "CHANGES_REQUESTED")) | length > 0)] | length')
STALE_PRS=$(echo "$OPEN_PRS" | jq --arg days "$DAYS" '[.[] | select(.createdAt | fromdateiso8601 < (now - (($days | tonumber) * 86400)))] | length')

TOTAL_MERGED=$(echo "$CLOSED_PRS" | jq '. | length')

# Output results
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "repository": "$REPO",
  "period_days": $DAYS,
  "open_prs": {
    "total": $TOTAL_OPEN,
    "draft": $DRAFT_PRS,
    "needs_review": $NEEDS_REVIEW,
    "approved": $APPROVED,
    "changes_requested": $CHANGES_REQUESTED,
    "stale": $STALE_PRS
  },
  "merged_prs": {
    "total": $TOTAL_MERGED
  }
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# PR Review Summary - $REPO
**Period:** Last $DAYS days

## Open PRs
- **Total Open:** $TOTAL_OPEN
- **Draft:** $DRAFT_PRS
- **Needs Review:** $NEEDS_REVIEW
- **Approved:** $APPROVED
- **Changes Requested:** $CHANGES_REQUESTED
- **Stale (>$DAYS days):** $STALE_PRS

## Recently Merged
- **Total Merged:** $TOTAL_MERGED

## PRs Needing Attention
EOF
    echo "$OPEN_PRS" | jq -r '.[] | select(.reviews | length == 0) | select(.isDraft == false) | "- #\(.number): \(.title) (@\(.author.login)) - created \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))"' | head -10

    echo -e "\n## Stale PRs (>$DAYS days old)"
    echo "$OPEN_PRS" | jq -r --arg days "$DAYS" '.[] | select(.createdAt | fromdateiso8601 < (now - (($days | tonumber) * 86400))) | "- #\(.number): \(.title) (@\(.author.login)) - created \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))"' | head -10
else
    # Text format
    cat <<EOF
${GREEN}═══════════════════════════════════════════════${NC}
${GREEN}  PR REVIEW SUMMARY - $REPO${NC}
${GREEN}═══════════════════════════════════════════════${NC}
Period: Last $DAYS days

${BLUE}OPEN PRS${NC}
────────────────────────────────────────────────
Total Open:          $TOTAL_OPEN
Draft:               $DRAFT_PRS
Needs Review:        $NEEDS_REVIEW
Approved:            $APPROVED
Changes Requested:   $CHANGES_REQUESTED
Stale (>$DAYS days):  $STALE_PRS

${BLUE}RECENTLY MERGED${NC}
────────────────────────────────────────────────
Total Merged:        $TOTAL_MERGED

EOF

    if [ "$NEEDS_REVIEW" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  PRs NEEDING REVIEW${NC}"
        echo "────────────────────────────────────────────────"
        echo "$OPEN_PRS" | jq -r '.[] | select(.reviews | length == 0) | select(.isDraft == false) | "#\(.number): \(.title)\n   Author: @\(.author.login)\n   Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n"' | head -20
    fi

    if [ "$STALE_PRS" -gt 0 ]; then
        echo -e "${YELLOW}⏰ STALE PRS (>$DAYS days old)${NC}"
        echo "────────────────────────────────────────────────"
        echo "$OPEN_PRS" | jq -r --arg days "$DAYS" '.[] | select(.createdAt | fromdateiso8601 < (now - (($days | tonumber) * 86400))) | "#\(.number): \(.title)\n   Author: @\(.author.login)\n   Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n"' | head -20
    fi

    if [ "$CHANGES_REQUESTED" -gt 0 ]; then
        echo -e "${RED}🔄 CHANGES REQUESTED${NC}"
        echo "────────────────────────────────────────────────"
        echo "$OPEN_PRS" | jq -r '.[] | select(.reviews | map(select(.state == "CHANGES_REQUESTED")) | length > 0) | "#\(.number): \(.title)\n   Author: @\(.author.login)\n"' | head -20
    fi
fi
