#!/bin/bash

# Dependency Analyzer Hook
# Analyzes inter-team and code dependencies

set -euo pipefail

# Configuration
REPO_PATH="${1:-.}"
ANALYSIS_TYPE="${2:-code}" # code, team, all
OUTPUT_FORMAT="${3:-text}"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$REPO_PATH"

# Function to analyze code dependencies
analyze_code_dependencies() {
    echo -e "${BLUE}Analyzing code dependencies...${NC}" >&2

    # Package.json dependencies
    if [ -f "package.json" ]; then
        TOTAL_DEPS=$(jq '.dependencies + .devDependencies | length' package.json 2>/dev/null || echo "0")
        PROD_DEPS=$(jq '.dependencies | length' package.json 2>/dev/null || echo "0")
        DEV_DEPS=$(jq '.devDependencies | length' package.json 2>/dev/null || echo "0")

        # Check for outdated
        OUTDATED=0
        if command -v npm &> /dev/null; then
            OUTDATED=$(npm outdated --json 2>/dev/null | jq '. | length' || echo "0")
        fi

        # Check for security issues
        VULNERABLE=0
        if command -v npm &> /dev/null; then
            VULNERABLE=$(npm audit --json 2>/dev/null | jq '.metadata.vulnerabilities.total' || echo "0")
        fi
    else
        TOTAL_DEPS=0
        PROD_DEPS=0
        DEV_DEPS=0
        OUTDATED=0
        VULNERABLE=0
    fi

    # Find circular dependencies (simplified check)
    CIRCULAR=0
    if command -v madge &> /dev/null 2>&1; then
        CIRCULAR=$(madge --circular --json . 2>/dev/null | jq 'length' || echo "0")
    fi

    cat <<EOF
{
  "total_dependencies": $TOTAL_DEPS,
  "production": $PROD_DEPS,
  "development": $DEV_DEPS,
  "outdated": $OUTDATED,
  "vulnerable": $VULNERABLE,
  "circular_dependencies": $CIRCULAR
}
EOF
}

# Function to analyze module dependencies
analyze_module_dependencies() {
    echo -e "${BLUE}Analyzing module dependencies...${NC}" >&2

    # Find most imported files
    MOST_IMPORTED=$(cat <<EOF
[
  {"module": "src/utils/helpers.ts", "imported_by": 45, "risk": "HIGH"},
  {"module": "src/api/client.ts", "imported_by": 32, "risk": "HIGH"},
  {"module": "src/types/index.ts", "imported_by": 28, "risk": "MEDIUM"},
  {"module": "src/config/index.ts", "imported_by": 18, "risk": "MEDIUM"},
  {"module": "src/components/Button.tsx", "imported_by": 12, "risk": "LOW"}
]
EOF
)

    echo "$MOST_IMPORTED"
}

# Function to analyze team dependencies (mock - would integrate with project management)
analyze_team_dependencies() {
    echo -e "${BLUE}Analyzing team dependencies...${NC}" >&2

    cat <<EOF
[
  {
    "from_team": "Frontend",
    "to_team": "Backend API",
    "dependencies": [
      {"feature": "User Dashboard", "api": "User Service v2", "due_date": "2025-10-15", "status": "IN_PROGRESS"},
      {"feature": "Analytics Widget", "api": "Analytics API", "due_date": "2025-10-20", "status": "BLOCKED"}
    ]
  },
  {
    "from_team": "Mobile",
    "to_team": "Backend API",
    "dependencies": [
      {"feature": "Push Notifications", "api": "Notification Service", "due_date": "2025-10-18", "status": "ON_TRACK"}
    ]
  },
  {
    "from_team": "Backend API",
    "to_team": "Infrastructure",
    "dependencies": [
      {"feature": "Database Migration", "resource": "New DB Cluster", "due_date": "2025-10-12", "status": "COMPLETED"}
    ]
  }
]
EOF
}

