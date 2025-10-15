#!/bin/bash
# Test Flakiness Detector Hook
# Detects and reports flaky tests by running tests multiple times

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎲 Test Flakiness Detector${NC}\n"

# Configuration
FLAKY_RUNS=${FLAKY_RUNS:-10}
FLAKY_THRESHOLD=${FLAKY_THRESHOLD:-80}  # Pass rate % to consider flaky
PARALLEL=${PARALLEL:-false}
TEST_PATTERN=${TEST_PATTERN:-""}

echo -e "${YELLOW}Configuration:${NC}"
echo -e "  Runs per test: $FLAKY_RUNS"
echo -e "  Flakiness threshold: ${FLAKY_THRESHOLD}%"
echo -e "  Parallel execution: $PARALLEL"
echo ""

# Detect test framework
detect_framework() {
  if [ -f "package.json" ]; then
    if grep -q "jest" package.json; then
      echo "jest"
    elif grep -q "vitest" package.json; then
      echo "vitest"
    elif grep -q "@playwright/test" package.json; then
      echo "playwright"
    elif grep -q "cypress" package.json; then
      echo "cypress"
    else
      echo "unknown"
    fi
  elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
    echo "pytest"
  elif [ -f "Gemfile" ] && grep -q "rspec" Gemfile 2>/dev/null; then
    echo "rspec"
  else
    echo "unknown"
  fi
}

FRAMEWORK=$(detect_framework)
echo -e "${YELLOW}🔍 Detected framework: $FRAMEWORK${NC}\n"

if [ "$FRAMEWORK" = "unknown" ]; then
  echo -e "${RED}✗ Could not detect test framework${NC}"
  exit 1
fi

# Track flaky tests
declare -A test_results
declare -A test_run_count
declare -A test_pass_count

# Run tests multiple times
run_flakiness_detection() {
  echo -e "${YELLOW}🔄 Running tests $FLAKY_RUNS times...${NC}\n"

  for ((run=1; run<=FLAKY_RUNS; run++)); do
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Run $run of $FLAKY_RUNS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    local run_result=0

    case $FRAMEWORK in
      jest)
        run_jest_tests || run_result=$?
        ;;
      vitest)
        run_vitest_tests || run_result=$?
        ;;
      playwright)
        run_playwright_tests || run_result=$?
        ;;
      cypress)
        run_cypress_tests || run_result=$?
        ;;
      pytest)
        run_pytest_tests || run_result=$?
        ;;
      rspec)
        run_rspec_tests || run_result=$?
        ;;
    esac

    if [ $run_result -ne 0 ]; then
      echo -e "${RED}✗ Run $run failed${NC}\n"
    else
      echo -e "${GREEN}✓ Run $run passed${NC}\n"
    fi

    # Small delay between runs
    sleep 1
  done
}

# Run Jest tests
run_jest_tests() {
  local result_file="/tmp/jest-results-$$.json"

  npm test -- --json --outputFile="$result_file" $TEST_PATTERN || true

  if [ -f "$result_file" ]; then
    parse_jest_results "$result_file"
    rm "$result_file"
  fi

  return 0
}

# Run Vitest tests
run_vitest_tests() {
  npm test -- --run --reporter=json $TEST_PATTERN > /tmp/vitest-results-$$.json 2>&1 || true

  if [ -f /tmp/vitest-results-$$.json ]; then
    parse_vitest_results /tmp/vitest-results-$$.json
    rm /tmp/vitest-results-$$.json
  fi

  return 0
}

# Run Playwright tests
run_playwright_tests() {
  npx playwright test --reporter=json $TEST_PATTERN > /tmp/playwright-results-$$.json 2>&1 || true

  if [ -f /tmp/playwright-results-$$.json ]; then
    parse_playwright_results /tmp/playwright-results-$$.json
    rm /tmp/playwright-results-$$.json
  fi

  return 0
}

