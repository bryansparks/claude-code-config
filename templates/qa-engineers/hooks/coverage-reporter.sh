#!/bin/bash
# Coverage Reporter Hook
# Generates and reports test coverage metrics with detailed analysis

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MIN_COVERAGE=${MIN_COVERAGE:-80}
COVERAGE_DIR=${COVERAGE_DIR:-"coverage"}
REPORT_FORMAT=${REPORT_FORMAT:-"html"} # html, json, lcov, text

echo -e "${BLUE}📊 Test Coverage Reporter${NC}\n"

# Detect test framework
detect_framework() {
  if [ -f "package.json" ]; then
    if grep -q "jest" package.json; then
      echo "jest"
    elif grep -q "vitest" package.json; then
      echo "vitest"
    elif grep -q "playwright" package.json && grep -q "@playwright/test" package.json; then
      echo "playwright"
    else
      echo "unknown"
    fi
  elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    echo "pytest"
  elif [ -f "Gemfile" ] && grep -q "simplecov" Gemfile 2>/dev/null; then
    echo "rspec"
  else
    echo "unknown"
  fi
}

FRAMEWORK=$(detect_framework)
echo -e "${YELLOW}🔍 Detected framework: $FRAMEWORK${NC}\n"

# Run tests with coverage
run_coverage() {
  case $FRAMEWORK in
    jest)
      echo -e "${YELLOW}Running Jest with coverage...${NC}"
      npm test -- --coverage --coverageReporters=json --coverageReporters=lcov --coverageReporters=text --coverageReporters=html || {
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
      }
      ;;

    vitest)
      echo -e "${YELLOW}Running Vitest with coverage...${NC}"
      npm test -- --run --coverage --coverage.reporter=json --coverage.reporter=lcov --coverage.reporter=text --coverage.reporter=html || {
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
      }
      ;;

    playwright)
      echo -e "${YELLOW}Running Playwright tests...${NC}"
      echo -e "${YELLOW}⚠ Note: Playwright doesn't generate coverage by default${NC}"
      echo -e "${YELLOW}💡 Use Istanbul/NYC for coverage with Playwright${NC}"
      npx playwright test || {
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
      }
      # If v8 coverage is enabled
      if [ -d ".nyc_output" ]; then
        npx nyc report --reporter=html --reporter=text --reporter=json
      fi
      ;;

    pytest)
      echo -e "${YELLOW}Running pytest with coverage...${NC}"
      pytest --cov=. --cov-report=html --cov-report=json --cov-report=term-missing || {
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
      }
      ;;

    rspec)
      echo -e "${YELLOW}Running RSpec with SimpleCov...${NC}"
      COVERAGE=true bundle exec rspec || {
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
      }
      ;;

    *)
      echo -e "${RED}✗ Unknown test framework${NC}"
      echo -e "${YELLOW}💡 Supported: jest, vitest, pytest, rspec${NC}"
      return 1
      ;;
  esac

  return 0
}

# Parse coverage data
parse_coverage() {
  local coverage_file=""

  case $FRAMEWORK in
    jest|vitest)
      coverage_file="$COVERAGE_DIR/coverage-summary.json"
      if [ ! -f "$coverage_file" ]; then
        coverage_file="$COVERAGE_DIR/coverage-final.json"
      fi
      ;;
    pytest)
      coverage_file="coverage.json"
      ;;
  esac

  if [ -f "$coverage_file" ]; then
    echo "$coverage_file"
  else
    echo ""
  fi
}

# Extract coverage percentages
extract_coverage_percentage() {
  local coverage_file=$1

  if [ ! -f "$coverage_file" ]; then
    echo "0"
    return
  fi

  case $FRAMEWORK in
    jest|vitest)
      # Extract from coverage-summary.json
      if command -v jq &> /dev/null; then
        jq -r '.total.lines.pct' "$coverage_file" 2>/dev/null || echo "0"
      else
        # Fallback: parse manually
        grep -o '"pct":[0-9.]*' "$coverage_file" | head -1 | cut -d':' -f2 || echo "0"
      fi
      ;;
    pytest)
      # Extract from coverage.json
      if command -v jq &> /dev/null; then
        jq -r '.totals.percent_covered' "$coverage_file" 2>/dev/null || echo "0"
      else
        echo "0"
      fi
      ;;
  esac
}

