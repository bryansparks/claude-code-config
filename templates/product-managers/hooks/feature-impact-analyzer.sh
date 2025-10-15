#!/bin/bash

# Feature Impact Analyzer Hook
# Analyzes feature impact, dependencies, and downstream effects
# Triggered: During feature planning, before prioritization decisions

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_analyze() { echo -e "${PURPLE}[ANALYSIS]${NC} $1"; }

# Analyze user impact
analyze_user_impact() {
    local source_file=$1

    log_analyze "Analyzing user impact..."

    local impact_score=0
    local impact_details=()

    # Check for user count/reach
    if grep -qi "all users\|every user\|entire user base" "$source_file"; then
        impact_score=$((impact_score + 50))
        impact_details+=("Affects ALL users")
    elif grep -qiE "[0-9]+%\s+of users|[0-9]+ users" "$source_file"; then
        local user_count=$(grep -oiE "[0-9]+%\s+of users|[0-9]+ users" "$source_file" | head -1)
        impact_score=$((impact_score + 30))
        impact_details+=("Affects: $user_count")
    else
        impact_score=$((impact_score + 10))
        impact_details+=("User count not specified")
    fi

    # Check for user personas
    local persona_count=$(grep -c "As a\|As an" "$source_file" || echo "0")
    if [ "$persona_count" -gt 0 ]; then
        impact_score=$((impact_score + 10))
        impact_details+=("$persona_count user persona(s) identified")
    fi

    # Check for user pain points
    if grep -qi "pain point\|frustration\|problem\|difficulty\|struggle" "$source_file"; then
        impact_score=$((impact_score + 15))
        impact_details+=("Addresses user pain points")
    fi

    # Check for user value/benefit
    if grep -qi "so that\|benefit\|value\|improve.*experience" "$source_file"; then
        impact_score=$((impact_score + 15))
        impact_details+=("Clear user value identified")
    fi

    # Check for frequency of use
    if grep -qi "daily\|every day\|frequently\|often\|multiple times" "$source_file"; then
        impact_score=$((impact_score + 10))
        impact_details+=("High frequency use case")
    fi

    echo "$impact_score|${impact_details[@]}"
}

# Analyze business impact
analyze_business_impact() {
    local source_file=$1

    log_analyze "Analyzing business impact..."

    local impact_score=0
    local impact_details=()

    # Check for revenue impact
    if grep -qi "revenue\|sales\|conversion\|monetization\|pricing" "$source_file"; then
        impact_score=$((impact_score + 30))
        impact_details+=("Direct revenue impact")
    fi

    # Check for cost savings
    if grep -qi "cost savings\|reduce cost\|efficiency\|automation" "$source_file"; then
        impact_score=$((impact_score + 25))
        impact_details+=("Cost savings potential")
    fi

    # Check for strategic value
    if grep -qi "strategic\|competitive\|market\|differentiation" "$source_file"; then
        impact_score=$((impact_score + 20))
        impact_details+=("Strategic importance")
    fi

    # Check for ROI
    if grep -qiE "ROI|return on investment|[0-9]+%.*increase|[0-9]+%.*improvement" "$source_file"; then
        impact_score=$((impact_score + 15))
        impact_details+=("Quantified ROI")
    fi

    # Check for metrics
    if grep -qi "metric\|KPI\|measure\|track\|goal" "$source_file"; then
        impact_score=$((impact_score + 10))
        impact_details+=("Success metrics defined")
    fi

    echo "$impact_score|${impact_details[@]}"
}

# Analyze technical impact
analyze_technical_impact() {
    local source_file=$1

    log_analyze "Analyzing technical impact..."

    local complexity_score=0
    local impact_details=()

    # Check for system components
    local component_count=$(grep -ci "component\|service\|system\|module\|API" "$source_file" || echo "0")
    if [ "$component_count" -gt 5 ]; then
        complexity_score=$((complexity_score + 40))
        impact_details+=("High system complexity - $component_count components")
    elif [ "$component_count" -gt 2 ]; then
        complexity_score=$((complexity_score + 25))
        impact_details+=("Medium system complexity - $component_count components")
    else
        complexity_score=$((complexity_score + 10))
        impact_details+=("Low system complexity")
    fi

    # Check for database changes
    if grep -qi "database\|schema\|migration\|data model" "$source_file"; then
        complexity_score=$((complexity_score + 20))
        impact_details+=("Database changes required")
    fi

    # Check for API changes
    if grep -qi "API\|endpoint\|integration\|webhook" "$source_file"; then
        complexity_score=$((complexity_score + 15))
        impact_details+=("API changes/integration")
    fi

    # Check for performance considerations
    if grep -qi "performance\|scalability\|optimization\|caching" "$source_file"; then
        complexity_score=$((complexity_score + 10))
        impact_details+=("Performance considerations")
    fi

    # Check for security concerns
    if grep -qi "security\|authentication\|authorization\|encryption\|PCI\|compliance" "$source_file"; then
        complexity_score=$((complexity_score + 15))
        impact_details+=("Security/compliance requirements")
    fi

    echo "$complexity_score|${impact_details[@]}"
}

