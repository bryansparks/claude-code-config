---
description: Run visual regression testing to detect unintended visual changes
---

**Purpose**: Run visual regression testing to detect unintended visual changes

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Run visual regression tests for $ARGUMENTS"

Execute visual regression testing to detect UI changes, ensure pixel-perfect consistency, and prevent visual bugs across browsers and viewports.

## Usage Examples
- `/visual-test --update-baseline`
- `/visual-test --component Button --all-states`
- `/visual-test --page /dashboard --viewports desktop,mobile`
- `/visual-test --browser chrome,firefox,safari`
- `/visual-test --diff --threshold 0.1`

## Command-Specific Flags
--update-baseline: "Update visual baselines with current screenshots"
--component: "Test specific component"
--page: "Test specific page or route"
--all-states: "Capture all component states (hover, focus, etc.)"
--viewports: "Test viewports: desktop, tablet, mobile, or custom"
--browser: "Browsers to test: chrome, firefox, safari, edge"
--diff: "Show visual differences only"
--threshold: "Diff threshold percentage (default: 0.1)"
--ignore-regions: "Areas to exclude from comparison"
--animation: "Disable/wait for animations"
--full-page: "Capture full page (with scroll)"
--storybook: "Test all Storybook stories"
--report: "Generate visual test report"
--approve: "Approve all visual changes"

## Visual Regression Process

**1. Baseline Establishment:**
- Capture initial screenshots
- Store as reference images
- Document viewport and browser
- Version control baselines

**2. Screenshot Capture:**
- Navigate to page/component
- Wait for load complete
- Disable animations
- Capture multiple viewports
- Test interaction states

**3. Comparison:**
- Pixel-by-pixel comparison
- Calculate diff percentage
- Highlight changed areas
- Categorize changes

**4. Review:**
- Review visual diffs
- Determine if intentional
- Approve or reject changes
- Update baselines if approved

**5. Reporting:**
- Generate diff report
- Show before/after images
- List all changed components
- Track visual stability

## Output Format

The visual-test command provides:
1. **Test Summary**: Total screenshots, changes detected
2. **Visual Diffs**: Before/after/diff images
3. **Change Classification**: Expected vs unexpected
4. **Browser Variations**: Cross-browser differences
5. **Viewport Comparison**: Responsive behavior
6. **Approval Workflow**: Accept or reject changes
7. **Baseline Update**: Update reference images

## Visual Testing Strategies

**Component Testing:**
```javascript
// Test all button variants
test.describe('Button Component', () => {
  test('primary button', async ({ page }) => {
    await page.goto('/storybook?path=/story/button--primary');
    await expect(page.locator('button')).toHaveScreenshot('button-primary.png');
  });

  test('primary button hover', async ({ page }) => {
    await page.goto('/storybook?path=/story/button--primary');
    await page.locator('button').hover();
    await expect(page.locator('button')).toHaveScreenshot('button-primary-hover.png');
  });

  test('primary button disabled', async ({ page }) => {
    await page.goto('/storybook?path=/story/button--primary-disabled');
    await expect(page.locator('button')).toHaveScreenshot('button-primary-disabled.png');
  });
});
```

**Page Testing:**
```javascript
// Test full pages
test('homepage desktop', async ({ page }) => {
  await page.setViewportSize({ width: 1920, height: 1080 });
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  await expect(page).toHaveScreenshot('homepage-desktop.png', {
    fullPage: true,
  });
});

test('homepage mobile', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 });
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage-mobile.png', {
    fullPage: true,
  });
});
```

**Interaction State Testing:**
```javascript
const states = ['default', 'hover', 'focus', 'active', 'disabled'];

for (const state of states) {
  test(`button ${state} state`, async ({ page }) => {
    await page.goto('/components/button');
    const button = page.locator(`[data-state="${state}"]`);

    if (state === 'hover') {
      await button.hover();
    } else if (state === 'focus') {
      await button.focus();
    }

    await expect(button).toHaveScreenshot(`button-${state}.png`);
  });
}
```

## Handling Dynamic Content

**Mask Dynamic Elements:**
```javascript
await expect(page).toHaveScreenshot({
  mask: [
    page.locator('[data-testid="timestamp"]'),
    page.locator('[data-testid="user-avatar"]'),
    page.locator('.advertisement'),
  ],
});
```

**Use Fixed Test Data:**
```javascript
// Set up deterministic test data
await page.route('**/api/products', route => {
  route.fulfill({
    status: 200,
    body: JSON.stringify(fixedProductData),
  });
});

await page.goto('/products');
await expect(page).toHaveScreenshot();
```

**Mock Time:**
```javascript
// Fix time-dependent UI
await page.addInitScript(() => {
  Date.now = () => new Date('2024-01-15T12:00:00Z').getTime();
});
```

## Configuration

**Playwright Visual Testing:**
```typescript
// playwright.config.ts
export default defineConfig({
  expect: {
    toHaveScreenshot: {
      maxDiffPixels: 100,           // Allow up to 100px difference
      threshold: 0.2,                // 20% similarity threshold
      animations: 'disabled',        // Disable animations
      caret: 'hide',                 // Hide text cursor
      scale: 'css',                  // CSS pixel scaling
    },
  },
  projects: [
    {
      name: 'Desktop Chrome',
      use: {
        ...devices['Desktop Chrome'],
      },
    },
    {
      name: 'Mobile Safari',
      use: {
        ...devices['iPhone 12'],
      },
    },
  ],
});
```

**Percy Configuration:**
```yaml
# .percy.yml
version: 2
snapshot:
  widths: [375, 768, 1280, 1920]
  min-height: 1024
  percy-css: |
    * {
      animation-duration: 0s !important;
      transition: none !important;
    }
```

## Cross-Browser Testing

