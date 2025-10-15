**Purpose**: Generate comprehensive bug reports with reproduction steps and analysis

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Generate bug report for $ARGUMENTS"

Create detailed, actionable bug reports that enable fast resolution through clear reproduction steps, root cause analysis, and comprehensive evidence.

## Usage Examples
- `/bug-report --title "Payment button disabled on mobile Safari"`
- `/bug-report --severity P1 --classify`
- `/bug-report --reproduce --issue "Checkout fails with 500 error"`
- `/bug-report --template --component PaymentForm`
- `/bug-report --analysis --logs error.log`

## Command-Specific Flags
--title: "Bug title/description"
--severity: "Bug severity: P0, P1, P2, P3, P4"
--classify: "Auto-classify severity through questionnaire"
--reproduce: "Help create minimal reproduction steps"
--template: "Generate bug report template"
--component: "Affected component or feature"
--issue: "Describe the unexpected behavior"
--logs: "Attach log files or error traces"
--analysis: "Include root cause analysis"
--screenshot: "Attach screenshot evidence"
--network: "Include network activity logs"
--regression: "Create regression test"
--assign: "Suggest engineer to assign"

## Bug Report Process

**1. Bug Identification:**
- What is the expected behavior?
- What is actually happening?
- When did this start?
- How often does it occur?

**2. Reproduction:**
- Create minimal steps to reproduce
- Identify required environment
- Note reproduction rate
- Test across browsers/devices

**3. Evidence Collection:**
- Capture screenshots/videos
- Save console errors
- Export network activity
- Gather stack traces

**4. Severity Classification:**
- Assess user impact
- Determine business impact
- Check for workarounds
- Classify P0-P4

**5. Root Cause Analysis:**
- Identify affected code
- Determine why it fails
- Assess scope of impact
- Document findings

**6. Report Creation:**
- Write clear title
- Document reproduction steps
- Attach evidence
- Propose fix (if known)

## Output Format

The bug-report command provides:
1. **Bug Summary**: Title and one-sentence description
2. **Severity Classification**: P0-P4 with justification
3. **Reproduction Steps**: Minimal, sequential steps
4. **Environment Details**: Browser, OS, version
5. **Evidence**: Screenshots, logs, network activity
6. **Root Cause**: Technical analysis (if identified)
7. **Proposed Fix**: Code changes (if known)
8. **Regression Test**: Test to prevent recurrence

## Severity Classification

**P0 - Critical:**
```
Definition:
  - Production completely down
  - Data loss or corruption
  - Security vulnerability
  - Revenue-blocking issue

Action: Immediate hotfix (same day)
SLA: Response immediate, fix within hours
```

**P1 - High:**
```
Definition:
  - Major feature broken
  - Affects >10% of users
  - No workaround available
  - Core functionality impaired

Action: Fix within 24 hours
SLA: Response within 2 hours, fix within 1 day
```

**P2 - Medium:**
```
Definition:
  - Feature partially broken
  - Workaround exists
  - Affects <10% of users
  - Moderate impact

Action: Fix in current sprint
SLA: Response within 1 day, fix within 1 week
```

**P3 - Low:**
```
Definition:
  - Minor visual issue
  - Edge case scenario
  - Minimal user impact
  - Nice-to-have fix

Action: Fix when convenient
SLA: Response within 1 week, fix within 1 month
```

**P4 - Trivial:**
```
Definition:
  - Cosmetic issue
  - Very rare edge case
  - No user impact
  - Enhancement/improvement

Action: Backlog priority
SLA: No SLA, fix when convenient
```

## Bug Report Template

