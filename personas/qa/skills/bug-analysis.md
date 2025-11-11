---
name: bug-analysis
description: Systematic root cause analysis, reproduction steps generation, and severity assessment for bugs. Use when user reports a bug, asks to investigate an issue, wants to understand why something failed, or needs detailed bug report.
---

# Bug Analysis Skill

Perform systematic root cause analysis, generate clear reproduction steps, assess severity, and provide comprehensive bug reports with recommended fixes.

## When to Use This Skill

Automatically invoke when the user:
- Reports a bug or unexpected behavior
- Asks "why is this failing" or "what's causing this error"
- Requests help investigating an issue
- Wants to create a detailed bug report
- Asks to analyze test failures
- Mentions "not working" or "broken"

## Bug Analysis Process

### 1. Information Gathering

#### Symptoms
- **What is the unexpected behavior?**
- **What was the expected behavior?**
- **When did this start happening?**
- **How often does it occur?** (Always, Sometimes, Rarely)
- **Which environments are affected?** (Dev, Staging, Production)

#### Context
- **Steps to reproduce** (exact sequence of actions)
- **Browser/Device** (Chrome 120, iPhone 14, etc.)
- **User role** (Admin, User, Guest)
- **Data involved** (specific IDs, values)
- **Error messages** (exact text, stack traces)

### 2. Root Cause Analysis (5 Whys)

```
Problem: Users cannot log in

Why? → Authentication API returns 500 error
Why? → Database connection pool exhausted
Why? → Too many concurrent connections
Why? → Connection pool size set to 10 (too small)
Why? → Default configuration was never tuned for production load

Root Cause: Connection pool size misconfigured
```

### 3. Severity Assessment

#### P0 - Critical (Fix Immediately)
- **Production down** or major functionality broken
- **Data loss** or corruption risk
- **Security vulnerability** exposed
- **Affects all/most users**
- **No workaround available**

#### P1 - High (Fix Within 24 Hours)
- **Core feature broken** for subset of users
- **Significant user impact**
- **Workaround exists but difficult**
- **Revenue impact**

#### P2 - Medium (Fix Within 1 Week)
- **Minor feature broken**
- **Moderate user impact**
- **Easy workaround available**
- **Affects small user segment**

#### P3 - Low (Fix When Possible)
- **Cosmetic issues**
- **Edge case scenarios**
- **Minimal user impact**
- **Nice-to-have fixes**

### 4. Impact Analysis

- **User Impact**: How many users affected?
- **Business Impact**: Revenue, reputation, compliance?
- **Technical Impact**: Performance, security, data integrity?
- **Workaround**: Is there a temporary solution?

## Output Format

```
🐛 BUG ANALYSIS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏷️  Bug ID: BUG-1234
📋 Title: Users Cannot Log In After Password Reset
🔴 Severity: P0 - Critical
📅 Reported: 2025-01-15 14:23 UTC
👤 Reported By: Jane Doe
🌍 Environment: Production

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 DESCRIPTION
───────────────────────────────────

After resetting password via email link, users are redirected
to login page but receive "Invalid credentials" error even when
using the new password they just set.

Expected: Users can log in with new password
Actual: Login fails with "Invalid credentials" error

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 REPRODUCTION STEPS
───────────────────────────────────

1. Go to login page
2. Click "Forgot Password"
3. Enter email: test@example.com
4. Check email and click reset link
5. Enter new password: "NewSecurePass123!"
6. Confirm new password: "NewSecurePass123!"
7. Click "Reset Password"
8. Redirected to login page
9. Enter email: test@example.com
10. Enter password: "NewSecurePass123!"
11. Click "Log In"

Result: Error message "Invalid credentials"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 ROOT CAUSE ANALYSIS
───────────────────────────────────

Problem: Login fails after password reset

Why? → New password not being accepted
  ↓
Why? → Password hash in database doesn't match
  ↓
Why? → Password reset transaction not committing
  ↓
Why? → Missing .commit() call in password reset handler
  ↓
Why? → Recent refactoring removed explicit commit

Root Cause: Password reset endpoint missing database commit

File: src/api/auth/password-reset.ts:45
Missing: await db.commit()

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 IMPACT ASSESSMENT
───────────────────────────────────

User Impact:
  • Affected Users: ~500/day attempting password reset
  • Success Rate: 0% (complete failure)
  • Workaround: Admin must manually reset passwords

Business Impact:
  • Customer Support: +50 tickets/hour
  • User Satisfaction: Severe negative impact
  • Revenue: Users cannot access accounts to transact

Technical Impact:
  • Security: No security risk (authentication still secure)
  • Data: No data loss (passwords not being saved)
  • Performance: No performance impact

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 RECOMMENDED FIX
───────────────────────────────────

**Immediate Fix** (5 minutes):

```typescript
// File: src/api/auth/password-reset.ts