# Run Cypress tests
run_cypress_tests() {
  npx cypress run --reporter json $TEST_PATTERN > /tmp/cypress-results-$$.json 2>&1 || true

  if [ -f /tmp/cypress-results-$$.json ]; then
    parse_cypress_results /tmp/cypress-results-$$.json
    rm /tmp/cypress-results-$$.json
  fi

  return 0
}

# Run pytest tests
run_pytest_tests() {
  pytest --json-report --json-report-file=/tmp/pytest-results-$$.json $TEST_PATTERN || true

  if [ -f /tmp/pytest-results-$$.json ]; then
    parse_pytest_results /tmp/pytest-results-$$.json
    rm /tmp/pytest-results-$$.json
  fi

  return 0
}

# Run RSpec tests
run_rspec_tests() {
  bundle exec rspec --format json --out /tmp/rspec-results-$$.json $TEST_PATTERN || true

  if [ -f /tmp/rspec-results-$$.json ]; then
    parse_rspec_results /tmp/rspec-results-$$.json
    rm /tmp/rspec-results-$$.json
  fi

  return 0
}

# Parse Jest results
parse_jest_results() {
  local result_file=$1

  if ! command -v jq &> /dev/null; then
    return
  fi

  jq -r '.testResults[].testResults[] | "\(.fullName)|\(.status)"' "$result_file" | while IFS='|' read -r test_name status; do
    track_test_result "$test_name" "$status"
  done
}

# Parse Playwright results
parse_playwright_results() {
  local result_file=$1

  if ! command -v jq &> /dev/null; then
    return
  fi

  jq -r '.suites[].specs[] | "\(.title)|\(.ok)"' "$result_file" 2>/dev/null | while IFS='|' read -r test_name ok; do
    local status="failed"
    if [ "$ok" = "true" ]; then
      status="passed"
    fi
    track_test_result "$test_name" "$status"
  done || true
}

# Parse pytest results
parse_pytest_results() {
  local result_file=$1

  if ! command -v jq &> /dev/null; then
    return
  fi

  jq -r '.tests[] | "\(.nodeid)|\(.outcome)"' "$result_file" | while IFS='|' read -r test_name outcome; do
    track_test_result "$test_name" "$outcome"
  done
}

# Track individual test result
track_test_result() {
  local test_name=$1
  local status=$2

  # Initialize counters if needed
  if [ -z "${test_run_count[$test_name]:-}" ]; then
    test_run_count[$test_name]=0
    test_pass_count[$test_name]=0
  fi

  # Increment run count
  ((test_run_count[$test_name]++))

  # Increment pass count if passed
  if [ "$status" = "passed" ] || [ "$status" = "pass" ]; then
    ((test_pass_count[$test_name]++))
  fi
}

