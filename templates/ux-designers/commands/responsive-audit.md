**Purpose**: Responsive design audit across devices

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Audit responsive design for $ARGUMENTS"

Verify responsive behavior across all screen sizes, devices, and orientations.

## Usage Examples
- `/responsive-audit --page /checkout --all-breakpoints`
- `/responsive-audit --component ProductCard --mobile-first`
- `/responsive-audit --directory src/pages --touch-targets`
- `/responsive-audit --compare mobile-vs-desktop`

## Command-Specific Flags
--page: "Audit specific page"
--component: "Audit component responsiveness"
--directory: "Audit all pages in directory"
--all-breakpoints: "Test all breakpoints"
--mobile-first: "Focus on mobile optimization"
--touch-targets: "Verify touch target sizes"
--compare: "Compare mobile vs desktop"
--orientation: "Test portrait and landscape"
--images: "Check responsive images"

## Breakpoints to Test

### Standard Breakpoints
```
Mobile (Portrait):
  • 320px - iPhone SE (smallest)
  • 375px - iPhone 12/13 Mini
  • 390px - iPhone 12/13/14
  • 414px - iPhone 12/13/14 Plus

Mobile (Landscape):
  • 667px - iPhone SE landscape
  • 844px - iPhone 12/13/14 landscape

Tablet (Portrait):
  • 768px - iPad Mini, iPad
  • 810px - iPad 10.2"
  • 834px - iPad Air

Tablet (Landscape):
  • 1024px - iPad landscape
  • 1112px - iPad Air landscape
  • 1366px - iPad Pro 12.9" landscape

Desktop:
  • 1280px - Laptop (small)
  • 1440px - Laptop (large)
  • 1920px - Desktop 1080p
  • 2560px - Desktop 1440p
```

## Output Format

```
📱 RESPONSIVE DESIGN AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Page: Checkout Flow
Breakpoints Tested: 8
Devices Tested: 12
Date: 2025-10-04

OVERALL SCORE: 78% ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mobile: 72% ⚠️  (needs improvement)
Tablet: 85% ✅ (good)
Desktop: 92% ✅ (excellent)

Target: 90%+ across all devices

BREAKPOINT TESTING RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[320px] iPhone SE (Portrait)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Layout: Single column, content fits
⚠️  Typography: Some text too small (12px, needs 14px min)
❌ Horizontal Scroll: Present (container width issue)
  Location: Payment form overflows by 24px
  Fix: Reduce form padding from 24px to 16px

⚠️  Touch Targets: 3 buttons below 44px minimum
  - "Edit" link: 32x32px (needs 44x44px)
  - Promo code toggle: 36x36px
  - Back button: 40x40px

✅ Images: Scale properly, no overflow
❌ Form Inputs: Too narrow, hard to tap
  Issue: Input height 36px (needs 44px minimum)

⚠️  Navigation: Hamburger menu works but close button small
✅ Footer: Stacks properly

Issues: 5 (2 critical, 3 moderate)
Score: 65% ⚠️

[375px] iPhone 12/13 Mini (Portrait)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Layout: Clean single column
✅ Typography: Readable sizes
✅ No Horizontal Scroll
⚠️  Touch Targets: Same 3 small buttons as 320px
✅ Images: Proper aspect ratio maintained
✅ Form Inputs: Adequate size
✅ Navigation: Works well
✅ Footer: Proper spacing

Issues: 1 (touch targets)
Score: 88% ✅

[768px] iPad (Portrait)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Layout: Two-column layout appropriate
⚠️  Typography: Line length too long (120ch, needs <80ch)
✅ No Horizontal Scroll
✅ Touch Targets: All adequate
⚠️  Images: Some stretched, not using srcset
  Fix: Add tablet-specific images

✅ Form Inputs: Good size
⚠️  Navigation: Desktop nav on tablet (could improve)
  Consider: Tablet-specific navigation pattern

✅ Footer: Three-column layout works

Issues: 3 (all moderate)
Score: 82% ⚠️

[1024px] iPad Landscape / Desktop
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Layout: Sidebar + main content (good)
✅ Typography: Excellent readability
✅ No Horizontal Scroll
✅ Click Targets: All large enough (desktop)
✅ Images: High-res versions loaded
✅ Form Inputs: Well-sized with labels
✅ Navigation: Full desktop nav
✅ Footer: Four-column layout

Issues: 0
Score: 100% ✅

[1920px] Desktop 1080p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Layout: Max-width container centers content
⚠️  Typography: Some headings could be larger
✅ No Horizontal Scroll
✅ Click Targets: All adequate
✅ Images: Full resolution
✅ Form Inputs: Good proportions
✅ Navigation: Well-spaced
⚠️  Footer: Content feels sparse (add more padding)

Issues: 2 (minor)
Score: 92% ✅

CRITICAL ISSUES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Issue 1: Horizontal Scroll on 320px
Location: Payment form
Cause: Form container padding 24px + form width
Impact: Poor UX, content cut off
Fix:
```css
@media (max-width: 375px) {
  .payment-form {
    padding: 16px; /* Was 24px */
  }
}
```
Priority: P0 - Critical
Effort: 5 minutes

🔴 Issue 2: Touch Targets Too Small
Location: Edit buttons, promo toggle, back button
Current: 32-40px
Required: 44x44px (iOS), 48x48px (Android recommended)
Impact: Hard to tap, accessibility violation
Fix:
```css
.button-small,
.link-button {
  min-width: 44px;
  min-height: 44px;
  padding: 12px; /* Increase from 8px */
}
```
Priority: P0 - Critical (accessibility)
Effort: 10 minutes

🔴 Issue 3: Form Input Height Too Small
Location: All form inputs on mobile
Current: 36px
Required: 44px minimum for touch
Impact: Hard to tap, poor UX
Fix:
```css
@media (max-width: 768px) {
  input,
  select,
  textarea {
    min-height: 44px;
    font-size: 16px; /* Prevents zoom on iOS */
  }
}
```
Priority: P0 - Critical
Effort: 5 minutes

IMPORTANT ISSUES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Issue 4: Text Too Small on 320px
Location: Helper text, labels
Current: 12px
Recommended: 14px minimum
Fix: Increase base font size on smallest screens

⚠️  Issue 5: Line Length Too Long (Tablet)
Location: Content areas on tablet
Current: 120 characters per line
Recommended: 50-80 characters for readability
Fix: Add max-width to content containers

⚠️  Issue 6: Images Not Optimized
Location: Product images
Issue: Single image size for all devices
Fix: Implement srcset for responsive images
```html
<img
  src="product-800.jpg"
  srcset="
    product-400.jpg 400w,
    product-800.jpg 800w,
    product-1200.jpg 1200w,
    product-1600.jpg 1600w
  "
  sizes="
    (max-width: 768px) 100vw,
    (max-width: 1024px) 50vw,
    33vw
  "
  alt="Product name"