export async function resetPassword(req: Request, res: Response) {
  const { token, newPassword } = req.body;

  // Verify reset token
  const user = await verifyResetToken(token);
  if (!user) {
    return res.status(400).json({ error: 'Invalid or expired token' });
  }

  // Hash new password
  const hashedPassword = await bcrypt.hash(newPassword, 10);

  // Update password
  await db.users.update({
    where: { id: user.id },
    data: { passwordHash: hashedPassword }
  });

  // ✓ ADD THIS LINE - Commit transaction
  await db.commit();  // <-- MISSING LINE

  // Invalidate reset token
  await db.resetTokens.delete({ where: { token } });
  await db.commit();  // Also commit token deletion

  return res.json({ message: 'Password reset successful' });
}
```

**Long-term Fix**:
- Use ORM transactions properly (auto-commit)
- Add integration test for password reset flow
- Add monitoring/alerts for failed password resets

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ VERIFICATION STEPS
───────────────────────────────────

After fix is deployed:

1. ✓ Request password reset email
2. ✓ Click reset link
3. ✓ Set new password
4. ✓ Attempt login with new password
5. ✓ Verify successful login
6. ✓ Verify old password no longer works
7. ✓ Check database: password hash updated
8. ✓ Check logs: no errors
9. ✓ Test with multiple users
10. ✓ Verify reset token invalidated after use

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧪 REGRESSION TEST
───────────────────────────────────

```typescript
describe('Password Reset Flow', () => {
  it('should allow login with new password after reset', async () => {
    // Arrange
    const user = await createTestUser();
    const resetToken = await generateResetToken(user.email);

    // Act - Reset password
    const response = await api.post('/auth/password-reset', {
      token: resetToken,
      newPassword: 'NewSecurePass123!'
    });

    // Assert - Reset successful
    expect(response.status).toBe(200);

    // Act - Login with new password
    const loginResponse = await api.post('/auth/login', {
      email: user.email,
      password: 'NewSecurePass123!'
    });

    // Assert - Login successful
    expect(loginResponse.status).toBe(200);
    expect(loginResponse.body).toHaveProperty('token');

    // Assert - Old password no longer works
    const oldLoginAttempt = await api.post('/auth/login', {
      email: user.email,
      password: user.oldPassword
    });
    expect(oldLoginAttempt.status).toBe(401);
  });
});
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔗 RELATED ISSUES
───────────────────────────────────

• BUG-1189: Similar issue with email verification
• BUG-1203: Transaction handling inconsistent
• TASK-456: Refactor auth endpoints (introduced this bug)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📎 ATTACHMENTS
───────────────────────────────────

• Error logs: error-logs-2025-01-15.txt
• Network trace: har-file.har
• Screenshot: login-error-screenshot.png
• Database query: failed-password-updates.sql

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Investigation Techniques

### Log Analysis
```bash
# Search for errors around time of issue
grep "password reset" /var/log/app.log | grep "2025-01-15 14:"

# Find stack traces
grep -A 20 "Error" /var/log/app.log

# Check database query logs
tail -f /var/log/postgresql/queries.log | grep "UPDATE users"
```

### Database Investigation
```sql
-- Check if password was updated
SELECT id, email, passwordHash, updatedAt
FROM users
WHERE email = 'test@example.com'
ORDER BY updatedAt DESC
LIMIT 1;

-- Check reset token status
SELECT * FROM resetTokens
WHERE userId = (SELECT id FROM users WHERE email = 'test@example.com')
ORDER BY createdAt DESC;

-- Check authentication attempts
SELECT * FROM authLogs
WHERE userId = (SELECT id FROM users WHERE email = 'test@example.com')
ORDER BY timestamp DESC
LIMIT 10;
```

### Network Analysis
```bash
# Capture network traffic
# Check if API call completed
curl -X POST http://api.example.com/auth/password-reset \
  -H "Content-Type: application/json" \
  -d '{"token":"abc123","newPassword":"NewPass123!"}' \
  -v

# Check response headers
# Look for 200 OK vs error status
```

## Common Bug Patterns

### Race Conditions
```javascript
// Problem: Race condition in concurrent updates
let counter = 0;
function increment() {
  const current = counter;  // Read
  // Another thread might run here
  counter = current + 1;     // Write
}

// Solution: Use atomic operations
function increment() {
  return db.counters.increment({ where: { id: 1 } });
}
```

### Null Pointer / Undefined
```typescript
// Problem: Assuming value exists
function getUser Name(userId: string) {
  const user = users.find(u => u.id === userId);
  return user.name;  // Error if user is undefined
}

// Solution: Check for existence
function getUserName(userId: string) {
  const user = users.find(u => u.id === userId);
  return user?.name ?? 'Unknown User';
}
```

### Off-by-One Errors
```python
# Problem: Missing last element
for i in range(len(items) - 1):  # Oops! Misses last item
    process(items[i])

# Solution: Correct range
for i in range(len(items)):
    process(items[i])
# Or better
for item in items:
    process(item)
```

## Best Practices

1. **Reproduce First**: Always reproduce the bug before investigating
2. **Isolate**: Narrow down to specific component/function
3. **5 Whys**: Keep asking "why" to find root cause
4. **Document**: Write clear reproduction steps
5. **Test Fix**: Verify fix resolves issue
6. **Prevent Regression**: Add automated test
7. **Learn**: Identify how to prevent similar bugs

---

**Remember**: A good bug report saves hours of investigation time and prevents the bug from reoccurring.
