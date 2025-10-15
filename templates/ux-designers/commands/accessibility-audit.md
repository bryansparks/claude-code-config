**Purpose**: Full WCAG 2.1 accessibility compliance audit

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Audit accessibility for $ARGUMENTS"

Perform a comprehensive accessibility audit against WCAG 2.1 Level AA/AAA standards.

## Usage Examples
- `/accessibility-audit --file src/components/Modal.tsx`
- `/accessibility-audit --page /checkout --level AA`
- `/accessibility-audit --directory src/ --report`
- `/accessibility-audit --component Form --wcag 2.2`

## Command-Specific Flags
--file: "Audit specific file"
--page: "Audit entire page/route"
--directory: "Audit all files in directory"
--component: "Audit specific component"
--level: "WCAG level (A, AA, AAA) - default: AA"
--wcag: "WCAG version (2.1, 2.2) - default: 2.1"
--report: "Generate detailed compliance report"
--auto-fix: "Suggest automated fixes where possible"

## WCAG 2.1 Principles (POUR)

### 1. Perceivable
Information and UI components must be presentable to users in ways they can perceive.

**1.1 Text Alternatives:**
- Alt text for images
- ARIA labels for icons
- Captions for videos
- Transcripts for audio

**1.2 Time-based Media:**
- Captions for videos
- Audio descriptions
- Transcripts available

**1.3 Adaptable:**
- Semantic HTML structure
- Proper heading hierarchy (h1→h2→h3)
- Meaningful sequence
- Input purpose identified

**1.4 Distinguishable:**
- Color contrast 4.5:1 (text), 3:1 (UI)
- No audio auto-play
- Text resizable to 200%
- Images of text avoided
- Text spacing adjustable
- Content on hover/focus persistent

### 2. Operable
UI components and navigation must be operable.

**2.1 Keyboard Accessible:**
- All functionality keyboard accessible
- No keyboard traps
- Keyboard shortcuts documented
- Character key shortcuts configurable

**2.2 Enough Time:**
- No time limits or adjustable
- Pause, stop, hide for moving content
- Auto-updating can be paused

**2.3 Seizures:**
- No content flashing >3 times/second
- No known seizure triggers

**2.4 Navigable:**
- Bypass blocks (skip links)
- Page titles descriptive
- Focus order logical
- Link purpose clear from context
- Multiple ways to find pages
- Headings and labels descriptive
- Focus visible

**2.5 Input Modalities:**
- Pointer gestures alternative
- Pointer cancellation
- Label in name matches visual
- Motion actuation alternative
- Target size adequate (44x44px)

### 3. Understandable
Information and UI operation must be understandable.

**3.1 Readable:**
- Language of page specified (lang attribute)
- Language of parts specified
- Unusual words defined
- Abbreviations explained

**3.2 Predictable:**
- On focus doesn't cause context change
- On input doesn't cause context change
- Consistent navigation
- Consistent identification
- Change on request only

**3.3 Input Assistance:**
- Error identification
- Labels or instructions provided
- Error suggestions
- Error prevention (legal, financial, data)
- Help available

### 4. Robust
Content must be robust enough to be interpreted by assistive technologies.

**4.1 Compatible:**
- Valid HTML (parsing)
- Name, role, value of UI components
- Status messages via ARIA

## Audit Process

**1. Automated Scanning:**
```bash
# Run automated tools
npx axe --tags wcag2a,wcag2aa
npm run test:a11y
lighthouse --only-categories=accessibility
```

**2. Manual Keyboard Testing:**
- Tab through entire interface
- Verify tab order is logical
- Test all interactive elements
- Verify no keyboard traps
- Check focus indicators visible
- Test keyboard shortcuts

**3. Screen Reader Testing:**
- VoiceOver (Mac/iOS)
- NVDA (Windows - free)
- JAWS (Windows - paid)
- TalkBack (Android)

**4. Visual Testing:**
- Color contrast check
- Zoom to 200%
- Check layout at different sizes
- Test with color blindness simulators
- Verify focus indicators

**5. Assistive Tech Testing:**
- Voice control (Dragon, Voice Access)
- Screen magnification
- Switch control
- Eye tracking (if applicable)

## Output Format