/>
```

TOUCH-FRIENDLY CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Minimum Sizes (iOS HIG / Android Material):
✅ Primary Buttons: 48x48px (good)
❌ Secondary Buttons: 32x32px → needs 44x44px
❌ Icon Buttons: 36x36px → needs 44x44px
✅ Form Inputs: 44px height (after fix)
❌ Links: Some too small → add padding
✅ Checkboxes/Radio: 24x24px (acceptable with padding)

Spacing Between Targets:
✅ Primary actions: 16px spacing (good)
⚠️  Secondary actions: 8px → recommend 12px
✅ Form fields: 16px spacing (good)

Tap Feedback:
✅ Buttons: Ripple effect present
⚠️  Links: No visual feedback → add
❌ Form inputs: No focus ring on mobile → add

MOBILE-SPECIFIC ISSUES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

iOS Safari:
⚠️  Input zoom on focus (font-size < 16px)
  Fix: Set font-size: 16px on inputs
  ```css
  input { font-size: 16px; }
  ```

⚠️  Fixed positioning on scroll
  Issue: Fixed header jumps during scroll
  Fix: Use position: sticky instead

✅ Safe area insets: Properly handled
  Good use of: padding: env(safe-area-inset-*)

Android Chrome:
✅ Viewport meta tag: Correct
✅ Touch scrolling: Smooth
⚠️  Address bar: Content shifts when bar hides
  Consider: Using 100vh vs 100dvh

Landscape Orientation:
⚠️  Navigation takes too much vertical space
  Fix: Collapse to hamburger on landscape mobile

✅ Content readable in landscape
⚠️  Form requires scrolling to see submit button
  Fix: Sticky footer with submit button

RESPONSIVE IMAGES AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Implementation:
❌ Single image size served to all devices
❌ No srcset or picture element used
❌ No lazy loading implemented
⚠️  Images not optimized (large file sizes)

Issues Found:
1. Desktop images (1600px) served to mobile (wasted bandwidth)
2. Image file sizes: 800KB avg (should be <200KB for mobile)
3. No WebP format support
4. No art direction for different aspect ratios

Recommended Implementation:
```html
<picture>
  <source
    media="(max-width: 768px)"
    srcset="product-mobile.webp"
    type="image/webp"
  />
  <source
    media="(min-width: 769px)"
    srcset="product-desktop.webp"
    type="image/webp"
  />
  <img
    src="product-fallback.jpg"
    alt="Product name"
    loading="lazy"
  />
