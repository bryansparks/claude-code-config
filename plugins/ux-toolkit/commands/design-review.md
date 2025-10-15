---
description: Comprehensive UI/UX design review
---

**Purpose**: Comprehensive UI/UX design review

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Review UI/UX design for $ARGUMENTS"

Conduct a thorough UI/UX design review focusing on visual consistency, usability, accessibility, and design system compliance.

## Usage Examples
- `/design-review --file src/components/ProductCard.tsx`
- `/design-review --page /checkout --complete`
- `/design-review --directory src/pages --focus responsive`
- `/design-review --component Button --variants`

## Command-Specific Flags
--file: "Review specific file"
--page: "Review entire page/route"
--directory: "Review all files in directory"
--component: "Review specific component"
--variants: "Review all component variants"
--complete: "Full design review (visual, UX, a11y, tokens)"
--focus: "Focus area (responsive, accessibility, tokens, interactions)"
--compare: "Compare with design mockups/specs"

## Review Areas

### Visual Design (UI Component Reviewer)
**Appearance & Consistency:**
- Visual hierarchy and typography
- Color usage and brand consistency
- Spacing and alignment (8px grid)
- Component sizing and proportions
- Visual feedback states

**Design Tokens:**
- Color token compliance
- Typography scale usage
- Spacing system adherence
- Shadow/elevation system
- Border radius consistency

**Responsive Design:**
- Mobile (320px, 375px, 414px)
- Tablet (768px, 1024px)
- Desktop (1280px, 1440px, 1920px)
- Breakpoint handling
- Touch target sizes (44x44px min)

### User Experience
**Usability:**
- Clear call-to-action buttons
- Intuitive navigation
- Helpful error messages
- Loading states and feedback
- Empty states

**Interactions:**
- Hover/focus states
- Click/tap feedback
- Animation performance
- Transition smoothness
- Micro-interactions

**Information Architecture:**
- Content organization
- Visual hierarchy
- Scannability
- Progressive disclosure
- Cognitive load

### Accessibility (WCAG 2.1 Level AA)
**Perceivable:**
- Alt text for images
- Color contrast 4.5:1+ (text), 3:1+ (UI)
- Text resizable to 200%
- No text in images

**Operable:**
- Keyboard accessible
- No keyboard traps
- Focus visible (3px min)
- Touch targets 44x44px+

**Understandable:**
- Clear labels
- Helpful errors
- Consistent navigation
- Predictable behavior

**Robust:**
- Valid HTML
- Proper ARIA
- Screen reader compatible

### Design System Compliance
**Component Library:**
- Using design system components
- Component variants properly used
- No one-off custom components
- Props API consistent

**Pattern Consistency:**
- Following established patterns
- Consistent similar solutions
- Deviations documented

**Documentation:**
- Component documented
- Usage examples present
- Accessibility notes
- Props table complete

## Review Process

**1. Initial Visual Scan:**
```
- Overall visual impression
- Brand consistency
- Layout and spacing
- Typography hierarchy
- Color usage
```

**2. Component Analysis:**
```
- Design system compliance
- Token usage vs hardcoded values
- Component variants coverage
- State handling (hover, focus, disabled, error)
- Responsive behavior
```

**3. Interaction Review:**
```
- Hover/focus feedback
- Click/tap response
- Loading states
- Error handling
- Micro-interactions
```

**4. Accessibility Audit:**
```
- Keyboard navigation
- Screen reader compatibility
- Color contrast
- Focus indicators
- ARIA attributes
```

**5. Usability Evaluation:**
```
- User flow clarity
- CTA prominence
- Error message helpfulness
- Success feedback
- Empty state handling
```

## Output Format

The design-review command provides:

