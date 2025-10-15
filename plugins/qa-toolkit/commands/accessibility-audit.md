---
description: Run comprehensive accessibility audits and ensure WCAG compliance
---

**Purpose**: Run comprehensive accessibility audits and ensure WCAG compliance

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Run accessibility audit for $ARGUMENTS"

Perform thorough accessibility testing to ensure applications are usable by everyone, including people with disabilities.

## Usage Examples
- `/accessibility-audit --wcag AA --url https://app.example.com`
- `/accessibility-audit --component Button --storybook`
- `/accessibility-audit --screen-reader NVDA --page /checkout`
- `/accessibility-audit --keyboard-only --flow "Login to Dashboard"`
- `/accessibility-audit --color-contrast --report`

## Command-Specific Flags
--wcag: "WCAG level to test: A, AA, AAA (default: AA)"
--url: "URL to audit"
--page: "Specific page or route to test"
--component: "Test specific component"
--storybook: "Test components in Storybook"
--screen-reader: "Screen reader to test: NVDA, JAWS, VoiceOver, TalkBack"
--keyboard-only: "Test keyboard navigation exclusively"
--color-contrast: "Focus on color contrast issues"
--aria: "Validate ARIA implementation"
--flow: "Test complete user flow for accessibility"
--report: "Generate detailed audit report"
--fix: "Show fix recommendations for issues"
--automated: "Run automated tools only (axe, Pa11y)"
--manual: "Include manual testing checklist"

## Accessibility Audit Process

**1. Automated Scanning:**
- Run axe-core on all pages
- Execute Pa11y accessibility tests
- Check Lighthouse accessibility score
- Validate HTML structure
- Scan for common violations

**2. Keyboard Navigation:**
- Test tab order
- Verify focus indicators
- Check skip links
- Test modal focus traps
- Validate keyboard shortcuts

**3. Screen Reader Testing:**
- Test with NVDA (Windows)
- Test with JAWS (Windows)
- Test with VoiceOver (Mac/iOS)
- Test with TalkBack (Android)
- Verify meaningful announcements

**4. Visual Testing:**
- Check color contrast (WCAG 4.5:1)
- Test at 200% zoom
- Verify text resize
- Check for motion/animation controls
- Test with high contrast mode

**5. Manual Verification:**
- Forms have proper labels
- Images have alt text
- Videos have captions
- Content is readable
- No keyboard traps

## Output Format

The accessibility-audit command provides:
1. **Compliance Score**: WCAG conformance level
2. **Violations List**: Categorized by severity
3. **Fix Recommendations**: Specific code changes
4. **Manual Testing Checklist**: Items requiring human verification
5. **Screen Reader Report**: Usability findings
6. **Keyboard Navigation Map**: Tab order and shortcuts
7. **Action Plan**: Prioritized remediation tasks

## WCAG Compliance Levels

**Level A (Minimum):**
- Essential accessibility features
- Critical for basic usability
- 25 success criteria
- Legal requirement in many regions

**Level AA (Standard):**
- Recommended for most websites
- Addresses major barriers
- 38 success criteria total
- Industry best practice

**Level AAA (Enhanced):**
- Highest level of accessibility
- May not be achievable for all content
- 61 success criteria total
- Aspirational for most sites

## Common Accessibility Issues

**1. Missing Alt Text:**
```html
<!-- ✗ Inaccessible -->
<img src="product.jpg">

<!-- ✓ Accessible -->
<img src="product.jpg" alt="Blue leather messenger bag with brass buckles">

<!-- ✓ Decorative image -->
<img src="decorative.svg" alt="" role="presentation">
```

**2. Poor Color Contrast:**
```css
/* ✗ Insufficient contrast (2.8:1) */
.text { color: #999; background: #fff; }

/* ✓ Sufficient contrast (4.7:1) */
.text { color: #666; background: #fff; }

/* ✓ Strong contrast (7.0:1) */
.text { color: #333; background: #fff; }
```

**3. Missing Form Labels:**
```html
<!-- ✗ Inaccessible -->
<input type="text" placeholder="Enter email">

<!-- ✓ Accessible -->
<label for="email">Email Address</label>
<input type="text" id="email" name="email">
```

**4. Keyboard Trap:**
```javascript
// ✗ Modal with keyboard trap
function openModal() {
  modal.show();
  // Focus stuck in modal!
}

// ✓ Proper focus management
function openModal() {
  modal.show();
  trapFocusInModal();

  modal.addEventListener('close', () => {
    returnFocusToTrigger();
  });
}
```

**5. Non-Semantic HTML:**
```html
<!-- ✗ Inaccessible -->
<div onclick="submit()">Submit</div>

<!-- ✓ Accessible -->
<button type="submit">Submit</button>
```

**6. Missing ARIA Labels:**
```html
<!-- ✗ Icon button without label -->
<button><i class="icon-close"></i></button>

<!-- ✓ Labeled icon button -->
<button aria-label="Close dialog">
  <i class="icon-close" aria-hidden="true"></i>
</button>
```

## Testing Tools

**Automated Testing:**
- **axe DevTools**: Browser extension, comprehensive checks
- **WAVE**: Visual feedback on accessibility issues
- **Lighthouse**: Part of Chrome DevTools
- **Pa11y**: Command-line tool for CI/CD
- **axe-core**: JavaScript library for testing

**Screen Readers:**
- **NVDA** (Windows, Free): Most popular
- **JAWS** (Windows, Paid): Industry standard
- **VoiceOver** (Mac/iOS, Free): Built-in
- **TalkBack** (Android, Free): Built-in

