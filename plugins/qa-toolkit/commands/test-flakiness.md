---
description: Analyze and fix flaky tests that pass/fail inconsistently
---

**Purpose**: Analyze and fix flaky tests that pass/fail inconsistently

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Analyze test flakiness for $ARGUMENTS"

Identify, diagnose, and fix flaky tests that create false positives/negatives and reduce CI/CD reliability.

## Usage Examples
- `/test-flakiness --detect --runs 10`
- `/test-flakiness --analyze --test "User Login Flow"`
- `/test-flakiness --fix --pattern "**/*.spec.ts"`
- `/test-flakiness --report --threshold 95`
- `/test-flakiness --monitor --days 7`

## Command-Specific Flags
--detect: "Run tests multiple times to detect flakiness"
--analyze: "Analyze specific flaky test for root cause"
--fix: "Suggest fixes for identified flaky tests"
--runs: "Number of times to run each test (default: 10)"
--threshold: "Pass rate % to consider stable (default: 95)"
--pattern: "Test file pattern to analyze"
--test: "Specific test name to investigate"
--report: "Generate flakiness report"
--monitor: "Monitor test stability over time"
--days: "Number of days to analyze (default: 7)"
--ci: "Analyze CI/CD test failure logs"
--parallel: "Run detection in parallel (faster but less accurate)"

## Flakiness Detection Process

**1. Pattern Recognition:**
- Run tests multiple times (10-100 runs)
- Track pass/fail patterns
- Calculate failure rate
- Identify intermittent failures

**2. Root Cause Analysis:**
- Review test implementation
- Check for timing issues
- Identify shared state
- Analyze environmental dependencies

**3. Categorization:**
- Race conditions (async timing)
- State pollution (test isolation)
- Network issues (API flakiness)
- Environment-specific (browser/OS)
- Random data (improper test data)

**4. Fix Development:**
- Implement proper wait strategies
- Add test isolation
- Mock external dependencies
- Fix timing issues
- Stabilize test data

**5. Validation:**
- Run fixed test 100+ times
- Verify 100% pass rate
- Monitor in CI/CD
- Document the fix

## Output Format

The test-flakiness command provides:
1. **Flakiness Score**: Percentage of test runs that pass
2. **Failure Pattern**: When and how the test fails
3. **Root Cause**: Identified source of flakiness
4. **Fix Recommendations**: Specific code changes
5. **Validation Steps**: How to verify the fix
6. **Prevention**: How to avoid similar issues

## Common Flakiness Causes

**1. Race Conditions:**
```javascript
// Flaky: Hard-coded timeout
await page.waitForTimeout(2000); // Might not be enough

// Stable: Wait for specific condition
await page.waitForSelector('[data-testid="results"]');
```

**2. Improper Async Handling:**
```javascript
// Flaky: Missing await
test('loads data', () => {
  fetchData(); // Not awaited!
  expect(data).toBeDefined();
});

// Stable: Proper async
test('loads data', async () => {
  await fetchData();
  expect(data).toBeDefined();
});
```

**3. Test Isolation Issues:**
```javascript
// Flaky: Shared mutable state
let userData = { name: 'Test' };

test('updates name', () => {
  userData.name = 'Updated';
});

// Stable: Fresh data each test
test('updates name', () => {
  const userData = { name: 'Test' };
  userData.name = 'Updated';
});
```

**4. Brittle Selectors:**
```javascript
// Flaky: Index-based selector
const button = page.locator('button').nth(2);

// Stable: Semantic selector
const button = page.locator('[data-testid="submit"]');
```

**5. Time-Dependent Tests:**
```javascript
// Flaky: Depends on current time
const isWeekend = new Date().getDay() === 0 || 6;

// Stable: Mock time
jest.setSystemTime(new Date('2024-01-15')); // Monday
```

**6. Network Dependencies:**
```javascript
// Flaky: Real API calls
const data = await fetch('https://api.example.com');

// Stable: Mocked responses
jest.mock('fetch');
fetch.mockResolvedValue({ data: mockData });
```

## Detection Strategies

**Statistical Analysis:**
```
Pass Rate Classification:
  100%:     Stable ✓
  95-99%:   Slightly flaky ⚠
  80-94%:   Moderately flaky ⚠⚠
  <80%:     Highly flaky ✗
```

**Pattern Detection:**
- Time-of-day correlation
- Browser-specific failures
- CI vs local differences
- Parallel execution issues
- Load-dependent failures

**Automated Detection:**
```bash
# Run test 100 times
for i in {1..100}; do
  npm test -- specific-test.spec.ts || echo "Failed on run $i"
done
```

## Fix Strategies

