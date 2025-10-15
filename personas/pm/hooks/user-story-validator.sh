#!/bin/bash

# User Story Validator Hook
# Validates user story format, completeness, and quality
# Triggered: Before story commit, during backlog refinement

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIN_ACCEPTANCE_CRITERIA=2
MIN_STORY_QUALITY_SCORE=70

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Validation functions
validate_user_story_format() {
    local file=$1
    local score=0
    local max_score=100
    local issues=()

    log_info "Validating user story format: $file"

    # Check for "As a" clause (20 points)
    if grep -q "As a\|As an" "$file"; then
        score=$((score + 20))
        log_success "✓ User role defined"
    else
        issues+=("Missing 'As a [role]' clause")
        log_error "✗ Missing user role"
    fi

    # Check for "I want" clause (20 points)
    if grep -q "I want" "$file"; then
        score=$((score + 20))
        log_success "✓ User goal defined"
    else
        issues+=("Missing 'I want [goal]' clause")
        log_error "✗ Missing user goal"
    fi

    # Check for "So that" clause (20 points)
    if grep -q "So that" "$file"; then
        score=$((score + 20))
        log_success "✓ Business value defined"
    else
        issues+=("Missing 'So that [value]' clause")
        log_warning "⚠ Missing business value (recommended)"
    fi

    # Check for Acceptance Criteria (30 points)
    local ac_count=$(grep -c "Given.*When.*Then\|Acceptance Criteria\|\*\*Given\*\*" "$file" || echo "0")
    if [ "$ac_count" -ge "$MIN_ACCEPTANCE_CRITERIA" ]; then
        score=$((score + 30))
        log_success "✓ Acceptance criteria present ($ac_count criteria)"
    else
        issues+=("Insufficient acceptance criteria (found: $ac_count, required: $MIN_ACCEPTANCE_CRITERIA)")
        log_error "✗ Need at least $MIN_ACCEPTANCE_CRITERIA acceptance criteria"
    fi

    # Check for Context (10 points bonus)
    if grep -q "Context:\|Background:\|\*\*Context\*\*" "$file"; then
        score=$((score + 10))
        log_success "✓ Context provided"
    else
        log_warning "⚠ Consider adding context (optional)"
    fi

    echo "$score|${issues[@]}"
}

validate_acceptance_criteria() {
    local file=$1
    local score=0
    local issues=()

    log_info "Validating acceptance criteria quality"

    # Check for Given/When/Then format
    local gwt_count=$(grep -c "\*\*Given\*\*.*\*\*When\*\*.*\*\*Then\*\*\|Given.*When.*Then" "$file" || echo "0")

    if [ "$gwt_count" -gt 0 ]; then
        score=$((score + 40))
        log_success "✓ Using Given/When/Then format ($gwt_count criteria)"
    else
        issues+=("Acceptance criteria not using Given/When/Then format")
        log_warning "⚠ Consider using Given/When/Then format"
        # Still give partial credit if criteria exist
        local ac_present=$(grep -c "Acceptance Criteria\|Criteria:" "$file" || echo "0")
        if [ "$ac_present" -gt 0 ]; then
            score=$((score + 20))
        fi
    fi

    # Check for edge cases
    if grep -qi "edge case\|error case\|invalid\|exception" "$file"; then
        score=$((score + 30))
        log_success "✓ Edge cases considered"
    else
        issues+=("No edge cases defined")
        log_warning "⚠ Consider adding edge cases"
    fi

    # Check for testability indicators
    if grep -qi "should\|must\|will\|displays\|returns\|shows" "$file"; then
        score=$((score + 30))
        log_success "✓ Testable criteria present"
    else
        issues+=("Criteria may not be testable")
        log_warning "⚠ Make criteria more testable"
    fi

    echo "$score|${issues[@]}"
}

