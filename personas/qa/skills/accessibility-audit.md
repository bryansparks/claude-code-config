---
name: accessibility-audit
description: Perform comprehensive WCAG 2.1/2.2 accessibility compliance analysis with prioritized remediation steps. Use when user requests accessibility audit, asks to check WCAG compliance, wants a11y testing, or needs accessibility review.
---

# Accessibility Audit Skill

Perform comprehensive Web Content Accessibility Guidelines (WCAG) 2.1/2.2 compliance analysis with automated testing, manual validation, and prioritized remediation recommendations.

## When to Use This Skill

Automatically invoke when the user:
- Requests accessibility audit or a11y review
- Asks "check accessibility" or "WCAG compliance"
- Wants to test screen reader compatibility
- Asks about color contrast or keyboard navigation
- Requests Section 508 compliance check
- Mentions "accessibility issues" or "a11y violations"
- Needs to meet ADA compliance requirements

## WCAG Standards Overview

### WCAG 2.1 Levels
- **Level A**: Minimum accessibility (must meet)
- **Level AA**: Recommended standard (industry standard)
- **Level AAA**: Enhanced accessibility (nice to have)

### WCAG 2.2 (Latest)
- **Includes all 2.1 criteria** plus additional success criteria
- **New criteria focus on**: Mobile accessibility, cognitive disabilities, low vision

### Compliance Targets
- **Government sites**: Section 508 (WCAG 2.0 Level AA)
- **Commercial sites**: WCAG 2.1 Level AA minimum
- **Best practice**: WCAG 2.2 Level AA

## Accessibility Audit Process

### 1. Automated Testing

#### Tools to Use
- **Axe-core**: Via A11y MCP server (primary)
- **Playwright**: Accessibility tree inspection
- **Lighthouse**: Overall accessibility score
- **WAVE**: Visual feedback tool (browser extension)

#### Automated Checks
```javascript
// Example using Playwright + Axe
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility Audit', () => {
  test('should not have automatically detectable WCAG A violations', async ({ page }) => {
    await page.goto('/');

    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(accessibilityScanResults.violations).toEqual([]);
  });
});
```

#### Coverage
- **ARIA roles and attributes**
- **Color contrast** (WCAG AAtext and non-text)
- **Keyboard accessibility**
- **Form labels and instructions**
- **Headings hierarchy**
- **Image alt text**
- **Link text descriptiveness**
- **Page titles**
- **Language declaration**

### 2. Manual Testing

#### Keyboard Navigation
**Test without mouse:**
- [ ] Tab through all interactive elements
- [ ] Shift+Tab navigates backward
- [ ] Enter/Space activates buttons and links
- [ ] Arrow keys navigate menus and lists
- [ ] Escape closes dialogs and menus
- [ ] Focus indicator is visible and clear
- [ ] No keyboard traps (can navigate away from all elements)
- [ ] Tab order is logical

#### Screen Reader Testing

**Test with:**
- **NVDA** (Windows, free)
- **JAWS** (Windows, commercial)
- **VoiceOver** (macOS/iOS, built-in)
- **TalkBack** (Android, built-in)

**Verify:**
- [ ] All content is announced
- [ ] Interactive elements have clear labels
- [ ] Form inputs have associated labels
- [ ] Error messages are announced
- [ ] Status updates are announced (ARIA live regions)
- [ ] Images have descriptive alt text
- [ ] Links describe their destination
- [ ] Headings create logical document structure

#### Visual Testing
- [ ] **Zoom to 200%**: Content is readable and usable
- [ ] **High contrast mode**: UI is still visible
- [ ] **Color blindness**: Information not conveyed by color alone
- [ ] **Dark mode**: Color contrast maintained
- [ ] **Text spacing**: Content doesn't overlap or get cut off

### 3. WCAG Principle Analysis

#### Perceivable
**Information and UI components must be presentable to users**

##### Text Alternatives (1.1)
- [ ] Images have alt text
- [ ] Decorative images use alt=""
- [ ] Complex images have long descriptions
- [ ] Form buttons have descriptive text

##### Time-based Media (1.2)
- [ ] Audio has transcripts
- [ ] Video has captions
- [ ] Video has audio descriptions (AA)

##### Adaptable (1.3)
- [ ] Semantic HTML (headings, lists, tables)
- [ ] Logical reading order
- [ ] Instructions don't rely solely on shape/size/location
- [ ] Orientation is not restricted (portrait/landscape)