**1. Replace Hard-Coded Waits:**
```javascript
// Before
await page.waitForTimeout(3000);

// After
await page.waitForSelector('[data-testid="loaded"]', {
  state: 'visible',
  timeout: 10000
});
```

**2. Add Test Isolation:**
```javascript
// Before
beforeAll(() => {
  setupDatabase();
});

// After
beforeEach(() => {
  cleanDatabase();
  setupFreshData();
});

afterEach(() => {
  cleanupTestData();
});
```

**3. Use Test Fixtures:**
```javascript
// Before
const user = { email: 'test@example.com' };

// After
import { test } from '@playwright/test';

const test = base.extend({
  authenticatedUser: async ({ page }, use) => {
    const user = await createTestUser();
    await loginAs(page, user);
    await use(user);
    await deleteTestUser(user.id);
  }
});
```

**4. Mock External Services:**
```javascript
// Mock network requests
test.beforeEach(async ({ page }) => {
  await page.route('**/api/data', route => {
    route.fulfill({
      status: 200,
      body: JSON.stringify(mockData)
    });
  });
});
```

**5. Disable Animations:**
```javascript
// Playwright config
use: {
  // Disable CSS animations
  hasTouch: false,
  screenshot: {
    animations: 'disabled'
  }
}

// Or in test
await page.addStyleTag({
  content: '*, *::before, *::after { transition: none !important; }'
});
```

## Output Example

```
Test Flakiness Analysis Report
==============================

Test: "User can complete checkout flow"
File: tests/e2e/checkout.spec.ts

Flakiness Score: 73% pass rate (73/100 runs)
Status: 🔴 HIGHLY FLAKY

Failure Pattern:
  ✓ Passed: 73 times
  ✗ Failed: 27 times

  Failures by Error:
    • "Timeout waiting for payment button" - 18 times
    • "Element not found: [data-testid=confirm]" - 7 times
    • "Test timeout exceeded" - 2 times

Root Cause Analysis:
  PRIMARY: Race condition in payment module initialization
  - Payment button event listener attached too late
  - Safari's stricter timing exposes the issue
  - Missing await in async payment SDK loading

  SECONDARY: Brittle selector for confirmation button
  - Button ID changes between payment methods
  - Need more robust selector strategy

Recommended Fixes:

1. Fix async payment initialization (P0):
```javascript
// Current (flaky)
function initializePayment() {
  loadPaymentSDK();
  attachEventListeners();
}

// Fixed (stable)
async function initializePayment() {
  await loadPaymentSDK();
  attachEventListeners();
}
```

2. Improve selector (P1):
```javascript
// Current (flaky)
await page.click('#confirm-btn');

// Fixed (stable)
await page.click('[data-testid="confirm-payment"]');
```

3. Add explicit wait (P1):
```javascript
// Before clicking payment button
await page.waitForLoadState('networkidle');
await page.waitForSelector('[data-testid="payment-button"]:not([disabled])');
```

Validation:
  [ ] Run test 100 times locally
  [ ] Verify 100% pass rate
  [ ] Test on Safari specifically
  [ ] Monitor in CI for 24 hours

Prevention:
  • Always await async initialization functions
  • Use data-testid for test selectors
  • Add integration test for payment SDK loading
  • Set up flakiness monitoring in CI

Estimated Fix Time: 2 hours
```

## Monitoring & Prevention

**CI/CD Integration:**
```yaml
# GitHub Actions example
- name: Detect Flaky Tests
  run: |
    npm test -- --repeat-each=3 --retries=0
  continue-on-error: true

- name: Report Flakiness
  if: failure()
  run: |
    echo "Flaky tests detected. Review test results."
```

**Flakiness Dashboard:**
- Track test stability over time
- Alert on new flaky tests
- Trend analysis
- Quarantine flaky tests

**Prevention Checklist:**
- [ ] No hard-coded timeouts
- [ ] All async operations awaited
- [ ] Tests isolated (no shared state)
- [ ] External dependencies mocked
- [ ] Selectors are stable and semantic
- [ ] Animations disabled in tests
- [ ] Test data is deterministic
- [ ] No time-dependent logic

## Common Patterns by Framework

**Playwright:**
- Use auto-waiting features
- Avoid `waitForTimeout()`
- Use test fixtures
- Enable retries only for network issues

**Cypress:**
- Leverage automatic retry logic
- Use `cy.intercept()` for API mocking
- Avoid `cy.wait(milliseconds)`
- Use `data-cy` attributes

**Jest:**
- Mock external dependencies
- Use `jest.useFakeTimers()`
- Avoid shared test state
- Use `beforeEach` for setup

**Pytest:**
- Use fixtures for test data
- Mock time-dependent code
- Isolate database state
- Use `pytest-rerunfailures` sparingly