```
🎨 UI/UX DESIGN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Component: ProductCard
File: src/components/ProductCard.tsx

VISUAL DESIGN
✅ Typography hierarchy clear (h3 → price → description)
⚠️  Inconsistent spacing: 12px used instead of design token spacing[3] (16px)
❌ Hardcoded color #3B82F6 instead of tokens.colors.brand.primary[500]
✅ Following 8px grid system
⚠️  Image aspect ratio not enforced (causes layout shift)

DESIGN TOKENS
Token Compliance: 68% (Target: 95%+)
❌ 5 hardcoded colors found (lines 23, 34, 45, 67, 89)
❌ 3 hardcoded spacing values (lines 28, 56, 78)
✅ Typography using design system scale
⚠️  Shadow hardcoded: use tokens.shadows.md

RESPONSIVE DESIGN
✅ Mobile-first approach (min-width queries)
✅ Touch targets 48x48px (meets guidelines)
⚠️  Text doesn't wrap on mobile at 320px width
✅ Images scale properly
❌ Horizontal scroll on 375px width (fix: container width)

ACCESSIBILITY (WCAG 2.1 AA)
Score: 72% - Needs Improvement

Critical Issues:
❌ Image missing alt text (line 45)
❌ Button missing accessible label (icon-only)
❌ Color contrast 3.8:1 (needs 4.5:1) on secondary button

Important Issues:
⚠️  No focus indicator on card hover
⚠️  Heading hierarchy skip (h2 → h4)
⚠️  Price announced as "dollar sign 99 point 99" (add aria-label: "99 dollars")

USABILITY
✅ Clear call-to-action ("Add to Cart")
✅ Product info scannable
⚠️  "Out of Stock" state too subtle (low contrast)
❌ No loading state for "Add to Cart" action
⚠️  Error messages don't appear inline

INTERACTIONS
✅ Hover state present (background color change)
❌ No click feedback on "Add to Cart" button
⚠️  Image transition too slow (400ms → recommend 250ms)
❌ No favorite button animation
✅ Smooth transitions (using transform/opacity)

DESIGN SYSTEM COMPLIANCE
Component Library Match: 85%
✅ Using Button component from design system
⚠️  Card variant "elevated" not in design system
❌ Custom Badge component (design system has Badge)
✅ Props API matches design system conventions

PRIORITY FIXES (Critical → High → Medium)

🔴 Critical (Block Release):
1. Fix color contrast on secondary button (3.8:1 → 4.5:1+)
2. Add alt text to product image
3. Add accessible label to favorite button
4. Fix horizontal scroll on mobile

🟡 High (Should Fix):
5. Replace hardcoded colors with design tokens
6. Add "Add to Cart" loading state
7. Add focus indicator to card
8. Fix heading hierarchy skip
9. Replace custom Badge with design system Badge

🟢 Medium (Nice to Have):
10. Add click feedback animation
11. Improve image transition timing
12. Enforce image aspect ratio
13. Add error state inline messaging
14. Improve "Out of Stock" visual prominence

RECOMMENDATIONS

Design System:
• Run token migration: npx design-system-migrate
• Replace custom Badge with ds.Badge
• Document "elevated" card variant or remove

Accessibility:
• Run axe DevTools scan
• Test with keyboard navigation
• Test with screen reader (VoiceOver/NVDA)
• Verify color contrast with WebAIM checker

Usability:
• Add micro-interactions for delight
• Improve feedback for user actions
• Consider skeleton loading state
• A/B test CTA button prominence

Next Steps:
1. Fix critical issues immediately
2. Run automated accessibility scan
3. Test on real devices (iOS/Android)
4. Submit for design system team review
5. Schedule usability testing session
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Checklist

### Visual Design
- [ ] Typography hierarchy clear
- [ ] Colors from design system
- [ ] Spacing consistent (8px grid)
- [ ] Alignment precise
- [ ] Visual balance

### Design Tokens
- [ ] No hardcoded colors
- [ ] Spacing tokens used
- [ ] Typography scale
- [ ] Shadows from system
- [ ] 95%+ token compliance

### Responsive
- [ ] Mobile optimized (320px+)
- [ ] Tablet layout (768px+)
- [ ] Desktop layout (1280px+)
- [ ] No horizontal scroll
- [ ] Touch targets 44px+

### Accessibility
- [ ] Color contrast 4.5:1+
- [ ] Keyboard navigable
- [ ] Screen reader friendly
- [ ] Focus visible
- [ ] ARIA labels present

### Usability
- [ ] CTAs clear
- [ ] Error messages helpful
- [ ] Loading states present
- [ ] Empty states designed
- [ ] Success feedback

### Interactions
- [ ] Hover states
- [ ] Focus states
- [ ] Click feedback
- [ ] Loading indicators
- [ ] Smooth animations

## Collaboration

**Involves:**
- **ui-component-reviewer**: Component-level analysis
- **accessibility-specialist**: WCAG compliance audit
- **design-system-expert**: Token and pattern compliance
- **interaction-designer**: Interaction and animation review
- **user-flow-architect**: UX flow analysis

**Outputs:**
- Comprehensive design review report
- Prioritized issue list
- Specific fix recommendations
- Compliance scores
- Next steps and action items

Focus on identifying issues early, providing actionable feedback, and ensuring high-quality, accessible, and consistent user interfaces.
