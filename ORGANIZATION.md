# ORGANIZATION.md - Engineering Standards & Best Practices

> **Purpose**: This document defines organization-wide engineering standards, guard-rails, and protocols that apply to ALL projects. These standards are enforced through code review, automated tooling, and CI/CD pipelines.

> **Scope**: Global - applies to all repositories, all teams, all personas

> **Maintenance**: Owned by Engineering Leadership. Updates distributed via Claude-Config updates.

---

## 🎯 Core Principles

### 1. Quality Over Speed
- Code quality is non-negotiable
- Technical debt must be tracked and addressed
- "Move fast but don't break things"

### 2. Security by Default
- Security is everyone's responsibility
- No secrets in code, ever
- Defense in depth

### 3. Accessibility First
- WCAG 2.1 AA minimum for all user-facing features
- Accessible by default, not as an afterthought

### 4. Test-Driven Development
- Tests are not optional
- Coverage requirements must be met
- Red-Green-Refactor cycle

### 5. Documentation is Code
- Code without documentation is incomplete
- APIs must be documented
- Architecture decisions must be recorded

---

## 🔒 Security Standards

### OWASP Top 10 Compliance

**ALL code must be free of OWASP Top 10 vulnerabilities:**

1. **Broken Access Control**
   - ✅ Implement role-based access control (RBAC)
   - ✅ Deny by default
   - ✅ Validate permissions on every request
   - ❌ Never trust client-side access control

2. **Cryptographic Failures**
   - ✅ Use TLS 1.3 for all data in transit
   - ✅ Encrypt sensitive data at rest (AES-256)
   - ✅ Use vetted cryptographic libraries (libsodium, OpenSSL)
   - ❌ Never implement custom crypto

3. **Injection Attacks**
   - ✅ Use parameterized queries (prepared statements)
   - ✅ Validate and sanitize all user input
   - ✅ Use ORM frameworks correctly
   - ❌ Never concatenate user input into queries

4. **Insecure Design**
   - ✅ Threat model during design phase
   - ✅ Use secure design patterns
   - ✅ Fail securely
   - ✅ Document security requirements

5. **Security Misconfiguration**
   - ✅ Remove default credentials
   - ✅ Disable unnecessary features
   - ✅ Use security headers (CSP, HSTS, etc.)
   - ✅ Keep dependencies updated

6. **Vulnerable and Outdated Components**
   - ✅ Automated dependency scanning (Dependabot, Snyk)
   - ✅ Update dependencies within 7 days of security patches
   - ✅ Maintain SBOM (Software Bill of Materials)
   - ❌ No dependencies with known critical vulnerabilities

7. **Identification and Authentication Failures**
   - ✅ Multi-factor authentication (MFA) for sensitive operations
   - ✅ Secure password storage (bcrypt, Argon2)
   - ✅ Session management (secure, httpOnly, sameSite cookies)
   - ✅ Rate limiting on authentication endpoints

8. **Software and Data Integrity Failures**
   - ✅ Verify digital signatures
   - ✅ Use trusted registries (npm, PyPI, Maven Central)
   - ✅ CI/CD pipeline security
   - ✅ Code signing

9. **Security Logging and Monitoring Failures**
   - ✅ Log all authentication events
   - ✅ Log all authorization failures
   - ✅ Centralized logging
   - ❌ Never log sensitive data (passwords, tokens, PII)

10. **Server-Side Request Forgery (SSRF)**
    - ✅ Validate and sanitize all URLs
    - ✅ Use allowlists for external requests
    - ✅ Disable HTTP redirects where possible
    - ✅ Network segmentation

### Secrets Management

**CRITICAL: No secrets in code, configuration files, or version control**

- ✅ Use secrets management tools (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault)
- ✅ Rotate secrets regularly (minimum: every 90 days)
- ✅ Use environment variables for configuration
- ✅ Git hooks to prevent secret commits (pre-commit, git-secrets)
- ❌ No API keys, passwords, tokens, or certificates in code
- ❌ No secrets in CI/CD logs