</picture>
```

TYPOGRAPHY SCALE AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mobile (320-768px):
✅ Body text: 16px (readable)
⚠️  Small text: 12px → increase to 14px
✅ Headings: Appropriate scale
⚠️  Line height: 1.4 → increase to 1.5 for readability

Tablet (769-1023px):
✅ Body text: 16px
✅ Headings: Scaled appropriately
⚠️  Line length: Too long (fix with max-width)

Desktop (1024px+):
✅ Body text: 16-18px
✅ Headings: Large and clear
✅ Line height: 1.5-1.6

Fluid Typography:
💡 Consider implementing:
```css
body {
  font-size: clamp(16px, 1rem + 0.5vw, 18px);
}

h1 {
  font-size: clamp(24px, 2rem + 2vw, 48px);
}
```

LAYOUT PATTERNS ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mobile (320-768px):
✅ Single column layout
✅ Stack elements vertically
✅ Full-width containers
⚠️  Some horizontal padding too large (24px → 16px on 320px)

Tablet (769-1023px):
✅ Two-column layout where appropriate
⚠️  Some sections force single column (could use two)
✅ Proper use of CSS Grid/Flexbox

Desktop (1024px+):
✅ Multi-column layouts
✅ Sidebar + main content
✅ Max-width container (1280px)
✅ Centered content

Responsive Techniques Used:
✅ Flexbox for flexible layouts
✅ CSS Grid for complex layouts
⚠️  Some media queries (could use container queries)
❌ No container queries (modern approach)

ACCESSIBILITY AT DIFFERENT SIZES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mobile:
❌ Touch targets too small (critical)
✅ Text readable (16px+)
✅ Adequate color contrast
⚠️  Focus indicators need improvement

Tablet:
✅ Touch/click targets adequate
✅ Text readable
⚠️  Line length too long

Desktop:
✅ Click targets adequate
✅ Text readable
✅ Keyboard navigation works

Text Zoom (200%):
⚠️  Layout breaks at 200% zoom on mobile
  Fix: Use relative units (rem, em) not px

RECOMMENDATIONS (Prioritized)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Immediate (P0 - Critical):
1. Fix horizontal scroll on 320px (5 min)
2. Increase touch targets to 44x44px (10 min)
3. Increase form input height to 44px (5 min)
4. Set input font-size to 16px (iOS zoom fix) (2 min)

High Priority (P1):
5. Implement responsive images with srcset (1 hour)
6. Fix text size on smallest screens (14px min) (10 min)
7. Add touch feedback to all tappable elements (30 min)
8. Fix line length on tablet (max-width) (5 min)

Medium Priority (P2):
9. Optimize image file sizes (compress, WebP) (2 hours)
10. Implement lazy loading for images (30 min)
11. Add container queries for modern responsiveness (1 hour)
12. Improve landscape mobile experience (1 hour)
13. Implement fluid typography (30 min)

TESTING CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Device Testing:
- [ ] iPhone SE (320px)
- [ ] iPhone 12/13/14 (390px)
- [ ] iPhone 12/13/14 Plus (414px)
- [ ] iPad (768px portrait, 1024px landscape)
- [ ] iPad Pro (1024px portrait, 1366px landscape)
- [ ] Laptop (1280px, 1440px)
- [ ] Desktop (1920px, 2560px)

Browser Testing:
- [ ] Chrome (desktop & mobile)
- [ ] Safari (desktop & iOS)
- [ ] Firefox (desktop & mobile)
- [ ] Edge (desktop)
- [ ] Samsung Internet (Android)

Orientation:
- [ ] Portrait mode (all mobile/tablet sizes)
- [ ] Landscape mode (all mobile/tablet sizes)

Interactions:
- [ ] Touch (mobile/tablet)
- [ ] Mouse (desktop)
- [ ] Keyboard (all sizes)
- [ ] Trackpad (laptop)

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Fix P0 critical issues (touch targets, scroll)
2. Test fixes on real devices
3. Implement responsive images
4. Conduct user testing on mobile devices
5. Set up automated responsive testing (Percy, Chromatic)
6. Document responsive patterns in design system

Tools for Ongoing Testing:
• Chrome DevTools Device Mode
• BrowserStack (cross-device testing)
• LambdaTest (visual testing)
• Percy (visual regression)
• Responsively App (local testing)

TARGET: 90%+ Score Across All Devices
Current: 78% | Gap: 12% | ETA: 1 week

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📱 Test on real devices when possible!
Simulators are good, but real devices reveal true UX issues.
```

## Collaboration

**Led by:**
- **ui-component-reviewer**: Responsive component review
- **interaction-designer**: Touch interactions

**Supports:**
- **accessibility-specialist**: Touch target accessibility
- **design-system-expert**: Responsive token patterns
- **qa-engineers**: Device testing

Focus on ensuring excellent experiences across all devices, with special attention to mobile where most users interact with the product.
