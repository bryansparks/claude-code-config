# Engineer Skills Training Guide

**Version:** 1.0.0
**Target Audience:** Software Engineers using Claude Code
**Duration:** 2-3 hours (self-paced)
**Prerequisites:** Claude Code installed, Engineer persona configured

---

## 📚 Training Overview

This guide teaches you how to effectively use all **8 Engineer Skills** to maximize your productivity and code quality.

### Skills Covered

**Core Quality Skills:**
1. Code Review
2. Debug Analysis
3. Performance Optimization

**Security & Architecture Skills:**
4. Security Analysis
5. API Design Review

**Development Standards Skills:**
6. Accessibility Development
7. ISO Standards Compliance
8. Unit Test Generator

---

## 🎯 Learning Objectives

By the end of this training, you will:
- ✅ Know when and how to use each skill
- ✅ Understand skill activation patterns
- ✅ Master skill combinations for complex workflows
- ✅ Achieve 90%+ test coverage automatically
- ✅ Write WCAG 2.1 AA compliant code from day one
- ✅ Maintain ISO/IEC 25010 quality standards

---

## 1️⃣ Skill 1: Code Review

### What It Does
Provides comprehensive code quality, security, and performance analysis with SOLID principles validation.

### When to Use
- Before creating pull requests
- After implementing new features
- When refactoring existing code
- During pair programming reviews
- When user says "review my code"

### How to Use

#### Method 1: Direct Request
```
You: "Review this authentication code for quality and security issues"

Claude: [Analyzes code against SOLID, security, performance]
```

#### Method 2: Automatic Trigger
```
You: "I just finished implementing OAuth login. Can you take a look?"

Claude: [Code-review skill auto-activates]
```

### Example Output
```
🔍 CODE REVIEW RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⛔ Critical Issues (P0)
• [auth.ts:45] SQL injection vulnerability
  Fix: Use parameterized queries

⚠️  High Priority (P1)
• [auth.ts:67] Missing rate limiting
  Fix: Implement express-rate-limit

📊 Code Quality: 78/100
✓ SOLID principles: Mostly followed
⚠️ Complexity: 15 (target: ≤10)
```

### Practice Exercise
**Task:** Review your most recent feature implementation
1. Open your latest PR
2. Ask Claude: "Review the code in this PR for quality, security, and performance"
3. Address all P0 and P1 issues
4. Re-run review to verify improvements

**Expected Outcome:** Code quality score improves from ~75 to 90+

---

## 2️⃣ Skill 2: Debug Analysis

### What It Does
Systematic root cause analysis using the 5 Whys method with reproduction steps and fix recommendations.

### When to Use
- When encountering errors or bugs
- When tests are failing
- When investigating production issues
- When user says "why is this failing"
- When debugging performance issues

### How to Use

#### Method 1: Error Description
```
You: "I'm getting this error: 'Cannot read property 'id' of undefined'"

Claude: [Debug-analysis skill activates, performs root cause analysis]
```

#### Method 2: Stack Trace Analysis
```
You: "Debug this stack trace:
TypeError: Cannot read property 'id' of undefined
    at UserService.createUser (userService.ts:45)
    at async POST /api/users (users.ts:23)"

Claude: [Analyzes stack trace, identifies root cause, suggests fix]
```

### Example Output
```
🐛 DEBUG ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Root Cause Analysis (5 Whys):

Problem: Cannot read property 'id' of undefined

Why? → user object is undefined
Why? → Database query returned null
Why? → Email lookup failed (case sensitivity)
Why? → Email stored lowercase, query used mixed case
Why? → No normalization before DB insert

Root Cause: Email not normalized to lowercase before storage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 Recommended Fix:

// Before (userService.ts:42)
const user = await db.users.findByEmail(email);

// After
const user = await db.users.findByEmail(email.toLowerCase());

// Also normalize on insert (userService.ts:18)
email: userData.email.toLowerCase()
```

### Practice Exercise
**Task:** Debug a failing test
1. Run your test suite: `npm test`
2. Copy a failing test error
3. Ask Claude: "Help me debug this test failure: [paste error]"
4. Apply the suggested fix
5. Verify test passes

**Expected Outcome:** Understand root cause in <5 minutes, fix applied successfully

---

## 3️⃣ Skill 3: Performance Optimization