**What to do if secrets are committed:**
1. Revoke/rotate the secret immediately
2. Remove from Git history (`git-filter-repo`, BFG Repo-Cleaner)
3. Notify security team
4. Post-mortem to prevent recurrence

### Dependency Management

- ✅ **Automated scanning**: Dependabot, Renovate, or Snyk
- ✅ **Update critical vulnerabilities**: Within 7 days
- ✅ **Update high vulnerabilities**: Within 30 days
- ✅ **Pin dependencies**: Use lock files (package-lock.json, Pipfile.lock, go.sum)
- ✅ **Audit regularly**: `npm audit`, `pip-audit`, `go mod verify`
- ❌ No dependencies with GPL/AGPL licenses (unless approved)

---

## 🧪 Testing Standards

### Coverage Requirements

**Minimum coverage by component type:**

| Component Type | Line Coverage | Branch Coverage | Notes |
|----------------|---------------|-----------------|-------|
| Business Logic | 90% | 85% | Critical paths must be 100% |
| API Endpoints | 85% | 80% | Include error cases |
| UI Components | 75% | 70% | Focus on interactions |
| Utilities | 95% | 90% | High reuse = high coverage |
| Infrastructure | 70% | 65% | Focus on critical paths |

**Enforcement:**
- CI/CD pipeline fails if coverage drops below thresholds
- Coverage reports published to pull requests
- Trend monitoring (coverage should not decrease)

### Test Pyramid

Follow the test pyramid approach:

```
           /\
          /  \  E2E Tests (10%)
         /____\
        /      \  Integration Tests (20%)
       /________\
      /          \
     /   Unit     \  Unit Tests (70%)
    /______________\
```

**Unit Tests (70% of tests)**
- Fast (<100ms per test)
- Isolated (no external dependencies)
- Focused (one concept per test)
- TDD workflow (Red-Green-Refactor)

**Integration Tests (20% of tests)**
- Test component interactions
- Use test databases/APIs
- Focus on contracts between services
- Moderate speed (<5s per test)

**E2E Tests (10% of tests)**
- Critical user journeys only
- Run against staging environment
- Acceptable speed (<30s per test)
- Flaky tests must be fixed or removed

### Test-Driven Development (TDD)

**Required for:**
- New features
- Bug fixes (write failing test first)
- Refactoring (tests prevent regressions)

**TDD Cycle:**
1. **Red**: Write failing test
2. **Green**: Write minimal code to pass
3. **Refactor**: Improve code while keeping tests green

### Test Quality Standards

✅ **Good Tests:**
- Clear test names (describe what is being tested)
- Arrange-Act-Assert (AAA) pattern
- One assertion per test (generally)
- No logic in tests (no if/else, no loops)
- Fast and deterministic

❌ **Bad Tests:**
- Flaky tests (non-deterministic)
- Slow tests (>1s for unit tests)
- Tests that test implementation details
- Tests with hard-coded dates/times
- Tests that depend on execution order

---

## 👁️ Code Review Standards

### Review Requirements

**ALL code must be reviewed before merging:**

- ✅ At least 1 approval from team member
- ✅ At least 1 approval from domain expert (for significant changes)
- ✅ All CI/CD checks passing (tests, linting, security scans)
- ✅ No unresolved conversations
- ✅ Branch up-to-date with target branch

**Review SLAs:**
- Small PRs (<200 lines): 4 hours
- Medium PRs (200-500 lines): 1 business day
- Large PRs (>500 lines): 2 business days or break into smaller PRs

### What to Review

**Security (Highest Priority)**
- ✅ Input validation
- ✅ Authentication/authorization
- ✅ SQL injection prevention
- ✅ XSS prevention
- ✅ CSRF protection
- ✅ Secrets management
- ✅ Error handling (no information leakage)

