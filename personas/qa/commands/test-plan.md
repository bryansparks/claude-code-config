**Purpose**: Create comprehensive test plans and testing strategies

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Create test plan for $ARGUMENTS"

Generate detailed test plans that define testing scope, strategy, and approach for features, releases, or entire projects.

## Usage Examples
- `/test-plan --feature "User Authentication" --types unit,e2e`
- `/test-plan --release v2.4.0 --risk-based`
- `/test-plan --project "E-commerce Platform" --comprehensive`
- `/test-plan --regression --baseline v2.3.0`
- `/test-plan --performance --load-profile peak-traffic`

## Command-Specific Flags
--feature: "Test plan for specific feature"
--release: "Test plan for release version"
--project: "Comprehensive project test plan"
--regression: "Regression test plan"
--types: "Test types to include: unit, integration, e2e, performance, a11y"
--risk-based: "Prioritize by risk analysis"
--comprehensive: "Include all test types and scenarios"
--baseline: "Baseline version for comparison"
--performance: "Include performance testing"
--security: "Include security testing"
--accessibility: "Include accessibility testing"
--load-profile: "Expected load profile: normal, peak, stress"
--timeline: "Testing timeline and milestones"
--resources: "Team resources and allocation"

## Test Plan Process

**1. Requirements Analysis:**
- Review feature requirements
- Identify testable requirements
- Note acceptance criteria
- Understand user stories

**2. Scope Definition:**
- In-scope items
- Out-of-scope items
- Testing types needed
- Environment requirements

**3. Risk Assessment:**
- Identify high-risk areas
- Business impact analysis
- Technical complexity
- User impact

**4. Test Strategy:**
- Test approach per layer
- Automation vs manual
- Tool selection
- Coverage targets

**5. Test Design:**
- Test scenarios
- Test cases
- Test data requirements
- Expected results

**6. Resource Planning:**
- Team allocation
- Timeline estimation
- Environment setup
- Tool requirements

**7. Execution Plan:**
- Test phases
- Entry/exit criteria
- Defect management
- Reporting cadence

## Output Format

The test-plan command provides:
1. **Executive Summary**: Overview and objectives
2. **Scope**: What will/won't be tested
3. **Risk Assessment**: High-risk areas prioritized
4. **Test Strategy**: Approach for each test type
5. **Test Scenarios**: Detailed test cases
6. **Timeline**: Phases and milestones
7. **Resources**: Team and tools needed
8. **Success Criteria**: Definition of done

## Test Plan Template

