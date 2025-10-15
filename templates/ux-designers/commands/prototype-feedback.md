**Purpose**: Analyze and provide feedback on design prototypes

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Provide prototype feedback for $ARGUMENTS"

Review design prototypes (Figma, Adobe XD, Sketch, etc.) and provide comprehensive UX/UI feedback.

## Usage Examples
- `/prototype-feedback --figma-url https://figma.com/file/... --complete`
- `/prototype-feedback --compare prototype-v1 vs prototype-v2`
- `/prototype-feedback --focus usability --heuristics`
- `/prototype-feedback --mobile-app --flow checkout`

## Command-Specific Flags
--figma-url: "Figma prototype URL"
--adobe-xd: "Adobe XD prototype"
--sketch: "Sketch prototype"
--compare: "Compare two prototype versions"
--focus: "Focus area (usability, visual, accessibility, flow)"
--complete: "Complete review (all aspects)"
--heuristics: "Nielsen's heuristics evaluation"
--flow: "Specific user flow to review"
--mobile-app: "Mobile app prototype"
--web-app: "Web application prototype"

## Evaluation Framework

### 1. Visual Design (20%)
- Brand consistency
- Typography hierarchy
- Color usage and contrast
- Spacing and alignment
- Visual balance

### 2. Usability (30%)
- Intuitive navigation
- Clear CTAs
- Error prevention
- Help and documentation
- User control

### 3. User Flow (20%)
- Logical task flow
- Minimal steps
- Clear next actions
- Exit points
- Error recovery

### 4. Accessibility (15%)
- Color contrast
- Touch targets
- Text readability
- Screen reader support
- Keyboard navigation

### 5. Interaction Design (15%)
- Micro-interactions
- Transitions
- Loading states
- Feedback
- Animations

## Output Format