**Code Quality**
- ✅ Follows SOLID principles
- ✅ DRY (Don't Repeat Yourself)
- ✅ YAGNI (You Aren't Gonna Need It)
- ✅ Clear naming (functions, variables, classes)
- ✅ Appropriate abstractions
- ✅ Error handling
- ✅ Edge cases covered

**Performance**
- ✅ No N+1 queries
- ✅ Appropriate use of indexes
- ✅ Efficient algorithms (O(n) vs O(n²))
- ✅ Caching where appropriate
- ✅ Lazy loading
- ✅ Pagination for large datasets

**Testing**
- ✅ Tests included
- ✅ Coverage requirements met
- ✅ Edge cases tested
- ✅ Error cases tested
- ✅ Tests are maintainable

**Documentation**
- ✅ API documentation (OpenAPI/Swagger)
- ✅ Inline comments for complex logic
- ✅ README updated (if applicable)
- ✅ ADR for significant decisions

**Accessibility**
- ✅ Semantic HTML
- ✅ ARIA labels where needed
- ✅ Keyboard navigation
- ✅ Color contrast (WCAG AA)
- ✅ Screen reader compatibility

### Review Etiquette

**For Reviewers:**
- 🎯 Be specific ("Use const instead of let here" vs "Fix this")
- 🤝 Be respectful (assume positive intent)
- 📚 Provide context (explain WHY, not just WHAT)
- ✅ Approve when ready (don't hold up good work)
- 🚫 Don't nitpick style (automate with linters)

**For Authors:**
- 📝 Provide context (link to ticket, explain approach)
- 🏗️ Keep PRs small (<400 lines preferred)
- 💬 Respond to all comments
- 🙏 Thank reviewers
- 🚫 Don't take feedback personally

---

## 🌿 Git Workflow & Conventions

### Branching Strategy

**Branch Types:**

```
main (protected)
  ├── develop (protected)
  │   ├── feature/TICKET-123-short-description
  │   ├── feature/TICKET-456-another-feature
  │   ├── bugfix/TICKET-789-fix-login-issue
  │   └── hotfix/TICKET-999-critical-security-fix
```

**Branch Naming:**
- `feature/TICKET-ID-short-description` - New features
- `bugfix/TICKET-ID-short-description` - Bug fixes
- `hotfix/TICKET-ID-short-description` - Critical production fixes
- `refactor/TICKET-ID-short-description` - Code refactoring
- `docs/TICKET-ID-short-description` - Documentation only

**Protected Branches:**
- `main` - Production-ready code only
- `develop` - Integration branch for features

**Protections:**
- ✅ Require pull request reviews (minimum 1)
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Require linear history (no merge commits to main)
- ❌ No direct commits (even for admins)
- ❌ No force pushes

### Commit Message Conventions

**Format (Conventional Commits):**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Code style changes (formatting, no logic change)
- `refactor` - Code refactoring (no feature change or bug fix)
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Maintenance tasks (dependencies, build)
- `ci` - CI/CD pipeline changes
- `revert` - Reverting previous commit

**Examples:**

```
feat(auth): add OAuth2 authentication

Implement OAuth2 flow using Authorization Code grant type.
Supports Google and GitHub as identity providers.

Closes TICKET-123
```

```
fix(api): prevent SQL injection in user search

Use parameterized queries instead of string concatenation.

Security: Fixes OWASP A03:2021 Injection vulnerability
```

```
perf(database): add index on user_id column

Query performance improved from 2.5s to 50ms for user lookups.
```

**Commit Guidelines:**
- ✅ Use imperative mood ("add" not "added" or "adds")
- ✅ First line 50 characters or less
- ✅ Body wrapped at 72 characters
- ✅ Reference ticket ID
- ✅ Atomic commits (one logical change per commit)
- ❌ No "WIP" or "fix" commits in main/develop

### Pull Request Guidelines

**PR Title:**
- Follow commit message format: `type(scope): description`
- Clear and descriptive

**PR Description Template:**

```markdown
## Summary
Brief description of changes (2-3 sentences)

## Related Ticket
Closes TICKET-123

## Changes Made
- Added OAuth2 authentication
- Updated user model with provider field
- Added integration tests

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] Accessibility tested (if UI changes)

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Security Considerations
[Describe any security implications]

## Performance Considerations
[Describe any performance implications]

## Deployment Notes
[Any special deployment requirements]
```

**PR Size Guidelines:**
- ✅ **Small** (<200 lines): Preferred
- ⚠️ **Medium** (200-500 lines): Acceptable
- ❌ **Large** (>500 lines): Break into smaller PRs

**Before Submitting PR:**
- ✅ Self-review your code
- ✅ Run tests locally
- ✅ Update documentation
- ✅ Check for merge conflicts
- ✅ Remove debug code/console.logs
- ✅ Run linter

---

## ♿ Accessibility Standards

### WCAG 2.1 Compliance

**Minimum Level: AA (for all user-facing features)**

### POUR Principles

**1. Perceivable**
- ✅ Text alternatives for non-text content
- ✅ Captions for audio/video
- ✅ Adaptable content (multiple ways to present)
- ✅ Distinguishable (color contrast, text sizing)

**2. Operable**
- ✅ Keyboard accessible (all functionality via keyboard)
- ✅ Enough time (no time limits or adjustable)
- ✅ No seizure triggers (no flashing content >3 times/sec)
- ✅ Navigable (skip links, clear focus, breadcrumbs)

**3. Understandable**
- ✅ Readable (clear language, abbreviations explained)
- ✅ Predictable (consistent navigation and behavior)
- ✅ Input assistance (error messages, labels, instructions)

**4. Robust**
- ✅ Compatible (valid HTML, ARIA when needed)
- ✅ Works with assistive technologies

### Accessibility Checklist

**Semantic HTML**
- ✅ Use semantic elements (`<nav>`, `<main>`, `<article>`, `<aside>`)
- ✅ Proper heading hierarchy (h1 → h2 → h3, no skipping)
- ✅ Use `<button>` for buttons (not `<div>` with click handler)
- ✅ Use `<a>` for links (with meaningful text, no "click here")

**ARIA (When Semantic HTML Insufficient)**
- ✅ `aria-label` for elements without visible labels
- ✅ `aria-labelledby` for associating labels
- ✅ `aria-describedby` for additional descriptions
- ✅ `aria-live` for dynamic content updates
- ✅ `role` when semantic HTML unavailable
- ❌ Don't override semantic HTML with ARIA unnecessarily

**Keyboard Navigation**
- ✅ All interactive elements keyboard accessible
- ✅ Visible focus indicators (outline, border)
- ✅ Logical tab order
- ✅ Skip links for navigation
- ✅ Keyboard shortcuts documented
- ❌ No keyboard traps

**Color & Contrast**
- ✅ **Text contrast**: 4.5:1 for normal text, 3:1 for large text
- ✅ **UI component contrast**: 3:1 for interactive elements
- ✅ Don't rely on color alone (use icons, patterns, text)
- ✅ Test with color blindness simulators

**Forms**
- ✅ Labels for all inputs (`<label for="inputId">`)
- ✅ Clear error messages
- ✅ `aria-required` for required fields
- ✅ `aria-invalid` and error messages for validation
- ✅ Group related inputs (`<fieldset>` and `<legend>`)

**Images & Media**
- ✅ `alt` text for all images (empty `alt=""` for decorative)
- ✅ Transcripts for audio
- ✅ Captions for video
- ✅ Audio descriptions for complex video content

**Testing Requirements**
- ✅ Automated testing (axe, Lighthouse, WAVE)
- ✅ Keyboard-only testing
- ✅ Screen reader testing (NVDA, JAWS, VoiceOver)
- ✅ Zoom to 200% (content must reflow)
- ✅ Color contrast verification

---

## 📊 Code Quality Standards

### ISO/IEC 25010 Quality Model

**All code evaluated on 8 quality characteristics:**

| Characteristic | Weight | Description | Key Metrics |
|----------------|--------|-------------|-------------|
| **Functional Suitability** | 15% | Complete, correct, appropriate | Feature completeness, correctness |
| **Performance Efficiency** | 10% | Time behavior, resource utilization | Response time, throughput |
| **Compatibility** | 8% | Co-existence, interoperability | API compatibility, data formats |
| **Usability** | 12% | Learnability, operability, UX | Error rates, task completion |
| **Reliability** | 15% | Maturity, availability, fault tolerance | Uptime, MTBF, error rates |
| **Security** | 20% | Confidentiality, integrity, accountability | Vulnerabilities, auth coverage |
| **Maintainability** | 15% | Modularity, reusability, analyzability | Cyclomatic complexity, coupling |
| **Portability** | 5% | Adaptability, installability | Cross-platform, deployment |

**Overall Quality Score Calculation:**
```
Quality Score = Σ(Characteristic Score × Weight)
Target: ≥ 80/100
```

### Code Complexity Limits

**Cyclomatic Complexity:**
- ✅ **Low complexity**: 1-10 (ideal)
- ⚠️ **Moderate complexity**: 11-20 (acceptable with tests)
- ❌ **High complexity**: 21+ (requires refactoring)

**Function Length:**
- ✅ Preferred: <50 lines
- ⚠️ Acceptable: <100 lines
- ❌ Requires justification: >100 lines

**File Length:**
- ✅ Preferred: <300 lines
- ⚠️ Acceptable: <500 lines
- ❌ Requires justification: >500 lines

**Class/Module Responsibilities:**
- ✅ Single Responsibility Principle
- ❌ God classes/modules

### Static Analysis

**Linting (Required):**
- JavaScript/TypeScript: ESLint
- Python: Pylint, Flake8, Black
- Java: Checkstyle, PMD, SpotBugs
- Go: golangci-lint
- Ruby: RuboCop

**Linting Rules:**
- ✅ No warnings in production code
- ✅ Errors must be fixed before merge
- ✅ Run in CI/CD pipeline
- ⚠️ Can disable specific rules with justification in code

**Code Formatting:**
- ✅ Automated formatting (Prettier, Black, gofmt)
- ✅ Run on pre-commit hook
- ✅ Consistent across team
- ❌ No manual formatting discussions in code review

---

## 🚀 API Design Standards

### RESTful API Principles

**Resource-Oriented Design:**
- ✅ Use nouns for resources (`/users`, `/orders`)
- ❌ No verbs in URLs (`/getUser`, `/createOrder`)

**HTTP Methods:**
- `GET` - Retrieve resource(s) (idempotent, safe)
- `POST` - Create new resource
- `PUT` - Replace entire resource (idempotent)
- `PATCH` - Partial update
- `DELETE` - Remove resource (idempotent)

**Status Codes:**
- `200 OK` - Successful GET, PUT, PATCH, DELETE
- `201 Created` - Successful POST
- `204 No Content` - Successful DELETE (no body)
- `400 Bad Request` - Client error (validation)
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Authenticated but not authorized
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Resource state conflict
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limiting
- `500 Internal Server Error` - Server error
- `503 Service Unavailable` - Temporary outage

### URL Structure

**Format:**
```
https://api.example.com/v1/resources/{id}/sub-resources
```

**Guidelines:**
- ✅ Use plural nouns (`/users` not `/user`)
- ✅ Use kebab-case for multi-word resources (`/user-profiles`)
- ✅ Versioning in URL (`/v1/`, `/v2/`)
- ✅ Filter with query params (`/users?role=admin&active=true`)
- ✅ Pagination with query params (`/users?page=2&limit=50`)
- ✅ Sorting with query params (`/users?sort=created_at:desc`)
- ❌ No file extensions (`/users.json`)
- ❌ No trailing slashes (`/users/`)

### Request/Response Format

**Request Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
X-Request-ID: {uuid}
```

**Response Format (Success):**
```json
{
  "data": {
    "id": "123",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com"
    }
  },
  "meta": {
    "timestamp": "2025-01-11T10:00:00Z"
  }
}
```

**Response Format (Error):**
```json
{
  "errors": [
    {
      "code": "VALIDATION_ERROR",
      "message": "Email is required",
      "field": "email",
      "details": {
        "constraint": "required"
      }
    }
  ],
  "meta": {
    "requestId": "abc-123",
    "timestamp": "2025-01-11T10:00:00Z"
  }
}
```

### API Documentation

**OpenAPI/Swagger (Required):**
- ✅ All endpoints documented
- ✅ Request/response schemas defined
- ✅ Authentication documented
- ✅ Examples provided
- ✅ Error codes documented
- ✅ Interactive documentation (Swagger UI)
- ✅ Keep documentation up-to-date with code

### Rate Limiting

**Standard Limits:**
- Authenticated users: 1000 requests/hour
- Unauthenticated: 100 requests/hour
- Burst: 10 requests/second

**Response Headers:**
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

**429 Response:**
```json
{
  "errors": [{
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Try again in 3600 seconds.",
    "retryAfter": 3600
  }]
}
```

### Versioning Strategy

**Major Version Changes:**
- Breaking changes (remove field, change behavior)
- New major version (`/v2/`)
- Support old version for 12 months minimum

**Minor Version Changes:**
- Non-breaking (add field, add endpoint)
- Same major version
- Backward compatible

### Pagination

**Cursor-based (Preferred):**
```
GET /users?cursor=abc123&limit=50
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "nextCursor": "def456",
    "prevCursor": "xyz789",
    "hasMore": true
  }
}
```

**Page-based (Simple Use Cases):**
```
GET /users?page=2&limit=50
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 50,
    "total": 1000,
    "totalPages": 20
  }
}
```

---

## 📚 Documentation Requirements

### Code Documentation

**Inline Comments:**
- ✅ Explain WHY, not WHAT
- ✅ Complex algorithms explained
- ✅ Non-obvious behavior documented
- ✅ TODOs with ticket references
- ❌ No redundant comments (code should be self-documenting)

**Function/Method Documentation:**

**JavaScript/TypeScript (JSDoc):**
```typescript
/**
 * Calculate the total price including tax and discounts
 *
 * @param {number} basePrice - The base price before tax/discounts
 * @param {number} taxRate - Tax rate as decimal (e.g., 0.08 for 8%)
 * @param {number} discountPercent - Discount percentage (0-100)
 * @returns {number} Final price with tax and discounts applied
 * @throws {Error} If taxRate or discountPercent are invalid
 *
 * @example
 * const price = calculateTotal(100, 0.08, 10);
 * // Returns 97.20 (100 - 10% = 90, + 8% tax = 97.20)
 */