# Analyze dependencies
analyze_dependencies() {
    local source_file=$1

    log_analyze "Analyzing dependencies..."

    local dependency_count=0
    local dependency_details=()

    # Extract dependencies section
    local deps=$(grep -A 10 "Dependencies:\|Depends on:\|Prerequisites:" "$source_file" || echo "")

    if [ -n "$deps" ]; then
        dependency_count=$(echo "$deps" | grep -c "^\s*[-*]" || echo "0")

        if [ "$dependency_count" -gt 5 ]; then
            dependency_details+=("🔴 HIGH dependency risk - $dependency_count dependencies")
        elif [ "$dependency_count" -gt 2 ]; then
            dependency_details+=("🟡 MEDIUM dependency risk - $dependency_count dependencies")
        elif [ "$dependency_count" -gt 0 ]; then
            dependency_details+=("🟢 LOW dependency risk - $dependency_count dependencies")
        fi
    else
        dependency_details+=("ℹ️ No dependencies documented")
    fi

    # Check for blocking dependencies
    if grep -qi "blocked by\|blocker\|waiting for\|requires.*complete" "$source_file"; then
        dependency_details+=("⚠️ Has blocking dependencies")
    fi

    # Check for external dependencies
    if grep -qi "third-party\|external\|vendor\|partner" "$source_file"; then
        dependency_details+=("⚠️ External dependencies present")
    fi

    echo "$dependency_count|${dependency_details[@]}"
}

# Calculate RICE score
calculate_rice_score() {
    local source_file=$1

    log_analyze "Calculating RICE score..."

    # Try to extract RICE components from file
    local reach=$(grep -oiE "reach:?\s*[0-9]+" "$source_file" | grep -oE "[0-9]+" | head -1 || echo "0")
    local impact=$(grep -oiE "impact:?\s*[0-9]+" "$source_file" | grep -oE "[0-9]+" | head -1 || echo "0")
    local confidence=$(grep -oiE "confidence:?\s*[0-9]+" "$source_file" | grep -oE "[0-9]+" | head -1 || echo "0")
    local effort=$(grep -oiE "effort:?\s*[0-9]+" "$source_file" | grep -oE "[0-9]+" | head -1 || echo "1")

    # Default values if not found
    reach=${reach:-1000}
    impact=${impact:-2}
    confidence=${confidence:-80}
    effort=${effort:-1}

    # Calculate: (Reach × Impact × Confidence) / Effort
    local rice_score=$(( (reach * impact * confidence) / (effort * 100) ))

    echo "$rice_score|Reach:$reach|Impact:$impact|Confidence:$confidence|Effort:$effort"
}

# Analyze risks
analyze_risks() {
    local source_file=$1

    log_analyze "Analyzing risks..."

    local risk_level="LOW"
    local risk_details=()

    # Check for risk section
    if grep -qi "risk" "$source_file"; then
        local risk_count=$(grep -A 20 -i "risk" "$source_file" | grep -c "^\s*[-*]" || echo "0")

        if [ "$risk_count" -gt 3 ]; then
            risk_level="HIGH"
            risk_details+=("$risk_count risks identified")
        elif [ "$risk_count" -gt 1 ]; then
            risk_level="MEDIUM"
            risk_details+=("$risk_count risks identified")
        fi
    fi

    # Check for complexity indicators
    if grep -qi "complex\|complicated\|challenging\|difficult" "$source_file"; then
        risk_details+=("Complexity risk noted")
        if [ "$risk_level" = "LOW" ]; then
            risk_level="MEDIUM"
        fi
    fi

    # Check for timeline risks
    if grep -qi "tight timeline\|aggressive\|rushed\|quick turnaround" "$source_file"; then
        risk_details+=("Timeline risk present")
        if [ "$risk_level" != "HIGH" ]; then
            risk_level="MEDIUM"
        fi
    fi

    # Check for resource risks
    if grep -qi "limited resources\|resource constraint\|understaffed" "$source_file"; then
        risk_details+=("Resource constraints")
        risk_level="HIGH"
    fi

    echo "$risk_level|${risk_details[@]}"
}