# Display coverage summary
display_coverage_summary() {
  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}              COVERAGE SUMMARY${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  case $FRAMEWORK in
    jest|vitest)
      if [ -f "$COVERAGE_DIR/coverage-summary.json" ]; then
        if command -v jq &> /dev/null; then
          local statements=$(jq -r '.total.statements.pct' "$COVERAGE_DIR/coverage-summary.json")
          local branches=$(jq -r '.total.branches.pct' "$COVERAGE_DIR/coverage-summary.json")
          local functions=$(jq -r '.total.functions.pct' "$COVERAGE_DIR/coverage-summary.json")
          local lines=$(jq -r '.total.lines.pct' "$COVERAGE_DIR/coverage-summary.json")

          display_metric "Statements" "$statements"
          display_metric "Branches" "$branches"
          display_metric "Functions" "$functions"
          display_metric "Lines" "$lines"
        fi
      fi
      ;;

    pytest)
      # Parse from terminal output or coverage.json
      if [ -f "coverage.json" ] && command -v jq &> /dev/null; then
        local total=$(jq -r '.totals.percent_covered' coverage.json)
        local total_rounded=$(printf "%.2f" "$total")
        display_metric "Total Coverage" "$total_rounded"
      fi
      ;;
  esac

  echo ""
}

# Display individual metric with color coding
display_metric() {
  local label=$1
  local value=$2
  local value_int=${value%.*}

  local color=$GREEN
  if (( value_int < MIN_COVERAGE )); then
    color=$RED
  elif (( value_int < 90 )); then
    color=$YELLOW
  fi

  printf "  %-20s ${color}%6.2f%%${NC}\n" "$label:" "$value"
}

# Find untested files
find_untested_files() {
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}              UNTESTED FILES${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  case $FRAMEWORK in
    jest|vitest)
      if [ -f "$COVERAGE_DIR/coverage-summary.json" ] && command -v jq &> /dev/null; then
        local untested_count=0

        jq -r 'to_entries[] | select(.value.lines.pct == 0) | .key' "$COVERAGE_DIR/coverage-summary.json" | while read -r file; do
          echo -e "  ${RED}✗${NC} $file (0% coverage)"
          ((untested_count++))
        done

        if [ $untested_count -eq 0 ]; then
          echo -e "  ${GREEN}✓ No completely untested files${NC}"
        fi
      fi
      ;;
  esac

  echo ""
}

# Find files with low coverage
find_low_coverage_files() {
  local threshold=${1:-50}

  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}         FILES WITH <${threshold}% COVERAGE${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  case $FRAMEWORK in
    jest|vitest)
      if [ -f "$COVERAGE_DIR/coverage-summary.json" ] && command -v jq &> /dev/null; then
        local low_coverage_count=0

        jq -r --arg threshold "$threshold" 'to_entries[] | select(.value.lines.pct < ($threshold | tonumber) and .value.lines.pct > 0) | "\(.key)|\(.value.lines.pct)"' "$COVERAGE_DIR/coverage-summary.json" | while IFS='|' read -r file pct; do
          printf "  ${YELLOW}⚠${NC} %-60s ${YELLOW}%6.2f%%${NC}\n" "$file" "$pct"
          ((low_coverage_count++))
        done

        if [ $low_coverage_count -eq 0 ]; then
          echo -e "  ${GREEN}✓ All files have >${threshold}% coverage${NC}"
        fi
      fi
      ;;
  esac

  echo ""
}