### What It Does
Identifies bottlenecks, analyzes time complexity, suggests optimizations for database queries, algorithms, and API responses.

### When to Use
- When API responses are slow (>500ms)
- When database queries are timing out
- When user reports "this is slow"
- Before production deployment
- During performance testing

### How to Use

#### Method 1: Performance Analysis Request
```
You: "This user search endpoint is taking 2 seconds. How can I optimize it?"

Claude: [Analyzes query, identifies N+1 problem, suggests eager loading]
```

#### Method 2: Code Performance Review
```
You: "Optimize this function for better performance:
function findActiveUsers() {
  const users = db.users.findAll();
  return users.filter(u => u.isActive);
}"

Claude: [Suggests moving filter to database query, adds index recommendation]
```

### Example Output
```
⚡ PERFORMANCE ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Performance:
  • API Response (p95): 2,150ms ❌
  • Database Query: 1,980ms (99.2% of time)
  • Application Logic: 170ms

🔍 Bottleneck Identified: N+1 Query Problem

Location: src/api/users.ts:34-42

Current Code (Inefficient):
const users = await User.findAll();
for (const user of users) {
  user.orders = await Order.findByUserId(user.id);
}
// Result: 1 query + N queries = 501 queries for 500 users

Optimized Code:
const users = await User.findAll({
  include: [{ model: Order }]
});
// Result: 1 query (JOIN)

Expected Performance:
  • API Response (p95): 245ms ✓
  • Improvement: 88% faster
```

### Practice Exercise
**Task:** Optimize your slowest endpoint
1. Identify slowest API endpoint (use logs or APM)
2. Ask Claude: "How can I optimize this [endpoint name]? Current response time is [Xms]"
3. Apply suggested optimizations
4. Measure before/after performance
5. Document improvement

**Expected Outcome:** >50% performance improvement

---

## 4️⃣ Skill 4: Security Analysis

### What It Does
Comprehensive OWASP Top 10 vulnerability scanning, dependency checking, and security best practices validation.

### When to Use
- Before deploying to production
- When handling user input
- When implementing authentication/authorization
- During security audits
- When user mentions "security"

### How to Use

#### Method 1: Security Audit Request
```
You: "Run a security audit on my authentication system"

Claude: [Scans for OWASP Top 10, checks dependencies, validates security headers]
```

#### Method 2: Specific Vulnerability Check
```
You: "Check this code for SQL injection vulnerabilities:
const query = `SELECT * FROM users WHERE email = '${email}'`"

Claude: [Identifies SQL injection, suggests parameterized queries]
```

### Example Output
```
🔒 SECURITY ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Security Score: 65/100 (Needs Improvement)

🔴 CRITICAL (Fix Immediately):
[1] SQL Injection - auth.ts:23
  Risk: Complete database compromise
  Fix: Use parameterized queries

[2] Hardcoded AWS Credentials - config.ts:7
  Risk: AWS account takeover
  Fix: Use environment variables

🟠 HIGH (Fix Within 24h):
[3] Missing Rate Limiting - login endpoint
  Risk: Brute force attacks
  Fix: Add express-rate-limit

📦 DEPENDENCY VULNERABILITIES:
  • jsonwebtoken@8.5.1: Signature bypass (CVE-2022-23529)
  Fix: npm install jsonwebtoken@9.0.0
```

### Practice Exercise
**Task:** Secure your authentication system
1. Ask Claude: "Perform a security audit on my auth system"
2. Fix all CRITICAL issues immediately
3. Schedule HIGH issues for this sprint
4. Run `npm audit fix` for dependencies
5. Re-run security analysis
6. Verify score improves to 85+

**Expected Outcome:** All critical vulnerabilities fixed, security score >85

---

## 5️⃣ Skill 5: API Design Review

### What It Does
RESTful API design validation, OpenAPI compliance checking, versioning strategy recommendations, and HTTP best practices.

### When to Use
- When designing new API endpoints
- Before publishing API documentation
- When refactoring existing APIs
- During API versioning discussions
- When user asks about "REST" or "API design"

### How to Use

#### Method 1: API Design Review
```
You: "Review this API design:
POST /api/createUser
GET /api/getUserById/123
DELETE /api/deleteUser/123"

Claude: [Identifies non-RESTful patterns, suggests improvements]
```

