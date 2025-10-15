#!/bin/bash
# Performance Baseline Check Hook
# Compares current performance against baseline metrics

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}⚡ Performance Baseline Checker${NC}\n"

# Configuration
BASELINE_FILE=${BASELINE_FILE:-".performance-baseline.json"}
THRESHOLD_LCP=${THRESHOLD_LCP:-2500}        # ms
THRESHOLD_FID=${THRESHOLD_FID:-100}         # ms
THRESHOLD_CLS=${THRESHOLD_CLS:-0.1}
THRESHOLD_TTFB=${THRESHOLD_TTFB:-400}       # ms
REGRESSION_TOLERANCE=${REGRESSION_TOLERANCE:-10}  # %

# Detect performance testing tool
detect_perf_tool() {
  if command -v lighthouse &> /dev/null; then
    echo "lighthouse"
  elif npm list -g @lhci/cli &> /dev/null 2>&1 || npm list @lhci/cli &> /dev/null 2>&1; then
    echo "lighthouse-ci"
  elif command -v npx &> /dev/null && npm list web-vitals &> /dev/null 2>&1; then
    echo "web-vitals"
  else
    echo "unknown"
  fi
}

TOOL=$(detect_perf_tool)
echo -e "${YELLOW}🔍 Detected tool: $TOOL${NC}\n"

if [ "$TOOL" = "unknown" ]; then
  echo -e "${RED}✗ No performance testing tool found${NC}"
  echo -e "${YELLOW}💡 Install one of:${NC}"
  echo -e "  npm install -g lighthouse"
  echo -e "  npm install -D @lhci/cli"
  echo -e "  npm install -D web-vitals"
  exit 1
fi

# Get URL to test
URL=${1:-"http://localhost:3000"}

if ! curl -s "$URL" > /dev/null 2>&1; then
  echo -e "${RED}✗ Cannot reach $URL${NC}"
  echo -e "${YELLOW}💡 Start your application or provide a valid URL${NC}"
  exit 1
fi

echo -e "${YELLOW}🎯 Testing URL: $URL${NC}\n"

# Run Lighthouse performance test
run_lighthouse_test() {
  local url=$1
  local output_file="/tmp/lighthouse-perf-$$.json"

  echo -e "${YELLOW}🔄 Running Lighthouse performance audit...${NC}"

  lighthouse "$url" \
    --only-categories=performance \
    --output=json \
    --output-path="$output_file" \
    --chrome-flags="--headless" \
    --quiet || {
    echo -e "${RED}✗ Lighthouse test failed${NC}"
    return 1
  }

  echo "$output_file"
}

# Parse Lighthouse results
parse_lighthouse_results() {
  local result_file=$1

  if ! command -v jq &> /dev/null; then
    echo -e "${RED}✗ jq not found (required for parsing results)${NC}"
    return 1
  fi

  # Extract metrics
  local lcp=$(jq -r '.audits."largest-contentful-paint".numericValue' "$result_file" 2>/dev/null || echo "0")
  local fid=$(jq -r '.audits."max-potential-fid".numericValue' "$result_file" 2>/dev/null || echo "0")
  local cls=$(jq -r '.audits."cumulative-layout-shift".numericValue' "$result_file" 2>/dev/null || echo "0")
  local ttfb=$(jq -r '.audits."server-response-time".numericValue' "$result_file" 2>/dev/null || echo "0")
  local fcp=$(jq -r '.audits."first-contentful-paint".numericValue' "$result_file" 2>/dev/null || echo "0")
  local tti=$(jq -r '.audits."interactive".numericValue' "$result_file" 2>/dev/null || echo "0")
  local tbt=$(jq -r '.audits."total-blocking-time".numericValue' "$result_file" 2>/dev/null || echo "0")
  local score=$(jq -r '.categories.performance.score' "$result_file" 2>/dev/null || echo "0")

  # Create JSON object
  cat << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "url": "$URL",
  "metrics": {
    "lcp": $lcp,
    "fid": $fid,
    "cls": $cls,
    "ttfb": $ttfb,
    "fcp": $fcp,
    "tti": $tti,
    "tbt": $tbt,
    "score": $score
  }
}
EOF
}

# Load baseline metrics
load_baseline() {
  if [ -f "$BASELINE_FILE" ]; then
    cat "$BASELINE_FILE"
  else
    echo "{}"
  fi
}

# Save baseline metrics
save_baseline() {
  local metrics=$1
  echo "$metrics" > "$BASELINE_FILE"
  echo -e "${GREEN}✓ Baseline saved to $BASELINE_FILE${NC}"
}

