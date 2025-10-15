---
description: Generate detailed test coverage reports and identify untested code
---

**Purpose**: Generate detailed test coverage reports and identify untested code

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Generate test coverage report for $ARGUMENTS"

Provide comprehensive test coverage analysis, identify gaps, and recommend testing strategies to improve coverage.

## Usage Examples
- `/test-coverage --unit --threshold 80`
- `/test-coverage --e2e --report html --open`
- `/test-coverage --file src/components/UserList.tsx`
- `/test-coverage --diff --baseline main`
- `/test-coverage --untested --priority critical`

## Command-Specific Flags
--unit: "Generate unit test coverage report"
--integration: "Generate integration test coverage report"
--e2e: "Generate end-to-end test coverage report"
--all: "Generate coverage for all test types"
--file: "Coverage report for specific file or directory"
--threshold: "Minimum coverage percentage required (default: 80)"
--report: "Report format: text, html, json, lcov (default: html)"
--open: "Automatically open HTML report in browser"
--diff: "Show coverage diff against baseline"
--baseline: "Baseline branch for comparison (default: main)"
--untested: "List files with no test coverage"
--priority: "Filter by priority: critical, high, medium, low"
--trend: "Show coverage trend over time"
--ci: "Output in CI-friendly format"

## Coverage Analysis Process

**1. Test Execution:**
- Run tests with coverage instrumentation
- Collect line, branch, function, and statement coverage
- Generate coverage data files
- Calculate coverage percentages

**2. Coverage Assessment:**
- Compare against threshold requirements
- Identify untested code paths
- Analyze branch coverage gaps
- Review function coverage

**3. Gap Analysis:**
- Find critical paths without tests
- Identify edge cases not covered
- Locate error handling gaps
- Check boundary conditions

**4. Recommendations:**
- Prioritize testing gaps by criticality
- Suggest test cases for uncovered code
- Recommend test strategies
- Provide coverage improvement plan

**5. Reporting:**
- Generate visual coverage reports
- Create actionable task list
- Track coverage trends
- Set up coverage monitoring

## Output Format

The test-coverage command provides:
1. **Coverage Summary**: Overall coverage percentages by type
2. **Detailed Breakdown**: Coverage per file and function
3. **Untested Code**: List of files/functions without coverage
4. **Critical Gaps**: High-priority untested code paths
5. **Recommendations**: Specific tests to add
6. **Trend Analysis**: Coverage change over time
7. **Action Items**: Prioritized testing tasks

## Coverage Metrics

**Line Coverage:**
- Percentage of code lines executed
- Target: 80%+ for most projects
- Focus on business logic

**Branch Coverage:**
- Percentage of decision paths tested
- Target: 75%+ for critical code
- Ensure all if/else paths covered

**Function Coverage:**
- Percentage of functions called
- Target: 90%+ for public APIs
- Include error handlers

**Statement Coverage:**
- Percentage of statements executed
- Most granular metric
- Target: 80%+ overall

## Best Practices

**What to Test:**
- Business logic and algorithms
- User interactions and workflows
- Error handling and edge cases
- API integrations
- Data transformations

**What Not to Chase:**
- 100% coverage (diminishing returns)
- Generated code and boilerplate
- Third-party library internals
- Simple getters/setters
- Configuration files

**Coverage Targets:**
```
Critical Code (auth, payment): 95%+
Business Logic: 85%+
UI Components: 75%+
Utilities: 90%+
Overall Project: 80%+
```

## Framework-Specific Commands

**Jest:**
```bash
npm test -- --coverage --coverageReporters=html
```

**Vitest:**
```bash
npm test -- --coverage --coverage.reporter=html
```

**Pytest:**
```bash
pytest --cov=. --cov-report=html
```

**Playwright:**
```bash
npx playwright test --coverage
```

## CI/CD Integration

**GitHub Actions:**
```yaml
- name: Run tests with coverage
  run: npm test -- --coverage
- name: Upload coverage
  uses: codecov/codecov-action@v3
```

**Coverage Badge:**
- Display coverage percentage in README
- Update automatically on CI runs
- Color-coded: green (80%+), yellow (60-80%), red (<60%)

## Interpreting Results

**High Coverage (80%+):**
- Good test suite foundation
- Confidence in refactoring
- Lower regression risk
- Maintain with new code

**Medium Coverage (60-80%):**
- Core functionality covered
- Gaps in edge cases
- Need more integration tests
- Prioritize critical paths

**Low Coverage (<60%):**
- Significant testing gaps
- High regression risk
- Invest in test infrastructure
- Start with critical features

## Output Example

```
Test Coverage Report
====================

Overall Coverage: 78.5%

By Type:
  Statements: 79.2% (1,584 / 2,000)
  Branches:   72.1% (432 / 599)
  Functions:  81.5% (163 / 200)
  Lines:      78.5% (1,570 / 2,000)

Status: ⚠ Below 80% threshold

Untested Files (0% coverage):
  ✗ src/utils/analytics.ts
  ✗ src/helpers/deprecated.ts
  ✗ src/config/legacy.ts

Low Coverage Files (<50%):
  ⚠ src/components/PaymentForm.tsx (42%)
  ⚠ src/services/api/billing.ts (38%)
  ⚠ src/utils/validation.ts (45%)

Recommendations:
  1. Add tests for PaymentForm.tsx (P0 - Critical)
  2. Test billing API error handling (P1 - High)
  3. Cover validation edge cases (P2 - Medium)
  4. Remove deprecated code or add tests (P3 - Low)

Coverage Trend:
  Last Week: 75.2%
  Current:   78.5%
  Change:    +3.3% 📈

Next Steps:
  [ ] Add PaymentForm component tests
  [ ] Test billing API failure scenarios
  [ ] Add validation boundary tests
  [ ] Review and update coverage threshold
```

## Common Issues

**False High Coverage:**
- Tests that don't assert anything
- Shallow tests that miss edge cases
- Tests that only cover happy path
- Solution: Review test quality, not just quantity

**Coverage Blind Spots:**
- Async code timing issues
- Error handling paths
- Browser-specific code
- Solution: Use mutation testing to verify

**Flaky Coverage:**
- Tests skipped conditionally
- Environment-dependent code
- Random test execution order
- Solution: Ensure consistent test runs