##### Distinguishable (1.4)
- [ ] Color contrast: ≥4.5:1 for normal text, ≥3:1 for large text
- [ ] Audio control (pause, stop, mute)
- [ ] Text can be resized to 200%
- [ ] Images of text avoided (use real text)
- [ ] Text spacing is adjustable
- [ ] Content reflow works at 320px width

#### Operable
**UI components and navigation must be operable**

##### Keyboard Accessible (2.1)
- [ ] All functionality available via keyboard
- [ ] No keyboard traps
- [ ] Keyboard shortcuts don't conflict

##### Enough Time (2.2)
- [ ] Time limits can be extended or disabled
- [ ] Auto-updating content can be paused
- [ ] Timeouts warn users (WCAG 2.2)

##### Seizures and Physical Reactions (2.3)
- [ ] No content flashes more than 3 times per second
- [ ] Animation can be disabled (prefers-reduced-motion)

##### Navigable (2.4)
- [ ] Skip links to main content
- [ ] Page titles are descriptive
- [ ] Focus order is logical
- [ ] Link purpose is clear
- [ ] Multiple ways to find pages (nav, search, sitemap)
- [ ] Headings and labels are descriptive
- [ ] Focus is visible

##### Input Modalities (2.5)
- [ ] Touch targets are ≥44x44px
- [ ] Gestures have keyboard alternatives
- [ ] Accidental activation can be undone

#### Understandable
**Information and UI operation must be understandable**

##### Readable (3.1)
- [ ] Page language is declared (lang attribute)
- [ ] Language changes are marked
- [ ] Unusual words are defined

##### Predictable (3.2)
- [ ] Focus doesn't cause unexpected context changes
- [ ] Input doesn't cause unexpected changes
- [ ] Navigation is consistent
- [ ] Components are consistently identified

##### Input Assistance (3.3)
- [ ] Error messages are clear and specific
- [ ] Labels and instructions are provided
- [ ] Error suggestions are provided
- [ ] Error prevention for critical actions (confirm)
- [ ] Help is available

#### Robust
**Content must be robust enough to be interpreted by assistive technologies**

##### Compatible (4.1)
- [ ] Valid HTML (no parsing errors)
- [ ] Name, role, value for all components
- [ ] Status messages use ARIA live regions

## Output Format

Provide structured audit report:

```
♿ ACCESSIBILITY AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Overall Score: 85/100 (Good)
🎯 WCAG Level: AA (Partially Compliant)
🔍 Pages Audited: 5
🛠️  Violations Found: 12 (3 Critical, 5 Serious, 4 Moderate)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 CRITICAL Violations (Must Fix) - 3 issues

[1] Color Contrast Insufficient
  • WCAG: 1.4.3 Contrast (Minimum) [AA]
  • Location: Homepage > Hero Section > CTA Button
  • Issue: Text color #777 on background #999 has contrast ratio of 2.1:1
  • Requirement: Minimum 4.5:1 for normal text
  • Impact: Users with low vision cannot read button text
  • Remediation:
    - Change text color to #000 or #222 for 4.6:1 contrast
    - Or change background to #eee for 4.7:1 contrast
  • Code:
    ```css
    /* Current (BAD) */
    .cta-button {
      color: #777;
      background: #999;
    }

    /* Fixed (GOOD) */
    .cta-button {
      color: #000;  /* Contrast: 4.6:1 ✓ */
      background: #999;
    }
    ```

[2] Missing Form Labels
  • WCAG: 1.3.1 Info and Relationships [A], 4.1.2 Name, Role, Value [A]
  • Location: Contact Form > Email and Phone inputs
  • Issue: Input fields lack associated labels
  • Impact: Screen readers cannot identify purpose of fields
  • Remediation:
    ```html
    <!-- Current (BAD) -->
    <input type="email" placeholder="Email" />

    <!-- Fixed (GOOD) -->
    <label for="email-input">Email Address</label>
    <input