**Manual Testing:**
- **Color Contrast Analyzer**: Check WCAG ratios
- **Color Oracle**: Simulate color blindness
- **ANDI**: Accessibility testing bookmarklet
- **Accessibility Insights**: Microsoft's testing tool

## Keyboard Navigation Testing

**Essential Keyboard Commands:**
```
Tab:           Move focus forward
Shift+Tab:     Move focus backward
Enter:         Activate button/link
Space:         Activate button, check checkbox
Escape:        Close modal/dialog
Arrow Keys:    Navigate within components
Home/End:      Jump to start/end
```

**Testing Checklist:**
- [ ] All interactive elements reachable via Tab
- [ ] Logical tab order (left-to-right, top-to-bottom)
- [ ] Visible focus indicator on all elements
- [ ] No keyboard traps
- [ ] Skip links to main content
- [ ] Modal focus trapped appropriately
- [ ] Escape closes modals and dropdowns

## Screen Reader Testing

**NVDA Testing (Windows):**
```
Basic Commands:
  NVDA+N:        Open NVDA menu
  NVDA+Q:        Quit NVDA
  H/Shift+H:     Navigate by headings
  F/Shift+F:     Navigate by form fields
  B/Shift+B:     Navigate by buttons
  K/Shift+K:     Navigate by links
  D/Shift+D:     Navigate by landmarks
  Insert+Down:   Read line
```

**Testing Scenarios:**
- Navigate entire page using headings
- Fill out all forms using only keyboard
- Understand all images from alt text
- Perceive all page state changes
- Complete critical user flows

## Color Contrast Requirements

**WCAG AA Contrast Ratios:**
```
Normal Text (< 18pt):     4.5:1
Large Text (≥ 18pt):      3:1
UI Components/Graphics:    3:1

WCAG AAA (Enhanced):
Normal Text:              7:1
Large Text:               4.5:1
```

**Common Failures:**
- Light gray text on white (#999 on #FFF = 2.8:1) ✗
- Placeholder text too light
- Disabled buttons insufficient contrast
- Link text not distinct from body text

## Output Example

```
Accessibility Audit Report
=========================

URL: https://app.example.com/checkout
WCAG Level: AA
Date: 2025-10-04

Overall Status: ⚠ PARTIAL COMPLIANCE (78% compliant)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CRITICAL ISSUES (3) - Block Compliance

1. Missing Form Labels (WCAG 3.3.2 - Level A)
   Location: Checkout form, payment section
   Impact: Screen readers cannot identify input fields

   Fix:
   <label for="card-number">Card Number</label>
   <input id="card-number" type="text" />

2. Insufficient Color Contrast (WCAG 1.4.3 - Level AA)
   Location: Error messages, price labels
   Contrast: 3.2:1 (needs 4.5:1)

   Fix: Change color from #FF6B6B to #D32F2F

3. Keyboard Trap (WCAG 2.1.2 - Level A)
   Location: Payment modal
   Issue: Cannot exit with keyboard

   Fix: Add Escape key handler and focus management

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MODERATE ISSUES (8)

• Missing skip link (affects keyboard users)
• Images without alt text (5 instances)
• Buttons with generic labels ("Click here")
• No ARIA live region for dynamic content
• Form validation errors not announced
• Missing heading hierarchy (h1 → h3, no h2)
• Insufficient focus indicators
• Autocomplete missing on form fields

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AUTOMATED TEST RESULTS

axe-core:
  ✓ Passed: 87 checks
  ✗ Failed: 12 checks
  ⚠ Needs Review: 5 checks

Pa11y:
  Errors: 15
  Warnings: 23
  Notices: 31

Lighthouse:
  Accessibility Score: 82/100

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SCREEN READER TESTING (NVDA)

Overall Usability: 6/10

✓ Strengths:
  • Page landmarks properly defined
  • Headings provide clear structure
  • Form submit button clearly labeled

✗ Issues:
  • Payment form inputs missing labels
  • Price changes not announced
  • Loading states not communicated
  • Error messages not associated with fields

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KEYBOARD NAVIGATION

✓ Passed: Navigation to page
✓ Passed: Form field focus
✗ Failed: Modal focus trap
⚠ Partial: Focus indicators visible (some missing)

Tab Order: Logical and follows visual layout ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RECOMMENDATIONS (Prioritized)

Immediate (This Sprint):
  [ ] Fix all CRITICAL issues (3 items)
  [ ] Add missing form labels
  [ ] Fix color contrast violations
  [ ] Resolve keyboard trap in modal

Short-term (Next Sprint):
  [ ] Add skip navigation link
  [ ] Complete alt text for all images
  [ ] Improve focus indicators
  [ ] Add ARIA labels to icon buttons

Long-term (Backlog):
  [ ] Implement comprehensive keyboard shortcuts
  [ ] Add high contrast mode support
  [ ] Create accessibility component library
  [ ] Set up automated a11y testing in CI/CD

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ESTIMATED REMEDIATION TIME

Critical Issues:    8 hours
Moderate Issues:   16 hours
Long-term Items:   40 hours
Total:            64 hours (8 days)

Next Audit: After critical fixes implemented
```

## Prevention Strategies

**Design Phase:**
- Design with 4.5:1 contrast minimum
- Include focus states in designs
- Label all UI elements
- Consider keyboard navigation

**Development Phase:**
- Use semantic HTML
- Test with keyboard only
- Run automated tools
- Add ARIA when needed (sparingly)

**Testing Phase:**
- Automated testing in CI/CD
- Manual keyboard testing
- Screen reader verification
- Regular accessibility audits

**Maintenance Phase:**
- Monitor for regressions
- Update as WCAG evolves
- Train team on accessibility
- Build accessibility culture
