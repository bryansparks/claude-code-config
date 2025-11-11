---
name: visual-regression
description: UI change detection, screenshot comparison, and visual testing strategy. Use when user requests visual testing, wants to detect UI changes, needs screenshot comparison, or asks about visual regression testing.
---

# Visual Regression Testing Skill

Detect unintended UI changes through automated screenshot comparison and visual diff analysis.

## When to Use This Skill

Automatically invoke when the user:
- Requests visual regression testing
- Wants to detect UI changes
- Asks about screenshot comparison
- Mentions "visual testing" or "visual bugs"
- Wants to validate UI after refactoring
- Needs to test responsive design across devices

## Visual Testing Strategy

### 1. Baseline Creation
Capture screenshots of known-good UI state:
- Critical user flows
- All responsive breakpoints (mobile, tablet, desktop)
- Different states (hover, focus, error, disabled)
- Cross-browser (Chrome, Firefox, Safari)

### 2. Comparison Testing
Capture new screenshots and compare against baselines:
- Pixel-perfect diff highlighting
- Percentage difference calculation
- Ignore dynamic content (dates, IDs)
- Threshold configuration (tolerance levels)

### 3. Review and Approval
- Review visual diffs
- Approve intentional changes (update baselines)
- Reject unintended changes (fix bugs)

## Output Format

```
📸 VISUAL REGRESSION TEST REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Summary
  • Pages Tested: 15
  • Screenshots: 45 (3 breakpoints each)
  • Passed: 38 (84%)
  • Changed: 7 (16%)
  • Threshold: 0.1% pixel difference

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ CHANGED - Requires Review (7)

[1] Homepage Hero Section
  • Page: /
  • Breakpoint: Desktop (1920x1080)
  • Difference: 2.4% pixels changed
  • Status: Exceeds threshold (0.1%)

  Changes Detected:
  - CTA button color: #007bff → #0056b3 (darker blue)
  - Button text size: 16px → 18px (larger)
  - Margin-top increased: 20px → 30px

  Impact: Intentional design change
  Action: ✓ Approve and update baseline

[2] Login Form Error State
  • Page: /login
  • Breakpoint: Mobile (375x667)
  • Difference: 5.1% pixels changed
  • Status: Significant change

  Changes Detected:
  - Error message position shifted down 10px
  - Submit button overlapping error text
  - Red border color changed

  Impact: Layout bug - button overlaps error
  Action: ✗ Reject - Fix required

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ PASSED - No Changes (38)

  • Homepage (mobile, tablet, desktop)
  • Product Listing Page (all breakpoints)
  • Product Detail Page (all breakpoints)
  • Shopping Cart (all breakpoints)
  • Checkout Flow (all breakpoints)
  [...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Implementation (Playwright)

```typescript
import { test, expect } from '@playwright/test';

test.describe('Visual Regression Tests', () => {
  // Test responsive breakpoints
  const breakpoints = [
    { name: 'mobile', width: 375, height: 667 },
    { name: 'tablet', width: 768, height: 1024 },
    { name: 'desktop', width: 1920, height: 1080 }
  ];

  for (const bp of breakpoints) {
    test(`homepage should match baseline - ${bp.name}`, async ({ page }) => {
      // Set viewport
      await page.setViewportSize({ width: bp.width, height: bp.height });

      // Navigate and wait for stable state
      await page.goto('/');
      await page.waitForLoadState('networkidle');

      // Mask dynamic content
      await page.addStyleTag({
        content: `
          [data-testid="timestamp"],
          [data-testid="user-id"] {
            visibility: hidden !important;
          }
        `
      });

      // Disable animations
      await page.emulateMedia({ reducedMotion: 'reduce' });

      // Take screenshot and compare
      await expect(page).toHaveScreenshot(`homepage-${bp.name}.png`, {
        maxDiffPixels: 100,  // Allow 100 pixels difference
        threshold: 0.2        // 20% per-pixel color difference tolerance
      });
    });
  }
});
```

## Best Practices

1. **Mask Dynamic Content**: Hide timestamps, user IDs, random data
2. **Disable Animations**: Use `prefers-reduced-motion` for consistency
3. **Wait for Stability**: Use `networkidle` before screenshots
4. **Set Thresholds**: Define acceptable pixel difference levels
5. **Test Critical Paths**: Focus on important user journeys
6. **Cross-Browser**: Test on Chrome, Firefox, Safari
7. **Responsive**: Test all breakpoints
8. **CI/CD Integration**: Run on every PR

---

**Remember**: Visual regression catches UI bugs that unit tests miss, ensuring pixel-perfect user experiences across devices and browsers.