#### Method 2: OpenAPI Validation
```
You: "Validate this OpenAPI spec for best practices: [paste spec]"

Claude: [Checks OpenAPI compliance, suggests improvements]
```

### Example Output
```
🔌 API DESIGN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Score: 75/100 (Good, Needs Improvement)

❌ CRITICAL ISSUES:
[1] Non-RESTful URL: POST /api/createUser
  Current: POST /api/createUser
  Fix: POST /api/users (201 Created)

[2] Inconsistent Error Format
  Problem: Different endpoints return different error shapes
  Fix: Standardize to:
  {
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Descriptive message",
      "details": [...]
    }
  }

⚠️ IMPROVEMENTS:
[3] Missing Pagination
  Endpoint: GET /api/users
  Risk: Performance issues with large datasets
  Fix: Add ?page=1&limit=20

✅ STRENGTHS:
• RESTful structure (mostly)
• JWT authentication
• HTTPS enforced
• Rate limiting
```

### Practice Exercise
**Task:** Design a new RESTful API
1. Design endpoints for a "Projects" resource
2. Ask Claude: "Review this API design for RESTful best practices: [paste endpoints]"
3. Apply all suggested improvements
4. Generate OpenAPI documentation
5. Validate with Claude again

**Expected Outcome:** API design score >90, fully RESTful

---

## 6️⃣ Skill 6: Accessibility Development

### What It Does
WCAG 2.1/2.2 compliant code generation with accessible React/Vue/Angular components, ARIA implementation, keyboard navigation, and color contrast validation.

### When to Use
- **PROACTIVELY:** When building any UI component
- When implementing forms or interactive elements
- When user mentions "accessibility" or "WCAG"
- During component development
- Before UI code reviews

### How to Use

#### Method 1: Accessible Component Request
```
You: "Create an accessible modal dialog component in React"

Claude: [Generates WCAG-compliant modal with focus management, keyboard nav, ARIA]
```

#### Method 2: Accessibility Review
```
You: "Make this button accessible:
<div class='button' onclick='submit()'>Submit</div>"

Claude: [Converts to semantic HTML, adds ARIA, ensures keyboard accessibility]
```

### Example Output
```
♿ ACCESSIBLE COMPONENT GENERATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Component: AccessibleModal.tsx

✓ WCAG 2.1 AA Compliant
✓ Semantic HTML: <dialog> or role="dialog"
✓ ARIA Attributes: aria-modal, aria-labelledby
✓ Keyboard Navigation: Tab, Escape, focus trap
✓ Focus Management: Auto-focus, restore on close
✓ Screen Reader: All content announced
✓ Color Contrast: 7.0:1 (AAA)

Code Generated:
[See accessibility-development skill for full example]

Testing Checklist:
□ Tab through modal (all elements reachable)
□ Press Escape (closes modal)
□ Click backdrop (closes modal)
□ Test with screen reader (NVDA/VoiceOver)
□ Verify focus returns to trigger button
```

### Practice Exercise
**Task:** Make your form accessible
1. Pick an existing form in your codebase
2. Ask Claude: "Make this form WCAG 2.1 AA compliant: [paste form code]"
3. Apply all accessibility improvements
4. Test with keyboard only (no mouse)
5. Test with screen reader
6. Run automated accessibility audit

**Expected Outcome:** Form passes WCAG 2.1 AA, keyboard accessible, screen reader compatible

---

## 7️⃣ Skill 7: ISO Standards Compliance

### What It Does
ISO/IEC 25010 software quality model assessment with automated scoring for functional suitability, performance, compatibility, usability, reliability, security, maintainability, and portability.

### When to Use
- During code quality reviews
- Before major releases
- For certification preparation
- During architecture reviews
- When user asks about "software quality" or "ISO"

### How to Use

#### Method 1: Quality Assessment Request
```
You: "Assess my application against ISO/IEC 25010 quality standards"

Claude: [Analyzes 8 quality characteristics, provides scores and recommendations]
```

#### Method 2: Specific Characteristic Review
```
You: "Evaluate the maintainability of this codebase"

Claude: [Focuses on modularity, reusability, analyzability, modifiability, testability]
```