```markdown
# Test Plan: [Feature/Release Name]

## 1. Executive Summary

**Project**: E-commerce Platform
**Feature**: User Authentication & Authorization
**Version**: v2.4.0
**Test Plan Owner**: QA Lead
**Date**: 2025-10-04

### Objectives
- Verify secure user authentication
- Validate role-based access control
- Ensure password security compliance
- Test SSO integration

### Scope Overview
- Login/logout functionality
- Password reset flow
- Session management
- OAuth 2.0 integration
- Multi-factor authentication

## 2. Scope

### In Scope
- User registration and login
- Password strength validation
- Password reset workflow
- Session timeout handling
- Remember me functionality
- OAuth login (Google, GitHub)
- MFA setup and verification
- Role-based permissions
- Account lockout after failed attempts
- Security audit logging

### Out of Scope
- Third-party OAuth provider testing (trust provider)
- Email delivery testing (covered separately)
- Browser compatibility < 2 years old
- Load testing > 10,000 concurrent users

### Test Types
- ✓ Unit Testing (80% coverage target)
- ✓ Integration Testing (API endpoints)
- ✓ End-to-End Testing (user flows)
- ✓ Security Testing (OWASP Top 10)
- ✓ Accessibility Testing (WCAG AA)
- ✓ Performance Testing (login speed)
- ✗ Penetration Testing (external security audit)

## 3. Risk Assessment

### High Risk (Priority 1)
**Security Vulnerabilities**
- Impact: Data breach, user account compromise
- Probability: Medium
- Mitigation: Security testing, code review, penetration test
- Test Priority: P0

**Password Reset Flow**
- Impact: Users locked out of accounts
- Probability: Medium
- Mitigation: Extensive E2E testing, manual verification
- Test Priority: P1

**Session Management**
- Impact: Unauthorized access, session hijacking
- Probability: Low
- Mitigation: Security testing, session timeout tests
- Test Priority: P1

### Medium Risk (Priority 2)
**OAuth Integration**
- Impact: Unable to login via SSO
- Probability: Low
- Mitigation: Integration testing, fallback to email/password
- Test Priority: P2

**MFA Setup**
- Impact: User unable to enable MFA
- Probability: Low
- Mitigation: E2E testing, clear error messages
- Test Priority: P2

### Low Risk (Priority 3)
**Remember Me Functionality**
- Impact: Minor inconvenience
- Probability: Low
- Mitigation: Basic testing
- Test Priority: P3

## 4. Test Strategy

### Unit Testing
**Tools**: Jest, React Testing Library
**Coverage Target**: 80% minimum
**Focus**:
- Password validation logic
- Token generation/verification
- Session utilities
- Input sanitization

**Example**:
```typescript
describe('PasswordValidator', () => {
  it('requires minimum 8 characters', () => {
    expect(validatePassword('short')).toBe(false);
    expect(validatePassword('longenough1!')).toBe(true);
  });

  it('requires uppercase, lowercase, number, symbol', () => {
    expect(validatePassword('lowercase1!')).toBe(false);
    expect(validatePassword('Uppercase1!')).toBe(true);
  });
});
```

### Integration Testing
**Tools**: Supertest, Jest
**Focus**:
- Authentication API endpoints
- Token refresh flow
- Database interactions
- OAuth callback handling

**Test Cases**:
1. POST /api/auth/login - Valid credentials
2. POST /api/auth/login - Invalid credentials
3. POST /api/auth/logout - Clear session
4. POST /api/auth/refresh - Refresh access token
5. POST /api/auth/reset-password - Send reset email

### End-to-End Testing
**Tools**: Playwright
**Coverage**: Critical user journeys
**Focus**:
- Complete login flow
- Password reset workflow
- OAuth login process
- MFA setup and verification
- Session timeout behavior

**Test Scenarios** (see section 5)

### Security Testing
**Tools**: OWASP ZAP, npm audit, Snyk
**Focus**:
- SQL injection prevention
- XSS prevention
- CSRF protection
- Password hashing (bcrypt)
- Secure session storage
- Rate limiting on login
- Account lockout policy

**Checklist**:
- [ ] Passwords stored as bcrypt hashes
- [ ] HTTPS enforced
- [ ] JWT tokens properly signed
- [ ] Session cookies HttpOnly & Secure
- [ ] CSRF tokens implemented
- [ ] Input validation & sanitization
- [ ] Rate limiting on auth endpoints
- [ ] Account lockout after 5 failed attempts

### Performance Testing
**Tools**: Lighthouse, k6
**Targets**:
- Login page load: < 2s
- Login API response: < 300ms
- Token refresh: < 100ms

**Load Test**:
- Concurrent logins: 100 users
- Duration: 5 minutes
- Success rate: > 99%

### Accessibility Testing
**Tools**: axe-core, NVDA
**Standard**: WCAG 2.1 AA
**Focus**:
- Login form labels
- Error message announcements
- Keyboard navigation
- Focus indicators
- Screen reader compatibility

## 5. Test Scenarios

### Scenario 1: New User Registration
**Priority**: P0
**Type**: E2E

**Steps**:
1. Navigate to /register
2. Fill registration form:
   - Email: newuser@example.com
   - Password: SecurePass123!
   - Confirm password: SecurePass123!
3. Click "Create Account"

**Expected Result**:
- Account created successfully
- Verification email sent
- User redirected to /verify-email
- Success message displayed

**Test Data**:
- Valid emails, invalid emails
- Strong passwords, weak passwords
- Password mismatch scenarios

---

### Scenario 2: User Login (Valid Credentials)
**Priority**: P0
**Type**: E2E

**Steps**:
1. Navigate to /login
2. Enter email: test@example.com
3. Enter password: correctpassword
4. Click "Login"

**Expected Result**:
- User authenticated
- Redirected to /dashboard
- Session cookie set
- User profile loaded

**Variations**:
- Remember me checked
- Remember me unchecked
- Login from different device

---

### Scenario 3: User Login (Invalid Credentials)
**Priority**: P0
**Type**: E2E

**Steps**:
1. Navigate to /login
2. Enter email: test@example.com
3. Enter password: wrongpassword
4. Click "Login"

**Expected Result**:
- Login fails
- Error message: "Invalid email or password"
- No session created
- Account lockout after 5 attempts

---

### Scenario 4: Password Reset Flow
**Priority**: P1
**Type**: E2E

**Steps**:
1. Navigate to /login
2. Click "Forgot Password?"
3. Enter email: test@example.com
4. Click "Send Reset Link"
5. Open reset email (simulated)
6. Click reset link
7. Enter new password
8. Confirm new password
9. Click "Reset Password"

**Expected Result**:
- Reset email sent
- Reset link valid for 1 hour
- Password updated successfully
- Old password no longer works
- Can login with new password

---

### Scenario 5: OAuth Login (Google)
**Priority**: P2
**Type**: Integration + E2E

**Steps**:
1. Navigate to /login
2. Click "Login with Google"
3. Redirected to Google OAuth
4. Grant permissions (simulated)
5. Redirected back to app

**Expected Result**:
- User authenticated via OAuth
- Account created if new user
- Linked to existing account if email matches
- Session created
- Redirected to /dashboard

---

### Scenario 6: Multi-Factor Authentication
**Priority**: P2
**Type**: E2E

**Steps**:
1. Login successfully
2. Navigate to /settings/security
3. Click "Enable MFA"
4. Scan QR code with authenticator app
5. Enter verification code
6. Click "Enable"

**Expected Result**:
- MFA enabled on account
- Backup codes generated
- Next login requires MFA code

**MFA Login**:
1. Enter email & password
2. Prompted for MFA code
3. Enter 6-digit code
4. Successfully authenticated

---

### Scenario 7: Session Timeout
**Priority**: P2
**Type**: E2E

**Steps**:
1. Login successfully
2. Wait for session timeout (30 minutes)
3. Attempt to access protected page

**Expected Result**:
- Session expired
- Redirected to /login
- Message: "Session expired, please login again"
- Can login again successfully

---

### Scenario 8: Account Lockout
**Priority**: P1
**Type**: Security

**Steps**:
1. Attempt login with wrong password (5 times)

**Expected Result**:
- After 5 failed attempts, account locked
- Message: "Account locked for 15 minutes"
- Cannot login even with correct password
- Can login after 15 minutes

---

## 6. Test Environment

### Environments
**Development**:
- URL: https://dev.example.com
- Purpose: Feature testing, integration testing
- Data: Synthetic test data, refreshed daily

**Staging**:
- URL: https://staging.example.com
- Purpose: Release candidate testing, E2E testing
- Data: Production-like data (sanitized)

**Production**:
- URL: https://example.com
- Purpose: Smoke testing post-deployment
- Data: Real user data

### Test Data
**Test Accounts**:
- qa-admin@example.com (Admin role)
- qa-user@example.com (Standard user)
- qa-premium@example.com (Premium user)

**OAuth Test Accounts**:
- Google: qa-google@example.com
- GitHub: qa-github@example.com

**Security Test Data**:
- SQL injection payloads
- XSS attack vectors
- Malformed JWT tokens

## 7. Timeline

### Phase 1: Test Preparation (Oct 4-6)
- [ ] Review requirements
- [ ] Set up test environments
- [ ] Create test data
- [ ] Configure test tools

### Phase 2: Test Execution (Oct 7-11)
- [ ] Unit tests (continuous)
- [ ] Integration tests
- [ ] E2E tests
- [ ] Security tests
- [ ] Performance tests
- [ ] Accessibility tests

### Phase 3: Regression Testing (Oct 12-13)
- [ ] Smoke tests
- [ ] Critical path tests
- [ ] Cross-browser tests

### Phase 4: Bug Fixing & Retesting (Oct 14-16)
- [ ] Fix P0/P1 bugs
- [ ] Retest fixed issues
- [ ] Verify no regression

### Phase 5: Sign-off (Oct 17)
- [ ] Test summary report
- [ ] Risk assessment
- [ ] Go/No-go decision

**Key Milestones**:
- Oct 6: Test environment ready
- Oct 11: Initial testing complete
- Oct 13: Regression complete
- Oct 17: Release candidate approved

## 8. Entry/Exit Criteria

### Entry Criteria
- [ ] Feature development complete
- [ ] Code review passed
- [ ] Unit tests passing (>80% coverage)
- [ ] Test environment available
- [ ] Test data prepared

### Exit Criteria
- [ ] All P0/P1 bugs fixed
- [ ] Test coverage targets met
- [ ] Performance benchmarks achieved
- [ ] Security scan passed
- [ ] Accessibility audit passed
- [ ] Cross-browser testing complete
- [ ] Test summary report approved

## 9. Defect Management

**Severity Levels**: P0 (Critical) → P4 (Trivial)

**Bug Workflow**:
1. Bug identified → Create bug report
2. Severity classified
3. Assigned to developer
4. Fixed → Retest
5. Verified → Close

**Acceptance Criteria**:
- Zero P0 bugs
- < 3 P1 bugs
- All P2 bugs documented for future fix

## 10. Resources

### Team
- QA Lead (1) - Test plan, coordination
- QA Engineers (2) - Test execution
- Security Specialist (0.5) - Security testing
- Developers (3) - Bug fixes

### Tools
- Test Framework: Playwright, Jest
- CI/CD: GitHub Actions
- Bug Tracking: GitHub Issues
- Test Management: TestRail (optional)
- Performance: Lighthouse, k6
- Security: OWASP ZAP, Snyk
- Accessibility: axe DevTools

## 11. Risks & Mitigation

**Risk**: OAuth provider downtime during testing
**Mitigation**: Mock OAuth responses, test against staging OAuth

**Risk**: Insufficient test data
**Mitigation**: Automated test data generation scripts

**Risk**: Environment instability
**Mitigation**: Dedicated test environment, infrastructure monitoring

## 12. Success Criteria

- ✓ All critical user journeys working
- ✓ No P0/P1 bugs remaining
- ✓ Security scan passed (no high vulnerabilities)
- ✓ Performance targets met (login < 2s)
- ✓ Accessibility WCAG AA compliant
- ✓ Test coverage > 80%
- ✓ Release approved by QA Lead & Product Manager

---

**Approval**:
- QA Lead: _________________ Date: _______
- Engineering Manager: _________________ Date: _______
- Product Manager: _________________ Date: _______
```

## Test Plan Best Practices

**1. Align with Requirements:**
- Every requirement should have tests
- Traceability matrix
- Cover acceptance criteria

**2. Risk-Based Prioritization:**
- Test high-risk areas thoroughly
- Allocate time based on impact
- Critical path focus

**3. Clear and Measurable:**
- Specific test objectives
- Quantifiable success criteria
- Defined timelines

**4. Stakeholder Communication:**
- Regular status updates
- Clear reporting format
- Transparent about risks

**5. Adaptability:**
- Adjust based on findings
- Re-prioritize as needed
- Document changes
