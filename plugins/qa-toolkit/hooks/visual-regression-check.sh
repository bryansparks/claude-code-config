#!/bin/bash
# Visual Regression Check Hook
# Runs visual regression tests using Playwright or other visual testing tools

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}👁️  Visual Regression Testing${NC}\n"

# Configuration
UPDATE_BASELINE=${UPDATE_BASELINE:-false}
DIFF_THRESHOLD=${DIFF_THRESHOLD:-0.2}
MAX_DIFF_PIXELS=${MAX_DIFF_PIXELS:-100}
VIEWPORTS=${VIEWPORTS:-"desktop,mobile,tablet"}

# Detect visual testing tool
detect_visual_tool() {
  if [ -f "package.json" ]; then
    if grep -q "@playwright/test" package.json; then
      echo "playwright"
    elif grep -q "percy" package.json || grep -q "@percy/cli" package.json; then
      echo "percy"
    elif grep -q "chromatic" package.json; then
      echo "chromatic"
    elif grep -q "backstopjs" package.json; then
      echo "backstop"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

TOOL=$(detect_visual_tool)
echo -e "${YELLOW}🔍 Detected visual testing tool: $TOOL${NC}\n"

# Setup viewport configurations
setup_viewports() {
  IFS=',' read -ra VIEWPORT_ARRAY <<< "$VIEWPORTS"

  echo -e "${YELLOW}📱 Testing viewports:${NC}"
  for viewport in "${VIEWPORT_ARRAY[@]}"; do
    case $viewport in
      desktop)
        echo "  • Desktop: 1920x1080"
        ;;
      mobile)
        echo "  • Mobile: 375x667 (iPhone SE)"
        ;;
      tablet)
        echo "  • Tablet: 768x1024 (iPad)"
        ;;
    esac
  done
  echo ""
}

# Run Playwright visual tests
run_playwright_visual() {
  echo -e "${YELLOW}🎭 Running Playwright visual tests...${NC}\n"

  # Check if Playwright is installed
  if ! command -v npx &> /dev/null; then
    echo -e "${RED}✗ npx not found. Please install Node.js${NC}"
    return 1
  fi

  # Create or update Playwright config for visual testing
  if [ ! -f "playwright.config.ts" ] && [ ! -f "playwright.config.js" ]; then
    echo -e "${YELLOW}⚠ No Playwright config found${NC}"
    echo -e "${YELLOW}💡 Creating basic visual test config...${NC}"

    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    trace: 'on-first-retry',
  },
  expect: {
    toHaveScreenshot: {
      maxDiffPixels: 100,
      threshold: 0.2,
      animations: 'disabled',
    },
  },
  projects: [
    {
      name: 'Desktop Chrome',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'Tablet',
      use: {
        viewport: { width: 768, height: 1024 },
      },
    },
  ],
});
EOF
  fi

  # Run visual tests
  if [ "$UPDATE_BASELINE" = "true" ]; then
    echo -e "${YELLOW}📸 Updating visual baselines...${NC}"
    npx playwright test --update-snapshots || {
      echo -e "${RED}✗ Failed to update baselines${NC}"
      return 1
    }
    echo -e "${GREEN}✓ Baselines updated successfully${NC}"
  else
    echo -e "${YELLOW}🔍 Comparing against baselines...${NC}"
    npx playwright test || {
      local exit_code=$?
      echo -e "\n${RED}✗ Visual regression detected${NC}"

      # Show test results
      if [ -d "test-results" ]; then
        echo -e "\n${YELLOW}📊 Visual diffs found in:${NC}"
        find test-results -name "*-diff.png" | while read -r diff; do
          echo -e "  ${RED}✗${NC} $diff"
        done

        echo -e "\n${YELLOW}💡 To review diffs:${NC}"
        echo -e "  1. Open: test-results/index.html"
        echo -e "  2. Or run: npx playwright show-report"
        echo -e "\n${YELLOW}💡 To update baselines if changes are intentional:${NC}"
        echo -e "  UPDATE_BASELINE=true $0"
      fi

      return $exit_code
    }

    echo -e "${GREEN}✓ All visual tests passed${NC}"
  fi

  return 0
}

# Run Percy visual tests
run_percy_visual() {
  echo -e "${YELLOW}🦅 Running Percy visual tests...${NC}\n"

  if ! command -v npx &> /dev/null; then
    echo -e "${RED}✗ npx not found${NC}"
    return 1
  fi

  # Check for Percy token
  if [ -z "${PERCY_TOKEN:-}" ]; then
    echo -e "${RED}✗ PERCY_TOKEN not set${NC}"
    echo -e "${YELLOW}💡 Set PERCY_TOKEN environment variable${NC}"
    return 1
  fi

  echo -e "${YELLOW}🔍 Running tests with Percy...${NC}"
  npx percy exec -- npm test || {
    echo -e "${RED}✗ Percy tests failed${NC}"
    echo -e "${YELLOW}💡 Check Percy dashboard for visual diffs${NC}"
    return 1
  }

  echo -e "${GREEN}✓ Percy tests completed${NC}"
  echo -e "${YELLOW}📊 View results: https://percy.io${NC}"

  return 0
}