### Example Output
```
📊 ISO/IEC 25010 QUALITY ASSESSMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Quality Score: 82/100 (GOOD)
Compliance Level: HIGH

Quality Characteristics:
1. Functional Suitability  ████████████████░░  92/100 ✓
2. Performance Efficiency  ████████████████░░  82/100 ✓
3. Compatibility          ████████████████░░  82/100 ✓
4. Usability              ████████████████░░  81/100 ✓
5. Reliability            ████████████████░░  87/100 ✓
6. Security               ████████████████░░  85/100 ✓
7. Maintainability        ███████████████░░░  76/100 ⚠️
8. Portability            ████████████████░░  79/100 ✓

🎯 Top 3 Improvement Priorities:
1. Reduce technical debt (280h → 150h)
2. Improve test coverage (84% → 90%)
3. Reduce cyclomatic complexity (8.5 → 6.0)

🏆 Certification Readiness: READY
```

### Practice Exercise
**Task:** Assess your project's quality
1. Ask Claude: "Perform an ISO/IEC 25010 quality assessment on this codebase"
2. Review all 8 quality characteristics
3. Create tickets for top 3 priorities
4. Track improvements over next sprint
5. Re-assess to measure progress

**Expected Outcome:** Quality score visible, improvement plan created, progress trackable

---

## 8️⃣ Skill 8: Unit Test Generator

### What It Does
**AUTOMATIC** unit test generation with TDD workflow support, coverage analysis, and real-time test running. Auto-triggers when you write new code.

### When to Use
- **AUTOMATICALLY:** When you create new functions/classes
- When practicing TDD (Test-Driven Development)
- When test coverage drops below 80%
- When user says "write tests" or "generate tests"
- Before committing code

### How to Use

#### Method 1: Automatic Trigger (Recommended)
```
[You write new function]

POST-FILE-WRITE HOOK:
🧪 Source file modified without corresponding test
📝 Suggested test file: tests/userService.test.ts
💡 Ask Claude to generate tests

You: "Generate unit tests for src/services/userService.ts"

Claude: [Generates comprehensive test suite with 100% coverage]
```

#### Method 2: TDD Workflow
```
You: "I want to implement a calculateDiscount function using TDD. Help me write the test first."

Claude: [Generates failing test (RED)]

You: "Now help me write minimal code to pass this test"

Claude: [Provides minimal implementation (GREEN)]

You: "Now help me refactor this for better quality"

Claude: [Refactors while keeping tests passing (REFACTOR)]
```

### Example Output
```
🧪 UNIT TEST GENERATION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test File: tests/services/userService.test.ts

✓ Tests Generated: 12
✓ Coverage: 100% (15/15 statements, 8/8 branches)
✓ Execution Time: 145ms
✓ All Tests Passing

Test Breakdown:
  Happy Path (3 tests):
    ✓ should create user with valid data
    ✓ should hash password before storing
    ✓ should return created user object

  Error Cases (5 tests):
    ✓ should throw ValidationError for invalid email
    ✓ should throw ConflictError when email exists
    ✓ should handle database errors gracefully
    ✓ should handle bcrypt errors gracefully
    ✓ should validate all required fields

  Edge Cases (4 tests):
    ✓ should handle Unicode characters in name
    ✓ should trim whitespace from email
    ✓ should reject email with only spaces
    ✓ should handle very long names (>255 chars)

Next: Run tests with `npm test`
```

### Practice Exercise
**Task:** Practice TDD workflow
1. Start with a test: Ask Claude "Write a test for a calculateShipping function that takes weight and returns shipping cost"
2. Run test (should fail - RED)
3. Ask Claude: "Write minimal code to pass this test"
4. Run test (should pass - GREEN)
5. Ask Claude: "Refactor this code for better quality while keeping tests green"
6. Run tests again (should still pass)

**Expected Outcome:** Complete TDD cycle, 100% coverage, understanding of Red-Green-Refactor

---

## 🔗 Combining Skills for Maximum Impact

### Scenario 1: New Feature Development

**Workflow:**
1. **API Design Review** → Design RESTful endpoints
2. **Unit Test Generator** → Write tests first (TDD)
3. **Accessibility Development** → Implement accessible UI
4. **Security Analysis** → Validate security
5. **Code Review** → Final quality check
6. **ISO Compliance** → Verify quality standards