**Test Matrix:**
```
Desktop:
  - Chrome (latest)
  - Firefox (latest)
  - Safari (latest)
  - Edge (latest)

Mobile:
  - Safari iOS (iPhone 12, 14)
  - Chrome Android (Pixel 5, 7)
  - Samsung Internet
```

**Browser-Specific Issues:**
```javascript
// Safari renders box-shadow differently
test('button shadow', async ({ page, browserName }) => {
  await page.goto('/components/button');

  await expect(page.locator('button')).toHaveScreenshot(
    `button-shadow-${browserName}.png`
  );
});
```

## Output Example

```
Visual Regression Test Report
=============================

Run ID: 20251004-123456
Baseline: main branch (abc123)
Current: PR #456 - Update button styles

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SUMMARY

Total Screenshots: 156
  ✓ Unchanged: 152 (97.4%)
  ⚠ Changed:   4 (2.6%)
  + New:       0
  - Removed:   0

Status: ⚠ CHANGES DETECTED

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EXPECTED CHANGES (3) ✓

1. Button Primary - Desktop
   Component: Button.tsx (primary variant)
   Viewport: 1920x1080
   Diff: 2.3% pixels changed

   Changes:
     • Border radius: 4px → 8px
     • Padding: 12px 24px → 16px 32px
     • Font weight: 500 → 600

   Related PR: src/components/Button.tsx lines 34-42

   [View Diff] [Approve]

2. Button Primary - Mobile
   Component: Button.tsx (primary variant)
   Viewport: 375x667
   Diff: 2.1% pixels changed

   Same changes as desktop variant

   [View Diff] [Approve]

3. Input Error State
   Component: Input.tsx (error state)
   Viewport: 1920x1080
   Diff: 1.8% pixels changed

   Changes:
     • Error border: #FF0000 → #DC2626
     • Message spacing: 4px → 8px margin-top

   [View Diff] [Approve]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

UNEXPECTED CHANGES (1) ⚠

1. Homepage Hero Section
   Page: / (homepage)
   Viewport: 1920x1080
   Diff: 15.2% pixels changed (HIGH)

   Detected Changes:
     • Hero section shifted down 24px
     • "Learn More" button repositioned
     • Background image crop different

   Visual Comparison:
     Baseline: [Image]
     Current:  [Image]
     Diff:     [Image] (red = changed)

   Root Cause:
     Button CSS changes affected global layout
     Missing scoped styles - padding inherited

   Recommendation: ✗ REJECT
   Action Required: Scope button styles to prevent layout shift

   [View Details] [Reject]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CROSS-BROWSER RESULTS

Desktop Browsers:
  Chrome 120:   ✓ 0 diffs
  Firefox 121:  ✓ 0 diffs
  Safari 17.2:  ⚠ 2 diffs (box-shadow rendering)
  Edge 120:     ✓ 0 diffs

Mobile Browsers:
  Safari iOS:   ✓ 0 diffs
  Chrome Android: ✓ 0 diffs

Safari-Specific Issue:
  Component: Button shadows
  Diff: 0.8% pixels
  Issue: Safari renders box-shadow differently
  Fix: Use explicit shadow spread values

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RESPONSIVE VALIDATION

Tested Viewports:
  Desktop:
    ✓ 1920x1080 (Full HD)
    ✓ 1366x768 (HD)

  Tablet:
    ✓ 768x1024 (iPad Portrait)
    ✓ 1024x768 (iPad Landscape)

  Mobile:
    ✓ 375x667 (iPhone SE)
    ✓ 390x844 (iPhone 14)
    ✓ 360x800 (Android)

No responsive layout issues detected ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RECOMMENDATIONS

Immediate Actions:
  [ ] ✗ BLOCK MERGE - Fix homepage layout shift
  [ ] ⚠ Review Safari box-shadow differences
  [ ] ✓ Approve button style changes (3 items)

Process Improvements:
  [ ] Add visual tests to CI (currently manual)
  [ ] Expand component coverage (missing dropdowns)
  [ ] Add dark mode visual tests
  [ ] Test loading/skeleton states

Baseline Management:
  After fixing layout shift, update baselines:
    npm run visual-test:update-baseline

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files Generated:
  - test-results/visual-diffs/index.html
  - test-results/screenshots/*.png
  - test-results/diffs/*.png

View Full Report:
  npx playwright show-report
```

## Best Practices

**Screenshot Naming:**
```
component-variant-state-viewport.png

Examples:
  button-primary-hover-desktop.png
  input-error-focus-mobile.png
  modal-confirm-open-tablet.png
```

**Wait Strategies:**
```javascript
// Bad: Arbitrary wait
await page.waitForTimeout(3000);

// Good: Wait for specific state
await page.waitForSelector('[data-testid="content"]');
await page.waitForLoadState('networkidle');

// Better: Built-in auto-wait
await expect(page).toHaveScreenshot(); // Waits automatically
```

**Handling Fonts:**
```javascript
// Ensure fonts loaded
await page.waitForFunction(() => document.fonts.ready);
await expect(page).toHaveScreenshot();
```

**Animation Handling:**
```javascript
// Disable all animations
await page.addStyleTag({
  content: `
    *, *::before, *::after {
      animation-duration: 0s !important;
      transition-duration: 0s !important;
    }
  `
});
```

## CI/CD Integration

```yaml
# .github/workflows/visual-regression.yml
name: Visual Regression

on: [pull_request]

jobs:
  visual-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install --with-deps

      - name: Run visual tests
        run: npm run test:visual

      - name: Upload diff images
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: visual-diffs
          path: test-results/**/diff.png

      - name: Comment on PR
        if: failure()
        run: |
          echo "Visual regression detected" >> $GITHUB_STEP_SUMMARY
```
