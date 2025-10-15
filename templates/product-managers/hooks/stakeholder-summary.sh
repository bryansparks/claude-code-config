#!/bin/bash

# Stakeholder Summary Generator Hook
# Creates executive summaries and stakeholder updates from technical details
# Triggered: Weekly updates, sprint reviews, major milestones

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Generate executive summary
generate_executive_summary() {
    local source_file=$1
    local output_file=$2
    local audience=${3:-"executive"}

    log_info "Generating executive summary for: $audience"

    local feature_name=$(grep -m1 "^#\|^## " "$source_file" | sed 's/^#\+\s*//' || echo "Feature")

    cat > "$output_file" <<EOF
# Executive Summary: $feature_name

**Date**: $(date +%Y-%m-%d)
**Audience**: $(echo "$audience" | tr '[:lower:]' '[:upper:]')
**Status**: 🟢 On Track / 🟡 At Risk / 🔴 Blocked

---

## TL;DR

**What**: [One-sentence description]

**Why**: $(grep -o "So that[^#]*" "$source_file" | head -1 | sed 's/So that //' || echo "[Business value]")

**When**: [Target date]

**Impact**: [High-level impact metric]

---

## Business Value

### Problem We're Solving

[Description of user pain point or business challenge]

### Expected Outcomes

- **Revenue Impact**: [Projected increase/savings]
- **User Impact**: [Number of users affected]
- **Strategic Value**: [Alignment with company goals]

### Success Metrics

| Metric | Current | Target | Timeline |
|--------|---------|--------|----------|
| [Metric 1] | [Value] | [Target] | [Date] |
| [Metric 2] | [Value] | [Target] | [Date] |

---

## Progress Update

### What We've Accomplished

- ✅ [Completed item 1]
- ✅ [Completed item 2]
- ✅ [Completed item 3]

### What We're Working On

- 🔄 [In-progress item 1]
- 🔄 [In-progress item 2]

### What's Next

- 📋 [Upcoming item 1]
- 📋 [Upcoming item 2]

---

## Timeline

\`\`\`
Past          Now                    Future
|-------------|---------------------|-------->
   Phase 1        Phase 2      Phase 3
   (Done)      (In Progress)  (Planned)
\`\`\`

**Key Milestones**:
- ✅ **[Date]**: [Milestone 1] - Complete
- 🔄 **[Date]**: [Milestone 2] - In Progress
- 📋 **[Date]**: [Milestone 3] - Upcoming

---

## Risks & Mitigation

EOF

    # Extract or generate risks
    if grep -qi "risk" "$source_file"; then
        grep -A 10 -i "risk" "$source_file" | grep -E "^\s*[-*]" | head -3 >> "$output_file"
    else
        cat >> "$output_file" <<EOF
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | [High/Med/Low] | [Plan] |
| [Risk 2] | [High/Med/Low] | [Plan] |
EOF
    fi

    cat >> "$output_file" <<EOF

---

## Resource Requirements

- **Team Size**: [Number] people
- **Budget**: [Amount]
- **Timeline**: [Duration]

---

## Next Steps

1. [Action item 1] - **Owner**: [Name] - **Due**: [Date]
2. [Action item 2] - **Owner**: [Name] - **Due**: [Date]
3. [Action item 3] - **Owner**: [Name] - **Due**: [Date]

---

## Questions?

Contact: [Product Manager Name] - [email@example.com]

EOF

    log_success "Executive summary generated: $output_file"
}

# Generate sprint/weekly update
generate_sprint_update() {
    local sprint_number=$1
    local output_file=$2

    log_info "Generating Sprint $sprint_number update"

    cat > "$output_file" <<EOF
# Sprint $sprint_number Update

**Sprint Dates**: [Start Date] - [End Date]
**Team**: [Team Name]
**Product Manager**: [Name]

---

## 📊 Sprint Overview

**Sprint Goal**: [What we aimed to achieve]

**Completion Rate**: [X]% ([Y] of [Z] story points)

**Velocity**: [Points completed] (vs. [average] avg)

---

## ✅ Completed This Sprint

### Features Delivered

1. **[Feature Name]**
   - **Impact**: [User/business impact]
   - **Status**: ✅ Live in production
   - **Story Points**: [X]

2. **[Feature Name]**
   - **Impact**: [User/business impact]
   - **Status**: ✅ Ready for QA
   - **Story Points**: [X]

### Bug Fixes

- Fixed [critical bug] affecting [X] users
- Resolved [performance issue] improving [metric] by [%]

---

## 🔄 In Progress (Rolling to Next Sprint)

1. **[Feature Name]** - [Progress %]
   - **Reason**: [Why not completed]
   - **New ETA**: [Date]

---

## 🚀 Highlights & Wins

- 🎉 [Major achievement]
- 📈 [Metric improvement]
- 🎯 [User feedback/satisfaction]

---

## ⚠️ Challenges & Blockers

### Blockers Resolved

- ✅ [Blocker 1] - Resolved by [action taken]

### Current Blockers

- 🔴 [Active blocker] - **Action**: [Plan] - **Owner**: [Name]

---

## 📈 Metrics & KPIs

| Metric | Last Sprint | This Sprint | Change |
|--------|-------------|-------------|--------|
| [Metric 1] | [Value] | [Value] | 📈 +[%] |
| [Metric 2] | [Value] | [Value] | 📉 -[%] |
| [Metric 3] | [Value] | [Value] | ➡️ Flat |

---

## 🔮 Next Sprint Preview

### Priorities

1. **[Feature/Epic]** - [Why it's important]
2. **[Feature/Epic]** - [Why it's important]
3. **[Technical Debt]** - [Why it's important]

### Expected Deliverables

- [Deliverable 1]
- [Deliverable 2]
- [Deliverable 3]

---

## 🙏 Kudos & Thanks

- **[Team Member]**: [Achievement/contribution]
- **[Team Member]**: [Achievement/contribution]

---

**Questions or feedback?** Contact [PM Name] or join our Slack channel #[channel]

EOF

    log_success "Sprint update generated: $output_file"
}

# Generate stakeholder email
generate_stakeholder_email() {
    local topic=$1
    local output_file=$2
    local urgency=${3:-"normal"}

    log_info "Generating stakeholder email - Urgency: $urgency"

    local subject_prefix=""
    case "$urgency" in
        high|urgent)
            subject_prefix="[URGENT] "
            ;;
        low|fyi)
            subject_prefix="[FYI] "
            ;;
    esac

    cat > "$output_file" <<EOF
**Subject**: ${subject_prefix}Update: $topic

---

Hi [Stakeholder Name],

**Quick Summary**: [One-sentence update]

---

### Key Points

- **Status**: [On track/At risk/Blocked]
- **Timeline**: [Current ETA]
- **Impact**: [Expected outcome]

### Details

[2-3 paragraph explanation with:
- What has changed/happened
- Why it matters
- What happens next]

### What This Means for You

[Specific impact on this stakeholder's area]

### Action Needed

EOF

    case "$urgency" in
        high|urgent)
            cat >> "$output_file" <<EOF
⚠️ **Your immediate input needed by [date]**:
1. [Action item 1]
2. [Action item 2]
EOF
            ;;
        normal)
            cat >> "$output_file" <<EOF
✅ **Please review and confirm by [date]**:
1. [Action item 1]
2. [Action item 2]
EOF
            ;;
        low|fyi)
            cat >> "$output_file" <<EOF
ℹ️ **For your information - no action required**
EOF
            ;;
    esac

    cat >> "$output_file" <<EOF

### Timeline

- **[Date]**: [Milestone 1]
- **[Date]**: [Milestone 2]
- **[Date]**: [Final delivery]

---

Happy to discuss further. Feel free to [schedule time](calendar-link) or reply to this email.

Best regards,
[Your Name]
[Your Title]

---

**Attachments**:
- [Document 1]
- [Document 2]

EOF

    log_success "Stakeholder email generated: $output_file"
}

# Generate roadmap update
generate_roadmap_update() {
    local quarter=$1
    local output_file=$2

    log_info "Generating roadmap update for $quarter"

    cat > "$output_file" <<EOF
# Product Roadmap Update: $quarter

**Last Updated**: $(date +%Y-%m-%d)
**Product Manager**: [Name]

---

## Executive Summary

[High-level overview of the quarter's focus and achievements]

---

## 🎯 This Quarter's Focus

### Strategic Themes

1. **[Theme 1]**: [Description]
2. **[Theme 2]**: [Description]
3. **[Theme 3]**: [Description]

---

## 📊 Progress Overview

| Initiative | Status | Completion | Target Date |
|-----------|--------|------------|-------------|
| [Initiative 1] | 🟢 On Track | 75% | [Date] |
| [Initiative 2] | 🟡 At Risk | 45% | [Date] |
| [Initiative 3] | 🔴 Blocked | 20% | [Date] |

**Overall Health**: [X]% of initiatives on track

---

## ✅ Completed This Quarter

1. **[Feature/Initiative]**
   - **Impact**: [Metric improvement]
   - **User Feedback**: [Summary]

2. **[Feature/Initiative]**
   - **Impact**: [Metric improvement]
   - **User Feedback**: [Summary]

---

## 🔄 In Progress

### [Initiative Name] - [Status]

**Goal**: [What we're trying to achieve]

**Progress**:
- ✅ [Completed milestone]
- 🔄 [In-progress milestone]
- 📋 [Upcoming milestone]

**Next Steps**: [What's happening next]

---

## 🔮 Looking Ahead: Next Quarter

### Planned Initiatives

1. **[Initiative 1]**
   - **Why**: [Strategic rationale]
   - **Impact**: [Expected outcome]
   - **Effort**: [Size]

2. **[Initiative 2]**
   - **Why**: [Strategic rationale]
   - **Impact**: [Expected outcome]
   - **Effort**: [Size]

### Under Consideration

- [Potential initiative 1]
- [Potential initiative 2]

---

## 📈 Impact & Metrics

### Key Achievements

- 📈 [Metric 1]: Improved from [X] to [Y] ([Z]% increase)
- 📈 [Metric 2]: Improved from [X] to [Y] ([Z]% increase)
- 📈 [Metric 3]: Improved from [X] to [Y] ([Z]% increase)

### User Feedback Highlights

> "[Positive user quote]"
> — [User/Source]

---

## 🚧 Challenges & Learnings

### What Slowed Us Down

1. [Challenge 1] - **Learning**: [What we learned]
2. [Challenge 2] - **Learning**: [What we learned]

### What We're Doing About It

- [Improvement action 1]
- [Improvement action 2]

---

## 💡 Strategic Shifts

[Any changes to product strategy or priorities, with rationale]

---

## Questions & Feedback

We welcome your input! Contact [PM Name] or join our [feedback session/meeting].

**Next Roadmap Review**: [Date]

EOF

    log_success "Roadmap update generated: $output_file"
}

# Main function
main() {
    local summary_type=${1:-"executive"}
    shift

    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║      Stakeholder Summary Generator                 ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""

    case "$summary_type" in
        executive|exec)
            if [ $# -lt 1 ]; then
                log_error "Source file required"
                echo "Usage: $0 executive <source-file.md> [output-file.md] [audience]"
                exit 1
            fi
            local source=$1
            local output=${2:-"executive-summary.md"}
            local audience=${3:-"executive"}
            generate_executive_summary "$source" "$output" "$audience"
            ;;
        sprint|weekly)
            if [ $# -lt 1 ]; then
                log_error "Sprint number required"
                echo "Usage: $0 sprint <sprint-number> [output-file.md]"
                exit 1
            fi
            local sprint=$1
            local output=${2:-"sprint-${sprint}-update.md"}
            generate_sprint_update "$sprint" "$output"
            ;;
        email)
            if [ $# -lt 1 ]; then
                log_error "Topic required"
                echo "Usage: $0 email <topic> [output-file.md] [urgency: high|normal|low]"
                exit 1
            fi
            local topic=$1
            local output=${2:-"stakeholder-email.md"}
            local urgency=${3:-"normal"}
            generate_stakeholder_email "$topic" "$output" "$urgency"
            ;;
        roadmap)
            if [ $# -lt 1 ]; then
                log_error "Quarter required"
                echo "Usage: $0 roadmap <quarter> [output-file.md]"
                exit 1
            fi
            local quarter=$1
            local output=${2:-"roadmap-update-${quarter}.md"}
            generate_roadmap_update "$quarter" "$output"
            ;;
        *)
            log_error "Unknown summary type: $summary_type"
            echo ""
            echo "Available types:"
            echo "  executive - Executive summary from feature/story"
            echo "  sprint    - Sprint/weekly update"
            echo "  email     - Stakeholder email"
            echo "  roadmap   - Roadmap update"
            exit 1
            ;;
    esac

    echo ""
    log_success "Summary generation complete!"
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <type> [options]"
        echo ""
        echo "Types:"
        echo "  executive <source-file> [output] [audience] - Executive summary"
        echo "  sprint <sprint-number> [output]             - Sprint update"
        echo "  email <topic> [output] [urgency]            - Stakeholder email"
        echo "  roadmap <quarter> [output]                  - Roadmap update"
        exit 1
    fi

    main "$@"
fi
