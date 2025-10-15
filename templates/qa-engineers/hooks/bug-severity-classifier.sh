#!/bin/bash
# Bug Severity Classifier Hook
# Classifies bugs by severity (P0-P4) based on impact analysis

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Bug Severity Classifier${NC}\n"

# Severity definitions
declare -A SEVERITY_COLORS=(
  ["P0"]=$RED
  ["P1"]=$RED
  ["P2"]=$YELLOW
  ["P3"]=$BLUE
  ["P4"]=$GREEN
)

# Classification criteria
classify_severity() {
  local bug_description=$1

  echo -e "${YELLOW}📋 Bug Classification Questionnaire${NC}\n"

  # Impact questions
  echo -e "${BLUE}1. Is production completely down or unavailable?${NC}"
  read -p "   (yes/no): " prod_down

  if [[ "$prod_down" =~ ^[Yy] ]]; then
    echo "P0"
    return
  fi

  echo -e "\n${BLUE}2. Is there data loss or corruption?${NC}"
  read -p "   (yes/no): " data_loss

  if [[ "$data_loss" =~ ^[Yy] ]]; then
    echo "P0"
    return
  fi

  echo -e "\n${BLUE}3. Is this a security vulnerability?${NC}"
  read -p "   (yes/no): " security

  if [[ "$security" =~ ^[Yy] ]]; then
    echo "P0"
    return
  fi

  echo -e "\n${BLUE}4. Does it block revenue or critical business operations?${NC}"
  read -p "   (yes/no): " revenue_blocking

  if [[ "$revenue_blocking" =~ ^[Yy] ]]; then
    echo "P0"
    return
  fi

  echo -e "\n${BLUE}5. What percentage of users are affected?${NC}"
  echo "   1) >50% of users"
  echo "   2) 10-50% of users"
  echo "   3) <10% of users"
  echo "   4) Edge case / rare"
  read -p "   Choice (1-4): " user_impact

  echo -e "\n${BLUE}6. Is there a workaround?${NC}"
  read -p "   (yes/no): " has_workaround

  echo -e "\n${BLUE}7. How critical is the affected feature?${NC}"
  echo "   1) Core functionality (login, payment, checkout)"
  echo "   2) Important feature (search, profile, settings)"
  echo "   3) Secondary feature"
  echo "   4) Nice-to-have feature"
  read -p "   Choice (1-4): " feature_criticality

  # Calculate severity
  local severity="P4"

  case $user_impact in
    1)
      if [[ "$has_workaround" =~ ^[Nn] ]]; then
        severity="P1"
      else
        severity="P2"
      fi
      ;;
    2)
      if [[ "$has_workaround" =~ ^[Nn] ]] && [ "$feature_criticality" = "1" ]; then
        severity="P1"
      elif [[ "$has_workaround" =~ ^[Yy] ]] || [ "$feature_criticality" != "1" ]; then
        severity="P2"
      fi
      ;;
    3)
      if [ "$feature_criticality" = "1" ]; then
        severity="P2"
      else
        severity="P3"
      fi
      ;;
    4)
      severity="P4"
      ;;
  esac

  echo "$severity"
}