function calculateTotal(basePrice: number, taxRate: number, discountPercent: number): number {
  // Implementation
}
```

**Python (Docstrings):**
```python
def calculate_total(base_price: float, tax_rate: float, discount_percent: float) -> float:
    """
    Calculate the total price including tax and discounts.

    Args:
        base_price: The base price before tax/discounts
        tax_rate: Tax rate as decimal (e.g., 0.08 for 8%)
        discount_percent: Discount percentage (0-100)

    Returns:
        Final price with tax and discounts applied

    Raises:
        ValueError: If tax_rate or discount_percent are invalid

    Example:
        >>> calculate_total(100, 0.08, 10)
        97.20
    """
    # Implementation
```

### README Requirements

**All repositories must have a comprehensive README:**

```markdown
# Project Name

Brief description (1-2 sentences)

## Overview
Detailed description, purpose, key features

## Prerequisites
- Node.js 18+
- PostgreSQL 14+
- etc.

## Installation
Step-by-step setup instructions

## Usage
Examples of how to use the project

## Configuration
Environment variables and config options

## Development
How to contribute, run tests, etc.

## API Documentation
Link to OpenAPI/Swagger docs

## Architecture
High-level architecture overview (link to ADRs)

## Testing
How to run tests

## Deployment
Deployment instructions

