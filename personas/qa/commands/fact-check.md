# Command: Fact-Check

## Purpose
Verify specific claims or statements against the codebase, documentation, and tests. Use when you need to validate a particular assertion without checking an entire response.

## Usage
```bash
/fact-check [claim or statement]
```

## What This Command Does

1. Accepts a specific claim to verify
2. Searches codebase for evidence
3. Checks tests and documentation
4. Provides confidence score with sources
5. Returns correction if claim is inaccurate

---

## Command Syntax

### Basic Usage
```bash
/fact-check The authentication uses JWT tokens
```

### Multiple Claims
```bash
/fact-check The API rate limit is 100 req/min AND uses Redis for storage
```

### File-Specific Claims
```bash
/fact-check src/auth/login.ts exports a validateUser function
```

### Behavior Claims
```bash
/fact-check The system retries failed requests 3 times before giving up
```

---

## Verification Process

### Step 1: Parse Claim (2-5 seconds)
Extract verifiable components:
- File paths
- Function/class/variable names
- Numeric values (limits, thresholds, counts)
- Behavior descriptions
- Technology mentions (Redis, JWT, etc.)

### Step 2: Search Evidence (15-30 seconds)
- **Code search**: Grep for relevant patterns
- **File checks**: Read specific files/lines
- **Test search**: Look for related test cases
- **Documentation**: Check README, comments

### Step 3: Evaluate Evidence (5-10 seconds)
- Match claim against findings
- Determine confidence level
- Identify discrepancies

### Step 4: Report (5-10 seconds)
- State verification result
- Cite sources (file:line)
- Provide corrections if needed

**Total Time: 30-60 seconds**

---

## Output Format

```markdown
🔎 FACT-CHECK RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claim: "The authentication uses JWT tokens"

Status: 🟢 VERIFIED

Evidence:
───────────────────────────────────
✓ src/auth/tokenService.ts:12
  → import jwt from 'jsonwebtoken'

✓ src/auth/tokenService.ts:34
  → const token = jwt.sign({ userId: user.id }, SECRET)

✓ tests/auth/tokenService.test.ts:45
  → describe('JWT Token Generation', () => { ... })

Confidence: 🟢 HIGH (100%)
Multiple sources confirm JWT token usage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Verification Strategies by Claim Type

### 1. File Location Claims
**Example:** "Database config is in config/database.ts"

**Verification:**
```bash
1. Glob: config/**/*.ts
2. Read: config/database.ts (check if exists)
3. Verify: Contains database configuration
```

---

### 2. Function/Class Existence Claims
**Example:** "There's a validateEmail function in utils"

**Verification:**
```bash
1. Grep: "function validateEmail|const validateEmail|validateEmail ="
2. Read: Found file to verify signature
3. Search tests: Check for test coverage
```

---

### 3. Numeric Value Claims
**Example:** "Rate limit is set to 100 requests per minute"

**Verification:**
```bash
1. Grep: "rateLimit|rate_limit|100"
2. Read: Configuration file
3. Verify: Exact value matches
```

---

### 4. Technology/Library Claims
**Example:** "The system uses Redis for caching"

**Verification:**
```bash
1. Grep: "redis|Redis" in codebase
2. Check: package.json for redis dependency
3. Read: Configuration or service files
4. Verify: Redis client initialization
```

---

### 5. Behavior Claims
**Example:** "Failed requests are retried 3 times"

**Verification:**
```bash
1. Grep: "retry|retries|MAX_RETRIES"
2. Read: HTTP client or service code
3. Check: Retry logic implementation
4. Search tests: Verify retry behavior tested
```

---

## Examples

### Example 1: Simple File Claim

**Command:**
```bash
/fact-check The user model is in src/models/User.ts
```

**Output:**
```
🔎 FACT-CHECK RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claim: "The user model is in src/models/User.ts"

Status: 🟢 VERIFIED

Evidence:
✓ File exists: src/models/User.ts
✓ Contains User class definition (line 12)
✓ Exports User model (line 89)