```markdown
# [BUG-XXX] Brief, specific title describing the issue

## Severity: P1 (High)

**Impact**: Prevents users from completing checkout
**Affected Users**: ~40% of users on mobile Safari
**Workaround**: Use desktop browser

## Summary
One-sentence description of the bug and its impact.

## Steps to Reproduce
1. Navigate to /checkout as authenticated user
2. Add item to cart (any product)
3. Click "Proceed to Payment"
4. Select "Credit Card" payment method
5. Fill in credit card details (4242 4242 4242 4242, 12/25, 123)
6. Click "Complete Purchase"

**Result**: Button remains disabled, payment never processes
**Expected**: Payment processes, order confirmation shown

## Environment
- **Browser**: Safari 17.2 (iOS)
- **Device**: iPhone 14 Pro
- **OS**: iOS 17.2.1
- **App Version**: v2.3.1
- **Account Type**: Standard user

## Reproduction Rate
- 8/10 attempts on Safari iOS
- 0/10 attempts on Chrome desktop
- 3/10 attempts on Safari desktop

Browser-specific issue, primarily affects mobile Safari.

## Evidence

### Console Errors
```
Uncaught TypeError: Cannot read property 'addEventListener' of null
    at payment.ts:56:18
    at async initializePaymentForm (payment.ts:45)
```

### Network Logs
- All API requests return 200 OK
- No failed network requests observed
- Payment SDK loads successfully

### Screenshots
[Attached: checkout-button-disabled.png]
[Attached: console-error.png]
[Attached: network-tab.png]

## Root Cause Analysis

**Direct Cause:**
Race condition in payment module initialization.

**Technical Details:**
The payment button's event listener is not being attached because:
1. `initializePaymentForm()` is not `async/await` properly
2. Payment SDK loads asynchronously
3. Event listener attachment happens before SDK is ready
4. Safari's stricter timing exposes the race condition

**Affected Code:**
`src/checkout/payment.ts:45-67`

```typescript
// Current (broken)
function initializePaymentForm() {
  loadPaymentSDK();              // Async, not awaited
  attachEventListeners();        // Runs too early
}
```

## Proposed Fix

```typescript
// Fixed version
async function initializePaymentForm() {
  await loadPaymentSDK();        // Wait for SDK
  attachEventListeners();        // Now SDK is ready
}

// Also ensure button click handler
const paymentButton = document.querySelector('[data-testid="submit-payment"]');
if (!paymentButton) {
  console.error('Payment button not found');
  return;
}
paymentButton.addEventListener('click', handlePayment);
```

## Regression Test

```typescript
// tests/e2e/checkout.spec.ts
test('payment button processes payment on Safari', async ({ page }) => {
  // Use Safari browser
  await page.goto('/checkout');

  // Add item to cart
  await page.click('[data-testid="add-to-cart"]');
  await page.click('[data-testid="checkout"]');

  // Fill payment details
  await page.fill('[data-testid="card-number"]', '4242424242424242');
  await page.fill('[data-testid="card-exp"]', '12/25');
  await page.fill('[data-testid="card-cvc"]', '123');

  // Submit payment
  const submitButton = page.locator('[data-testid="submit-payment"]');

  // Button should be enabled
  await expect(submitButton).toBeEnabled();

  // Click should process payment
  await submitButton.click();

  // Should redirect to confirmation
  await expect(page).toHaveURL(/order-confirmation/);
  await expect(page.locator('[data-testid="order-number"]')).toBeVisible();
});
```

## Related Issues
- #BUG-87: Similar timing issue in checkout flow (closed, fixed)
- #BUG-102: Payment SDK initialization warnings

## Labels
`P1`, `checkout`, `safari`, `mobile`, `race-condition`, `payment`

---

**Reporter**: QA Team
**Date**: 2025-10-04
**Assigned To**: @senior-frontend-engineer
**Sprint**: Sprint 23
**Estimated Fix Time**: 2 hours
```

## Evidence Collection Best Practices

**Screenshots:**
- Capture full viewport
- Include URL in browser
- Highlight specific issue areas
- Show before/after if applicable
- Use clear naming (bug-123-screenshot-1.png)

**Console Logs:**
```javascript
// Enable verbose logging
localStorage.debug = '*';

// Preserve log on navigation
// DevTools → Console → ☑ Preserve log

// Save console output
console.save = function(data, filename) {
  const blob = new Blob([data], {type: 'text/plain'});
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  link.click();
};
```