# Display severity information
display_severity_info() {
  local severity=$1

  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           SEVERITY CLASSIFICATION${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  local color=${SEVERITY_COLORS[$severity]}

  case $severity in
    P0)
      echo -e "  Severity: ${color}P0 - CRITICAL${NC}\n"
      echo -e "  ${YELLOW}Definition:${NC}"
      echo -e "    • Production completely down"
      echo -e "    • Data loss or corruption"
      echo -e "    • Security vulnerability"
      echo -e "    • Revenue-blocking issue"
      echo ""
      echo -e "  ${YELLOW}Action Required:${NC}"
      echo -e "    • Immediate hotfix (same day)"
      echo -e "    • All-hands response"
      echo -e "    • Executive notification"
      echo -e "    • Post-mortem required"
      echo ""
      echo -e "  ${YELLOW}SLA:${NC}"
      echo -e "    • Response: Immediate"
      echo -e "    • Fix: Within hours"
      echo -e "    • Deployment: Emergency hotfix"
      ;;

    P1)
      echo -e "  Severity: ${color}P1 - HIGH${NC}\n"
      echo -e "  ${YELLOW}Definition:${NC}"
      echo -e "    • Major feature broken"
      echo -e "    • Affects >10% of users"
      echo -e "    • No workaround available"
      echo -e "    • Core functionality impaired"
      echo ""
      echo -e "  ${YELLOW}Action Required:${NC}"
      echo -e "    • Fix within 24 hours"
      echo -e "    • Assign to senior engineer"
      echo -e "    • Stakeholder notification"
      echo -e "    • Include in next deployment"
      echo ""
      echo -e "  ${YELLOW}SLA:${NC}"
      echo -e "    • Response: Within 2 hours"
      echo -e "    • Fix: Within 24 hours"
      echo -e "    • Deployment: Next release"
      ;;

    P2)
      echo -e "  Severity: ${color}P2 - MEDIUM${NC}\n"
      echo -e "  ${YELLOW}Definition:${NC}"
      echo -e "    • Feature partially broken"
      echo -e "    • Workaround exists"
      echo -e "    • Affects <10% of users"
      echo -e "    • Moderate impact"
      echo ""
      echo -e "  ${YELLOW}Action Required:${NC}"
      echo -e "    • Fix in current sprint"
      echo -e "    • Assign to available engineer"
      echo -e "    • Update documentation with workaround"
      echo -e "    • Regular deployment"
      echo ""
      echo -e "  ${YELLOW}SLA:${NC}"
      echo -e "    • Response: Within 1 day"
      echo -e "    • Fix: Within 1 week"
      echo -e "    • Deployment: Next sprint"
      ;;

    P3)
      echo -e "  Severity: ${color}P3 - LOW${NC}\n"
      echo -e "  ${YELLOW}Definition:${NC}"
      echo -e "    • Minor visual issue"
      echo -e "    • Edge case scenario"
      echo -e "    • Minimal user impact"
      echo -e "    • Nice-to-have fix"
      echo ""
      echo -e "  ${YELLOW}Action Required:${NC}"
      echo -e "    • Fix when convenient"
      echo -e "    • Add to backlog"
      echo -e "    • Can be batched with other fixes"
      echo ""
      echo -e "  ${YELLOW}SLA:${NC}"
      echo -e "    • Response: Within 1 week"
      echo -e "    • Fix: Within 1 month"
      echo -e "    • Deployment: When ready"
      ;;

    P4)
      echo -e "  Severity: ${color}P4 - TRIVIAL${NC}\n"
      echo -e "  ${YELLOW}Definition:${NC}"
      echo -e "    • Cosmetic issue"
      echo -e "    • Very rare edge case"
      echo -e "    • No user impact"
      echo -e "    • Improvement/enhancement"
      echo ""
      echo -e "  ${YELLOW}Action Required:${NC}"
      echo -e "    • Backlog priority"
      echo -e "    • Good first issue"
      echo -e "    • Fix during cleanup"
      echo ""
      echo -e "  ${YELLOW}SLA:${NC}"
      echo -e "    • Response: No SLA"
      echo -e "    • Fix: When convenient"
      echo -e "    • Deployment: Any time"
      ;;
  esac

  echo ""
}