Confidence: 🟢 HIGH (100%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Example 2: Incorrect Numeric Claim

**Command:**
```bash
/fact-check The API timeout is set to 30 seconds
```

**Output:**
```
🔎 FACT-CHECK RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claim: "The API timeout is set to 30 seconds"

Status: 🔴 INCORRECT

Evidence:
✗ config/api.ts:45
  → timeout: 5000 // 5 seconds, not 30

Correction:
The API timeout is actually set to 5 seconds (5000ms),
not 30 seconds as claimed.

Source: config/api.ts:45

Confidence: 🟢 HIGH (100%)
Direct configuration value found
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Example 3: Multiple Component Claim

**Command:**
```bash
/fact-check The system uses bcrypt for password hashing with 12 rounds
```

**Output:**
```
🔎 FACT-CHECK RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claim: "The system uses bcrypt for password hashing with 12 rounds"

Status: 🟡 PARTIALLY CORRECT

Evidence:
✓ Uses bcrypt: VERIFIED
  → src/auth/password.ts:5
  → import bcrypt from 'bcrypt'

✗ Round count: INCORRECT
  → src/auth/password.ts:23
  → const hash = await bcrypt.hash(password, 10)

Correction:
The system uses bcrypt (CORRECT) but with 10 rounds,
not 12 as claimed.

Confidence: 🟢 HIGH (100%)
Direct code inspection confirms partial accuracy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Example 4: Cannot Verify

**Command:**
```bash
/fact-check The production database has 1 million user records
```

**Output:**
```
🔎 FACT-CHECK RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claim: "The production database has 1 million user records"

Status: 🟡 CANNOT VERIFY

Reason:
This claim requires access to production database metrics,
which are not available in the codebase.

What I can verify:
✓ User model exists: src/models/User.ts
✓ Database configured: config/database.ts
✗ Actual record count: Requires database query

To verify this claim:
- Run: SELECT COUNT(*) FROM users;
- Check: Production monitoring dashboard
- Review: Analytics reports

Confidence: N/A (Unable to verify from code)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Advanced Usage

### Check Multiple Claims
```bash
/fact-check "Rate limit: 100 req/min" AND "Uses Redis" AND "Timeout: 30s"
```

**Output shows verification for each claim separately**

---

### Check Against Specific File
```bash
/fact-check --file=src/auth/login.ts The function uses async/await
```

**Limits search to specified file**

---

### Quick Check (Skip Tests)
```bash
/fact-check --quick Redis is used for session storage
```

**Faster but less comprehensive (15-20 seconds)**

---

### Deep Check (Invoke Subagent)
```bash
/fact-check --deep The authentication flow is stateless
```

**Invokes Cross-Check subagent for complex verification**

---

## When to Use /fact-check vs /verify-response

| Use /fact-check | Use /verify-response |
|-----------------|----------------------|
| Verify single specific claim | Verify entire response |
| Check a statement you heard | Check Claude's last answer |
| Validate external information | Validate Claude's claims |
| Quick spot-check | Comprehensive verification |
| Example: "Is Redis used?" | Example: After technical explanation |

---

## Integration with Fact-Check Skill

This command automatically invokes the **fact-check skill** but focuses on a single claim instead of an entire response.

**Workflow:**
1. User provides specific claim
2. Command invokes fact-check skill
3. Skill focuses verification on that claim only
4. Returns targeted result

---

## Common Use Cases

### 1. Verify Documentation
```bash
/fact-check The setup requires Node.js 18 or higher
```

### 2. Check Configuration
```bash
/fact-check CORS is enabled for all origins
```

### 3. Validate Dependencies
```bash
/fact-check The project uses Express.js 4.x
```

### 4. Confirm Behavior
```bash
/fact-check Errors are logged to CloudWatch
```

### 5. Verify Standards
```bash
/fact-check The API follows REST conventions
```

---

## Limitations

**Cannot verify:**
- Claims about running systems (need monitoring data)
- Performance claims without benchmarks
- User behavior or analytics (need actual data)
- Future plans or roadmap items
- Subjective quality assessments

**For these, consider:**
- Monitoring tools for runtime data
- Performance profiling for speed claims
- Analytics dashboards for user behavior
- Project documentation for roadmaps

---

## Success Criteria

This command is successful when:
- ✅ Completes in 30-60 seconds
- ✅ Provides clear VERIFIED/INCORRECT/CANNOT VERIFY status
- ✅ Cites specific file:line sources
- ✅ Gives actionable corrections when wrong
- ✅ Helps users make informed decisions

---

## Tips

💡 **Best practices:**
- Be specific in your claim
- Include context when helpful
- Check one main assertion at a time
- Use --deep for complex architectural claims

💡 **Avoid:**
- Overly vague claims ("the code is good")
- Non-verifiable opinions
- Claims requiring external data you don't have access to

---

**This command gives you confidence in specific technical claims with evidence-based verification.**
