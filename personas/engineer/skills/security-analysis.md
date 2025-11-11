---
name: security-analysis
description: Comprehensive security vulnerability analysis covering OWASP Top 10, dependency vulnerabilities, and security best practices. Use when user requests security review, asks to check for vulnerabilities, wants security scan, or mentions security concerns.
---

# Security Analysis Skill

Perform comprehensive security analysis identifying OWASP Top 10 vulnerabilities, insecure dependencies, and security best practices violations with prioritized remediation steps.

## When to Use This Skill

Automatically invoke when the user:
- Requests security analysis or security review
- Asks "check for security vulnerabilities"
- Wants to scan for OWASP Top 10 issues
- Mentions "security audit" or "penetration testing"
- Asks about dependency vulnerabilities
- Requests security best practices review

## OWASP Top 10 Security Checks

### 1. Broken Access Control
**Check for:**
- Missing authorization checks
- Insecure Direct Object References (IDOR)
- Privilege escalation vulnerabilities
- CORS misconfiguration

```typescript
// ❌ VULNERABLE: No authorization check
app.get('/api/user/:id', async (req, res) => {
  const user = await db.users.findById(req.params.id);
  return res.json(user);  // Any user can access any other user's data
});

// ✅ SECURE: Authorization enforced
app.get('/api/user/:id', authenticate, async (req, res) => {
  const requestedId = req.params.id;
  const currentUserId = req.user.id;

  // Check authorization
  if (requestedId !== currentUserId && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const user = await db.users.findById(requestedId);
  return res.json(user);
});
```

### 2. Cryptographic Failures
**Check for:**
- Weak encryption algorithms
- Hardcoded secrets
- Plain-text sensitive data
- Insecure password storage

```python
# ❌ VULNERABLE: Plain-text password
user.password = request.form['password']
db.session.commit()

# ✅ SECURE: Hashed password with bcrypt
from werkzeug.security import generate_password_hash

user.password_hash = generate_password_hash(
    request.form['password'],
    method='bcrypt',
    salt_length=16
)
db.session.commit()
```

### 3. Injection Vulnerabilities
**Check for:**
- SQL injection
- NoSQL injection
- Command injection
- LDAP injection

```java
// ❌ VULNERABLE: SQL injection
String query = "SELECT * FROM users WHERE email = '" + userInput + "'";
Statement stmt = connection.createStatement();
ResultSet rs = stmt.executeQuery(query);

// ✅ SECURE: Parameterized query
String query = "SELECT * FROM users WHERE email = ?";
PreparedStatement pstmt = connection.prepareStatement(query);
pstmt.setString(1, userInput);
ResultSet rs = pstmt.executeQuery();
```

### 4. Security Misconfiguration
**Check for:**
- Default credentials
- Unnecessary features enabled
- Missing security headers
- Verbose error messages
- Directory listing enabled

```typescript
// ❌ VULNERABLE: Verbose error in production
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,
    stack: err.stack  // Exposes internal details
  });
});

// ✅ SECURE: Generic error message
app.use((err, req, res, next) => {
  logger.error(err);  // Log detailed error server-side
  res.status(500).json({
    error: 'Internal server error'  // Generic message to user
  });
});
```

### 5. Vulnerable Dependencies
**Check for:**
- Outdated packages with known vulnerabilities
- Unmaintained dependencies
- Missing security patches

```bash
# Run dependency audit
npm audit
pip-audit
snyk test

# Fix vulnerabilities
npm audit fix
pip install --upgrade package-name
```

## Output Format