id="email-input" type="email" placeholder="your@email.com" />
    ```

[3] Keyboard Trap in Modal
  • WCAG: 2.1.2 No Keyboard Trap [A]
  • Location: Login Modal
  • Issue: Cannot close modal with keyboard (only mouse click on backdrop)
  • Impact: Keyboard users get stuck in modal
  • Remediation:
    - Add Escape key handler to close modal
    - Ensure focus returns to trigger element on close
    - Trap focus within modal while open
    ```javascript
    // Add Escape key handling
    modal.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        closeModal();
        triggerButton.focus(); // Return focus
      }
    });
    ```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟠 SERIOUS Issues (Should Fix) - 5 issues

[4] Missing Skip Link
  • WCAG: 2.4.1 Bypass Blocks [A]
  • Location: All pages
  • Issue: No skip navigation link
  • Impact: Keyboard users must tab through entire nav on every page
  • Remediation:
    ```html
    <a href="#main-content" class="skip-link">
      Skip to main content
    </a>
    <nav>...</nav>
    <main id="main-content">...</main>

    <style>
    .skip-link {
      position: absolute;
      top: -40px;
      left: 0;
      background: #000;
      color: #fff;
      padding: 8px;
    }
    .skip-link:focus {
      top: 0; /* Becomes visible on focus */
    }
    </style>
    ```

[5] Images Missing Alt Text
  • WCAG: 1.1.1 Non-text Content [A]
  • Location: Product Gallery (12 images)
  • Issue: <img> tags without alt attribute
  • Impact: Screen readers announce only file name
  • Remediation:
    ```html
    <!-- Current (BAD) -->
    <img src="product-123.jpg" />

    <!-- Fixed (GOOD) -->
    <img src="product-123.jpg"
         alt="Blue cotton t-shirt, size M" />

    <!-- For decorative images -->
    <img src="decorative-pattern.png" alt="" role="presentation" />
    ```

[6-8] [Additional serious issues...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟡 MODERATE Issues (Recommended) - 4 issues

[9] Focus Indicator Not Visible
  • WCAG: 2.4.7 Focus Visible [AA]
  • Location: Navigation links
  • Issue: outline: none removes focus indicator
  • Remediation:
    ```css
    /* Current (BAD) */
    a:focus {
      outline: none;
    }

    /* Fixed (GOOD) */
    a:focus {
      outline: 2px solid #005fcc;
      outline-offset: 2px;
    }
    ```

[10-12] [Additional moderate issues...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ WCAG Compliance Breakdown
───────────────────────────────────

Level A:
  ✓ Passed: 28 criteria
  ✗ Failed: 4 criteria
  ⊘ N/A: 3 criteria
  Compliance: 87.5% (30/34 applicable)

Level AA:
  ✓ Passed: 15 criteria
  ✗ Failed: 5 criteria
  ⊘ N/A: 2 criteria
  Compliance: 75% (15/20 applicable)

Level AAA:
  ⊘ Not targeting this level

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎨 Color Contrast Analysis
───────────────────────────────────

Text Combinations Tested: 24
✓ Passing: 18 (75%)
✗ Failing: 6 (25%)

Failing Combinations:
1. #777 on #999 → 2.1:1 (Need 4.5:1) - CTA buttons
2. #aaa on #fff → 2.3:1 (Need 4.5:1) - Footer text
3. #666 on #888 → 1.9:1 (Need 4.5:1) - Disabled states

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⌨️  Keyboard Navigation Test Results
───────────────────────────────────

✓ All interactive elements reachable
✓ Tab order is logical
✗ Focus indicator missing on some elements
✗ Keyboard trap in login modal
✓ Enter/Space activates buttons
✗ Escape doesn't close dropdowns

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📱 Screen Reader Testing (NVDA)
───────────────────────────────────

✓ Page title announced
✓ Landmark regions identified
✗ Form inputs missing labels (2 inputs)
✓ Buttons have descriptive labels
✗ Status messages not announced (no ARIA live)
✓ Images have alt text (except 12 in gallery)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 Prioritized Remediation Roadmap
───────────────────────────────────

Sprint 1 (Week 1) - Critical Fixes:
  • Fix color contrast on CTA buttons
  • Add labels to form inputs
  • Fix keyboard trap in modal

Sprint 2 (Week 2) - Serious Issues:
  • Add skip navigation link
  • Add alt text to product images
  • Fix focus indicators

Sprint 3 (Week 3) - Moderate Issues:
  • Add ARIA live regions for status updates
  • Improve heading hierarchy
  • Add keyboard shortcuts

Estimated Effort: 40 hours
Impact: Compliance from 80% → 98% (WCAG AA)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 Resources & Documentation
───────────────────────────────────

WCAG 2.1 Guidelines:
  https://www.w3.org/WAI/WCAG21/quickref/

Axe Accessibility Rules:
  https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md

MDN Accessibility:
  https://developer.mozilla.org/en-US/docs/Web/Accessibility

WebAIM Resources:
  https://webaim.org/resources/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Testing Checklist

### Automated Testing
- [ ] Run Axe-core via A11y MCP server
- [ ] Run Lighthouse accessibility audit
- [ ] Test with Playwright accessibility APIs
- [ ] Validate HTML with Nu HTML Checker

### Manual Keyboard Testing
- [ ] Tab through entire page
- [ ] Test with keyboard only (no mouse)
- [ ] Verify focus indicators
- [ ] Test keyboard shortcuts
- [ ] Test form submission with Enter
- [ ] Test modal/dialog interactions

### Screen Reader Testing
- [ ] Test with NVDA (Windows) or VoiceOver (macOS)
- [ ] Navigate by headings (H key)
- [ ] Navigate by landmarks (D key)
- [ ] Navigate by forms (F key)
- [ ] Navigate by links (K key)
- [ ] Verify ARIA labels announced

### Visual Testing
- [ ] Zoom to 200% and verify layout
- [ ] Test high contrast mode
- [ ] Simulate color blindness (browser tools)
- [ ] Test with dark mode
- [ ] Test with custom text spacing

### Mobile Testing
- [ ] Touch target size ≥44x44px
- [ ] Pinch to zoom enabled
- [ ] Orientation change supported
- [ ] Focus visible on mobile

## Common Issues and Fixes

### Color Contrast
```css
/* Problem: Insufficient contrast */
color: #767676;
background: #ffffff;
/* Contrast: 4.48:1 - FAILS AA for normal text */