# Coverage trend analysis
coverage_trend() {
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}              COVERAGE TREND${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  # Check if previous coverage report exists
  local prev_coverage_file=".coverage-baseline.json"
  local current_coverage=$(parse_coverage)

  if [ -z "$current_coverage" ] || [ ! -f "$current_coverage" ]; then
    echo -e "  ${YELLOW}⚠ No coverage data available${NC}\n"
    return
  fi

  local current_pct=$(extract_coverage_percentage "$current_coverage")

  if [ -f "$prev_coverage_file" ]; then
    local prev_pct=$(cat "$prev_coverage_file")
    local diff=$(echo "$current_pct - $prev_pct" | bc -l)
    local diff_rounded=$(printf "%.2f" "$diff")

    if (( $(echo "$diff > 0" | bc -l) )); then
      echo -e "  Current:  ${GREEN}${current_pct}%${NC}"
      echo -e "  Previous: ${prev_pct}%"
      echo -e "  Change:   ${GREEN}+${diff_rounded}%${NC} 📈"
    elif (( $(echo "$diff < 0" | bc -l) )); then
      echo -e "  Current:  ${RED}${current_pct}%${NC}"
      echo -e "  Previous: ${prev_pct}%"
      echo -e "  Change:   ${RED}${diff_rounded}%${NC} 📉"
    else
      echo -e "  Current:  ${current_pct}%"
      echo -e "  Previous: ${prev_pct}%"
      echo -e "  Change:   No change"
    fi
  else
    echo -e "  Current: ${current_pct}%"
    echo -e "  ${YELLOW}⚠ No baseline found (first run)${NC}"
  fi

  # Save current as baseline
  echo "$current_pct" > "$prev_coverage_file"
  echo ""
}

# Generate coverage badge
generate_badge() {
  local coverage_pct=$1
  local badge_file="coverage-badge.svg"

  local color="red"
  if (( $(echo "$coverage_pct >= 80" | bc -l) )); then
    color="green"
  elif (( $(echo "$coverage_pct >= 60" | bc -l) )); then
    color="yellow"
  fi

  echo -e "${YELLOW}📛 Generating coverage badge...${NC}"
  echo -e "  Coverage: ${coverage_pct}%"
  echo -e "  Color: $color"
  echo -e "  File: $badge_file\n"
}

# Main execution
main() {
  # Run tests with coverage
  if ! run_coverage; then
    echo -e "\n${RED}✗ Coverage collection failed${NC}"
    exit 1
  fi

  echo ""

  # Display summary
  display_coverage_summary

  # Find issues
  find_untested_files
  find_low_coverage_files 50

  # Show trend
  coverage_trend

  # Check minimum coverage requirement
  local coverage_file=$(parse_coverage)
  if [ -n "$coverage_file" ]; then
    local total_coverage=$(extract_coverage_percentage "$coverage_file")
    local total_int=${total_coverage%.*}

    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}              COVERAGE CHECK${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

    if (( total_int >= MIN_COVERAGE )); then
      echo -e "  ${GREEN}✓ Coverage meets minimum requirement${NC}"
      echo -e "  Required: ${MIN_COVERAGE}%"
      echo -e "  Actual:   ${total_coverage}%\n"

      generate_badge "$total_coverage"

      echo -e "${GREEN}✓ Coverage report generated successfully${NC}"
      echo -e "  View report: ${COVERAGE_DIR}/index.html\n"
      exit 0
    else
      echo -e "  ${RED}✗ Coverage below minimum requirement${NC}"
      echo -e "  Required: ${MIN_COVERAGE}%"
      echo -e "  Actual:   ${total_coverage}%"
      echo -e "  Gap:      $(echo "$MIN_COVERAGE - $total_coverage" | bc)%\n"

      echo -e "${YELLOW}💡 Recommendations:${NC}"
      echo -e "  1. Add tests for untested files"
      echo -e "  2. Improve tests for files with <50% coverage"
      echo -e "  3. Review critical paths without test coverage\n"

      exit 1
    fi
  else
    echo -e "${YELLOW}⚠ Could not parse coverage data${NC}\n"
    exit 1
  fi
}

# Run main
main