# Analyze flakiness
analyze_flakiness() {
  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           FLAKINESS ANALYSIS${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  local total_tests=${#test_run_count[@]}
  local flaky_tests=0
  local stable_passing=0
  local stable_failing=0

  declare -a flaky_list

  # Calculate pass rates
  for test_name in "${!test_run_count[@]}"; do
    local runs=${test_run_count[$test_name]}
    local passes=${test_pass_count[$test_name]}
    local pass_rate=0

    if [ "$runs" -gt 0 ]; then
      pass_rate=$(echo "scale=2; ($passes * 100) / $runs" | bc)
    fi

    # Classify test
    if (( $(echo "$pass_rate == 100" | bc -l) )); then
      ((stable_passing++))
    elif (( $(echo "$pass_rate == 0" | bc -l) )); then
      ((stable_failing++))
    else
      ((flaky_tests++))
      flaky_list+=("$test_name|$pass_rate|$passes|$runs")
    fi
  done

  # Display summary
  echo -e "${YELLOW}📊 Test Stability Summary:${NC}"
  echo -e "  Total tests: $total_tests"
  echo -e "  ${GREEN}✓ Stable (100% pass): $stable_passing${NC}"
  echo -e "  ${RED}✗ Stable (0% pass): $stable_failing${NC}"
  echo -e "  ${YELLOW}🎲 Flaky: $flaky_tests${NC}"
  echo ""

  # Display flaky tests
  if [ $flaky_tests -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}FLAKY TESTS DETECTED${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    printf "%-60s %10s %15s\n" "Test Name" "Pass Rate" "Passes/Runs"
    printf "%-60s %10s %15s\n" "─────────" "─────────" "───────────"

    # Sort by pass rate (most flaky first)
    printf '%s\n' "${flaky_list[@]}" | sort -t'|' -k2 -n | while IFS='|' read -r name rate passes runs; do
      local color=$YELLOW
      if (( $(echo "$rate < 50" | bc -l) )); then
        color=$RED
      fi

      printf "%-60s ${color}%9.1f%%${NC} %15s\n" \
        "$(echo "$name" | cut -c1-60)" \
        "$rate" \
        "$passes/$runs"
    done

    echo ""
  fi

  # Display stable failing tests
  if [ $stable_failing -gt 0 ]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}CONSISTENTLY FAILING TESTS${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    for test_name in "${!test_run_count[@]}"; do
      local passes=${test_pass_count[$test_name]}
      if [ "$passes" -eq 0 ]; then
        echo -e "  ${RED}✗${NC} $test_name"
      fi
    done

    echo ""
  fi

  # Recommendations
  if [ $flaky_tests -gt 0 ] || [ $stable_failing -gt 0 ]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}           RECOMMENDATIONS${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

    echo -e "${YELLOW}For Flaky Tests:${NC}"
    echo -e "  1. Check for race conditions"
    echo -e "  2. Review async/await usage"
    echo -e "  3. Add proper wait strategies"
    echo -e "  4. Remove hard-coded timeouts"
    echo -e "  5. Ensure test isolation"
    echo -e "  6. Check for shared state"
    echo ""

    echo -e "${YELLOW}For Failing Tests:${NC}"
    echo -e "  1. Review test logic"
    echo -e "  2. Check if code changed"
    echo -e "  3. Verify test data"
    echo -e "  4. Update assertions if needed"
    echo ""
  else
    echo -e "${GREEN}✓ All tests are stable!${NC}\n"
  fi

  # Return non-zero if flaky tests found
  if [ $flaky_tests -gt 0 ]; then
    return 1
  else
    return 0
  fi
}

# Generate flakiness report file
generate_report() {
  local report_file="flakiness-report.json"

  echo -e "${YELLOW}📝 Generating flakiness report...${NC}"

  cat > "$report_file" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "runs": $FLAKY_RUNS,
  "framework": "$FRAMEWORK",
  "tests": [
EOF

  local first=true
  for test_name in "${!test_run_count[@]}"; do
    local runs=${test_run_count[$test_name]}
    local passes=${test_pass_count[$test_name]}
    local pass_rate=0

    if [ "$runs" -gt 0 ]; then
      pass_rate=$(echo "scale=4; ($passes * 100) / $runs" | bc)
    fi

    if [ "$first" = false ]; then
      echo "," >> "$report_file"
    fi
    first=false

    cat >> "$report_file" << EOF
    {
      "name": "$(echo "$test_name" | sed 's/"/\\"/g')",
      "runs": $runs,
      "passes": $passes,
      "failures": $((runs - passes)),
      "passRate": $pass_rate
    }
EOF
  done

  echo -e "\n  ]\n}" >> "$report_file"

  echo -e "${GREEN}✓ Report saved to: $report_file${NC}\n"
}

# Main execution
main() {
  run_flakiness_detection

  if analyze_flakiness; then
    generate_report
    echo -e "${GREEN}✓ No flaky tests detected${NC}\n"
    exit 0
  else
    generate_report
    echo -e "${RED}✗ Flaky tests detected${NC}\n"
    exit 1
  fi
}

# Run main
main