validate_invest_principles() {
    local file=$1
    local score=0
    local issues=()

    log_info "Validating INVEST principles"

    # I - Independent (check for excessive dependencies)
    local dep_count=$(grep -ci "depends on\|blocked by\|requires.*story\|waiting for" "$file" || echo "0")
    if [ "$dep_count" -le 2 ]; then
        score=$((score + 15))
        log_success "✓ Story appears independent"
    else
        issues+=("Too many dependencies ($dep_count) - consider splitting")
        log_warning "⚠ High dependency count: $dep_count"
    fi

    # V - Valuable (has business value)
    if grep -qi "so that\|business value\|user benefit\|impact" "$file"; then
        score=$((score + 20))
        log_success "✓ Value clearly stated"
    else
        issues+=("Business value not clear")
        log_error "✗ Missing clear business value"
    fi

    # E - Estimable (has context and detail)
    if grep -qi "technical notes\|implementation\|context\|background" "$file"; then
        score=$((score + 15))
        log_success "✓ Sufficient detail for estimation"
    else
        log_warning "⚠ Consider adding technical context"
    fi

    # S - Small (rough word count check)
    local word_count=$(wc -w < "$file")
    if [ "$word_count" -le 500 ]; then
        score=$((score + 15))
        log_success "✓ Story is appropriately sized"
    elif [ "$word_count" -le 1000 ]; then
        log_warning "⚠ Story might be large - consider splitting"
    else
        issues+=("Story is very large (${word_count} words) - should split")
        log_error "✗ Story too large: $word_count words"
    fi

    # T - Testable (has acceptance criteria)
    if grep -qi "acceptance criteria\|given.*when.*then" "$file"; then
        score=$((score + 35))
        log_success "✓ Story is testable"
    else
        issues+=("Story lacks testable acceptance criteria")
        log_error "✗ Missing testable criteria"
    fi

    echo "$score|${issues[@]}"
}

check_required_sections() {
    local file=$1
    local missing_sections=()

    log_info "Checking required sections"

    # Required sections
    local required=("As a" "I want" "Acceptance Criteria")

    for section in "${required[@]}"; do
        if ! grep -qi "$section" "$file"; then
            missing_sections+=("$section")
        fi
    done

    # Recommended sections
    local recommended=("Context" "Dependencies" "Estimated Effort")
    local missing_recommended=()

    for section in "${recommended[@]}"; do
        if ! grep -qi "$section" "$file"; then
            missing_recommended+=("$section")
        fi
    done

    if [ ${#missing_sections[@]} -eq 0 ]; then
        log_success "✓ All required sections present"
    else
        log_error "✗ Missing required sections: ${missing_sections[*]}"
    fi

    if [ ${#missing_recommended[@]} -gt 0 ]; then
        log_warning "⚠ Missing recommended sections: ${missing_recommended[*]}"
    fi

    echo "${missing_sections[*]}|${missing_recommended[*]}"
}

generate_validation_report() {
    local file=$1
    local format_score=$2
    local ac_score=$3
    local invest_score=$4
    local total_score=$5

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "User Story Validation Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "File: $(basename "$file")"
    echo ""
    echo "Scores:"
    echo "  Story Format:         $format_score/100"
    echo "  Acceptance Criteria:  $ac_score/100"
    echo "  INVEST Principles:    $invest_score/100"
    echo "  ─────────────────────────────────"
    echo "  Overall Quality:      $total_score/100"
    echo ""

    if [ "$total_score" -ge 90 ]; then
        echo -e "${GREEN}★★★★★ Excellent${NC}"
        echo "✓ Story meets high quality standards"
    elif [ "$total_score" -ge 80 ]; then
        echo -e "${GREEN}★★★★☆ Good${NC}"
        echo "✓ Story is ready for development"
    elif [ "$total_score" -ge 70 ]; then
        echo -e "${YELLOW}★★★☆☆ Acceptable${NC}"
        echo "⚠ Story is usable but could be improved"
    elif [ "$total_score" -ge 60 ]; then
        echo -e "${YELLOW}★★☆☆☆ Needs Work${NC}"
        echo "⚠ Story needs improvement before development"
    else
        echo -e "${RED}★☆☆☆☆ Poor${NC}"
        echo "✗ Story requires significant revision"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main validation
main() {
    local file=$1

    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        exit 1
    fi

    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║      User Story Validator                          ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""

    # Run validations
    local format_result=$(validate_user_story_format "$file")
    local format_score=$(echo "$format_result" | cut -d'|' -f1)

    echo ""

    local ac_result=$(validate_acceptance_criteria "$file")
    local ac_score=$(echo "$ac_result" | cut -d'|' -f1)

    echo ""

    local invest_result=$(validate_invest_principles "$file")
    local invest_score=$(echo "$invest_result" | cut -d'|' -f1)

    echo ""

    local sections_result=$(check_required_sections "$file")

    # Calculate total score (weighted average)
    local total_score=$(( (format_score * 35 + ac_score * 35 + invest_score * 30) / 100 ))

    # Generate report
    generate_validation_report "$file" "$format_score" "$ac_score" "$invest_score" "$total_score"

    # Exit code based on score
    if [ "$total_score" -ge "$MIN_STORY_QUALITY_SCORE" ]; then
        exit 0
    else
        log_error "Story quality score ($total_score) below minimum ($MIN_STORY_QUALITY_SCORE)"
        exit 1
    fi
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <user-story-file.md>"
        echo ""
        echo "Validates user story format, acceptance criteria, and INVEST principles"
        exit 1
    fi

    main "$1"
fi