```
♿ ACCESSIBILITY AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Target: Checkout Flow
Standard: WCAG 2.1 Level AA
Date: 2025-10-04

COMPLIANCE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall Score: 68% (Needs Improvement)

Level A Compliance: 82% ⚠️  (Target: 100%)
Level AA Compliance: 68% ❌ (Target: 100%)
Level AAA Compliance: 45% (Optional)

CRITICAL ISSUES (Level A - MUST FIX)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ 1.1.1 Non-text Content
   Issue: 3 images missing alt text
   Location: /checkout (product images)
   Impact: Screen reader users cannot identify products
   Fix: Add alt="Product name - description" to <img> tags
   Priority: P0 - Critical
   WCAG: Level A

❌ 2.1.2 No Keyboard Trap
   Issue: Modal dialog traps keyboard focus
   Location: Confirmation modal
   Impact: Keyboard users cannot exit modal
   Fix: Implement focus trap with Esc key handler
   Priority: P0 - Critical
   WCAG: Level A

❌ 3.3.2 Labels or Instructions
   Issue: 5 form inputs missing labels
   Location: Payment form
   Impact: Screen readers cannot identify input purpose
   Fix: Add <label> or aria-label to all inputs
   Priority: P0 - Critical
   WCAG: Level A

❌ 4.1.2 Name, Role, Value
   Issue: Custom dropdown not exposing state
   Location: Country selector
   Impact: Screen readers don't announce selection
   Fix: Add role="combobox" aria-expanded aria-selected
   Priority: P0 - Critical
   WCAG: Level A

SERIOUS ISSUES (Level AA - SHOULD FIX)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  1.4.3 Contrast (Minimum)
   Issue: Button text contrast 3.8:1 (needs 4.5:1)
   Location: Secondary "Cancel" button
   Impact: Low vision users cannot read text
   Fix: Darken text from #757575 to #5A5A5A
   Priority: P1 - High
   WCAG: Level AA

⚠️  2.4.7 Focus Visible
   Issue: Focus indicator too subtle (1px outline)
   Location: All interactive elements
   Impact: Keyboard users can't see current focus
   Fix: Increase to 3px outline with sufficient contrast
   Priority: P1 - High
   WCAG: Level AA

⚠️  3.2.2 On Input
   Issue: Country selection triggers unexpected form submit
   Location: Shipping address form
   Impact: Unexpected behavior confuses users
   Fix: Remove auto-submit, add explicit "Continue" button
   Priority: P1 - High
   WCAG: Level AA

⚠️  1.3.1 Info and Relationships
   Issue: Heading hierarchy jumps from H1 to H3
   Location: Checkout page
   Impact: Screen reader navigation broken
   Fix: Use H1 → H2 → H3 sequence
   Priority: P1 - High
   WCAG: Level AA

ENHANCEMENT OPPORTUNITIES (Level AAA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 1.4.6 Contrast (Enhanced)
   Improve contrast to 7:1 for AAA compliance
   Current: 4.8:1 (meets AA, but not AAA)

💡 2.4.8 Location
   Add breadcrumb navigation
   Helps users understand location in checkout flow

💡 3.3.5 Help
   Provide contextual help for form fields
   Example: "CVV is 3-digit code on back of card"

DETAILED FINDINGS BY PRINCIPLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. PERCEIVABLE (75% compliant)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1.1 Text Alternatives:
✅ 1.1.1 (AA): Most images have alt text
❌ 1.1.1 (A): 3 product images missing alt text

1.3 Adaptable:
⚠️  1.3.1 (A): Heading hierarchy has gaps
✅ 1.3.2 (A): Meaningful sequence maintained
⚠️  1.3.5 (AA): Some autocomplete missing

1.4 Distinguishable:
⚠️  1.4.3 (AA): 2 instances of low contrast
✅ 1.4.4 (AA): Text resizes properly
✅ 1.4.10 (AA): Content reflows at 320px
✅ 1.4.11 (AA): UI component contrast 3:1+
⚠️  1.4.13 (AA): Tooltips dismiss on Esc

2. OPERABLE (65% compliant)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

2.1 Keyboard Accessible:
✅ 2.1.1 (A): All features keyboard accessible
❌ 2.1.2 (A): Keyboard trap in modal
✅ 2.1.4 (A): Character key shortcuts avoided

2.4 Navigable:
✅ 2.4.1 (A): Skip link present
✅ 2.4.2 (A): Page title descriptive
✅ 2.4.3 (A): Focus order logical
⚠️  2.4.4 (A): Some link purpose unclear
⚠️  2.4.6 (AA): Headings could be more descriptive
❌ 2.4.7 (AA): Focus indicator too subtle

2.5 Input Modalities:
✅ 2.5.1 (A): No path-based gestures
✅ 2.5.2 (A): Pointer cancellation works
✅ 2.5.3 (A): Labels match visual text
✅ 2.5.4 (A): No motion actuation
⚠️  2.5.5 (AAA): Some targets <44x44px

3. UNDERSTANDABLE (70% compliant)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3.1 Readable:
✅ 3.1.1 (A): Language specified (lang="en")
✅ 3.1.2 (AA): Parts language specified

3.2 Predictable:
✅ 3.2.1 (A): On focus no unexpected change
⚠️  3.2.2 (A): On input triggers submit
✅ 3.2.3 (AA): Navigation consistent
✅ 3.2.4 (AA): Identification consistent

3.3 Input Assistance:
✅ 3.3.1 (A): Errors identified
❌ 3.3.2 (A): Labels missing on 5 inputs
⚠️  3.3.3 (AA): Error suggestions could improve
✅ 3.3.4 (AA): Error prevention for payment

4. ROBUST (80% compliant)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4.1 Compatible:
✅ 4.1.1 (A): HTML validates
❌ 4.1.2 (A): Custom dropdown state not exposed
⚠️  4.1.3 (AA): Status messages need aria-live

TESTING RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Automated Tools:
✅ axe DevTools: 12 issues found
✅ Lighthouse: Accessibility score 68
✅ WAVE: 8 errors, 14 alerts

Manual Keyboard Testing:
✅ Tab order logical
❌ Modal keyboard trap (critical)
✅ All interactive elements reachable
❌ Focus indicator too subtle
✅ Skip link functional

Screen Reader Testing (NVDA):
❌ Images not announced (missing alt)
❌ Form inputs not labeled
⚠️  Dropdown state not announced
✅ Landmarks properly labeled
⚠️  Error messages need better announcement

RECOMMENDATIONS (Prioritized)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IMMEDIATE (P0 - Critical):
1. Add alt text to 3 product images
2. Fix modal keyboard trap (add Esc handler)
3. Add labels to 5 form inputs
4. Fix custom dropdown ARIA state
   Estimated effort: 4 hours

HIGH PRIORITY (P1):
5. Improve button contrast (3.8:1 → 4.5:1)
6. Increase focus indicator (1px → 3px)
7. Fix heading hierarchy (H1→H2→H3)
8. Remove auto-submit on input change
   Estimated effort: 3 hours

MEDIUM PRIORITY (P2):
9. Add aria-live for dynamic messages
10. Improve link text specificity
11. Increase small touch targets to 44px
12. Add autocomplete attributes
    Estimated effort: 2 hours

TESTING RECOMMENDATIONS:
• Re-run axe DevTools after fixes
• Test with real screen reader users
• Conduct keyboard-only navigation audit
• Verify on mobile devices
• Test with voice control software

NEXT STEPS:
1. Fix all P0 critical issues (4 issues)
2. Re-test with automated tools
3. Conduct manual keyboard audit
4. Test with screen reader
5. Fix P1 high priority issues (4 issues)
6. Schedule user testing with disabled users
7. Document accessibility in component library

TARGET: 100% WCAG 2.1 Level AA Compliance
Current: 68% | Gap: 32% | Estimated time to 100%: 9 hours

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Resources:
- WCAG Quick Reference: https://www.w3.org/WAI/WCAG21/quickref/
- axe DevTools: https://www.deque.com/axe/devtools/
- WebAIM: https://webaim.org/
- A11y Project: https://www.a11yproject.com/
```