/* Solution: Increase contrast */
color: #595959;
background: #ffffff;
/* Contrast: 7.0:1 - PASSES AAA */
```

### Missing ARIA Labels
```html
<!-- Problem: Icon-only button without label -->
<button><svg>...</svg></button>

<!-- Solution: Add aria-label -->
<button aria-label="Close dialog">
  <svg aria-hidden="true">...</svg>
</button>
```

### Keyboard Trap
```javascript
// Problem: Focus trapped in modal without escape
modal.show();

// Solution: Trap focus properly and allow escape
modal.show();
trapFocus(modal);
modal.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    modal.close();
    restoreFocus();
  }
});
```

### Focus Management
```javascript
// Problem: Focus not managed after dynamic content loads
loadContent().then(() => {
  // Content loaded but focus unchanged
});

// Solution: Move focus to new content
loadContent().then(() => {
  document.getElementById('new-heading').focus();
  // or
  document.getElementById('new-heading').setAttribute('tabindex', '-1');
  document.getElementById('new-heading').focus();
});
```

## Tools and Resources

### Automated Testing Tools
- **Axe DevTools**: Browser extension for audits
- **Lighthouse**: Chrome DevTools built-in
- **WAVE**: Visual feedback tool
- **Pa11y**: CI/CD automation
- **Axe-core**: JavaScript accessibility testing

### Manual Testing Tools
- **NVDA**: Free Windows screen reader
- **VoiceOver**: macOS/iOS screen reader (built-in)
- **Colour Contrast Analyser**: Check color combinations
- **HeadingsMap**: Visualize heading structure
- **Accessibility Insights**: Microsoft testing tool

### Browser Extensions
- **Axe DevTools**: Comprehensive audits
- **WAVE**: Visual feedback
- **HeadingsMap**: Heading structure visualization
- **Landmark Navigation**: ARIA landmark viewer
- **Screen Reader**: Built-in to browsers for testing

## Best Practices

1. **Test Early**: Integrate accessibility into design phase
2. **Automate**: Run automated tests in CI/CD pipeline
3. **Manual Test**: Automated tools catch ~30-40% of issues
4. **Real Users**: Test with users who rely on assistive tech
5. **Document**: Track issues and remediation in issue tracker
6. **Train Team**: Educate developers and designers on a11y
7. **Continuous**: Accessibility is ongoing, not one-time
8. **Standards**: Target WCAG 2.1 Level AA minimum

---

**Remember**: Accessibility benefits everyone, not just users with disabilities. Better accessibility often means better usability for all users.