**Network Activity:**
```
1. Open DevTools (F12)
2. Network tab
3. ☑ Preserve log
4. Reproduce issue
5. Right-click → Save all as HAR
6. Attach HAR file to bug report
```

**Performance Traces:**
```
1. DevTools → Performance tab
2. Start recording
3. Reproduce issue
4. Stop recording
5. Save trace
6. Attach to bug report
```

## Writing Effective Reproduction Steps

**Bad Example:**
```
1. Go to the page
2. Click the button
3. See error
```

**Good Example:**
```
1. Navigate to https://app.example.com/checkout
2. Log in as standard user (not admin)
   - Email: test@example.com
   - Password: Test123!
3. Add "Premium Widget" to cart
   - Click "Add to Cart" on product ID 12345
4. Click "Checkout" button (top right corner)
5. On payment page, select "Credit Card" radio button
6. Fill in card details:
   - Card: 4242 4242 4242 4242
   - Exp: 12/25
   - CVC: 123
7. Click "Complete Purchase" button
8. Observe: Button becomes disabled, no confirmation appears

Expected: Payment processes, redirects to /order-confirmation
Actual: Button disabled, stuck on payment page, console shows error
```

## Root Cause Analysis Framework

**5 Whys Technique:**
```
Bug: Payment button doesn't work

Why? → Event listener not attached
Why? → initializePaymentForm() runs too early
Why? → Payment SDK not loaded yet
Why? → SDK loads asynchronously
Why? → Missing await in initialization

Root Cause: Improper async/await handling
```

**Timeline Analysis:**
```
v2.3.0 (Working):
  - Synchronous payment initialization
  - No SDK dependency

v2.3.1 (Broken):
  - Added Stripe SDK
  - Made initialization async
  - Forgot to await SDK loading
  - Regression introduced

Affected: PR #456, 3 days ago
```

## Output Example

```
Bug Report Generator
===================

Creating bug report for: "Payment fails on mobile Safari"

Step 1: Severity Classification
───────────────────────────────

Is production down? No
Data loss? No
Security issue? No
Revenue blocking? Yes (payments affected)
% users affected: ~40% (mobile Safari users)
Workaround available? Yes (use desktop)
Feature criticality: Core (payment)

Severity: P1 (High Priority)
Reasoning: Revenue-blocking, affects significant users, but workaround exists

Step 2: Reproduction Steps
─────────────────────────

Minimum steps to reproduce:
  1. Open Safari on iOS device
  2. Navigate to checkout
  3. Fill payment form
  4. Click "Complete Purchase"

Reproduction rate: 8/10 (80%)
Environment-specific: Safari iOS primarily

Step 3: Evidence Collection
───────────────────────────

✓ Console errors captured
✓ Network logs exported (HAR)
✓ Screenshots attached (3 files)
⚠ Video recording recommended

Step 4: Root Cause Analysis
───────────────────────────

Analyzing code...

Found: Race condition in payment initialization
File: src/checkout/payment.ts:45-67
Issue: Missing await in async initialization

Confidence: High (90%)

Step 5: Proposed Fix
───────────────────

Fix Type: Add async/await handling
Estimated Time: 2 hours
Breaking Change: No

Code changes:
  - payment.ts: Add async/await (2 lines)
  - payment.test.ts: Add regression test (20 lines)

Step 6: Report Generation
─────────────────────────

✓ Bug report created: bug-report-20251004-123456.md
✓ Regression test template created
✓ Recommended labels added

Next steps:
  [ ] Review bug report for accuracy
  [ ] Attach to issue tracker
  [ ] Assign to engineer
  [ ] Add to current sprint

Report saved to: ./bug-reports/bug-report-20251004-123456.md
```

## Integration with Issue Trackers

**GitHub Issues:**
```bash
# Create issue via CLI
gh issue create \
  --title "[BUG] Payment button disabled on mobile Safari" \
  --body-file bug-report.md \
  --label "P1,bug,checkout,safari" \
  --assignee @senior-engineer
```

**Jira:**
```bash
# Import bug report to Jira
jira-cli create-issue \
  --project PROJ \
  --type Bug \
  --priority High \
  --file bug-report.md
```