## Automated Testing Tools

**Browser Extensions:**
- axe DevTools (Chrome, Firefox, Edge)
- WAVE Evaluation Tool
- Lighthouse (Chrome built-in)
- IBM Equal Access Checker

**CLI Tools:**
```bash
# axe-core
npx @axe-core/cli https://your-site.com

# Pa11y
pa11y https://your-site.com

# Lighthouse CI
lighthouse https://your-site.com --only-categories=accessibility
```

**Testing Libraries:**
```javascript
// Jest + jest-axe
import { axe, toHaveNoViolations } from 'jest-axe';
expect.extend(toHaveNoViolations);

test('should have no accessibility violations', async () => {
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Manual Testing Checklist

### Keyboard Navigation
- [ ] Tab through all interactive elements
- [ ] Shift+Tab works in reverse
- [ ] Enter/Space activates buttons
- [ ] Arrow keys navigate within components
- [ ] Esc closes modals/dropdowns
- [ ] Focus visible at all times
- [ ] No keyboard traps

### Screen Reader
- [ ] All images announced with alt text
- [ ] Form inputs labeled correctly
- [ ] Headings navigate properly
- [ ] Landmarks identified
- [ ] Buttons announce purpose
- [ ] Links announce destination
- [ ] Dynamic content announced

### Visual
- [ ] Color contrast 4.5:1+ (text)
- [ ] Color contrast 3:1+ (UI components)
- [ ] Zoom to 200% - content readable
- [ ] Focus indicators visible
- [ ] No information by color alone
- [ ] Touch targets 44x44px minimum

## Collaboration

**Led by:**
- **accessibility-specialist**: Primary audit and WCAG expertise

**Supports:**
- **ui-component-reviewer**: Component-level fixes
- **interaction-designer**: Accessible interaction patterns
- **design-system-expert**: Accessible design tokens
- **qa-engineers**: Automated accessibility testing

Focus on achieving WCAG 2.1 Level AA compliance as the baseline, with AAA enhancements where feasible.