# Generate impact report
generate_impact_report() {
    local source_file=$1
    local user_impact=$2
    local business_impact=$3
    local tech_complexity=$4
    local deps=$5
    local rice=$6
    local risks=$7

    local feature_name=$(grep -m1 "^#\|^## " "$source_file" | sed 's/^#\+\s*//' || echo "Feature")

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Feature Impact Analysis Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Feature: $feature_name"
    echo "Analysis Date: $(date +%Y-%m-%d)"
    echo ""

    # User Impact
    local user_score=$(echo "$user_impact" | cut -d'|' -f1)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "USER IMPACT SCORE: $user_score/100"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local IFS='|'
    local user_details=($user_impact)
    for i in "${!user_details[@]}"; do
        if [ $i -gt 0 ]; then
            echo "  • ${user_details[$i]}"
        fi
    done
    echo ""

    # Business Impact
    local business_score=$(echo "$business_impact" | cut -d'|' -f1)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "BUSINESS IMPACT SCORE: $business_score/100"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local business_details=($business_impact)
    for i in "${!business_details[@]}"; do
        if [ $i -gt 0 ]; then
            echo "  • ${business_details[$i]}"
        fi
    done
    echo ""

    # Technical Complexity
    local tech_score=$(echo "$tech_complexity" | cut -d'|' -f1)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "TECHNICAL COMPLEXITY SCORE: $tech_score/100"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local tech_details=($tech_complexity)
    for i in "${!tech_details[@]}"; do
        if [ $i -gt 0 ]; then
            echo "  • ${tech_details[$i]}"
        fi
    done
    echo ""

    # Dependencies
    local dep_count=$(echo "$deps" | cut -d'|' -f1)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "DEPENDENCIES: $dep_count"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local dep_details=($deps)
    for i in "${!dep_details[@]}"; do
        if [ $i -gt 0 ]; then
            echo "  ${dep_details[$i]}"
        fi
    done
    echo ""

    # RICE Score
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "RICE PRIORITIZATION SCORE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local rice_score=$(echo "$rice" | cut -d'|' -f1)
    local reach=$(echo "$rice" | cut -d'|' -f2)
    local impact=$(echo "$rice" | cut -d'|' -f3)
    local confidence=$(echo "$rice" | cut -d'|' -f4)
    local effort=$(echo "$rice" | cut -d'|' -f5)
    echo "  RICE Score: $rice_score"
    echo ""
    echo "  Components:"
    echo "    • $reach"
    echo "    • $impact"
    echo "    • $confidence"
    echo "    • $effort"
    echo ""

    # Risks
    local risk_level=$(echo "$risks" | cut -d'|' -f1)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "RISK ASSESSMENT: $risk_level"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local risk_details=($risks)
    for i in "${!risk_details[@]}"; do
        if [ $i -gt 0 ]; then
            echo "  • ${risk_details[$i]}"
        fi
    done
    echo ""

    # Overall Recommendation
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "OVERALL RECOMMENDATION"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local total_impact=$(( (user_score + business_score) / 2 ))

    if [ "$total_impact" -ge 70 ] && [ "$tech_score" -le 40 ] && [ "$risk_level" = "LOW" ]; then
        echo -e "  ${GREEN}✅ HIGH PRIORITY - Quick Win${NC}"
        echo "  • High impact, low complexity, low risk"
        echo "  • Recommended: Prioritize for next sprint"
    elif [ "$total_impact" -ge 70 ] && [ "$tech_score" -gt 40 ]; then
        echo -e "  ${BLUE}🎯 HIGH PRIORITY - Major Investment${NC}"
        echo "  • High impact but significant effort required"
        echo "  • Recommended: Plan carefully, allocate adequate resources"
    elif [ "$total_impact" -lt 40 ] && [ "$tech_score" -gt 60 ]; then
        echo -e "  ${RED}❌ LOW PRIORITY - Avoid${NC}"
        echo "  • Low impact, high complexity"
        echo "  • Recommended: Deprioritize or reconsider"
    else
        echo -e "  ${YELLOW}⚠️ MEDIUM PRIORITY - Evaluate Further${NC}"
        echo "  • Mixed impact and complexity"
        echo "  • Recommended: Gather more data before deciding"
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main function
main() {
    local source_file=$1

    if [ ! -f "$source_file" ]; then
        log_error "File not found: $source_file"
        exit 1
    fi

    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║          Feature Impact Analyzer                               ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    # Run all analyses
    local user_impact=$(analyze_user_impact "$source_file")
    local business_impact=$(analyze_business_impact "$source_file")
    local tech_complexity=$(analyze_technical_impact "$source_file")
    local deps=$(analyze_dependencies "$source_file")
    local rice=$(calculate_rice_score "$source_file")
    local risks=$(analyze_risks "$source_file")

    # Generate report
    generate_impact_report "$source_file" "$user_impact" "$business_impact" "$tech_complexity" "$deps" "$rice" "$risks"
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <feature-file.md>"
        echo ""
        echo "Analyzes feature impact across multiple dimensions:"
        echo "  • User impact"
        echo "  • Business impact"
        echo "  • Technical complexity"
        echo "  • Dependencies"
        echo "  • RICE score"
        echo "  • Risk assessment"
        exit 1
    fi

    main "$1"
fi