# Compare metrics
compare_metrics() {
  local current=$1
  local baseline=$2

  if ! command -v jq &> /dev/null; then
    return 1
  fi

  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           PERFORMANCE COMPARISON${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  local has_regression=false

  # Extract current metrics
  local curr_lcp=$(echo "$current" | jq -r '.metrics.lcp')
  local curr_fid=$(echo "$current" | jq -r '.metrics.fid')
  local curr_cls=$(echo "$current" | jq -r '.metrics.cls')
  local curr_ttfb=$(echo "$current" | jq -r '.metrics.ttfb')
  local curr_score=$(echo "$current" | jq -r '.metrics.score')

  # Extract baseline metrics
  local base_lcp=$(echo "$baseline" | jq -r '.metrics.lcp // 0')
  local base_fid=$(echo "$baseline" | jq -r '.metrics.fid // 0')
  local base_cls=$(echo "$baseline" | jq -r '.metrics.cls // 0')
  local base_ttfb=$(echo "$baseline" | jq -r '.metrics.ttfb // 0')
  local base_score=$(echo "$baseline" | jq -r '.metrics.score // 0')

  # Compare LCP
  compare_metric "LCP (Largest Contentful Paint)" "$curr_lcp" "$base_lcp" "$THRESHOLD_LCP" "ms" || has_regression=true

  # Compare FID
  compare_metric "FID (First Input Delay)" "$curr_fid" "$base_fid" "$THRESHOLD_FID" "ms" || has_regression=true

  # Compare CLS
  compare_metric "CLS (Cumulative Layout Shift)" "$curr_cls" "$base_cls" "$THRESHOLD_CLS" "" || has_regression=true

  # Compare TTFB
  compare_metric "TTFB (Time to First Byte)" "$curr_ttfb" "$base_ttfb" "$THRESHOLD_TTFB" "ms" || has_regression=true

  # Compare Score
  local score_pct=$(echo "$curr_score * 100" | bc)
  local base_score_pct=$(echo "$base_score * 100" | bc)
  echo -e "\n${YELLOW}Performance Score:${NC}"
  printf "  Current:  %6.0f/100\n" "$score_pct"
  if [ "$base_score" != "0" ]; then
    printf "  Baseline: %6.0f/100\n" "$base_score_pct"

    local score_diff=$(echo "$score_pct - $base_score_pct" | bc)
    if (( $(echo "$score_diff < -5" | bc -l) )); then
      printf "  Change:   ${RED}%+.0f${NC} 📉\n" "$score_diff"
    elif (( $(echo "$score_diff > 5" | bc -l) )); then
      printf "  Change:   ${GREEN}%+.0f${NC} 📈\n" "$score_diff"
    else
      printf "  Change:   %.0f\n" "$score_diff"
    fi
  fi

  echo ""

  if [ "$has_regression" = true ]; then
    return 1
  else
    return 0
  fi
}

# Compare individual metric
compare_metric() {
  local name=$1
  local current=$2
  local baseline=$3
  local threshold=$4
  local unit=$5

  echo -e "\n${YELLOW}$name:${NC}"

  # Format values
  if [ "$unit" = "ms" ]; then
    printf "  Current:  %8.0f ms\n" "$current"
  else
    printf "  Current:  %8.3f\n" "$current"
  fi

  # Check against threshold
  local within_threshold=true
  if [ "$unit" = "ms" ]; then
    if (( $(echo "$current > $threshold" | bc -l) )); then
      printf "  Threshold: ${RED}%8.0f ms ✗${NC}\n" "$threshold"
      within_threshold=false
    else
      printf "  Threshold: ${GREEN}%8.0f ms ✓${NC}\n" "$threshold"
    fi
  else
    if (( $(echo "$current > $threshold" | bc -l) )); then
      printf "  Threshold: ${RED}%8.3f ✗${NC}\n" "$threshold"
      within_threshold=false
    else
      printf "  Threshold: ${GREEN}%8.3f ✓${NC}\n" "$threshold"
    fi
  fi

  # Compare with baseline if available
  if [ "$baseline" != "0" ] && [ "$baseline" != "null" ]; then
    if [ "$unit" = "ms" ]; then
      printf "  Baseline: %8.0f ms\n" "$baseline"
    else
      printf "  Baseline: %8.3f\n" "$baseline"
    fi

    # Calculate change
    local change=$(echo "scale=2; (($current - $baseline) / $baseline) * 100" | bc)
    local change_abs=$(echo "$current - $baseline" | bc)

    # Check for regression
    if (( $(echo "$change > $REGRESSION_TOLERANCE" | bc -l) )); then
      if [ "$unit" = "ms" ]; then
        printf "  Change:   ${RED}+%.0f ms (+%.1f%%) ⚠ REGRESSION${NC}\n" "$change_abs" "$change"
      else
        printf "  Change:   ${RED}+%.3f (+%.1f%%) ⚠ REGRESSION${NC}\n" "$change_abs" "$change"
      fi
      return 1
    elif (( $(echo "$change < -5" | bc -l) )); then
      if [ "$unit" = "ms" ]; then
        printf "  Change:   ${GREEN}%.0f ms (%.1f%%) 📈 IMPROVED${NC}\n" "$change_abs" "$change"
      else
        printf "  Change:   ${GREEN}%.3f (%.1f%%) 📈 IMPROVED${NC}\n" "$change_abs" "$change"
      fi
    else
      if [ "$unit" = "ms" ]; then
        printf "  Change:   %.0f ms (%.1f%%)\n" "$change_abs" "$change"
      else
        printf "  Change:   %.3f (%.1f%%)\n" "$change_abs" "$change"
      fi
    fi
  fi

  if [ "$within_threshold" = false ]; then
    return 1
  fi

  return 0
}

# Display recommendations
display_recommendations() {
  local current=$1

  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           RECOMMENDATIONS${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  local lcp=$(echo "$current" | jq -r '.metrics.lcp')
  local cls=$(echo "$current" | jq -r '.metrics.cls')
  local tbt=$(echo "$current" | jq -r '.metrics.tbt')

  # LCP recommendations
  if (( $(echo "$lcp > 2500" | bc -l) )); then
    echo -e "${YELLOW}📊 LCP (Largest Contentful Paint) needs improvement:${NC}"
    echo -e "  • Optimize and compress images"
    echo -e "  • Implement lazy loading for below-fold images"
    echo -e "  • Use CDN for static assets"
    echo -e "  • Preload critical resources"
    echo -e "  • Reduce server response time"
    echo ""
  fi

  # CLS recommendations
  if (( $(echo "$cls > 0.1" | bc -l) )); then
    echo -e "${YELLOW}📊 CLS (Cumulative Layout Shift) needs improvement:${NC}"
    echo -e "  • Set explicit width/height on images and videos"
    echo -e "  • Reserve space for ad slots and embeds"
    echo -e "  • Avoid inserting content above existing content"
    echo -e "  • Use font-display: swap carefully"
    echo ""
  fi

  # TBT recommendations
  if (( $(echo "$tbt > 200" | bc -l) )); then
    echo -e "${YELLOW}📊 TBT (Total Blocking Time) needs improvement:${NC}"
    echo -e "  • Split long JavaScript tasks"
    echo -e "  • Reduce JavaScript bundle size"
    echo -e "  • Defer non-critical JavaScript"
    echo -e "  • Use code splitting"
    echo ""
  fi
}

# Main execution
main() {
  # Run performance test
  local result_file=$(run_lighthouse_test "$URL")

  if [ ! -f "$result_file" ]; then
    echo -e "${RED}✗ Performance test failed${NC}"
    exit 1
  fi

  # Parse results
  local current_metrics=$(parse_lighthouse_results "$result_file")

  # Clean up
  rm "$result_file"

  # Load baseline
  local baseline_metrics=$(load_baseline)

  # First run - save baseline
  if [ "$baseline_metrics" = "{}" ]; then
    echo -e "${YELLOW}⚠ No baseline found - saving current metrics as baseline${NC}"
    save_baseline "$current_metrics"
    echo -e "\n${GREEN}✓ Baseline established${NC}"
    echo -e "${YELLOW}💡 Run again to compare against this baseline${NC}\n"
    exit 0
  fi

  # Compare metrics
  if compare_metrics "$current_metrics" "$baseline_metrics"; then
    display_recommendations "$current_metrics"
    echo -e "${GREEN}✓ Performance within acceptable range${NC}\n"

    # Ask if user wants to update baseline
    echo -e "${YELLOW}Update baseline with current metrics?${NC}"
    read -p "(yes/no): " update_baseline

    if [[ "$update_baseline" =~ ^[Yy] ]]; then
      save_baseline "$current_metrics"
    fi

    exit 0
  else
    display_recommendations "$current_metrics"
    echo -e "${RED}✗ Performance regression detected${NC}\n"
    exit 1
  fi
}

# Run main
main