## Security
Security considerations, how to report vulnerabilities

## License
License information

## Contact
Team/owner contact information
```

### Architecture Decision Records (ADRs)

**Required for significant technical decisions:**

**Location:** `docs/adr/`

**Template:**
```markdown
# ADR-001: Use PostgreSQL for Primary Database

## Status
Accepted

## Context
We need a relational database for storing user data, transactions, and analytics.
Requirements:
- ACID compliance
- Complex query support
- JSON support for flexible schemas
- Strong community support

## Decision
We will use PostgreSQL 14+ as our primary database.

## Consequences
**Positive:**
- Strong ACID guarantees
- Excellent JSON support (JSONB)
- Rich extension ecosystem
- Strong community and tooling

**Negative:**
- Vertical scaling limitations
- More complex operations than NoSQL for some use cases
- Requires careful index management

**Neutral:**
- Need to train team on PostgreSQL best practices
- Must implement proper backup/restore procedures

## Alternatives Considered
- MySQL: Less robust JSON support
- MongoDB: No ACID guarantees across documents
- DynamoDB: Vendor lock-in, less flexible querying
```

---

## 🏗️ Infrastructure & DevOps

### CI/CD Requirements

**All repositories must have CI/CD pipelines:**

**On Pull Request:**
- ✅ Run all tests (unit, integration)
- ✅ Run linters
- ✅ Check code coverage
- ✅ Security scanning (Snyk, Dependabot)
- ✅ Build application
- ✅ Deploy to preview environment

**On Merge to Main:**
- ✅ All PR checks plus:
- ✅ Deploy to staging
- ✅ Run E2E tests against staging
- ✅ Performance testing
- ✅ Tag release

**On Release Tag:**
- ✅ Deploy to production
- ✅ Smoke tests
- ✅ Rollback capability

### Environment Strategy

**Environments:**

| Environment | Purpose | Branch | Access |
|-------------|---------|--------|--------|
| **Development** | Local development | feature/* | Developers |
| **Preview** | PR preview | PR branch | Reviewers |
| **Staging** | Pre-production testing | develop | QA + Team |
| **Production** | Live system | main | Restricted |

**Environment Parity:**
- ✅ Staging mirrors production (same versions, configs)
- ✅ Use same deployment process
- ✅ Same monitoring and logging

### Monitoring & Observability

**Required Metrics:**
- ✅ Application metrics (response time, throughput, error rate)
- ✅ Infrastructure metrics (CPU, memory, disk, network)
- ✅ Business metrics (user sign-ups, transactions, etc.)

**Logging:**
- ✅ Structured logging (JSON format)
- ✅ Correlation IDs for request tracing
- ✅ Log levels: ERROR, WARN, INFO, DEBUG
- ✅ Centralized logging (ELK, CloudWatch, etc.)
- ❌ No sensitive data in logs

**Alerting:**
- ✅ Error rate thresholds
- ✅ Response time thresholds
- ✅ Availability monitoring
- ✅ Security alerts
- ✅ Escalation policies

### Deployment Best Practices

**Zero-Downtime Deployments:**
- ✅ Blue-green deployments or rolling updates
- ✅ Database migrations backward compatible
- ✅ Feature flags for gradual rollout
- ✅ Automated rollback capability

**Deployment Checklist:**
- [ ] All tests passing
- [ ] Security scans passed
- [ ] Database migrations tested
- [ ] Configuration reviewed
- [ ] Monitoring alerts configured
- [ ] Rollback plan documented
- [ ] Team notified
- [ ] Post-deployment verification plan

---

## 🔐 Data Privacy & Compliance

### Personal Data Handling

**GDPR/CCPA Compliance:**

- ✅ **Data minimization**: Collect only necessary data
- ✅ **Purpose limitation**: Use data only for stated purpose
- ✅ **Consent**: Obtain explicit consent before collection
- ✅ **Right to access**: Users can request their data
- ✅ **Right to deletion**: Users can request data deletion
- ✅ **Data portability**: Export user data in standard format
- ✅ **Breach notification**: Report breaches within 72 hours

**PII (Personally Identifiable Information):**
- ✅ Encrypt PII at rest (AES-256)
- ✅ Encrypt PII in transit (TLS 1.3)
- ✅ Tokenize/pseudonymize where possible
- ✅ Access logging for PII access
- ❌ Never log PII (names, emails, SSN, addresses, etc.)
- ❌ Never commit PII to version control
- ❌ No PII in error messages or stack traces

### Data Retention

**Retention Policies:**

| Data Type | Retention Period | Deletion Method |
|-----------|------------------|-----------------|
| User accounts (active) | Until user deletion request | Hard delete + anonymize analytics |
| User accounts (inactive) | 3 years | Hard delete |
| Logs (application) | 90 days | Automated deletion |
| Logs (security) | 1 year | Automated deletion |
| Backups | 30 days | Automated deletion |
| Analytics (anonymized) | 2 years | Automated deletion |

---

## 🎓 Learning & Development

### Onboarding Requirements

**All new engineers must complete:**

1. Security training (OWASP Top 10)
2. Accessibility training (WCAG 2.1)
3. Code review training
4. Testing best practices
5. Git workflow training

### Continuous Learning

- ✅ Lunch & learns (bi-weekly)
- ✅ Conference attendance budget ($2000/year/engineer)
- ✅ Training budget ($1000/year/engineer)
- ✅ Knowledge sharing (internal tech talks)

---

## 📋 Enforcement & Exceptions

### Automated Enforcement

**Pre-commit Hooks:**
- Linting
- Formatting
- Secret scanning

**CI/CD Pipeline:**
- All tests must pass
- Coverage thresholds must be met
- Security scans must pass (no critical/high vulnerabilities)
- Build must succeed

### Exception Process

**When standards cannot be met:**

1. **Document** the exception request
2. **Justify** why the standard cannot be met
3. **Get approval** from tech lead or architect
4. **Add TODO** to address technical debt
5. **Track** in technical debt backlog

**Exception Template:**
```markdown
## Standards Exception Request

