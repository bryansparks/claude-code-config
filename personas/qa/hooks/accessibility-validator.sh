#!/bin/bash
# Accessibility Validator Hook
# Validates HTML for accessibility issues using axe-core, Pa11y, and other a11y tools

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}♿ Accessibility Validator${NC}\n"

# Configuration
WCAG_LEVEL=${WCAG_LEVEL:-"AA"}  # A, AA, AAA
A11Y_TOOL=${A11Y_TOOL:-"auto"}   # auto, axe, pa11y, lighthouse
FAIL_ON_WARNINGS=${FAIL_ON_WARNINGS:-false}
OUTPUT_FORMAT=${OUTPUT_FORMAT:-"cli"}  # cli, json, html

# Detect which a11y tools are available
detect_a11y_tools() {
  local tools=()

  if command -v npx &> /dev/null; then
    if npm list @axe-core/cli &> /dev/null || npm list -g @axe-core/cli &> /dev/null; then
      tools+=("axe")
    fi
    if npm list pa11y &> /dev/null || npm list -g pa11y &> /dev/null; then
      tools+=("pa11y")
    fi
    if command -v lighthouse &> /dev/null; then
      tools+=("lighthouse")
    fi
  fi

  if [ ${#tools[@]} -eq 0 ]; then
    echo "none"
  else
    printf '%s,' "${tools[@]}" | sed 's/,$//'
  fi
}

AVAILABLE_TOOLS=$(detect_a11y_tools)

if [ "$AVAILABLE_TOOLS" = "none" ]; then
  echo -e "${RED}✗ No accessibility testing tools found${NC}"
  echo -e "${YELLOW}💡 Install one of:${NC}"
  echo -e "  npm install -D @axe-core/cli"
  echo -e "  npm install -D pa11y"
  echo -e "  npm install -g lighthouse"
  exit 1
fi

echo -e "${YELLOW}🔍 Available tools: $AVAILABLE_TOOLS${NC}\n"

# Determine which tool to use
TOOL=$A11Y_TOOL
if [ "$TOOL" = "auto" ]; then
  # Prefer axe, then pa11y, then lighthouse
  if [[ $AVAILABLE_TOOLS == *"axe"* ]]; then
    TOOL="axe"
  elif [[ $AVAILABLE_TOOLS == *"pa11y"* ]]; then
    TOOL="pa11y"
  elif [[ $AVAILABLE_TOOLS == *"lighthouse"* ]]; then
    TOOL="lighthouse"
  fi
fi

echo -e "${YELLOW}Using tool: $TOOL${NC}\n"

# Get URLs to test
get_urls() {
  local urls=()

  # Check if URL provided as argument
  if [ $# -gt 0 ]; then
    urls=("$@")
  # Check if server is running locally
  elif curl -s http://localhost:3000 > /dev/null 2>&1; then
    urls=("http://localhost:3000")
  elif curl -s http://localhost:8080 > /dev/null 2>&1; then
    urls=("http://localhost:8080")
  else
    echo -e "${RED}✗ No URLs provided and no local server detected${NC}"
    echo -e "${YELLOW}💡 Usage: $0 <url1> <url2> ...${NC}"
    echo -e "${YELLOW}💡 Or start local server on port 3000 or 8080${NC}"
    exit 1
  fi

  printf '%s\n' "${urls[@]}"
}

URLS=($(get_urls "$@"))

echo -e "${YELLOW}🔍 Testing URLs:${NC}"
for url in "${URLS[@]}"; do
  echo "  • $url"
done
echo ""

# Run axe-core tests
run_axe() {
  local url=$1
  local result=0

  echo -e "${YELLOW}🪓 Running axe-core...${NC}"

  # Map WCAG level
  local tags="wcag2a,wcag2aa"
  if [ "$WCAG_LEVEL" = "AAA" ]; then
    tags="wcag2a,wcag2aa,wcag2aaa"
  elif [ "$WCAG_LEVEL" = "A" ]; then
    tags="wcag2a"
  fi

  # Run axe
  npx axe "$url" --tags "$tags" --exit || result=$?

  return $result
}

# Run Pa11y tests
run_pa11y() {
  local url=$1
  local result=0

  echo -e "${YELLOW}🔍 Running Pa11y...${NC}"

  # Map WCAG level
  local standard="WCAG2AA"
  if [ "$WCAG_LEVEL" = "AAA" ]; then
    standard="WCAG2AAA"
  elif [ "$WCAG_LEVEL" = "A" ]; then
    standard="WCAG2A"
  fi

  # Run Pa11y
  npx pa11y "$url" --standard "$standard" --reporter cli || result=$?

  return $result
}

# Run Lighthouse accessibility audit
run_lighthouse() {
  local url=$1
  local result=0

  echo -e "${YELLOW}💡 Running Lighthouse accessibility audit...${NC}"

  # Run Lighthouse
  lighthouse "$url" \
    --only-categories=accessibility \
    --output=html \
    --output-path=./lighthouse-a11y-report.html \
    --quiet || result=$?

  # Parse score
  if command -v jq &> /dev/null && [ -f "lighthouse-a11y-report.json" ]; then
    local score=$(jq -r '.categories.accessibility.score' lighthouse-a11y-report.json)
    local score_pct=$(echo "$score * 100" | bc)

    echo -e "\n${YELLOW}Accessibility Score: ${score_pct}%${NC}"

    if (( $(echo "$score_pct >= 90" | bc -l) )); then
      echo -e "${GREEN}✓ Excellent accessibility${NC}"
    elif (( $(echo "$score_pct >= 75" | bc -l) )); then
      echo -e "${YELLOW}⚠ Good, but room for improvement${NC}"
    else
      echo -e "${RED}✗ Poor accessibility - needs improvement${NC}"
      result=1
    fi
  fi

  echo -e "\n${YELLOW}📊 Full report: lighthouse-a11y-report.html${NC}"

  return $result
}

# Run automated keyboard navigation test
test_keyboard_navigation() {
  local url=$1

  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}         KEYBOARD NAVIGATION TEST${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  # This requires Playwright
  if ! npm list @playwright/test &> /dev/null; then
    echo -e "${YELLOW}⚠ Playwright not installed - skipping keyboard test${NC}"
    echo -e "${YELLOW}💡 Install: npm install -D @playwright/test${NC}\n"
    return 0
  fi

  echo -e "${YELLOW}⌨️  Testing keyboard navigation...${NC}"

  # Create temporary keyboard test
  cat > /tmp/a11y-keyboard-test.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test('keyboard navigation', async ({ page }) => {
  await page.goto(process.env.TEST_URL || 'http://localhost:3000');

  // Test tab navigation
  await page.keyboard.press('Tab');
  let focusedElement = await page.evaluate(() => document.activeElement?.tagName);
  expect(focusedElement).toBeTruthy();

  // Check focus visible
  const hasFocusIndicator = await page.evaluate(() => {
    const el = document.activeElement;
    if (!el) return false;

    const styles = window.getComputedStyle(el, ':focus');
    const outline = styles.getPropertyValue('outline');
    const boxShadow = styles.getPropertyValue('box-shadow');

    return outline !== 'none' || boxShadow !== 'none';
  });

  expect(hasFocusIndicator).toBeTruthy();
  console.log('✓ Focus indicator visible');

  // Test skip link
  await page.keyboard.press('Tab');
  const skipLink = await page.evaluate(() => {
    const el = document.activeElement;
    return el?.textContent?.toLowerCase().includes('skip');
  });

  if (skipLink) {
    console.log('✓ Skip link found');
  } else {
    console.log('⚠ No skip link detected');
  }
});
EOF

  TEST_URL="$url" npx playwright test /tmp/a11y-keyboard-test.spec.ts || {
    echo -e "${RED}✗ Keyboard navigation test failed${NC}"
    return 1
  }

  echo -e "${GREEN}✓ Keyboard navigation test passed${NC}\n"
  return 0
}

# Test color contrast
test_color_contrast() {
  local url=$1

  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}            COLOR CONTRAST TEST${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  echo -e "${YELLOW}🎨 Testing color contrast...${NC}"

  # This is typically covered by axe/pa11y but we can do additional checks
  # Create a contrast checker script
  cat > /tmp/contrast-check.js << 'EOF'
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.goto(process.argv[2] || 'http://localhost:3000');

  const contrastIssues = await page.evaluate(() => {
    const issues = [];

    const checkContrast = (fg, bg) => {
      // Simple contrast ratio calculation
      const getLuminance = (color) => {
        const rgb = color.match(/\d+/g).map(Number);
        const [r, g, b] = rgb.map(val => {
          val = val / 255;
          return val <= 0.03928 ? val / 12.92 : Math.pow((val + 0.055) / 1.055, 2.4);
        });
        return 0.2126 * r + 0.7152 * g + 0.0722 * b;
      };

      const l1 = getLuminance(fg);
      const l2 = getLuminance(bg);
      const ratio = (Math.max(l1, l2) + 0.05) / (Math.min(l1, l2) + 0.05);

      return ratio;
    };

    document.querySelectorAll('*').forEach(el => {
      const styles = window.getComputedStyle(el);
      const fg = styles.color;
      const bg = styles.backgroundColor;

      if (fg && bg && bg !== 'rgba(0, 0, 0, 0)') {
        const ratio = checkContrast(fg, bg);

        if (ratio < 4.5) {
          issues.push({
            element: el.tagName,
            text: el.textContent?.substring(0, 50),
            ratio: ratio.toFixed(2),
            fg,
            bg
          });
        }
      }
    });

    return issues;
  });

  console.log(`Found ${contrastIssues.length} potential contrast issues`);

  await browser.close();
})();
EOF

  if command -v node &> /dev/null && npm list puppeteer &> /dev/null 2>&1; then
    node /tmp/contrast-check.js "$url" || true
  else
    echo -e "${YELLOW}⚠ Puppeteer not available - using axe/pa11y results${NC}"
  fi

  echo ""
}

# Generate summary report
generate_summary() {
  local total_urls=$1
  local failed_urls=$2

  echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}           ACCESSIBILITY SUMMARY${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

  echo -e "  WCAG Level: ${WCAG_LEVEL}"
  echo -e "  Tool Used: ${TOOL}"
  echo -e "  URLs Tested: ${total_urls}"
  echo -e "  Failed: ${failed_urls}"

  if [ "$failed_urls" -eq 0 ]; then
    echo -e "\n  ${GREEN}✓ All accessibility tests passed${NC}\n"
  else
    echo -e "\n  ${RED}✗ ${failed_urls} URL(s) failed accessibility tests${NC}\n"
  fi

  echo -e "${YELLOW}💡 Next Steps:${NC}"
  echo -e "  1. Review detailed errors above"
  echo -e "  2. Fix critical issues (P0)"
  echo -e "  3. Test manually with screen reader"
  echo -e "  4. Validate keyboard navigation"
  echo -e "  5. Run visual regression tests\n"
}

# Main execution
main() {
  local total_failures=0
  local total_urls=${#URLS[@]}

  for url in "${URLS[@]}"; do
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Testing: $url${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"

    local url_failed=false

    # Run selected tool
    case $TOOL in
      axe)
        run_axe "$url" || url_failed=true
        ;;
      pa11y)
        run_pa11y "$url" || url_failed=true
        ;;
      lighthouse)
        run_lighthouse "$url" || url_failed=true
        ;;
    esac

    # Run additional tests
    test_keyboard_navigation "$url" || url_failed=true

    if [ "$url_failed" = true ]; then
      ((total_failures++))
      echo -e "\n${RED}✗ Accessibility issues found for $url${NC}\n"
    else
      echo -e "\n${GREEN}✓ No accessibility issues found for $url${NC}\n"
    fi
  done

  # Generate summary
  generate_summary "$total_urls" "$total_failures"

  # Exit with appropriate code
  if [ "$total_failures" -gt 0 ]; then
    exit 1
  else
    exit 0
  fi
}

# Run main
main "$@"
