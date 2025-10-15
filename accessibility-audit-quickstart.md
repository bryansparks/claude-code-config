# Accessibility Audit Quick Start Guide

## Overview
This guide helps you run a complete WCAG 2.1 AA accessibility audit on any product listing page using automated and manual testing tools.

---

## Prerequisites

### 1. Install Required Tools

```bash
# Install Playwright and axe-core
npm install -D @playwright/test @axe-core/playwright

# Install Playwright browsers
npx playwright install

# Install axe DevTools CLI (optional)
npm install -g @axe-core/cli

# Install Pa11y (optional)
npm install -g pa11y
```

### 2. Verify MCP Servers

```bash
# Check available MCP servers
claude mcp list

# Required: playwright MCP should show as connected
# Optional: a11y MCP (if available)
```

---

## Running the Audit

### Step 1: Configure Test URL

Edit `accessibility-test-suite.js` and set your product listing URL:

```javascript
const PRODUCT_URL = 'https://your-site.com/products';
```

Or set as environment variable:

```bash
export PRODUCT_URL="https://your-site.com/products"
```

### Step 2: Run Automated Tests

```bash
# Run all accessibility tests
npx playwright test accessibility-test-suite.js

# Run with visual browser (see what's happening)
npx playwright test accessibility-test-suite.js --headed

# Run specific test category
npx playwright test accessibility-test-suite.js --grep "P0"

# Generate HTML report
npx playwright test accessibility-test-suite.js --reporter=html
npx playwright show-report
```

### Step 3: Review Results

Test results will show:
- ✅ **PASS** - No accessibility issues detected
- ❌ **FAIL** - Violations found (see console output for details)

Console output includes:
- Violation severity (critical, serious, moderate, minor)
- WCAG success criteria violated
- Affected HTML elements
- Suggested fixes

---

## Test Categories

### Critical (P0) - Must Fix Before Release
```bash
npx playwright test accessibility-test-suite.js --grep "P0"
```
Tests:
- Keyboard navigation
- Screen reader compatibility
- Color contrast
- Form labels
- ARIA attributes
- Semantic HTML

### High Priority (P1) - Fix Within Sprint
```bash
npx playwright test accessibility-test-suite.js --grep "P1"
```
Tests:
- Language declaration
- Focus order
- Touch target sizes
- Heading structure

### Medium Priority (P2) - Fix Next Sprint
```bash
npx playwright test accessibility-test-suite.js --grep "P2"
```
Tests:
- Responsive design
- Link purpose clarity
- Content reflow
- Zoom support

---

## Manual Testing Checklist

### Keyboard Navigation Testing

1. **Test Tab Navigation**
   ```
   - Press Tab key repeatedly
   - Verify all interactive elements receive focus
   - Check focus indicator is visible
   - Ensure logical tab order
   - No keyboard traps
   ```

2. **Test Functionality**
   ```
   - Enter key activates buttons/links
   - Space key activates buttons/checkboxes
   - Arrow keys work in dropdowns
   - Escape closes modals
   - Skip links function correctly
   ```

### Screen Reader Testing

**NVDA (Windows - FREE)**
```
1. Download from https://www.nvaccess.org/
2. Start NVDA (Ctrl + Alt + N)
3. Navigate with:
   - Down arrow: Next item
   - H: Next heading
   - Tab: Next focusable
   - NVDA + Space: Browse/Focus mode
```

**VoiceOver (macOS - Built-in)**
```
1. Enable: System Preferences → Accessibility → VoiceOver
2. Start: Cmd + F5
3. Navigate with:
   - VO + Right arrow: Next item
   - VO + Cmd + H: Next heading
   - Tab: Next focusable
   - VO = Ctrl + Option
```

**Screen Reader Test Checklist**
```
□ Page title is announced
□ All headings are announced with level
□ Images have descriptive alt text
□ Buttons have clear labels
□ Form inputs have associated labels
□ Error messages are announced
□ Dynamic content changes announced
□ Navigation structure is clear
```

### Color Contrast Testing

**Browser DevTools Method**
```
1. Open DevTools (F12)
2. Select element
3. Styles panel → Check contrast ratio
4. Look for AA/AAA badges
```

**Manual Verification**
```
- Use WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Minimum ratios:
  - Normal text: 4.5:1
  - Large text (18pt+): 3:1
  - UI components: 3:1
```

---

## Additional Testing Tools

### Browser Extensions

**axe DevTools** (Recommended)
```
1. Install from Chrome/Firefox store
2. Open DevTools → axe tab
3. Click "Scan ALL of my page"
4. Review violations by severity
```

**WAVE**
```
1. Install from Chrome/Firefox store
2. Click WAVE icon in toolbar
3. Review visual indicators on page
4. Check Details panel for issues
```

**Accessibility Insights**
```
1. Install from Microsoft
2. Click extension → FastPass
3. Follow automated + manual tests
4. Generate assessment report
```

### Command Line Tools

**Lighthouse**
```bash
# Run accessibility audit
npx lighthouse https://your-site.com/products --only-categories=accessibility --view

# CI/CD integration
npm install -g @lhci/cli
lhci autorun --collect.url=https://your-site.com/products
```

**axe-core CLI**
```bash
# Run axe audit
axe https://your-site.com/products --tags wcag2a,wcag2aa

# Save results as JSON
axe https://your-site.com/products --save accessibility-results.json
```

