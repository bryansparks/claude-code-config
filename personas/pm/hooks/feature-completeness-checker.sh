#!/bin/bash

# Feature Completeness Checker Hook
# Validates feature implementation against requirements and acceptance criteria
# Triggered: Pre-deployment, during QA, before feature sign-off

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

# Check if requirements file exists
check_requirements_file() {
    local req_file=$1

    if [ ! -f "$req_file" ]; then
        log_error "Requirements file not found: $req_file"
        return 1
    fi

    log_success "Requirements file found"
    return 0
}

# Extract acceptance criteria
extract_acceptance_criteria() {
    local req_file=$1
    local criteria=()

    # Extract GWT format criteria
    while IFS= read -r line; do
        if [[ $line =~ Given.*When.*Then ]] || [[ $line =~ \*\*Given\*\*.*\*\*When\*\*.*\*\*Then\*\* ]]; then
            criteria+=("$line")
        fi
    done < "$req_file"

    # If no GWT, extract numbered/bulleted items under AC section
    if [ ${#criteria[@]} -eq 0 ]; then
        local in_ac_section=false
        while IFS= read -r line; do
            if [[ $line =~ [Aa]cceptance[[:space:]][Cc]riteria ]]; then
                in_ac_section=true
                continue
            fi
            if $in_ac_section; then
                if [[ $line =~ ^(##|###|\*\*[A-Z]) ]]; then
                    break
                fi
                if [[ $line =~ ^[[:space:]]*[-*0-9]+\. ]]; then
                    criteria+=("$line")
                fi
            fi
        done < "$req_file"
    fi

    printf '%s\n' "${criteria[@]}"
}

# Interactive checklist
run_interactive_checklist() {
    local req_file=$1
    local criteria_list=$(extract_acceptance_criteria "$req_file")

    if [ -z "$criteria_list" ]; then
        log_error "No acceptance criteria found in requirements file"
        return 1
    fi

    local total_criteria=0
    local checked_criteria=0
    local failed_criteria=0

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Feature Completeness Checklist"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Review each acceptance criterion and mark as:"
    echo "  ✓ (y) - Implemented and working"
    echo "  ✗ (n) - Not implemented or failing"
    echo "  ? (s) - Skip (for now)"
    echo ""

    local IFS=$'\n'
    for criterion in $criteria_list; do
        total_criteria=$((total_criteria + 1))
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e "${BLUE}Criterion $total_criteria:${NC}"
        echo "$criterion"
        echo ""

        # Interactive prompt
        read -p "Status (y/n/s): " response

        case "$response" in
            y|Y)
                checked_criteria=$((checked_criteria + 1))
                echo -e "${GREEN}✓ Marked as complete${NC}"
                ;;
            n|N)
                failed_criteria=$((failed_criteria + 1))
                echo -e "${RED}✗ Marked as incomplete${NC}"
                read -p "  Note (optional): " note
                if [ -n "$note" ]; then
                    echo "  📝 $note" >> /tmp/feature-completeness-notes.txt
                fi
                ;;
            s|S)
                echo -e "${YELLOW}⊘ Skipped${NC}"
                ;;
            *)
                echo -e "${YELLOW}⊘ Invalid response, skipping${NC}"
                ;;
        esac
        echo ""
    done

    # Summary
    local completeness_percent=0
    if [ "$total_criteria" -gt 0 ]; then
        completeness_percent=$(( (checked_criteria * 100) / total_criteria ))
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Completeness Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Total Criteria:       $total_criteria"
    echo "Implemented:          $checked_criteria"
    echo "Not Implemented:      $failed_criteria"
    echo "Completeness:         $completeness_percent%"
    echo ""

    if [ "$completeness_percent" -ge 100 ]; then
        echo -e "${GREEN}★★★★★ Feature Complete${NC}"
        echo "✓ All acceptance criteria met"
    elif [ "$completeness_percent" -ge 80 ]; then
        echo -e "${GREEN}★★★★☆ Nearly Complete${NC}"
        echo "⚠ Minor items remaining"
    elif [ "$completeness_percent" -ge 60 ]; then
        echo -e "${YELLOW}★★★☆☆ Partially Complete${NC}"
        echo "⚠ Significant work remaining"
    elif [ "$completeness_percent" -ge 40 ]; then
        echo -e "${YELLOW}★★☆☆☆ Early Stage${NC}"
        echo "✗ Major work remaining"
    else
        echo -e "${RED}★☆☆☆☆ Incomplete${NC}"
        echo "✗ Feature not ready"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ -f /tmp/feature-completeness-notes.txt ]; then
        echo ""
        echo "Notes on incomplete items:"
        cat /tmp/feature-completeness-notes.txt
        rm /tmp/feature-completeness-notes.txt
    fi

    # Return exit code based on completeness
    if [ "$completeness_percent" -ge 100 ]; then
        return 0
    elif [ "$completeness_percent" -ge 80 ]; then
        return 0
    else
        return 1
    fi
}