# Run Chromatic visual tests
run_chromatic_visual() {
  echo -e "${YELLOW}🎨 Running Chromatic visual tests...${NC}\n"

  if ! command -v npx &> /dev/null; then
    echo -e "${RED}✗ npx not found${NC}"
    return 1
  fi

  # Check for Chromatic token
  if [ -z "${CHROMATIC_PROJECT_TOKEN:-}" ]; then
    echo -e "${RED}✗ CHROMATIC_PROJECT_TOKEN not set${NC}"
    echo -e "${YELLOW}💡 Set CHROMATIC_PROJECT_TOKEN environment variable${NC}"
    return 1
  fi

  echo -e "${YELLOW}🔍 Running Chromatic...${NC}"
  npx chromatic --exit-zero-on-changes || {
    echo -e "${RED}✗ Chromatic tests failed${NC}"
    return 1
  }

  echo -e "${GREEN}✓ Chromatic tests completed${NC}"

  return 0
}

# Run BackstopJS visual tests
run_backstop_visual() {
  echo -e "${YELLOW}🎯 Running BackstopJS visual tests...${NC}\n"

  if ! command -v npx &> /dev/null; then
    echo -e "${RED}✗ npx not found${NC}"
    return 1
  fi

  if [ "$UPDATE_BASELINE" = "true" ]; then
    echo -e "${YELLOW}📸 Updating reference images...${NC}"
    npx backstop reference || {
      echo -e "${RED}✗ Failed to create references${NC}"
      return 1
    }
    echo -e "${GREEN}✓ Reference images updated${NC}"
  else
    echo -e "${YELLOW}🔍 Running visual comparison...${NC}"
    npx backstop test || {
      echo -e "${RED}✗ Visual differences detected${NC}"
      echo -e "\n${YELLOW}💡 To review diffs:${NC}"
      echo -e "  npx backstop openReport"
      echo -e "\n${YELLOW}💡 To approve changes:${NC}"
      echo -e "  npx backstop approve"
      return 1
    }

    echo -e "${GREEN}✓ All visual tests passed${NC}"
  fi

  return 0
}

# Analyze visual diffs
analyze_diffs() {
  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}              DIFF ANALYSIS${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  case $TOOL in
    playwright)
      if [ -d "test-results" ]; then
        local total_diffs=$(find test-results -name "*-diff.png" | wc -l | xargs)
        local total_actual=$(find test-results -name "*-actual.png" | wc -l | xargs)

        echo -e "  Total Screenshots: $total_actual"
        echo -e "  Visual Diffs: ${RED}$total_diffs${NC}"

        if [ "$total_diffs" -gt 0 ]; then
          echo -e "\n  ${YELLOW}Changed Screenshots:${NC}"
          find test-results -name "*-diff.png" | while read -r diff; do
            local test_name=$(basename "$diff" -diff.png)
            echo -e "    • $test_name"
          done
        fi
      fi
      ;;
    backstop)
      if [ -f "backstop_data/bitmaps_test/report.json" ]; then
        echo -e "  ${YELLOW}Report available at:${NC}"
        echo -e "  backstop_data/html_report/index.html"
      fi
      ;;
  esac

  echo ""
}

# Generate visual test report
generate_report() {
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}              VISUAL TEST REPORT${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  case $TOOL in
    playwright)
      echo -e "  ${YELLOW}View detailed report:${NC}"
      echo -e "  npx playwright show-report"
      echo -e "\n  ${YELLOW}Or open:${NC}"
      echo -e "  playwright-report/index.html"
      ;;
    percy)
      echo -e "  ${YELLOW}View Percy dashboard:${NC}"
      echo -e "  https://percy.io"
      ;;
    chromatic)
      echo -e "  ${YELLOW}View Chromatic dashboard:${NC}"
      echo -e "  https://chromatic.com"
      ;;
    backstop)
      echo -e "  ${YELLOW}View BackstopJS report:${NC}"
      echo -e "  backstop_data/html_report/index.html"
      ;;
  esac

  echo ""
}

# Main execution
main() {
  setup_viewports

  local result=0

  case $TOOL in
    playwright)
      run_playwright_visual || result=$?
      ;;
    percy)
      run_percy_visual || result=$?
      ;;
    chromatic)
      run_chromatic_visual || result=$?
      ;;
    backstop)
      run_backstop_visual || result=$?
      ;;
    *)
      echo -e "${RED}✗ No visual testing tool detected${NC}"
      echo -e "${YELLOW}💡 Install one of: @playwright/test, @percy/cli, chromatic, backstopjs${NC}"
      exit 1
      ;;
  esac

  if [ $result -ne 0 ]; then
    analyze_diffs
    generate_report
    echo -e "${RED}✗ Visual regression tests failed${NC}\n"
    exit $result
  fi

  generate_report
  echo -e "${GREEN}✓ Visual regression tests passed${NC}\n"
  exit 0
}

# Run main
main
