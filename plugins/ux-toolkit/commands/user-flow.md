---
description: User flow creation and optimization
---

**Purpose**: User flow creation and optimization

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Analyze and optimize user flow for $ARGUMENTS"

Map user journeys, identify friction points, optimize conversion funnels, and improve task completion rates.

## Usage Examples
- `/user-flow --analyze checkout --funnel`
- `/user-flow --create signup --steps`
- `/user-flow --optimize /payment --drop-off`
- `/user-flow --compare current-vs-proposed --metrics`

## Command-Specific Flags
--analyze: "Analyze existing flow"
--create: "Create new flow diagram"
--optimize: "Suggest optimizations"
--funnel: "Conversion funnel analysis"
--steps: "Step-by-step breakdown"
--drop-off: "Identify drop-off points"
--compare: "Compare two flows"
--metrics: "Show completion/conversion metrics"
--mobile: "Mobile-specific flow analysis"

## User Flow Analysis

### Flow Mapping
```
Entry → Step 1 → Decision → Step 2 → Success
                    ↓
                 Alt Path → Step 3 → Success
                    ↓
                 Error → Recovery → Retry
```

### Key Elements
1. **Entry Points**: How users discover/start flow
2. **Steps**: Actions required to progress
3. **Decision Points**: User choices that branch flow
4. **Friction Points**: Where users struggle or abandon
5. **Exit Points**: Success, abandonment, or errors

## Output Format