```
🔒 SECURITY ANALYSIS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Security Score: 65/100 (Needs Improvement)
🔴 Critical: 2 issues
🟠 High: 5 issues
🟡 Medium: 8 issues
🟢 Low: 3 issues

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 CRITICAL VULNERABILITIES (Fix Immediately)

[1] SQL Injection in User Search
  • OWASP: A03:2021 - Injection
  • File: src/api/users/search.ts:23
  • Severity: Critical (CVSS 9.8)

  Vulnerable Code:
  ```typescript
  const query = `SELECT * FROM users WHERE name LIKE '%${searchTerm}%'`;
  const results = await db.raw(query);
  ```

  Attack Vector:
  ```
  searchTerm = "'; DROP TABLE users; --"
  Result: Deletes entire users table
  ```

  Remediation:
  ```typescript
  const query = 'SELECT * FROM users WHERE name LIKE ?';
  const results = await db.raw(query, [`%${searchTerm}%`]);
  ```

  Impact: Complete database compromise possible
  Fix Priority: IMMEDIATE
  Estimated Fix Time: 5 minutes

[2] Hardcoded AWS Credentials
  • OWASP: A02:2021 - Cryptographic Failures
  • File: src/config/aws.ts:7
  • Severity: Critical (CVSS 9.1)

  Vulnerable Code:
  ```typescript
  const AWS_ACCESS_KEY = 'AKIA...';  // Hardcoded in source
  const AWS_SECRET_KEY = 'wJalr...';  // Hardcoded in source
  ```

  Impact: Full AWS account access, potential data breach
  Remediation:
  ```typescript
  const AWS_ACCESS_KEY = process.env.AWS_ACCESS_KEY_ID;
  const AWS_SECRET_KEY = process.env.AWS_SECRET_ACCESS_KEY;

  if (!AWS_ACCESS_KEY || !AWS_SECRET_KEY) {
    throw new Error('AWS credentials not configured');
  }
  ```

  Additional Actions:
  1. Rotate compromised credentials immediately
  2. Remove from version control history
  3. Enable AWS CloudTrail for audit logging

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟠 HIGH SEVERITY ISSUES

[3] Missing Rate Limiting on Login Endpoint
  • OWASP: A07:2021 - Identification and Authentication Failures
  • File: src/api/auth/login.ts:15
  • Severity: High (CVSS 7.5)

  Issue: No rate limiting allows brute force attacks

  Remediation:
  ```typescript
  import rateLimit from 'express-rate-limit';

  const loginLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,  // 15 minutes
    max: 5,  // 5 attempts
    message: 'Too many login attempts, please try again later'
  });

  app.post('/api/auth/login', loginLimiter, loginHandler);
  ```

[4-7] [Additional high severity issues...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 DEPENDENCY VULNERABILITIES

Critical: 1
  • jsonwebtoken@8.5.1: Signature validation bypass (CVE-2022-23529)
    Fix: npm install jsonwebtoken@9.0.0

High: 3
  • axios@0.21.1: Server-Side Request Forgery (CVE-2021-3749)
  • lodash@4.17.20: Prototype pollution (CVE-2021-23337)
  • ws@7.4.5: ReDoS vulnerability (CVE-2021-32640)

Medium: 5
  [List of medium severity dependency issues...]

Action: Run `npm audit fix` to auto-update compatible versions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🛡️ SECURITY HEADERS ANALYSIS

Missing Headers:
  ❌ Content-Security-Policy
  ❌ X-Frame-Options
  ❌ Strict-Transport-Security
  ✓ X-Content-Type-Options (present)
  ❌ Permissions-Policy

Recommendation:
```typescript
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  frameguard: { action: 'deny' },
  xssFilter: true
}));
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔑 AUTHENTICATION & AUTHORIZATION

✓ Password hashing with bcrypt
❌ No multi-factor authentication (MFA)
❌ JWT tokens never expire (set expiration)
❌ No refresh token rotation
✓ HTTPS enforced

Recommendations:
1. Implement MFA (TOTP or SMS)
2. Set JWT expiration: 15 minutes (access), 7 days (refresh)
3. Implement token rotation on refresh
4. Add account lockout after failed attempts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 SECURITY CHECKLIST

Authentication:
  ✓ Passwords hashed (bcrypt)
  ❌ MFA not implemented
  ❌ Session timeout too long (24 hours → should be 30 min)
  ✓ Account lockout after 5 failed attempts

Authorization:
  ❌ Missing authorization checks (12 endpoints)
  ✓ Role-based access control implemented
  ❌ Insecure direct object references (IDOR) found

Input Validation:
  ❌ SQL injection vulnerabilities (3 instances)
  ❌ XSS vulnerabilities (5 instances)
  ✓ CSRF protection enabled
  ❌ Missing input sanitization (8 endpoints)

Data Protection:
  ✓ HTTPS enforced
  ❌ PII not encrypted at rest
  ✓ Database connections encrypted (TLS 1.3)
  ❌ Sensitive data in logs

Security Headers:
  ❌ CSP not configured
  ❌ HSTS not configured
  ✓ X-Content-Type-Options present
  ❌ X-Frame-Options missing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 REMEDIATION ROADMAP

Week 1 (Critical):
  • Fix SQL injection vulnerabilities
  • Rotate hardcoded AWS credentials
  • Add rate limiting to authentication endpoints
  • Update vulnerable dependencies (critical severity)

Week 2 (High):
  • Implement security headers (CSP, HSTS)
  • Add authorization checks to unprotected endpoints
  • Implement MFA
  • Fix XSS vulnerabilities

Week 3 (Medium):
  • Encrypt PII at rest
  • Implement JWT expiration and rotation
  • Add input sanitization
  • Remove sensitive data from logs

Estimated Total Effort: 120 hours
Expected Security Score After: 90/100

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Security Testing Tools

- **SAST**: SonarQube, Semgrep, Checkmarx
- **DAST**: OWASP ZAP, Burp Suite
- **Dependency Scanning**: Snyk, npm audit, Dependabot
- **Secret Scanning**: GitGuardian, TruffleHog

---

**Remember**: Security is not a one-time check - integrate security scanning into CI/CD and perform regular audits.