```
🎨 PROTOTYPE FEEDBACK REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Prototype: E-commerce Mobile App - Checkout Flow
Version: v2.1
Tool: Figma
Date: 2025-10-04
Reviewer: UX Designer (Claude)

OVERALL ASSESSMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Score: 78/100 ⚠️  Good, but needs improvement

Breakdown:
  Visual Design: 85/100 ✅ Strong
  Usability: 72/100 ⚠️  Needs work
  User Flow: 75/100 ⚠️  Needs optimization
  Accessibility: 68/100 ❌ Below standard
  Interaction Design: 80/100 ✅ Good

Readiness: Not ready for development
Recommendation: Address critical and high-priority issues before handoff

EXECUTIVE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Strengths:
✅ Beautiful visual design with strong brand identity
✅ Well-designed product cards with clear hierarchy
✅ Smooth transitions and micro-interactions
✅ Modern, clean interface

Areas for Improvement:
⚠️  Checkout flow has too many steps (7 → should be 4)
⚠️  Guest checkout not prominent enough (40% drop-off expected)
❌ Color contrast violations on 5 screens (WCAG AA)
❌ Touch targets below 44px minimum (12 instances)
⚠️  Loading states missing on 8 screens
⚠️  Error states inconsistent or missing

Critical Blockers (Must fix before development):
🔴 1. WCAG color contrast violations (accessibility)
🔴 2. Touch targets too small (usability + accessibility)
🔴 3. Checkout flow optimization needed (conversion impact)

DETAILED FEEDBACK BY SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Screen 1: Product Listing]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visual Design: 90/100 ✅
✅ Beautiful product cards with clear images
✅ Good use of white space
✅ Typography hierarchy clear (title → price → rating)
⚠️  Product title line-height could be looser (1.3 → 1.4)

Usability: 85/100 ✅
✅ Clear "Add to Cart" button
✅ Wishlist heart icon prominent
⚠️  Filter button position not intuitive (top-left vs expected top-right)
💡 Consider: Add quick view option

Accessibility: 75/100 ⚠️
⚠️  Heart icon button: 36x36px (needs 44x44px)
✅ Product images have alt text (good)
⚠️  "Sort by" dropdown: no visible label (needs aria-label)

Interaction Design: 88/100 ✅
✅ Heart animation on favorite is delightful
✅ "Add to Cart" ripple effect
⚠️  Product card hover state too subtle (add slight elevation)

Recommendations:
1. Increase heart icon touch target to 44x44px
2. Move filter button to top-right (standard position)
3. Add aria-label to "Sort by" dropdown
4. Enhance hover state with subtle shadow elevation
5. Consider adding product quick view modal

[Screen 2: Cart]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visual Design: 82/100 ✅
✅ Clean layout with clear hierarchy
⚠️  Quantity selector feels cramped (increase spacing)
⚠️  Remove button too prominent (red, should be subtle)

Usability: 78/100 ⚠️
✅ Clear "Proceed to Checkout" CTA
⚠️  "Continue Shopping" link too subtle (users might miss it)
❌ No "Save for Later" option (common user need)
⚠️  Empty cart state not shown in prototype

User Flow: 70/100 ⚠️
✅ Clear path to checkout
⚠️  Should show estimated total including taxes/shipping
⚠️  Promo code field hidden (show prominently or inline)

Accessibility: 65/100 ❌
❌ Quantity - and + buttons: 32x32px (need 44x44px)
❌ Remove button: "X" icon only, no text label
⚠️  Color contrast on "Continue Shopping" link: 3.8:1 (needs 4.5:1)

Recommendations:
1. Increase quantity button touch targets to 44x44px
2. Add text label to remove button or increase icon size
3. Fix color contrast on "Continue Shopping" link
4. Add "Save for Later" functionality
5. Show estimated total including taxes
6. Design empty cart state
7. Make promo code field more discoverable

[Screen 3: Checkout - Login/Guest]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usability: 45/100 ❌ Critical Issues
❌ "Create Account" is primary option (causes drop-off)
❌ Guest checkout buried below fold
❌ No explanation of account benefits
⚠️  Social login options missing (Google, Apple)
⚠️  Password requirements not shown until error

User Flow: 40/100 ❌ Major Friction Point
🔴 CRITICAL: This screen causes 40%+ drop-off in checkout
❌ Forcing account decision too early
❌ Account creation form too long (8 fields)
❌ No way to skip and decide later

Recommendations (High Priority):
🔴 1. Make guest checkout the primary, prominent option
🔴 2. Simplify guest: just email, no form
🔴 3. Move account creation to AFTER purchase completion
🔴 4. Add social login options (Google, Apple)
🔴 5. Show clear benefits of creating account
🔴 6. Allow users to create account later from email

Alternative Design:
```
Primary CTA: "Continue as Guest"
Secondary: "Login" (if existing customer)
Tertiary: Small text "Create account after checkout"
```

[Screen 4-7: Shipping, Payment, Review]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(Combined feedback as flow)

User Flow: 68/100 ⚠️
⚠️  Too many screens (4 separate: address, method, payment, review)
💡 Optimize to 2 screens: (1) Shipping + Method, (2) Payment + Review

Missing States:
❌ Loading states: Not designed for 8 screens
❌ Error states: Inconsistent across screens
❌ Success states: Missing for form validation
⚠️  Empty states: Not shown (e.g., no saved addresses)

Form Design:
✅ Labels clear and descriptive
⚠️  Too many required fields (simplify)
❌ Inline validation too aggressive (errors on blur, should be on submit)
⚠️  Autofill not considered (may break layout)

Accessibility: 62/100 ❌
❌ Form inputs: 36px height (need 44px on mobile)
❌ Checkbox touch targets: 24x24px (need 44x44px with padding)
⚠️  Error messages: Not associated with inputs (need aria-describedby)
⚠️  Required field indicators: Asterisk only (need text "required")

Recommendations:
1. Combine screens: Shipping + Method (one screen), Payment + Review (one screen)
2. Design all missing states (loading, error, success, empty)
3. Increase form input height to 44px minimum
4. Improve form validation UX (less aggressive)
5. Associate error messages with inputs (aria-describedby)
6. Add clear required field indicators
7. Consider autofill and layout shifts

NIELSEN'S HEURISTICS EVALUATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Visibility of System Status: 70/100 ⚠️
⚠️  No loading indicators designed
⚠️  Progress indicator in checkout could be clearer
✅ Cart badge shows item count (good)

2. Match Between System and Real World: 85/100 ✅
✅ Language clear and user-friendly
✅ Icons familiar and understandable
⚠️  "Proceed to Checkout" could be "Go to Checkout"

3. User Control and Freedom: 75/100 ⚠️
✅ Back navigation present
⚠️  No "Cancel" or "Exit Checkout" option
⚠️  No way to edit previous steps easily

4. Consistency and Standards: 82/100 ✅
✅ Consistent button styles
✅ Consistent color usage
⚠️  Inconsistent error message placement

5. Error Prevention: 60/100 ⚠️
⚠️  Form validation too aggressive (errors appear too soon)
⚠️  No confirmation for destructive actions (remove from cart)
❌ No "Save for Later" option to prevent accidental removal

6. Recognition Rather Than Recall: 78/100 ⚠️
✅ Order summary visible in checkout
⚠️  No breadcrumbs (users don't know where they are)
⚠️  Saved addresses not shown in prototype

7. Flexibility and Efficiency: 70/100 ⚠️
⚠️  No social login (slower for new users)
⚠️  No Apple Pay / Google Pay (mobile efficiency)
⚠️  No keyboard shortcuts or search

8. Aesthetic and Minimalist Design: 88/100 ✅
✅ Clean, uncluttered interface
✅ Good use of white space
⚠️  Some screens have too much text (e.g., T&C)

9. Help Users Recognize, Diagnose, Recover from Errors: 65/100 ❌
❌ Error messages generic ("Invalid input")
❌ No helpful suggestions for correction
⚠️  Error states inconsistent across screens

10. Help and Documentation: 60/100 ⚠️
⚠️  No help icons or tooltips
⚠️  No FAQ or live chat option
⚠️  Shipping/return policy not easily accessible

INTERACTION DESIGN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Micro-interactions:
✅ Favorite heart animation: Delightful scale + color change
✅ Add to Cart button: Ripple effect, loading state
⚠️  Quantity selector: No feedback on +/- button press
⚠️  Form inputs: No focus animation (add subtle highlight)

Transitions:
✅ Screen transitions: Smooth slide animation
⚠️  Modal appears: Too sudden (add fade + scale)
❌ Error state appears: Instant (add gentle shake animation)

Missing Interactions:
❌ Pull-to-refresh (mobile app)
❌ Swipe to remove item from cart (mobile pattern)
❌ Skeleton loading screens (better perceived performance)
❌ Success confetti/celebration (order placed)

Recommendations:
1. Add micro-feedback to all interactive elements
2. Design skeleton loading screens
3. Add gentle shake animation to form errors
4. Add success celebration animation (order placed)
5. Consider swipe gestures for mobile (remove item)

ACCESSIBILITY DETAILED AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Color Contrast Violations (WCAG 2.1 AA):
❌ 1. "Continue Shopping" link: 3.8:1 (needs 4.5:1)
❌ 2. Helper text: 3.2:1 (needs 4.5:1)
❌ 3. Disabled button: 2.1:1 (intentionally low, but may need adjustment)
❌ 4. Sale price (strikethrough): 3.9:1 (needs 4.5:1)
❌ 5. Placeholder text: 3.0:1 (needs 4.5:1)

Touch Target Violations (iOS 44x44px, Android 48x48px):
❌ 1. Heart/Favorite icon: 36x36px
❌ 2. Quantity +/- buttons: 32x32px
❌ 3. Remove item X button: 32x32px
❌ 4. Back button: 40x40px
❌ 5. Close modal X: 32x32px
❌ 6. Checkbox: 24x24px (needs padding to reach 44px)
❌ 7. Radio buttons: 24x24px (needs padding)
❌ 8. Edit button: 36x36px
❌ 9. Filter chips: 32px height
❌ 10. Social login icons: 40x40px
❌ 11. Breadcrumb links: 36px height
❌ 12. Tab bar icons: 40x40px

Screen Reader Considerations:
⚠️  Image alt text: Not specified in prototype
⚠️  Button labels: Some icon-only (need aria-label)
⚠️  Form errors: Not programmatically associated
⚠️  Loading states: No aria-live announcements

Keyboard Navigation:
⚠️  Tab order: Not indicated in prototype
⚠️  Focus indicators: Not designed (need 3px outline)
⚠️  Modal focus trap: Not specified
⚠️  Skip links: Not present

CRITICAL PRIORITIES (Before Development)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Must Fix (P0 - Blockers):
🔴 1. Fix all color contrast violations (5 instances)
🔴 2. Increase all touch targets to 44x44px minimum (12 instances)
🔴 3. Redesign checkout login/guest screen (conversion impact)
🔴 4. Design all missing states (loading, error, success)

Should Fix (P1 - Important):
🟡 5. Optimize checkout flow (7 steps → 4 steps)
🟡 6. Design empty cart state
🟡 7. Add "Save for Later" functionality
🟡 8. Improve form validation UX
🟡 9. Add social login options
🟡 10. Design focus indicators for keyboard nav

Nice to Have (P2 - Enhancements):
🟢 11. Add skeleton loading screens
🟢 12. Add success celebration animation
🟢 13. Add swipe gestures (mobile)
🟢 14. Add quick view product modal
🟢 15. Add help/tooltip system

COMPARISON WITH BEST PRACTICES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Industry Benchmarks (E-commerce):
✅ Product cards: Match best practices
⚠️  Checkout flow: 7 steps (benchmark: 4-5 steps)
❌ Checkout conversion: Est. 35% (benchmark: 55%+)
✅ Mobile-first design: Yes (good)
⚠️  Loading time: Unknown (need to test)

Competitor Analysis:
Amazon: Guest checkout prominent ✅ (ours: hidden ❌)
Shopify: Express checkout options ✅ (ours: missing ❌)
Apple: Touch targets 44px+ ✅ (ours: too small ❌)

RECOMMENDATIONS SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Design Changes Needed:
• 5 color contrast fixes (2-3 hours)
• 12 touch target increases (3-4 hours)
• Checkout flow redesign (8-12 hours)
• Missing states design (6-8 hours)
• Accessibility annotations (2-3 hours)

Estimated Total Effort: 21-30 hours

Timeline to Development Ready:
With 1 designer: 3-4 weeks
With 2 designers: 2 weeks

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Immediate:
1. Fix P0 blockers (color contrast, touch targets, checkout flow)
2. Design missing states (loading, error, success, empty)
3. Add accessibility annotations to Figma

Before Handoff:
4. User test checkout flow with 5-8 users
5. Conduct accessibility review with screen reader
6. Create developer handoff documentation
7. Create component specifications
8. Define interaction specs for animations

After Handoff:
9. Review implementation for design accuracy
10. Conduct QA testing on real devices
11. Iterate based on analytics and user feedback

APPROVAL STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ NOT APPROVED for development handoff

Reason: Critical accessibility and usability issues must be addressed

Required for Approval:
- [ ] All P0 issues fixed
- [ ] Accessibility audit passed (90%+ compliance)
- [ ] User testing completed with positive results
- [ ] Stakeholder sign-off

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Full annotated Figma file needed for developer handoff
📊 Analytics instrumentation plan recommended
🧪 User testing strongly recommended before build
```

## Collaboration

**Led by:**
- **UX Designer Team**: Complete prototype review

**Involves:**
- **ui-component-reviewer**: Visual component assessment
- **accessibility-specialist**: Accessibility compliance
- **user-flow-architect**: Flow optimization
- **interaction-designer**: Interaction specifications
- **product-managers**: Business requirements validation

Focus on providing actionable, prioritized feedback that leads to a production-ready, accessible, and delightful user experience.
