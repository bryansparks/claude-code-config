# Workflow Examples: All 8 Engineer Skills in Action

**Version:** 1.0.0
**Purpose:** Real-world scenarios demonstrating effective use of all Engineer skills

---

## 📖 Table of Contents

1. [Complete Feature Development: E-commerce Checkout](#workflow-1-complete-feature-development)
2. [Critical Bug Fix: Production Login Failure](#workflow-2-critical-bug-fix)
3. [API Redesign: Legacy to RESTful](#workflow-3-api-redesign)
4. [Accessibility Upgrade: Making Dashboard WCAG Compliant](#workflow-4-accessibility-upgrade)
5. [Performance Crisis: Slow Product Search](#workflow-5-performance-crisis)
6. [Security Audit: Pre-Deployment Review](#workflow-6-security-audit)
7. [Quality Improvement: ISO Certification Prep](#workflow-7-quality-improvement)
8. [TDD Implementation: New Payment Service](#workflow-8-tdd-implementation)

---

## Workflow 1: Complete Feature Development
### E-commerce Checkout System

**Scenario:** You need to build a complete checkout system for an e-commerce platform.

**Skills Used:** All 8 skills (complete development lifecycle)

**Duration:** 2-3 days

---

### Day 1: Design & Architecture

#### Step 1: API Design (API Design Review Skill)

```
You: "Help me design a RESTful API for an e-commerce checkout system.
I need endpoints for:
- Cart management
- Shipping address
- Payment processing
- Order confirmation"

Claude (API Design Review):
```

**Output:**
```
🔌 CHECKOUT API DESIGN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RESTful Endpoint Design:

Cart Management:
  GET    /api/v1/cart                    # Get current cart
  POST   /api/v1/cart/items              # Add item to cart
  PATCH  /api/v1/cart/items/:id          # Update item quantity
  DELETE /api/v1/cart/items/:id          # Remove item
  DELETE /api/v1/cart                    # Clear cart

Checkout Process:
  POST   /api/v1/checkout/shipping       # Set shipping address
  GET    /api/v1/checkout/shipping-options  # Get shipping options
  POST   /api/v1/checkout/payment        # Process payment
  POST   /api/v1/checkout/confirm        # Confirm and create order

Orders:
  GET    /api/v1/orders                  # List user's orders
  GET    /api/v1/orders/:id              # Get order details

Response Formats:
  Success (200/201): { data: {...}, meta: {...} }
  Error (4xx/5xx): { error: { code, message, details } }

Versioning: URL-based (/api/v1/)
Authentication: JWT Bearer token
Rate Limiting: 100 requests/min per user

Next: Generate OpenAPI documentation
```

#### Step 2: Security Planning (Security Analysis Skill)

```
You: "What security considerations do I need for this checkout API?"

Claude (Security Analysis):
```

**Output:**
```
🔒 CHECKOUT SECURITY REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Critical Security Controls:

1. Payment Data Security (PCI DSS):
   ✓ Never store credit card numbers
   ✓ Use Stripe/PayPal for payment processing
   ✓ Tokenize payment methods
   ✓ TLS 1.3 for all payment data

2. Authentication & Authorization:
   ✓ JWT with 15-minute expiration
   ✓ Verify user owns cart before checkout
   ✓ Re-authenticate before payment
   ✓ MFA for high-value orders (>$1000)

3. Input Validation:
   ✓ Validate all addresses (prevent XSS)
   ✓ Sanitize user input
   ✓ Verify product IDs exist
   ✓ Check inventory before payment

4. Rate Limiting:
   ✓ Strict limits on checkout endpoints
   ✓ Prevent cart manipulation attacks
   ✓ Block rapid order attempts

5. Audit Logging:
   ✓ Log all checkout attempts
   ✓ Track payment status changes
   ✓ Monitor for fraud patterns

Implementation Priority: P0 (Must implement before launch)
```

#### Step 3: Accessibility Planning (Accessibility Development Skill)

```
You: "I need to build an accessible checkout form. What are the WCAG requirements?"

Claude (Accessibility Development):
```

**Output:**
```
♿ ACCESSIBLE CHECKOUT REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WCAG 2.1 AA Compliance for Checkout:

1. Form Accessibility:
   ✓ All inputs have associated <label> elements
   ✓ Error messages announced to screen readers
   ✓ Required fields marked with aria-required
   ✓ Input validation with clear error guidance
   ✓ Success messages use aria-live="polite"

2. Multi-Step Process:
   ✓ Progress indicator (Step 1 of 3)
   ✓ Breadcrumb navigation
   ✓ Ability to go back and edit
   ✓ Save progress functionality

3. Payment Form:
   ✓ Credit card input with autocomplete
   ✓ Clear labels (Card Number, CVV, Expiry)
   ✓ Inline validation
   ✓ Secure visual indicators

4. Order Review:
   ✓ Clear summary before confirmation
   ✓ Editable fields
   ✓ Total price prominent and accessible

5. Keyboard Navigation:
   ✓ Tab order follows logical flow
   ✓ Enter submits forms
   ✓ Escape cancels modals
   ✓ No keyboard traps

Color Contrast:
  • Text: ≥4.5:1 contrast ratio
  • Interactive elements: ≥3:1
  • Error states: Don't rely solely on color

I'll provide accessible React components next.
```

---

### Day 2: Implementation with TDD

#### Step 4: Test-First Development (Unit Test Generator Skill)

```
You: "Generate tests for a ShoppingCart service using TDD. It should support:
- Adding items
- Removing items
- Calculating total
- Applying discount codes"

Claude (Unit Test Generator):
```

**Output:**
```
🧪 TDD: SHOPPING CART TESTS (RED Phase)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: tests/services/ShoppingCart.test.ts

describe('ShoppingCart', () => {
  describe('addItem', () => {
    it('should add item to empty cart', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 19.99, quantity: 1 });

      expect(cart.getItems()).toHaveLength(1);
      expect(cart.getTotal()).toBe(19.99);
    });

    it('should increment quantity if item already exists', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 19.99, quantity: 1 });
      cart.addItem({ id: '1', name: 'Widget', price: 19.99, quantity: 2 });

      expect(cart.getItems()).toHaveLength(1);
      expect(cart.getItems()[0].quantity).toBe(3);
    });

    it('should throw error for invalid price', () => {
      const cart = new ShoppingCart();

      expect(() => {
        cart.addItem({ id: '1', name: 'Widget', price: -10, quantity: 1 });
      }).toThrow('Price must be positive');
    });
  });

  describe('removeItem', () => {
    it('should remove item from cart', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 19.99, quantity: 1 });
      cart.removeItem('1');

      expect(cart.getItems()).toHaveLength(0);
    });

    it('should not throw when removing non-existent item', () => {
      const cart = new ShoppingCart();

      expect(() => cart.removeItem('999')).not.toThrow();
    });
  });

  describe('calculateTotal', () => {
    it('should calculate total for multiple items', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 19.99, quantity: 2 });
      cart.addItem({ id: '2', name: 'Gadget', price: 29.99, quantity: 1 });

      expect(cart.getTotal()).toBe(69.97);  // 19.99 * 2 + 29.99
    });

    it('should return 0 for empty cart', () => {
      const cart = new ShoppingCart();

      expect(cart.getTotal()).toBe(0);
    });
  });

  describe('applyDiscountCode', () => {
    it('should apply 10% discount for valid code', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 100, quantity: 1 });
      cart.applyDiscountCode('SAVE10');

      expect(cart.getTotal()).toBe(90);  // 10% off
    });

    it('should throw error for invalid discount code', () => {
      const cart = new ShoppingCart();

      expect(() => {
        cart.applyDiscountCode('INVALID');
      }).toThrow('Invalid discount code');
    });

    it('should not allow multiple discount codes', () => {
      const cart = new ShoppingCart();
      cart.addItem({ id: '1', name: 'Widget', price: 100, quantity: 1 });
      cart.applyDiscountCode('SAVE10');

      expect(() => {
        cart.applyDiscountCode('SAVE20');
      }).toThrow('Discount already applied');
    });
  });
});

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: Tests written (RED) ❌
Next: Implement ShoppingCart to make tests pass (GREEN)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
You: "Now implement the ShoppingCart class to pass these tests"

Claude (Unit Test Generator - GREEN Phase):
```

**Output:**
```typescript
// src/services/ShoppingCart.ts

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

export class ShoppingCart {
  private items: Map<string, CartItem> = new Map();
  private discountCode: string | null = null;
  private discountPercent: number = 0;

  addItem(item: CartItem): void {
    if (item.price <= 0) {
      throw new Error('Price must be positive');
    }

    const existing = this.items.get(item.id);
    if (existing) {
      existing.quantity += item.quantity;
    } else {
      this.items.set(item.id, { ...item });
    }
  }

  removeItem(itemId: string): void {
    this.items.delete(itemId);
  }

  getItems(): CartItem[] {
    return Array.from(this.items.values());
  }

  getTotal(): number {
    const subtotal = Array.from(this.items.values())
      .reduce((sum, item) => sum + (item.price * item.quantity), 0);

    const discount = subtotal * (this.discountPercent / 100);
    return subtotal - discount;
  }

  applyDiscountCode(code: string): void {
    if (this.discountCode !== null) {
      throw new Error('Discount already applied');
    }

    const validCodes: Record<string, number> = {
      'SAVE10': 10,
      'SAVE20': 20,
      'SAVE30': 30
    };

    const discount = validCodes[code];
    if (!discount) {
      throw new Error('Invalid discount code');
    }

    this.discountCode = code;
    this.discountPercent = discount;
  }
}
```

```bash
# Run tests
npm test ShoppingCart

✓ All tests passing (GREEN) ✅
Coverage: 100% (statements, branches, functions, lines)
```

#### Step 5: Accessible UI Implementation (Accessibility Development Skill)

```
You: "Create an accessible checkout form component in React with WCAG 2.1 AA compliance"

Claude (Accessibility Development):
```

**Output:**
```typescript
// components/CheckoutForm.tsx

import React, { useState } from 'react';

interface CheckoutFormProps {
  onSubmit: (data: CheckoutData) => void;
}

export const CheckoutForm: React.FC<CheckoutFormProps> = ({ onSubmit }) => {
  const [currentStep, setCurrentStep] = useState(1);
  const [errors, setErrors] = useState<Record<string, string>>({});

  return (
    <form onSubmit={handleSubmit} noValidate>
      {/* Progress Indicator */}
      <nav aria-label="Checkout progress">
        <ol className="progress-steps">
          <li aria-current={currentStep === 1 ? 'step' : undefined}>
            <span className="step-number">1</span>
            <span className="step-label">Shipping</span>
          </li>
          <li aria-current={currentStep === 2 ? 'step' : undefined}>
            <span className="step-number">2</span>
            <span className="step-label">Payment</span>
          </li>
          <li aria-current={currentStep === 3 ? 'step' : undefined}>
            <span className="step-number">3</span>
            <span className="step-label">Review</span>
          </li>
        </ol>
      </nav>

      {/* Step 1: Shipping Address */}
      {currentStep === 1 && (
        <fieldset>
          <legend>Shipping Address</legend>

          {/* Email */}
          <div className="form-group">
            <label htmlFor="email">
              Email <span aria-label="required">*</span>
            </label>
            <input
              type="email"
              id="email"
              name="email"
              required
              aria-required="true"
              aria-invalid={!!errors.email}
              aria-describedby={errors.email ? 'email-error' : undefined}
              autoComplete="email"
            />
            {errors.email && (
              <div
                id="email-error"
                className="error-message"
                role="alert"
                aria-live="polite"
              >
                {errors.email}
              </div>
            )}
          </div>

          {/* Full Name */}
          <div className="form-group">
            <label htmlFor="fullName">
              Full Name <span aria-label="required">*</span>
            </label>
            <input
              type="text"
              id="fullName"
              name="fullName"
              required
              aria-required="true"
              autoComplete="name"
            />
          </div>

          {/* Address */}
          <div className="form-group">
            <label htmlFor="address">
              Street Address <span aria-label="required">*</span>
            </label>
            <input
              type="text"
              id="address"
              name="address"
              required
              aria-required="true"
              autoComplete="street-address"
            />
          </div>

          {/* City, State, ZIP in one row */}
          <div className="form-row">
            <div className="form-group">
              <label htmlFor="city">City</label>
              <input
                type="text"
                id="city"
                name="city"
                required
                autoComplete="address-level2"
              />
            </div>

            <div className="form-group">
              <label htmlFor="state">State</label>
              <select
                id="state"
                name="state"
                required
                autoComplete="address-level1"
              >
                <option value="">Select state</option>
                <option value="CA">California</option>
                {/* ... more states ... */}
              </select>
            </div>

            <div className="form-group">
              <label htmlFor="zip">ZIP Code</label>
              <input
                type="text"
                id="zip"
                name="zip"
                required
                pattern="[0-9]{5}"
                autoComplete="postal-code"
              />
            </div>
          </div>

          <button type="button" onClick={() => setCurrentStep(2)}>
            Continue to Payment
          </button>
        </fieldset>
      )}

      {/* Step 2: Payment */}
      {currentStep === 2 && (
        <fieldset>
          <legend>Payment Information</legend>

          <div className="secure-notice" role="status">
            <span aria-hidden="true">🔒</span>
            Your payment information is encrypted and secure
          </div>

          {/* Card Number */}
          <div className="form-group">
            <label htmlFor="cardNumber">
              Card Number <span aria-label="required">*</span>
            </label>
            <input
              type="text"
              id="cardNumber"
              name="cardNumber"
              required
              aria-required="true"
              autoComplete="cc-number"
              inputMode="numeric"
              pattern="[0-9]{13,19}"
              maxLength={19}
            />
          </div>

          {/* Expiry and CVV in one row */}
          <div className="form-row">
            <div className="form-group">
              <label htmlFor="expiry">
                Expiry Date <span aria-label="required">*</span>
              </label>
              <input
                type="text"
                id="expiry"
                name="expiry"
                required
                placeholder="MM/YY"
                autoComplete="cc-exp"
                pattern="[0-9]{2}/[0-9]{2}"
              />
            </div>

            <div className="form-group">
              <label htmlFor="cvv">
                CVV <span aria-label="required">*</span>
              </label>
              <input
                type="text"
                id="cvv"
                name="cvv"
                required
                autoComplete="cc-csc"
                inputMode="numeric"
                pattern="[0-9]{3,4}"
                maxLength={4}
                aria-describedby="cvv-help"
              />
              <div id="cvv-help" className="form-hint">
                3-digit code on back of card
              </div>
            </div>
          </div>

          <div className="button-group">
            <button type="button" onClick={() => setCurrentStep(1)}>
              Back
            </button>
            <button type="button" onClick={() => setCurrentStep(3)}>
              Review Order
            </button>
          </div>
        </fieldset>
      )}

      {/* Step 3: Review & Confirm */}
      {currentStep === 3 && (
        <div>
          <h2>Review Your Order</h2>

          {/* Order Summary */}
          <section aria-labelledby="order-summary-heading">
            <h3 id="order-summary-heading">Order Summary</h3>
            {/* ... order items ... */}
          </section>

          {/* Shipping Address */}
          <section aria-labelledby="shipping-heading">
            <h3 id="shipping-heading">Shipping Address</h3>
            {/* ... address display ... */}
            <button type="button" onClick={() => setCurrentStep(1)}>
              Edit Shipping Address
            </button>
          </section>

          {/* Payment Method */}
          <section aria-labelledby="payment-heading">
            <h3 id="payment-heading">Payment Method</h3>
            {/* ... card display (last 4 digits) ... */}
            <button type="button" onClick={() => setCurrentStep(2)}>
              Edit Payment Method
            </button>
          </section>

          {/* Confirmation */}
          <button
            type="submit"
            className="btn-primary"
            aria-describedby="final-total"
          >
            Place Order
          </button>
          <div id="final-total" className="total-amount">
            Total: $123.45
          </div>
        </div>
      )}

      {/* Live region for announcements */}
      <div
        role="status"
        aria-live="polite"
        aria-atomic="true"
        className="sr-only"
      >
        {currentStep === 1 && 'Step 1 of 3: Enter shipping address'}
        {currentStep === 2 && 'Step 2 of 3: Enter payment information'}
        {currentStep === 3 && 'Step 3 of 3: Review and confirm your order'}
      </div>
    </form>
  );
};

// CSS for screen reader only content
// .sr-only { position: absolute; width: 1px; height: 1px; ... }
```

✅ **WCAG 2.1 AA Compliance Checklist:**
- ✓ All inputs have labels
- ✓ Required fields marked
- ✓ Error messages announced
- ✓ Autocomplete attributes
- ✓ Keyboard navigation
- ✓ Progress indicator
- ✓ Live regions for status updates
- ✓ Color contrast ≥4.5:1

---

### Day 3: Review & Deploy

#### Step 6: Code Quality Review (Code Review Skill)

```
You: "Review the complete checkout implementation for quality, security, and performance"

Claude (Code Review):
```

**Output:**
```
🔍 CHECKOUT SYSTEM CODE REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Quality Score: 88/100 (Excellent)

✅ POSITIVE OBSERVATIONS:
  • Comprehensive test coverage (100%)
  • WCAG 2.1 AA compliant
  • RESTful API design
  • Proper error handling
  • Input validation implemented
  • Security best practices followed

⚠️ HIGH PRIORITY IMPROVEMENTS:

[1] Add Rate Limiting
  Location: checkout endpoints
  Issue: No rate limiting on payment endpoint
  Risk: Brute force attacks, card testing
  Fix:
  ```typescript
  import rateLimit from 'express-rate-limit';

  const checkoutLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,  // 15 minutes
    max: 3,  // 3 checkout attempts
    message: 'Too many checkout attempts'
  });

  app.post('/api/v1/checkout/payment', checkoutLimiter, paymentHandler);
  ```

[2] Add Request Idempotency
  Location: POST /checkout/confirm
  Issue: Duplicate order risk (double-click, retry)
  Fix:
  ```typescript
  app.post('/checkout/confirm', async (req, res) => {
    const idempotencyKey = req.headers['idempotency-key'];

    if (!idempotencyKey) {
      return res.status(400).json({ error: 'Idempotency-Key required' });
    }

    // Check if request already processed
    const existing = await redis.get(`order:${idempotencyKey}`);
    if (existing) {
      return res.json(JSON.parse(existing));  // Return cached result
    }

    // Process order...
    const order = await createOrder(req.body);

    // Cache result for 24 hours
    await redis.setex(`order:${idempotencyKey}`, 86400, JSON.stringify(order));

    return res.status(201).json(order);
  });
  ```

[3] Optimize Cart Queries
  Location: ShoppingCart.getTotal()
  Issue: O(n) calculation on every call
  Fix: Cache total, invalidate on cart changes

📊 METRICS:
  • Cyclomatic Complexity: 6.2 (Target: ≤10) ✓
  • Test Coverage: 100% ✓
  • Code Duplication: 1.8% (Target: <3%) ✓
  • Function Length: Avg 22 lines (Target: ≤50) ✓

🔐 SECURITY:
  • No hardcoded secrets ✓
  • Input validation ✓
  • SQL injection prevention ✓
  • XSS prevention ✓
  • Need rate limiting ⚠️
  • Need idempotency ⚠️

Recommendation: Address 2 high-priority items before production deployment.
```

#### Step 7: Performance Check (Performance Optimization Skill)

```
You: "Check the performance of the checkout API endpoints"

Claude (Performance Optimization):
```

**Output:**
```
⚡ CHECKOUT PERFORMANCE ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Performance:

POST /checkout/payment (p95): 680ms ⚠️
  • Stripe API call: 550ms (81%)
  • Database query: 95ms (14%)
  • Application logic: 35ms (5%)

POST /checkout/confirm (p95): 420ms ✓
  • Order creation: 180ms
  • Email notification: 150ms
  • Inventory update: 90ms

RECOMMENDATIONS:

[1] Make email sending async
  Current: Blocking operation (150ms)
  Fix: Use message queue (RabbitMQ/AWS SQS)
  ```typescript
  // Current (blocking)
  await sendOrderConfirmationEmail(order);

  // Improved (non-blocking)
  await queue.publish('orders.confirmed', { orderId: order.id });
  // Background worker sends email
  ```
  Expected: Reduce p95 from 420ms → 270ms (36% faster)

[2] Cache shipping options
  Current: Database query every time (95ms)
  Fix: Cache in Redis (5ms)
  Expected: Reduce p95 from 680ms → 590ms

[3] Optimize cart total calculation
  Add memoization:
  ```typescript
  private _totalCache: number | null = null;

  getTotal(): number {
    if (this._totalCache !== null) {
      return this._totalCache;
    }

    this._totalCache = this.calculateTotal();
    return this._totalCache;
  }

  private invalidateCache() {
    this._totalCache = null;
  }
  ```

OVERALL ASSESSMENT: Good performance
- Most endpoints meet <500ms target
- Payment endpoint acceptable (external API dependency)
- Apply async email for further improvement
```

#### Step 8: Final ISO Quality Check (ISO Standards Compliance Skill)

```
You: "Assess the checkout system against ISO/IEC 25010 quality standards"

Claude (ISO Standards Compliance):
```

**Output:**
```
📊 ISO/IEC 25010 QUALITY ASSESSMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHECKOUT SYSTEM - Overall: 89/100 (EXCELLENT)

Quality Characteristics:
1. Functional Suitability   ████████████████████  95/100 ✓
2. Performance Efficiency   ████████████████░░░░  85/100 ✓
3. Compatibility           ████████████████████  92/100 ✓
4. Usability               ████████████████████  97/100 ✓
5. Reliability             ████████████████░░░░  88/100 ✓
6. Security                ████████████████░░░░  86/100 ✓
7. Maintainability         ████████████████░░░░  87/100 ✓
8. Portability             ████████████████████  92/100 ✓

🏆 STRENGTHS:
  • Exceptional usability (WCAG 2.1 AA: 97%)
  • High functional completeness (95%)
  • Excellent portability (cloud-agnostic)
  • Strong maintainability (100% test coverage)

🎯 MINOR IMPROVEMENTS:
  • Add idempotency (reliability: 88% → 95%)
  • Optimize async operations (performance: 85% → 90%)
  • Add rate limiting (security: 86% → 92%)

RECOMMENDATION: READY FOR PRODUCTION
  Estimated effort to reach 95+: 8-12 hours
  Priority: Idempotency > Rate limiting > Async email
```

---

## ✅ Workflow 1 Summary

**Skills Used:** All 8 ✓

**Results:**
- ✅ RESTful API designed and documented
- ✅ 100% test coverage (TDD approach)
- ✅ WCAG 2.1 AA compliant UI
- ✅ Security best practices implemented
- ✅ Performance targets met (<500ms most endpoints)
- ✅ ISO quality score: 89/100
- ✅ Production-ready with minor improvements identified

**Time:** 2-3 days (vs 5-7 days without skills)
**Quality:** Exceptional (would take weeks to achieve manually)

---

## Workflow 2: Critical Bug Fix
### Production Login Failure

**Scenario:** Users reporting they cannot log in after password reset.

**Skills Used:** Debug Analysis, Unit Test Generator, Code Review

**Duration:** 30-60 minutes

---

### Step 1: Root Cause Analysis (Debug Analysis Skill)

```
You: "Users are reporting login failures after password reset. Here's the error:
POST /api/auth/login - 401 Unauthorized
User completes password reset successfully, but new password doesn't work.
Old password also doesn't work."

Claude (Debug Analysis):
```

**Output:**
```
🐛 LOGIN FAILURE DEBUG ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Root Cause Analysis (5 Whys):

Problem: Users can't login after password reset

Why? → New password not accepted
  ↓
Why? → Password hash in database doesn't match
  ↓
Why? → Password update transaction not committing
  ↓
Why? → Missing await db.commit() after password hash update
  ↓
Why? → Recent refactoring removed explicit commit

ROOT CAUSE: Missing database commit in password reset handler

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 LOCATION: src/api/auth/passwordReset.ts:45

Current Code (BROKEN):
```typescript
export async function resetPassword(req, res) {
  const { token, newPassword } = req.body;

  const user = await verifyResetToken(token);
  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await db.users.update({
    where: { id: user.id },
    data: { passwordHash: hashedPassword }
  });
  // ❌ MISSING: await db.commit();

  await invalidateResetToken(token);

  return res.json({ message: 'Password reset successful' });
}
```

🔧 FIX (Add commit):
```typescript
export async function resetPassword(req, res) {
  const { token, newPassword } = req.body;

  const user = await verifyResetToken(token);
  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await db.users.update({
    where: { id: user.id },
    data: { passwordHash: hashedPassword }
  });

  await db.commit();  // ✅ ADD THIS LINE

  await invalidateResetToken(token);
  await db.commit();  // Also commit token invalidation

  return res.json({ message: 'Password reset successful' });
}
```

⏱️ ESTIMATED FIX TIME: 5 minutes
🔥 SEVERITY: P0 (Critical - users locked out)
📊 IMPACT: ~500 users/day affected
```

### Step 2: Add Regression Test (Unit Test Generator Skill)

```
You: "Generate a regression test for this password reset bug"

Claude (Unit Test Generator):
```

**Output:**
```typescript
// tests/api/auth/passwordReset.test.ts

describe('Password Reset Flow', () => {
  it('should allow login with new password after reset', async () => {
    // Arrange: Create test user
    const user = await createTestUser({
      email: 'test@example.com',
      password: 'OldPassword123!'
    });

    // Act: Request password reset
    const resetToken = await generateResetToken(user.email);

    // Reset password
    const resetResponse = await api.post('/auth/password-reset', {
      token: resetToken,
      newPassword: 'NewPassword456!'
    });

    // Assert: Reset successful
    expect(resetResponse.status).toBe(200);

    // Act: Attempt login with NEW password (THIS IS THE KEY TEST)
    const loginResponse = await api.post('/auth/login', {
      email: 'test@example.com',
      password: 'NewPassword456!'  // NEW password
    });

    // Assert: Login successful with new password
    expect(loginResponse.status).toBe(200);
    expect(loginResponse.body).toHaveProperty('token');

    // Assert: Old password NO LONGER works
    const oldPasswordAttempt = await api.post('/auth/login', {
      email: 'test@example.com',
      password: 'OldPassword123!'  // OLD password
    });

    expect(oldPasswordAttempt.status).toBe(401);

    // Verify database was actually updated
    const updatedUser = await db.users.findByEmail('test@example.com');
    const passwordMatches = await bcrypt.compare(
      'NewPassword456!',
      updatedUser.passwordHash
    );
    expect(passwordMatches).toBe(true);
  });

  it('should commit password change to database', async () => {
    // This test specifically checks the database commit
    const user = await createTestUser({ email: 'commit-test@example.com' });
    const resetToken = await generateResetToken(user.email);

    // Reset password
    await api.post('/auth/password-reset', {
      token: resetToken,
      newPassword: 'NewPass789!'
    });

    // Query database DIRECTLY (not through app)
    const dbUser = await db.raw(
      'SELECT password_hash FROM users WHERE email = ?',
      ['commit-test@example.com']
    );

    // Verify password was actually committed to database
    const passwordMatches = await bcrypt.compare(
      'NewPass789!',
      dbUser[0].password_hash
    );
    expect(passwordMatches).toBe(true);
  });
});
```

**Test Results:**
```
BEFORE FIX:
  ✗ should allow login with new password after reset (FAILS) ❌
  ✗ should commit password change to database (FAILS) ❌

AFTER FIX:
  ✓ should allow login with new password after reset (PASSES) ✅
  ✓ should commit password change to database (PASSES) ✅
```

### Step 3: Verify Fix Quality (Code Review Skill)

```
You: "Review my bug fix for completeness"

Claude (Code Review):
```

**Output:**
```
🔍 BUG FIX CODE REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Fix Quality: 95/100 (Excellent)

✅ FIX IS CORRECT:
  • Root cause addressed (missing commit)
  • Regression test added
  • Both password update AND token invalidation committed

✅ BEST PRACTICES FOLLOWED:
  • Transaction boundaries clear
  • Error handling maintained
  • Backward compatible

⚠️ ADDITIONAL RECOMMENDATION:

Consider using transaction wrapper for safety:

```typescript
export async function resetPassword(req, res) {
  const { token, newPassword } = req.body;

  // Use transaction to ensure atomicity
  return await db.transaction(async (trx) => {
    const user = await verifyResetToken(token, trx);
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await trx.users.update({
      where: { id: user.id },
      data: { passwordHash: hashedPassword }
    });

    await invalidateResetToken(token, trx);

    // Automatic commit on success, rollback on error
    return { message: 'Password reset successful' };
  });
}
```

Benefits:
  • Automatic commit/rollback
  • Prevents future similar bugs
  • Atomic operation guaranteed

DEPLOYMENT RECOMMENDATION:
  ✓ Fix is production-ready
  ✓ Add transaction wrapper for long-term robustness
  ✓ Monitor for 24h after deployment
```

---

## ✅ Workflow 2 Summary

**Skills Used:** 3 (Debug Analysis, Unit Test Generator, Code Review)

**Results:**
- ✅ Root cause identified in <10 minutes
- ✅ Fix applied in 5 minutes
- ✅ Regression test added (prevents future occurrences)
- ✅ Code review validated fix quality
- ✅ Additional improvement suggested (transaction wrapper)

**Time:** 30 minutes (vs 2-4 hours manual debugging)
**Impact:** 500 users/day unblocked

---

## 📊 Complete Workflow Summary

| Workflow | Skills Used | Time Saved | Quality Improvement |
|----------|-------------|------------|---------------------|
| 1. Feature Development | All 8 | 3-4 days | 89/100 ISO score |
| 2. Bug Fix | 3 | 1.5-3.5 hours | 100% coverage added |
| 3. API Redesign | 4 | 2-3 days | 90+ API score |
| 4. Accessibility | 2 | 1-2 weeks | 97% WCAG score |
| 5. Performance | 2 | 1-2 days | 50%+ improvement |
| 6. Security Audit | 2 | 3-4 days | 85+ security score |
| 7. Quality Improvement | 2 | Ongoing | 80+ ISO score |
| 8. TDD Implementation | 2 | 50% faster | 100% coverage |

---

**Version:** 1.0.0
**Last Updated:** 2025-11-11
**Next:** See METRICS_DASHBOARD_SPEC.md for tracking these improvements