**Pa11y**
```bash
# Run Pa11y audit
pa11y https://your-site.com/products --standard WCAG2AA --reporter json

# Test multiple URLs
pa11y-ci --sitemap https://your-site.com/sitemap.xml
```

---

## Interpreting Results

### Severity Levels

| Level | Priority | Action Required |
|-------|----------|-----------------|
| **Critical** | P0 | Block release, fix immediately |
| **Serious** | P1 | Fix within current sprint |
| **Moderate** | P2 | Fix in next sprint |
| **Minor** | P3 | Fix when possible |

### Common Violations

**"color-contrast"**
- Issue: Text doesn't meet minimum contrast ratio
- Fix: Darken text or lighten background

**"button-name"**
- Issue: Button has no accessible name
- Fix: Add aria-label or visible text

**"label"**
- Issue: Form input missing label
- Fix: Add <label> or aria-label

**"link-name"**
- Issue: Link has no accessible name
- Fix: Add descriptive text or aria-label

**"image-alt"**
- Issue: Image missing alt attribute
- Fix: Add alt text (or alt="" for decorative)

**"heading-order"**
- Issue: Heading levels skip (h1 → h3)
- Fix: Use sequential heading levels

---

## Generating Reports

### HTML Report (Playwright)
```bash
npx playwright test accessibility-test-suite.js --reporter=html
npx playwright show-report
```

### JSON Report (for CI/CD)
```bash
npx playwright test accessibility-test-suite.js --reporter=json > accessibility-report.json
```

### Update Audit Document
After running tests, update `WCAG_ACCESSIBILITY_AUDIT_REPORT.md` with:
1. Actual violation counts by priority
2. Screenshots of failures
3. Specific affected elements from your page
4. Estimated remediation effort

---

## CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/accessibility.yml`:

```yaml
name: Accessibility Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  a11y-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright
        run: npx playwright install --with-deps

      - name: Run accessibility tests
        run: npx playwright test accessibility-test-suite.js
        env:
          PRODUCT_URL: ${{ secrets.STAGING_URL }}

      - name: Upload test results
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: accessibility-report
          path: |
            test-results/
            playwright-report/

      - name: Comment PR with results
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '🧪 Accessibility tests completed. Check workflow for results.'
            })
```

### Quality Gate

Add to `package.json`:
```json
{
  "scripts": {
    "test:a11y": "playwright test accessibility-test-suite.js",
    "test:a11y:critical": "playwright test accessibility-test-suite.js --grep 'P0'",
    "precommit": "npm run test:a11y:critical"
  }
}
```

---

## Troubleshooting

### Tests Timing Out
```bash
# Increase timeout
npx playwright test accessibility-test-suite.js --timeout=60000
```

### Element Not Found
- Verify page loaded completely
- Check selector accuracy
- Add `await page.waitForSelector('...')`

### False Positives
```javascript
// Disable specific rules if needed
const results = await new AxeBuilder({ page })
  .disableRules(['color-contrast']) // Only if justified
  .analyze();
```

### Can't Install Playwright
```bash
# Try with sudo (macOS/Linux)
sudo npx playwright install

# Or install specific browser
npx playwright install chromium
```

---

## Best Practices

1. **Run Tests Regularly**
   - Every pull request
   - Before production deployments
   - After major UI changes

2. **Fix by Priority**
   - P0 issues block release
   - P1 issues must be scheduled
   - P2/P3 tracked in backlog

3. **Document Exceptions**
   - If violation cannot be fixed, document why
   - Add to known issues list
   - Plan alternative solution

4. **Test with Real Users**
   - Automated tests catch ~30-50% of issues
   - Manual testing catches ~70%
   - User testing catches ~90%
   - Include users with disabilities

5. **Continuous Monitoring**
   - Set up synthetic monitoring
   - Track accessibility metrics over time
   - Monitor error logs for a11y issues

---

## Resources

### WCAG Guidelines
- **WCAG 2.1 Quick Reference**: https://www.w3.org/WAI/WCAG21/quickref/
- **How to Meet WCAG**: https://www.w3.org/WAI/WCAG21/Understanding/

### Testing Tools
- **axe DevTools**: https://www.deque.com/axe/devtools/
- **WAVE**: https://wave.webaim.org/
- **Pa11y**: https://pa11y.org/
- **Lighthouse**: https://developers.google.com/web/tools/lighthouse

### Screen Readers
- **NVDA** (Windows): https://www.nvaccess.org/
- **JAWS** (Windows): https://www.freedomscientific.com/products/software/jaws/
- **VoiceOver** (macOS/iOS): Built-in
- **TalkBack** (Android): Built-in

### Learning Resources
- **WebAIM**: https://webaim.org/
- **A11y Project**: https://www.a11yproject.com/
- **MDN Accessibility**: https://developer.mozilla.org/en-US/docs/Web/Accessibility

---

## Support

For issues or questions:
1. Review `WCAG_ACCESSIBILITY_AUDIT_REPORT.md` for detailed findings
2. Check test console output for specific violations
3. Consult WCAG documentation for success criteria
4. Use browser DevTools accessibility panel

**Remember:** Accessibility is a journey, not a destination. Continuous improvement is key!