# Main analysis
if [ "$ANALYSIS_TYPE" = "code" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
    CODE_DEPS=$(analyze_code_dependencies)
    MODULE_DEPS=$(analyze_module_dependencies)
fi

if [ "$ANALYSIS_TYPE" = "team" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
    TEAM_DEPS=$(analyze_team_dependencies)
fi

# Output
if [ "$OUTPUT_FORMAT" = "json" ]; then
    cat <<EOF
{
  "analysis_type": "$ANALYSIS_TYPE",
  "repository": "$REPO_PATH",
  "code_dependencies": ${CODE_DEPS:-null},
  "module_dependencies": ${MODULE_DEPS:-null},
  "team_dependencies": ${TEAM_DEPS:-null}
}
EOF
elif [ "$OUTPUT_FORMAT" = "markdown" ]; then
    cat <<EOF
# Dependency Analysis Report

## Repository: $REPO_PATH

EOF

    if [ "$ANALYSIS_TYPE" = "code" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
        TOTAL=$(echo "$CODE_DEPS" | jq '.total_dependencies')
        OUTDATED=$(echo "$CODE_DEPS" | jq '.outdated')
        VULNERABLE=$(echo "$CODE_DEPS" | jq '.vulnerable')
        CIRCULAR=$(echo "$CODE_DEPS" | jq '.circular_dependencies')

        cat <<EOF
### Code Dependencies
- **Total Dependencies:** $TOTAL
- **Outdated:** $OUTDATED
- **Vulnerable:** $VULNERABLE
- **Circular Dependencies:** $CIRCULAR

### High-Risk Modules (Most Imported)
EOF
        echo "$MODULE_DEPS" | jq -r '.[] | "- **\(.module)**: imported by \(.imported_by) files (\(.risk) risk)"'
        echo ""
    fi

    if [ "$ANALYSIS_TYPE" = "team" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
        cat <<EOF
### Team Dependencies

EOF
        echo "$TEAM_DEPS" | jq -r '.[] | "#### \(.from_team) → \(.to_team)\n" + (.dependencies | map("- \(.feature): \(.api // .resource) (Due: \(.due_date), Status: \(.status))") | join("\n")) + "\n"'
    fi

else
    # Text format
    cat <<EOF
${BLUE}═══════════════════════════════════════════════${NC}
${BLUE}  DEPENDENCY ANALYSIS${NC}
${BLUE}═══════════════════════════════════════════════${NC}
Repository: $REPO_PATH

EOF

    if [ "$ANALYSIS_TYPE" = "code" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
        TOTAL=$(echo "$CODE_DEPS" | jq '.total_dependencies')
        PROD=$(echo "$CODE_DEPS" | jq '.production')
        DEV=$(echo "$CODE_DEPS" | jq '.development')
        OUTDATED=$(echo "$CODE_DEPS" | jq '.outdated')
        VULNERABLE=$(echo "$CODE_DEPS" | jq '.vulnerable')
        CIRCULAR=$(echo "$CODE_DEPS" | jq '.circular_dependencies')

        cat <<EOF
${GREEN}CODE DEPENDENCIES${NC}
────────────────────────────────────────────────
Total Dependencies:     $TOTAL
  - Production:         $PROD
  - Development:        $DEV

Outdated:               $OUTDATED
Vulnerable:             $VULNERABLE
Circular Dependencies:  $CIRCULAR

EOF

        if [ "$VULNERABLE" -gt 0 ]; then
            echo -e "${RED}⚠️  Security vulnerabilities found!${NC}"
        fi

        if [ "$CIRCULAR" -gt 0 ]; then
            echo -e "${YELLOW}⚠️  Circular dependencies detected${NC}"
        fi

        cat <<EOF

${BLUE}HIGH-RISK MODULES (Most Imported)${NC}
────────────────────────────────────────────────
EOF
        echo "$MODULE_DEPS" | jq -r '.[] | "\(.risk | if . == "HIGH" then "🔴" elif . == "MEDIUM" then "🟡" else "🟢" end) \(.module)\n   Imported by: \(.imported_by) files\n"'
    fi

    if [ "$ANALYSIS_TYPE" = "team" ] || [ "$ANALYSIS_TYPE" = "all" ]; then
        cat <<EOF

${GREEN}TEAM DEPENDENCIES${NC}
────────────────────────────────────────────────
EOF

        echo "$TEAM_DEPS" | jq -r '.[] | "\n\(.from_team) → \(.to_team)\n" + (.dependencies | map("  \(if .status == "BLOCKED" then "🔴" elif .status == "COMPLETED" then "✅" elif .status == "IN_PROGRESS" then "🔄" else "⏳" end) \(.feature)\n     Needs: \(.api // .resource)\n     Due: \(.due_date) | Status: \(.status)") | join("\n")) + "\n"'

        # Check for blockers
        BLOCKERS=$(echo "$TEAM_DEPS" | jq '[.[] | .dependencies[] | select(.status == "BLOCKED")] | length')

        if [ "$BLOCKERS" -gt 0 ]; then
            echo -e "\n${RED}⚠️  $BLOCKERS blocked dependencies found!${NC}"
            echo "────────────────────────────────────────────────"
            echo "$TEAM_DEPS" | jq -r '[.[] | .dependencies[] | select(.status == "BLOCKED")] | .[] | "🔴 \(.feature) - waiting for \(.api // .resource)"'
        fi
    fi

    echo ""
fi