**Standard**: [e.g., "80% test coverage requirement"]
**Reason**: [e.g., "Legacy code without tests, high risk to add tests now"]
**Proposed Alternative**: [e.g., "Add tests incrementally as we modify code"]
**Timeline**: [e.g., "6 months"]
**Approved By**: [Name, Date]
**Tracking**: [TICKET-ID]
```

---

## 🔄 Updates & Feedback

### Document Maintenance

- **Owner**: Engineering Leadership
- **Review Cycle**: Quarterly
- **Updates**: Announced in engineering all-hands
- **Distribution**: Via Claude-Config updates (`install.sh --update`)

### Feedback Process

**Have suggestions for improving these standards?**

1. Create an RFC (Request for Comments)
2. Share with engineering team
3. Gather feedback (2-week comment period)
4. Present to architecture review board
5. Update ORGANIZATION.md if approved
6. Announce changes

---

## 📞 Support & Questions

**Questions about these standards?**
- Engineering Leadership Team
- #engineering-standards Slack channel
- Monthly office hours (first Friday of each month)

**Reporting violations:**
- Discuss in code review
- Escalate to tech lead if needed
- Anonymous reporting via [link to form]

---

*Last Updated: 2025-01-11*
*Version: 1.0.0*
*Maintained by: Engineering Leadership*
