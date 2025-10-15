/**
 * WCAG 2.1 AA Accessibility Test Suite
 * Product Listing Page - Automated Testing with Playwright + axe-core
 *
 * Usage:
 *   npm install -D @playwright/test @axe-core/playwright
 *   npx playwright test accessibility-test-suite.js --headed
 *
 * Configuration:
 *   Set PRODUCT_URL environment variable or update in test
 */

import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

// Configuration
const PRODUCT_URL = process.env.PRODUCT_URL || 'https://example.com/products';
const VIEWPORT_SIZES = {
  mobile: { width: 375, height: 667 },
  tablet: { width: 768, height: 1024 },
  desktop: { width: 1920, height: 1080 }
};

test.describe('WCAG 2.1 AA Compliance - Product Listing Page', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto(PRODUCT_URL);
    // Wait for page to be fully loaded
    await page.waitForLoadState('networkidle');
  });

  // ========================================
  // CRITICAL (P0) TESTS
  // ========================================

  test('[P0] No automatically detectable WCAG violations', async ({ page }) => {
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();

    // Log violations for debugging
    if (accessibilityScanResults.violations.length > 0) {
      console.log('\n========== WCAG VIOLATIONS ==========');
      accessibilityScanResults.violations.forEach((violation, index) => {
        console.log(`\n${index + 1}. ${violation.id} (${violation.impact})`);
        console.log(`   Description: ${violation.description}`);
        console.log(`   WCAG: ${violation.tags.filter(t => t.startsWith('wcag')).join(', ')}`);
        console.log(`   Affected elements: ${violation.nodes.length}`);
        violation.nodes.forEach(node => {
          console.log(`   - ${node.html}`);
          console.log(`     ${node.failureSummary}`);
        });
      });
      console.log('\n====================================\n');
    }

    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('[P0] Keyboard navigation - All interactive elements accessible', async ({ page }) => {
    const interactiveSelectors = [
      'a[href]',
      'button',
      'input',
      'select',
      'textarea',
      '[tabindex]:not([tabindex="-1"])'
    ];

    const interactiveElements = await page.locator(
      interactiveSelectors.join(', ')
    ).all();

    console.log(`Found ${interactiveElements.length} interactive elements`);

    // Test tab navigation
    let tabCount = 0;
    const maxTabs = Math.min(interactiveElements.length, 50); // Limit for performance

    for (let i = 0; i < maxTabs; i++) {
      await page.keyboard.press('Tab');
      tabCount++;

      const activeElement = await page.evaluate(() => ({
        tag: document.activeElement?.tagName,
        role: document.activeElement?.getAttribute('role'),
        label: document.activeElement?.getAttribute('aria-label'),
        text: document.activeElement?.textContent?.trim().substring(0, 50)
      }));

      // Verify focus is not on body (lost focus)
      expect(activeElement.tag).not.toBe('BODY');

      // Check focus visibility
      const hasFocusIndicator = await page.evaluate(() => {
        const element = document.activeElement;
        const styles = window.getComputedStyle(element);
        return (
          styles.outline !== 'none' ||
          styles.outlineWidth !== '0px' ||
          element.matches(':focus-visible')
        );
      });

      if (!hasFocusIndicator) {
        console.warn(`Element ${i + 1} has no visible focus indicator:`, activeElement);
      }
    }

    expect(tabCount).toBeGreaterThan(0);
  });

  test('[P0] Skip links present and functional', async ({ page }) => {
    // Find skip link (should be first focusable element)
    await page.keyboard.press('Tab');

    const firstFocusedElement = await page.evaluate(() => ({
      tag: document.activeElement?.tagName,
      text: document.activeElement?.textContent?.trim(),
      href: document.activeElement?.getAttribute('href')
    }));

    // Check if it's a skip link
    const isSkipLink = firstFocusedElement.text?.toLowerCase().includes('skip') ||
                       firstFocusedElement.href?.startsWith('#');

    if (!isSkipLink) {
      console.warn('No skip link detected as first focusable element');
    }

    expect(isSkipLink).toBe(true);

    // Test skip link functionality
    if (firstFocusedElement.href?.startsWith('#')) {
      await page.keyboard.press('Enter');
      await page.waitForTimeout(500);

      const newFocusedElement = await page.evaluate(() =>
        document.activeElement?.id || document.activeElement?.tagName
      );

      expect(newFocusedElement).not.toBe('BODY');
    }
  });

  test('[P0] Color contrast - All text meets 4.5:1 ratio', async ({ page }) => {
    const contrastResults = await new AxeBuilder({ page })
      .withTags(['wcag2aa'])
      .include('*')
      .disableRules([
        'region',
        'landmark-one-main',
        'page-has-heading-one',
        'document-title'
      ])
      .analyze();

    const contrastViolations = contrastResults.violations.filter(
      v => v.id === 'color-contrast'
    );

    if (contrastViolations.length > 0) {
      console.log('\n========== COLOR CONTRAST FAILURES ==========');
      contrastViolations.forEach(violation => {
        violation.nodes.forEach(node => {
          console.log(`\nElement: ${node.html.substring(0, 100)}`);
          console.log(`Issue: ${node.failureSummary}`);
        });
      });
      console.log('\n============================================\n');
    }

    expect(contrastViolations.length).toBe(0);
  });

  test('[P0] ARIA labels on icon buttons', async ({ page }) => {
    // Find all buttons
    const buttons = await page.locator('button').all();

    for (const button of buttons) {
      const buttonInfo = await button.evaluate(el => ({
        text: el.textContent?.trim(),
        ariaLabel: el.getAttribute('aria-label'),
        ariaLabelledby: el.getAttribute('aria-labelledby'),
        title: el.getAttribute('title'),
        hasIcon: el.querySelector('svg, i, [class*="icon"]') !== null
      }));

      // If button has icon but no text, it must have aria-label
      if (buttonInfo.hasIcon && !buttonInfo.text) {
        const hasAccessibleName = buttonInfo.ariaLabel ||
                                  buttonInfo.ariaLabelledby ||
                                  buttonInfo.title;

        if (!hasAccessibleName) {
          const html = await button.evaluate(el => el.outerHTML.substring(0, 100));
          console.error(`Button without accessible name: ${html}`);
        }

        expect(hasAccessibleName).toBeTruthy();
      }
    }
  });

  test('[P0] Form inputs have labels', async ({ page }) => {
    const inputs = await page.locator('input, select, textarea').all();

    for (const input of inputs) {
      const inputInfo = await input.evaluate(el => ({
        id: el.id,
        type: el.type,
        ariaLabel: el.getAttribute('aria-label'),
        ariaLabelledby: el.getAttribute('aria-labelledby')
      }));

      // Check for associated label
      let hasLabel = false;

      if (inputInfo.id) {
        const label = await page.locator(`label[for="${inputInfo.id}"]`).count();
        hasLabel = label > 0;
      }

      hasLabel = hasLabel || !!inputInfo.ariaLabel || !!inputInfo.ariaLabelledby;

      if (!hasLabel && inputInfo.type !== 'hidden') {
        console.error(`Input without label: id="${inputInfo.id}" type="${inputInfo.type}"`);
      }

      // Hidden inputs don't need labels
      if (inputInfo.type !== 'hidden') {
        expect(hasLabel).toBe(true);
      }
    }
  });

  test('[P0] Semantic HTML structure', async ({ page }) => {
    const structure = await page.evaluate(() => ({
      hasMain: document.querySelector('main, [role="main"]') !== null,
      mainCount: document.querySelectorAll('main, [role="main"]').length,
      hasNav: document.querySelector('nav, [role="navigation"]') !== null,
      h1Count: document.querySelectorAll('h1').length,
      headingSequence: Array.from(document.querySelectorAll('h1, h2, h3, h4, h5, h6'))
        .map(h => parseInt(h.tagName[1]))
    }));

    // Should have exactly one main landmark
    expect(structure.hasMain).toBe(true);
    expect(structure.mainCount).toBe(1);

    // Should have navigation
    expect(structure.hasNav).toBe(true);

    // Should have exactly one h1
    expect(structure.h1Count).toBe(1);

    // Check heading sequence doesn't skip levels
    for (let i = 1; i < structure.headingSequence.length; i++) {
      const prev = structure.headingSequence[i - 1];
      const current = structure.headingSequence[i];
      const skip = current - prev;

      if (skip > 1) {
        console.warn(`Heading level skip detected: h${prev} → h${current}`);
        expect(skip).toBeLessThanOrEqual(1);
      }
    }
  });

  // ========================================
  // HIGH PRIORITY (P1) TESTS
  // ========================================

  test('[P1] Language attribute declared', async ({ page }) => {
    const langAttr = await page.evaluate(() =>
      document.documentElement.getAttribute('lang')
    );

    expect(langAttr).toBeTruthy();
    expect(langAttr).toMatch(/^[a-z]{2}(-[A-Z]{2})?$/); // e.g., "en" or "en-US"
  });

  test('[P1] Focus order matches visual order', async ({ page }) => {
    const focusOrder = [];
    const visualOrder = [];

    // Get tab order
    for (let i = 0; i < 20; i++) {
      await page.keyboard.press('Tab');

      const elementInfo = await page.evaluate(() => {
        const el = document.activeElement;
        const rect = el?.getBoundingClientRect();
        return {
          tag: el?.tagName,
          text: el?.textContent?.trim().substring(0, 30),
          top: rect?.top,
          left: rect?.left
        };
      });

      if (elementInfo.tag !== 'BODY') {
        focusOrder.push(elementInfo);
      }
    }

    // Visual order should generally go top-to-bottom, left-to-right
    let outOfOrderCount = 0;
    for (let i = 1; i < focusOrder.length; i++) {
      const prev = focusOrder[i - 1];
      const current = focusOrder[i];

      // If current element is significantly above previous, it's out of order
      if (current.top < prev.top - 50) {
        outOfOrderCount++;
        console.warn(`Potential focus order issue: ${prev.text} → ${current.text}`);
      }
    }

    // Allow some flexibility, but flag if many elements are out of order
    expect(outOfOrderCount).toBeLessThan(focusOrder.length * 0.2);
  });

  test('[P1] Touch target sizes meet minimum 44x44px', async ({ page }) => {
    await page.setViewportSize(VIEWPORT_SIZES.mobile);
    await page.reload();
    await page.waitForLoadState('networkidle');

    const interactiveElements = await page.locator(
      'a[href], button, input, select, [role="button"]'
    ).all();

    const smallTargets = [];

    for (const element of interactiveElements) {
      const box = await element.boundingBox();

      if (box && (box.width < 44 || box.height < 44)) {
        const info = await element.evaluate(el => ({
          tag: el.tagName,
          text: el.textContent?.trim().substring(0, 30),
          class: el.className,
          width: el.getBoundingClientRect().width,
          height: el.getBoundingClientRect().height
        }));

        smallTargets.push(info);
      }
    }

    if (smallTargets.length > 0) {
      console.log('\n========== SMALL TOUCH TARGETS ==========');
      smallTargets.forEach(target => {
        console.log(`${target.tag}: "${target.text}" - ${target.width}x${target.height}px`);
      });
      console.log('=========================================\n');
    }

    expect(smallTargets.length).toBe(0);
  });

  // ========================================
  // MEDIUM PRIORITY (P2) TESTS
  // ========================================

  test('[P2] Responsive - No horizontal scroll at 320px', async ({ page }) => {
    await page.setViewportSize({ width: 320, height: 568 });
    await page.reload();
    await page.waitForLoadState('networkidle');

    const hasHorizontalScroll = await page.evaluate(() => {
      return document.documentElement.scrollWidth > document.documentElement.clientWidth;
    });

    expect(hasHorizontalScroll).toBe(false);
  });

  test('[P2] Content reflows at 200% zoom', async ({ page }) => {
    // Simulate 200% zoom by setting larger viewport with same CSS pixels
    await page.evaluate(() => {
      document.body.style.zoom = '200%';
    });

    await page.waitForTimeout(1000);

    const hasHorizontalScroll = await page.evaluate(() => {
      return document.documentElement.scrollWidth > document.documentElement.clientWidth;
    });

    expect(hasHorizontalScroll).toBe(false);
  });

  test('[P2] Link purpose is clear from link text', async ({ page }) => {
    const links = await page.locator('a[href]').all();
    const genericLinkTexts = ['click here', 'read more', 'learn more', 'here', 'more'];
    const problematicLinks = [];

    for (const link of links) {
      const linkInfo = await link.evaluate(el => ({
        text: el.textContent?.trim().toLowerCase(),
        ariaLabel: el.getAttribute('aria-label'),
        title: el.getAttribute('title')
      }));

      const isGeneric = genericLinkTexts.includes(linkInfo.text);
      const hasDescriptiveLabel = linkInfo.ariaLabel || linkInfo.title;

      if (isGeneric && !hasDescriptiveLabel) {
        problematicLinks.push(linkInfo);
      }
    }

    if (problematicLinks.length > 0) {
      console.log('\n========== GENERIC LINK TEXT ==========');
      problematicLinks.forEach(link => {
        console.log(`- "${link.text}" (no aria-label or title)`);
      });
      console.log('========================================\n');
    }

    expect(problematicLinks.length).toBe(0);
  });

  // ========================================
  // SCREEN READER TESTS
  // ========================================

  test('[SR] ARIA live regions for dynamic content', async ({ page }) => {
    const liveRegions = await page.locator('[aria-live], [role="status"], [role="alert"]').all();

    console.log(`Found ${liveRegions.length} live regions`);

    // If there are filters or dynamic content, there should be live regions
    const hasFilters = await page.locator('input[type="checkbox"], select').count() > 0;

    if (hasFilters) {
      expect(liveRegions.length).toBeGreaterThan(0);
    }
  });

  test('[SR] Images have alt text', async ({ page }) => {
    const images = await page.locator('img').all();
    const missingAlt = [];

    for (const img of images) {
      const hasAlt = await img.evaluate(el => el.hasAttribute('alt'));

      if (!hasAlt) {
        const src = await img.getAttribute('src');
        missingAlt.push(src);
      }
    }

    if (missingAlt.length > 0) {
      console.log('\n========== IMAGES WITHOUT ALT ==========');
      missingAlt.forEach(src => console.log(`- ${src}`));
      console.log('========================================\n');
    }

    expect(missingAlt.length).toBe(0);
  });

  test('[SR] Product cards have proper structure', async ({ page }) => {
    const productCards = await page.locator('[class*="product"]').all();

    if (productCards.length === 0) {
      console.warn('No product cards found on page');
      return;
    }

    // Check first few product cards for structure
    const cardsToCheck = productCards.slice(0, 5);

    for (const card of cardsToCheck) {
      const structure = await card.evaluate(el => {
        const heading = el.querySelector('h1, h2, h3, h4, h5, h6');
        const price = el.querySelector('[class*="price"]');
        const button = el.querySelector('button, a[href]');

        return {
          hasHeading: !!heading,
          headingLevel: heading?.tagName,
          hasPrice: !!price,
          hasButton: !!button
        };
      });

      expect(structure.hasHeading).toBe(true);
    }
  });

  // ========================================
  // RESPONSIVE TESTS
  // ========================================

  test('[Responsive] Mobile viewport accessibility', async ({ page }) => {
    await page.setViewportSize(VIEWPORT_SIZES.mobile);
    await page.reload();
    await page.waitForLoadState('networkidle');

    const mobileResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(mobileResults.violations).toEqual([]);
  });

  test('[Responsive] Tablet viewport accessibility', async ({ page }) => {
    await page.setViewportSize(VIEWPORT_SIZES.tablet);
    await page.reload();
    await page.waitForLoadState('networkidle');

    const tabletResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(tabletResults.violations).toEqual([]);
  });

  // ========================================
  // PERFORMANCE TESTS
  // ========================================

  test('[Performance] Page is accessible within 3 seconds', async ({ page }) => {
    const startTime = Date.now();
    await page.goto(PRODUCT_URL);
    await page.waitForLoadState('domcontentloaded');
    const loadTime = Date.now() - startTime;

    console.log(`Page loaded in ${loadTime}ms`);
    expect(loadTime).toBeLessThan(3000);
  });

});

// ========================================
// UTILITY FUNCTIONS
// ========================================

/**
 * Generate detailed accessibility report
 */
test.afterAll(async ({}, testInfo) => {
  console.log('\n========================================');
  console.log('WCAG 2.1 AA ACCESSIBILITY AUDIT COMPLETE');
  console.log('========================================\n');
  console.log(`Total tests: ${testInfo.project.testDir}`);
  console.log(`Report generated: ${new Date().toISOString()}`);
  console.log('\nReview test results above for detailed findings.');
  console.log('Update WCAG_ACCESSIBILITY_AUDIT_REPORT.md with actual violation counts.\n');
});