# Generate bug report template
generate_bug_report() {
  local severity=$1
  local title=$2

  local bug_file="bug-report-$(date +%Y%m%d-%H%M%S).md"

  echo -e "${YELLOW}📝 Generating bug report template...${NC}"

  cat > "$bug_file" << EOF
# [BUG-XXX] $title

## Severity: $severity

**Impact**: [Describe the impact on users/business]
**Affected Users**: [Percentage or number of affected users]
**Workaround**: [Available/Not available - describe if available]

## Summary
[One-sentence description of the bug and its impact]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
4. [Action that triggers the bug]

**Result**: [What actually happens]
**Expected**: [What should happen]

## Environment
- **Browser**: [e.g., Chrome 120, Safari 17.2]
- **Device**: [e.g., Desktop, iPhone 14 Pro]
- **OS**: [e.g., macOS 14.2, Windows 11]
- **Version**: [Application version]
- **Account Type**: [User type if relevant]

## Root Cause Analysis
[Technical explanation of why this bug occurs]

**Affected Code**: [File path and line numbers]

## Reproduction Rate
- X/10 attempts
- [List any conditions that affect reproduction]

## Evidence

### Console Errors
\`\`\`
[Paste console errors here]
\`\`\`

### Network Logs
[Paste relevant network activity]

### Screenshots
[Attach screenshots]

## Proposed Fix
\`\`\`[language]
// Proposed code changes
\`\`\`

## Regression Test
\`\`\`[language]
// Test to prevent regression
\`\`\`

## Related Issues
- #XXX: [Related issue]

## Labels
\`$severity\`, \`[component]\`, \`[browser]\`, \`[platform]\`

---

**Classification Date**: $(date +%Y-%m-%d)
**Classifier**: Automated Severity Classification
EOF

  echo -e "${GREEN}✓ Bug report template created: $bug_file${NC}"
  echo -e "${YELLOW}💡 Next steps:${NC}"
  echo -e "  1. Fill in the template details"
  echo -e "  2. Attach screenshots and logs"
  echo -e "  3. Create issue in issue tracker"
  echo -e "  4. Assign according to severity SLA"
  echo ""

  echo "$bug_file"
}

# Suggest labels based on severity
suggest_labels() {
  local severity=$1

  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           SUGGESTED LABELS${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  echo -e "  ${YELLOW}Severity Label:${NC} $severity"

  case $severity in
    P0)
      echo -e "  ${YELLOW}Additional Labels:${NC}"
      echo -e "    • critical"
      echo -e "    • production"
      echo -e "    • hotfix"
      echo -e "    • urgent"
      ;;
    P1)
      echo -e "  ${YELLOW}Additional Labels:${NC}"
      echo -e "    • high-priority"
      echo -e "    • bug"
      echo -e "    • needs-fix"
      ;;
    P2)
      echo -e "  ${YELLOW}Additional Labels:${NC}"
      echo -e "    • medium-priority"
      echo -e "    • bug"
      ;;
    P3)
      echo -e "  ${YELLOW}Additional Labels:${NC}"
      echo -e "    • low-priority"
      echo -e "    • bug"
      echo -e "    • good-first-issue"
      ;;
    P4)
      echo -e "  ${YELLOW}Additional Labels:${NC}"
      echo -e "    • trivial"
      echo -e "    • enhancement"
      echo -e "    • good-first-issue"
      echo -e "    • hacktoberfest"
      ;;
  esac

  echo ""
}

# Main execution
main() {
  echo -e "${YELLOW}Bug Title:${NC}"
  read -p "> " bug_title

  if [ -z "$bug_title" ]; then
    echo -e "${RED}✗ Bug title required${NC}"
    exit 1
  fi

  # Classify severity
  severity=$(classify_severity "$bug_title")

  # Display information
  display_severity_info "$severity"
  suggest_labels "$severity"

  # Ask if user wants to generate bug report
  echo -e "${YELLOW}Generate bug report template?${NC}"
  read -p "(yes/no): " generate_report

  if [[ "$generate_report" =~ ^[Yy] ]]; then
    bug_file=$(generate_bug_report "$severity" "$bug_title")

    # Open in editor if available
    if command -v code &> /dev/null; then
      echo -e "${YELLOW}Opening in VS Code...${NC}"
      code "$bug_file"
    elif command -v vim &> /dev/null; then
      echo -e "${YELLOW}Opening in Vim...${NC}"
      vim "$bug_file"
    fi
  fi

  echo -e "${GREEN}✓ Bug classification complete${NC}\n"
}

# Run main
main