**Commands:**
```
You: "Help me design a REST API for user profile management"
[API Design Review skill creates design]

You: "Generate tests for the user profile service (TDD approach)"
[Unit Test Generator creates failing tests]

You: "Implement user profile component with WCAG 2.1 compliance"
[Accessibility Development generates accessible component]

You: "Run security analysis on the profile update endpoint"
[Security Analysis checks for vulnerabilities]

You: "Review the complete feature for quality and performance"
[Code Review provides comprehensive analysis]

You: "Assess overall quality against ISO standards"
[ISO Compliance provides quality score]
```

### Scenario 2: Bug Fixing

**Workflow:**
1. **Debug Analysis** → Identify root cause
2. **Unit Test Generator** → Add regression test
3. **Code Review** → Verify fix quality
4. **Performance Optimization** → Ensure no performance regression

**Commands:**
```
You: "Help me debug this error: [paste error]"
[Debug Analysis identifies root cause]

You: "Generate a regression test for this bug"
[Unit Test Generator creates test that reproduces bug]

You: "Review my bug fix for quality"
[Code Review validates fix]

You: "Ensure this fix doesn't impact performance"
[Performance Optimization validates]
```

### Scenario 3: Production Deployment Prep

**Workflow:**
1. **Security Analysis** → Security audit
2. **Performance Optimization** → Performance check
3. **ISO Compliance** → Quality assessment
4. **Code Review** → Final review

**Commands:**
```
You: "Run full security audit before production deployment"
[Security Analysis scans everything]

You: "Check performance of all critical endpoints"
[Performance Optimization validates]

You: "Assess overall quality for production readiness"
[ISO Compliance provides score]

You: "Final code review before deployment"
[Code Review provides sign-off]
```

---

## 📊 Measuring Your Success

### Skill Usage Targets (First Month)

| Skill | Target Uses/Week | Success Metric |
|-------|------------------|----------------|
| Code Review | 5-10 uses | Code quality score >85 |
| Debug Analysis | 3-5 uses | Bug fix time <30 min |
| Performance Optimization | 2-3 uses | API p95 <500ms |
| Security Analysis | 1-2 uses | Security score >85 |
| API Design Review | 2-4 uses | API design score >90 |
| Accessibility Development | 5-10 uses | WCAG score >95% |
| ISO Compliance | 1/week | Quality score >80 |
| Unit Test Generator | Daily | Test coverage >90% |

### Team-Wide Goals (First Quarter)

- ✅ 90%+ test coverage across all services
- ✅ 95%+ WCAG 2.1 AA compliance
- ✅ 85+ ISO quality score maintained
- ✅ <5 critical security vulnerabilities
- ✅ <500ms API response times (p95)
- ✅ 100% RESTful API compliance

---

## 🎓 Certification

Upon completing this training and demonstrating proficiency with all 8 skills:

**✅ Checklist for Certification:**
- [ ] Used Code Review skill 10+ times
- [ ] Fixed 5+ bugs using Debug Analysis
- [ ] Optimized 3+ slow endpoints
- [ ] Passed security audit (score >85)
- [ ] Designed 2+ RESTful APIs
- [ ] Created 5+ accessible components
- [ ] Achieved 90%+ test coverage on project
- [ ] Maintained ISO quality score >80

**Recognition:**
- Claude Code Engineer Skills Certification
- Team recognition as Skills Champion
- Mentor junior engineers on skill usage

---

## 📚 Additional Resources

### Documentation
- **Skills Reference**: `personas/engineer/skills/` (detailed skill docs)
- **Workflow Examples**: `docs/WORKFLOW_EXAMPLES.md`
- **Metrics Dashboard**: `docs/METRICS_DASHBOARD_SPEC.md`

### Support
- **Questions**: Ask in #claude-code Slack channel
- **Issues**: Create ticket in JIRA (label: claude-code)
- **Feedback**: Monthly skills retrospective meeting

### Continuous Learning
- **Weekly Tips**: Skills tip-of-the-week in team standup
- **Monthly Review**: Skills usage analytics shared
- **Quarterly Updates**: New skills and improvements announced

---

**Version:** 1.0.0
**Last Updated:** 2025-11-11
**Maintained By:** Engineering Team

---

**Ready to get started? Begin with Skill 1 (Code Review) and work your way through. Happy coding! 🚀**
