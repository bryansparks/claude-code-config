#!/bin/bash

# Acceptance Criteria Checker Hook
# Validates acceptance criteria quality, completeness, and testability
# Triggered: During story validation, before development starts

set -euo pipefail

# Configuration
MIN_CRITERIA_COUNT=2
MIN_QUALITY_SCORE=70

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

# Extract acceptance criteria section
extract_acceptance_criteria() {
    local file=$1
    local temp_file=$(mktemp)

    # Extract content between "Acceptance Criteria" and next major section
    awk '/[Aa]cceptance [Cc]riteria/,/^(##|###|\*\*[A-Z]|^[A-Z][^:]*:$)/{print}' "$file" > "$temp_file"

    echo "$temp_file"
}

# Count acceptance criteria
count_criteria() {
    local file=$1
    local count=0

    # Count Given/When/Then blocks
    count=$(grep -c "^\s*\*\*Given\*\*\|^\s*Given\|^[0-9]\+\.\s\+\*\*Given\*\*" "$file" 2>/dev/null || echo "0")

    # If no GWT format, count numbered/bulleted items under AC section
    if [ "$count" -eq 0 ]; then
        count=$(grep -c "^\s*[-*0-9]\+\." "$file" 2>/dev/null || echo "0")
    fi

    echo "$count"
}

# Validate Given/When/Then format
validate_gwt_format() {
    local criteria_file=$1
    local score=0
    local issues=()

    log_info "Validating Given/When/Then format"

    # Check for complete GWT blocks
    local gwt_blocks=$(grep -c "Given.*When.*Then\|\*\*Given\*\*.*\*\*When\*\*.*\*\*Then\*\*" "$criteria_file" || echo "0")

    if [ "$gwt_blocks" -gt 0 ]; then
        score=$((score + 40))
        log_success "✓ Using Given/When/Then format ($gwt_blocks blocks)"

        # Check for incomplete blocks
        local given_count=$(grep -c "Given\|\*\*Given\*\*" "$criteria_file" || echo "0")
        local when_count=$(grep -c "When\|\*\*When\*\*" "$criteria_file" || echo "0")
        local then_count=$(grep -c "Then\|\*\*Then\*\*" "$criteria_file" || echo "0")

        if [ "$given_count" -eq "$when_count" ] && [ "$when_count" -eq "$then_count" ]; then
            score=$((score + 20))
            log_success "✓ All GWT blocks complete"
        else
            issues+=("Incomplete GWT blocks found (Given:$given_count, When:$when_count, Then:$then_count)")
            log_warning "⚠ Some GWT blocks incomplete"
        fi
    else
        issues+=("Not using Given/When/Then format")
        log_warning "⚠ Consider using Given/When/Then format for clarity"
        score=$((score + 15)) # Partial credit
    fi

    echo "$score|${issues[*]}"
}

# Check testability
validate_testability() {
    local criteria_file=$1
    local score=0
    local issues=()

    log_info "Validating testability"

    # Look for testable verbs and outcomes
    local testable_verbs=("displays?" "shows?" "returns?" "contains?" "updates?" "creates?" "deletes?" "sends?" "receives?" "validates?" "prevents?" "allows?" "redirects?" "appears?")

    local testable_count=0
    for verb in "${testable_verbs[@]}"; do
        local matches=$(grep -ci "$verb" "$criteria_file" || echo "0")
        testable_count=$((testable_count + matches))
    done

    if [ "$testable_count" -ge 3 ]; then
        score=$((score + 30))
        log_success "✓ Criteria include testable verbs ($testable_count found)"
    elif [ "$testable_count" -ge 1 ]; then
        score=$((score + 15))
        log_warning "⚠ Limited testable verbs ($testable_count found)"
        issues+=("Add more testable verbs (displays, shows, returns, etc.)")
    else
        issues+=("No testable verbs found")
        log_error "✗ Missing testable verbs"
    fi

    # Check for vague terms
    local vague_terms=("should work" "properly" "correctly" "appropriately" "as expected" "good" "nice")
    local vague_count=0

    for term in "${vague_terms[@]}"; do
        if grep -qi "$term" "$criteria_file"; then
            vague_count=$((vague_count + 1))
        fi
    done

    if [ "$vague_count" -eq 0 ]; then
        score=$((score + 20))
        log_success "✓ No vague terms found"
    else
        issues+=("Contains vague terms - be more specific")
        log_warning "⚠ Found vague terms ($vague_count) - be specific"
        score=$((score + 5))
    fi

    echo "$score|${issues[*]}"
}

# Check completeness
validate_completeness() {
    local criteria_file=$1
    local score=0
    local issues=()

    log_info "Validating completeness"

    # Check for happy path
    if grep -qi "success\|complete\|valid\|correct" "$criteria_file"; then
        score=$((score + 20))
        log_success "✓ Happy path covered"
    else
        issues+=("Missing happy path scenario")
        log_warning "⚠ Add happy path scenario"
    fi

    # Check for error handling
    if grep -qi "error\|invalid\|fail\|incorrect\|missing\|empty" "$criteria_file"; then
        score=$((score + 20))
        log_success "✓ Error scenarios covered"
    else
        issues+=("Missing error scenarios")
        log_warning "⚠ Add error scenarios"
    fi

    # Check for edge cases
    if grep -qi "edge case\|boundary\|limit\|maximum\|minimum\|empty\|null" "$criteria_file"; then
        score=$((score + 20))
        log_success "✓ Edge cases considered"
    else
        issues+=("Missing edge cases")
        log_warning "⚠ Consider edge cases"
    fi

    # Check for user feedback/UI elements
    if grep -qi "message\|notification\|alert\|displays?\|shows?\|button\|page\|screen" "$criteria_file"; then
        score=$((score + 20))
        log_success "✓ User feedback specified"
    else
        issues+=("Missing user feedback details")
        log_warning "⚠ Specify user feedback (messages, UI changes)"
    fi

    # Check for state changes
    if grep -qi "updates?\|changes?\|creates?\|deletes?\|saves?\|stores?\|removes?" "$criteria_file"; then
        score=$((score + 20))
        log_success "✓ State changes documented"
    else
        log_warning "⚠ Consider documenting state changes"
    fi

    echo "$score|${issues[*]}"
}