# Non-interactive verification
verify_implementation() {
    local req_file=$1
    local implementation_dir=$2

    log_info "Running automated verification"

    local checks_passed=0
    local checks_failed=0

    # Check if implementation directory exists
    if [ ! -d "$implementation_dir" ]; then
        log_error "Implementation directory not found: $implementation_dir"
        return 1
    fi

    # Basic checks
    echo ""
    log_info "Checking implementation artifacts..."

    # Check for test files
    local test_count=$(find "$implementation_dir" -type f \( -name "*test*" -o -name "*spec*" \) | wc -l)
    if [ "$test_count" -gt 0 ]; then
        checks_passed=$((checks_passed + 1))
        log_success "✓ Found $test_count test file(s)"
    else
        checks_failed=$((checks_failed + 1))
        log_error "✗ No test files found"
    fi

    # Check for documentation
    local doc_count=$(find "$implementation_dir" -type f \( -name "README*" -o -name "*.md" \) | wc -l)
    if [ "$doc_count" -gt 0 ]; then
        checks_passed=$((checks_passed + 1))
        log_success "✓ Found $doc_count documentation file(s)"
    else
        checks_failed=$((checks_failed + 1))
        log_warning "⚠ No documentation found"
    fi

    # Check for source files
    local src_count=$(find "$implementation_dir" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" -o -name "*.java" \) | wc -l)
    if [ "$src_count" -gt 0 ]; then
        checks_passed=$((checks_passed + 1))
        log_success "✓ Found $src_count source file(s)"
    else
        checks_failed=$((checks_failed + 1))
        log_error "✗ No source files found"
    fi

    echo ""
    echo "Automated Checks: $checks_passed passed, $checks_failed failed"

    if [ "$checks_failed" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Generate completeness report
generate_report() {
    local req_file=$1
    local output_file=${2:-"feature-completeness-report.md"}

    log_info "Generating completeness report: $output_file"

    cat > "$output_file" <<EOF
# Feature Completeness Report

**Generated**: $(date)
**Requirements**: $(basename "$req_file")

## Acceptance Criteria

$(extract_acceptance_criteria "$req_file" | nl -w2 -s'. ')

## Verification Status

Use this checklist to track implementation:

$(extract_acceptance_criteria "$req_file" | sed 's/^/- [ ] /')

## Sign-off

- [ ] All acceptance criteria met
- [ ] Tests passing
- [ ] Documentation complete
- [ ] Code reviewed
- [ ] UX reviewed
- [ ] Stakeholder approval

**Product Manager**: __________________ Date: ________

**Tech Lead**: __________________ Date: ________

**QA Lead**: __________________ Date: ________

EOF

    log_success "Report generated: $output_file"
}

# Main function
main() {
    local mode=${1:-"interactive"}
    local req_file=$2
    local implementation_dir=${3:-"."}

    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║      Feature Completeness Checker                  ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""

    if [ -z "$req_file" ]; then
        log_error "Requirements file not specified"
        echo ""
        echo "Usage:"
        echo "  $0 interactive <requirements-file.md>"
        echo "  $0 verify <requirements-file.md> <implementation-dir>"
        echo "  $0 report <requirements-file.md> [output-file.md]"
        exit 1
    fi

    check_requirements_file "$req_file" || exit 1

    case "$mode" in
        interactive|i)
            run_interactive_checklist "$req_file"
            ;;
        verify|v)
            verify_implementation "$req_file" "$implementation_dir"
            ;;
        report|r)
            generate_report "$req_file" "${implementation_dir}"
            ;;
        *)
            log_error "Unknown mode: $mode"
            exit 1
            ;;
    esac
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