```
🗺️  USER FLOW ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Flow: E-commerce Checkout
Type: Conversion Funnel
Current Conversion: 38%
Target: 61%+ (industry benchmark: 55%)

CURRENT FLOW (7 Steps)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Cart Page
    ├─ Continue Shopping (15% exit)
    └─ Proceed to Checkout (85% continue) ✅

[2] Proceed to Checkout Interstitial
    └─ Click "Checkout" button (100% continue)
    ⚠️  ISSUE: Unnecessary step, adds 0 value

[3] Login or Guest Checkout
    ├─ Create Account (20% choose, 50% abandon) 🔴
    ├─ Login (20% choose, 80% complete)
    └─ Guest Checkout (60% choose, 95% complete)
    Overall: 60% continue, 40% DROP-OFF 🔴

    🔴 CRITICAL FRICTION POINT
    - 40% of users abandon here
    - Forced account creation major barrier
    - Guest option not prominent enough

[4] Shipping Address
    ├─ Manual entry (80%)
    └─ Autofill/saved address (20%)
    Continue: 90% ✅

    ⚠️  Minor friction:
    - Form validation too aggressive (on blur)
    - 12 fields feels overwhelming

[5] Shipping Method
    ├─ Standard (65%)
    ├─ Express (30%)
    └─ Overnight (5%)
    Continue: 95% ✅

    Could combine with Step 4 (reduce clicks)

[6] Payment Information
    ├─ Credit Card (70%)
    ├─ PayPal (20%)
    └─ Other (10%)
    Continue: 88% ✅

    ⚠️  Friction:
    - Security concerns (trust badges help)
    - Complex form (13 fields)
    - No saved payment for returning users

[7] Review & Place Order
    └─ Place Order (75% complete, 25% abandon) ⚠️

    ⚠️  Last-minute friction:
    - Unexpected costs (shipping, taxes)
    - Long delivery time
    - Second thoughts

OVERALL CONVERSION:
85% × 100% × 60% × 90% × 95% × 88% × 75% = 38.4%

DROP-OFF ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

100 users start checkout:

Step 1 (Cart): 100 users
  ↓ 85% continue (15 abandon - normal cart abandonment)
Step 2 (Proceed): 85 users
  ↓ 100% continue (0 abandon)
Step 3 (Login/Guest): 85 users
  ↓ 60% continue (34 abandon) 🔴 HIGHEST DROP-OFF
Step 4 (Shipping): 51 users
  ↓ 90% continue (5 abandon)
Step 5 (Method): 46 users
  ↓ 95% continue (2 abandon)
Step 6 (Payment): 44 users
  ↓ 88% continue (5 abandon)
Step 7 (Review): 39 users
  ↓ 75% complete (10 abandon)

Final: 29 conversions out of 100 = 29% conversion

Wait, calculation error above. Recalculating:
- Start with abandoners already gone at cart
- 85 proceed to actual checkout
- 85 × 60% × 90% × 95% × 88% × 75% = 30.6 complete
- Checkout conversion: 36% (30.6/85)
- Overall conversion including cart: 31% (30.6/100)

FRICTION POINT ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 CRITICAL (Step 3 - Login/Guest):
Problem: 40% abandon when forced to login/register
Root Causes:
  - "Create Account" presented as primary option
  - Guest checkout buried/not obvious
  - Account creation form too long (8 fields)
  - No explanation of account benefits
  - Password requirements too strict

Impact: Losing 34 of 85 users (40%)
Solution:
  ✅ Make guest checkout primary option
  ✅ Simplify: just email for guest
  ✅ Offer account creation AFTER purchase
  ✅ Add social login (Google, Apple)
  ✅ Show clear benefits of account

Expected Improvement: +15% (from 60% to 75% continue)
New conversion: 36% → 45%

🟡 MODERATE (Step 2 - Interstitial):
Problem: Unnecessary "Proceed to Checkout" screen
Impact: Extra click, minor friction, slows flow
Solution: Remove entirely, go direct from cart to checkout
Expected Improvement: +2% (from 100% to 102% - time saved)

🟡 MODERATE (Step 6 - Payment):
Problem: 12% abandon at payment
Root Causes:
  - Security concerns
  - Complex form (13 fields)
  - No saved payment option
  - Credit card errors

Solution:
  ✅ Add trust badges (Norton, McAfee)
  ✅ Show accepted payment methods upfront
  ✅ Save payment for returning users
  ✅ Better card validation with helpful errors
  ✅ Add Apple Pay / Google Pay

Expected Improvement: +5% (from 88% to 93% continue)

🟢 MINOR (Step 7 - Review):
Problem: 25% abandon at final step
Root Causes:
  - Unexpected costs revealed late
  - Long delivery times
  - Second thoughts / comparison shopping

Solution:
  ✅ Show estimated total earlier (in cart)
  ✅ Highlight delivery date prominently
  ✅ Add "Save for later" option
  ✅ Add urgency ("2 left in stock")
  ✅ Offer promo code field earlier

Expected Improvement: +7% (from 75% to 82% complete)

OPTIMIZED FLOW (4 Steps)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Cart → Checkout (Combined)
    ├─ Cart items in sidebar
    ├─ Estimated total visible
    └─ Direct to shipping form
    ⚠️  Change: Removed interstitial
    Continue: 85% (same)

[2] Shipping (Email + Address + Method)
    ├─ Email (for guest) or Login (optional)
    ├─ Shipping address (autofill enabled)
    ├─ Shipping method (same page)
    └─ Guest checkout default, account optional
    ⚠️  Changes: Combined steps 3, 4, 5
    Continue: 75% (up from 60% × 90% × 95% = 51%)
    📈 Improvement: +47% relative increase

[3] Payment (Method + Billing)
    ├─ Payment method (cards, PayPal, Apple/Google Pay)
    ├─ Billing address (same as shipping checkbox)
    ├─ Trust badges visible
    └─ Order summary in sidebar
    ⚠️  Changes: Added express pay, trust signals
    Continue: 93% (up from 88%)
    📈 Improvement: +6%

[4] Confirmation
    ├─ Order placed!
    ├─ Order number + email sent
    └─ Optional: Create account to track order
    ⚠️  Changes: Account creation AFTER purchase
    Complete: 82% (up from 75%)
    📈 Improvement: +9%

OPTIMIZED CONVERSION:
85% × 75% × 93% × 82% = 48.6%

vs. Current: 36%
Improvement: +35% relative increase (+12.6 percentage points)

PROJECTED IMPACT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Performance:
- 100 users start checkout
- 36 complete purchase
- Revenue: $36,000 (assuming $1,000 AOV)

Optimized Performance:
- 100 users start checkout
- 49 complete purchase (+36%)
- Revenue: $49,000 (+36%)
- Additional revenue: $13,000 per 100 users

Annual Impact (assuming 10,000 monthly checkouts):
- Additional conversions: 1,560/month, 18,720/year
- Additional revenue: $1.56M/month, $18.72M/year

ROI: Implementation cost ~$40K vs $18.72M gain = 468:1

IMPLEMENTATION ROADMAP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase 1 (Quick Wins - Week 1):
✅ Remove interstitial "Proceed" page
✅ Make guest checkout more prominent
✅ Combine shipping address + method
✅ Add trust badges to payment page

Expected Gain: +8% conversion (36% → 39%)
Effort: 2-3 days development

Phase 2 (Medium Changes - Week 2-3):
✅ Add social login (Google, Apple)
✅ Implement saved payment methods
✅ Add Apple Pay / Google Pay
✅ Improve form validation (less aggressive)
✅ Show delivery estimate earlier

Expected Gain: +5% conversion (39% → 41%)
Effort: 1 week development

Phase 3 (Major Changes - Week 4-6):
✅ Redesign login/guest flow
✅ Move account creation to post-purchase
✅ Implement full 4-step optimized flow
✅ Add progress indicator
✅ Enhance order summary sidebar

Expected Gain: +7% conversion (41% → 49%)
Effort: 2-3 weeks development

A/B TESTING PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1: Guest Checkout Prominence
  Variant A: Current (account creation primary)
  Variant B: Guest checkout primary
  Metric: Step 3 drop-off rate
  Traffic: 50/50 split
  Duration: 2 weeks
  Expected: -15% drop-off (40% → 25%)

Test 2: Combined Shipping Flow
  Variant A: Separate address + method pages
  Variant B: Combined into one page
  Metric: Time to complete, drop-off
  Traffic: 50/50 split
  Duration: 2 weeks
  Expected: -30% time, -5% drop-off

Test 3: Payment Express Options
  Variant A: Traditional card entry only
  Variant B: Apple/Google Pay prominent
  Metric: Payment completion rate
  Traffic: 50/50 split (mobile only)
  Duration: 2 weeks
  Expected: +10% completion on mobile

SUCCESS METRICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primary Metrics:
✅ Checkout conversion rate: 36% → 49% (+36%)
✅ Revenue per 100 visitors: $36K → $49K (+36%)
✅ Time to complete: 4:30 → 3:00 (-33%)

Secondary Metrics:
✅ Drop-off at login: 40% → 15% (-62%)
✅ Payment completion: 88% → 93% (+6%)
✅ Final step completion: 75% → 82% (+9%)
✅ Mobile conversion: 28% → 38% (+36%)

User Experience:
✅ Steps to complete: 7 → 4 (-43%)
✅ Form fields: 35 → 24 (-31%)
✅ Required clicks: 12 → 6 (-50%)
✅ Perceived simplicity: ⭐⭐⭐ → ⭐⭐⭐⭐⭐

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Review and approve optimization plan
2. Create design mockups for new flow
3. Develop Phase 1 quick wins
4. Set up A/B testing infrastructure
5. Launch Phase 1, monitor metrics
6. Iterate based on data
7. Roll out Phase 2 and 3
8. Achieve 49%+ conversion target

Timeline: 6-8 weeks to full implementation
Monitoring: Real-time analytics dashboard
Review: Weekly metrics review meetings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Analytics Setup:
- Google Analytics 4 enhanced ecommerce
- Hotjar session recordings
- Drop-off funnel visualization
- A/B test tracking (Optimizely/VWO)
```

## Mobile-Specific Flow Considerations

### Mobile Optimizations
- Fewer form fields per screen
- Autofill everything possible
- Apple Pay / Google Pay prominent
- Large touch targets (48x48px min)
- Progress indicator always visible
- Easy to go back/edit
- Keyboard-friendly inputs

### Mobile vs Desktop Differences
- Mobile: Vertical stack, one column
- Desktop: Sidebar with order summary
- Mobile: Sticky CTA button
- Desktop: CTA in flow

## Collaboration

**Led by:**
- **user-flow-architect**: Flow mapping and optimization

**Supports:**
- **ui-component-reviewer**: Step-by-step UI review
- **interaction-designer**: Transition design
- **accessibility-specialist**: Navigation accessibility
- **product-managers**: Metrics and business goals

Focus on reducing friction, minimizing steps, and maximizing conversion while maintaining a delightful user experience.