# Check clarity and specificity
validate_clarity() {
    local criteria_file=$1
    local score=0
    local issues=()

    log_info "Validating clarity"

    # Check for specific values/numbers
    if grep -qE "[0-9]+" "$criteria_file"; then
        score=$((score + 25))
        log_success "✓ Includes specific values/numbers"
    else
        log_warning "⚠ Consider adding specific values where applicable"
    fi

    # Check for UI element specificity
    if grep -qi "button\|input\|field\|dropdown\|checkbox\|radio\|link\|menu\|modal\|dialog" "$criteria_file"; then
        score=$((score + 25))
        log_success "✓ UI elements specified"
    else
        log_warning "⚠ Specify UI elements when applicable"
    fi

    # Check for data specificity
    if grep -qi "email\|name\|address\|phone\|date\|time\|password\|username" "$criteria_file"; then
        score=$((score + 25))
        log_success "✓ Data fields specified"
    else
        log_warning "⚠ Specify data fields when applicable"
    fi

    # Check for action specificity
    if grep -qi "click\|enter\|select\|submit\|type\|choose\|upload\|download" "$criteria_file"; then
        score=$((score + 25))
        log_success "✓ User actions specified"
    else
        log_warning "⚠ Specify user actions clearly"
    fi

    echo "$score|${issues[*]}"
}

# Generate quality report
generate_quality_report() {
    local count=$1
    local format_score=$2
    local testability_score=$3
    local completeness_score=$4
    local clarity_score=$5
    local total_score=$6

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Acceptance Criteria Quality Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Criteria Count:       $count (minimum: $MIN_CRITERIA_COUNT)"
    echo ""
    echo "Quality Scores:"
    echo "  Format (GWT):       $format_score/100"
    echo "  Testability:        $testability_score/100"
    echo "  Completeness:       $completeness_score/100"
    echo "  Clarity:            $clarity_score/100"
    echo "  ─────────────────────────────────"
    echo "  Overall Quality:    $total_score/100"
    echo ""

    if [ "$total_score" -ge 90 ]; then
        echo -e "${GREEN}★★★★★ Excellent${NC}"
        echo "✓ Criteria are comprehensive and well-defined"
    elif [ "$total_score" -ge 80 ]; then
        echo -e "${GREEN}★★★★☆ Good${NC}"
        echo "✓ Criteria are solid and ready for testing"
    elif [ "$total_score" -ge 70 ]; then
        echo -e "${YELLOW}★★★☆☆ Acceptable${NC}"
        echo "⚠ Criteria are usable but could be improved"
    elif [ "$total_score" -ge 60 ]; then
        echo -e "${YELLOW}★★☆☆☆ Needs Work${NC}"
        echo "⚠ Criteria need significant improvement"
    else
        echo -e "${RED}★☆☆☆☆ Poor${NC}"
        echo "✗ Criteria require major revision"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main function
main() {
    local file=$1

    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        exit 1
    fi

    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║      Acceptance Criteria Checker                   ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""

    # Extract acceptance criteria section
    local criteria_file=$(extract_acceptance_criteria "$file")

    # Count criteria
    local count=$(count_criteria "$criteria_file")
    log_info "Found $count acceptance criteria"

    if [ "$count" -lt "$MIN_CRITERIA_COUNT" ]; then
        log_error "Insufficient criteria count: $count (minimum: $MIN_CRITERIA_COUNT)"
    fi

    echo ""

    # Run validations
    local format_result=$(validate_gwt_format "$criteria_file")
    local format_score=$(echo "$format_result" | cut -d'|' -f1)

    echo ""

    local testability_result=$(validate_testability "$criteria_file")
    local testability_score=$(echo "$testability_result" | cut -d'|' -f1)

    echo ""

    local completeness_result=$(validate_completeness "$criteria_file")
    local completeness_score=$(echo "$completeness_result" | cut -d'|' -f1)

    echo ""

    local clarity_result=$(validate_clarity "$criteria_file")
    local clarity_score=$(echo "$clarity_result" | cut -d'|' -f1)

    # Calculate total score (weighted average)
    local total_score=$(( (format_score * 25 + testability_score * 30 + completeness_score * 30 + clarity_score * 15) / 100 ))

    # Adjust for count penalty
    if [ "$count" -lt "$MIN_CRITERIA_COUNT" ]; then
        total_score=$((total_score - 20))
        log_warning "Applied -20 penalty for insufficient criteria count"
    fi

    # Generate report
    generate_quality_report "$count" "$format_score" "$testability_score" "$completeness_score" "$clarity_score" "$total_score"

    # Cleanup
    rm -f "$criteria_file"

    # Exit code
    if [ "$count" -ge "$MIN_CRITERIA_COUNT" ] && [ "$total_score" -ge "$MIN_QUALITY_SCORE" ]; then
        exit 0
    else
        log_error "Criteria quality check failed"
        exit 1
    fi
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <user-story-file.md>"
        echo ""
        echo "Validates acceptance criteria quality and completeness"
        exit 1
    fi

    main "$1"
fi
