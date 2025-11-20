---
name: fact-check
description: Quick verification of Claude's responses for accuracy by cross-checking claims against codebase, documentation, and test results. Use when user asks to verify, validate, or fact-check information provided.
---

# Fact-Check Skill

Verify the accuracy of Claude's responses by cross-referencing claims with actual code, documentation, and running quick validation tests. Provide confidence scores and citations for all verified information.

## When to Use This Skill

Automatically invoke when the user:
- Asks "is this correct?" or "are you sure?"
- Says "verify this" or "validate this"
- Requests "fact-check" or "double-check"
- Questions "can you confirm" or "is that accurate?"
- Expresses doubt: "I'm not sure if that's right"
- Asks "check this" or "verify that"

## Fact-Checking Process

### 1. Claim Identification (5-10 seconds)

Identify all factual claims in the response that need verification:

**Code-related claims:**
- File paths and locations
- Function names and signatures
- Variable names and types
- API endpoints and routes
- Configuration values
- Dependencies and versions

**Behavior claims:**
- "This function does X"
- "The code handles Y"
- "Tests validate Z"
- "The system supports W"

**Architectural claims:**
- Component relationships
- Data flow patterns
- Integration points
- Design patterns used

### 2. Quick Verification (20-40 seconds)

For each claim, perform rapid verification:

#### Code Verification
```bash
# Search for referenced code
Grep: Search for function/class/variable names
Read: Verify implementation details
Glob: Confirm file existence and location
```

#### Documentation Verification
```bash
# Check documentation matches claims
Read: README, API docs, comments
Grep: Search for mentioned features
```

#### Test Verification (Optional)
```bash
# If claim is about behavior, check tests
Grep: Search for related test cases
Read: Verify test assertions
```

### 3. Confidence Scoring

**🟢 HIGH CONFIDENCE (Verified)**
- Direct code match found
- Tests confirm behavior
- Documentation aligns
- Multiple sources agree

**🟡 MEDIUM CONFIDENCE (Likely Correct)**
- Code found but slightly different
- Partial documentation match
- Logical inference supported
- One clear source

**🔴 LOW CONFIDENCE (Unverified/Incorrect)**
- No code match found
- Contradicts documentation
- Tests suggest different behavior
- Cannot verify claim

### 4. Output Format

Present verification results inline with original response:

```
✓ FACT-CHECK RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Original Response Verification:
───────────────────────────────────

Claim 1: "The authenticate() function is in src/auth/login.ts"
Status: 🟢 VERIFIED
Source: src/auth/login.ts:45-67
Evidence: Function signature matches exactly
  → export async function authenticate(email: string, password: string)

Claim 2: "The function returns a JWT token"
Status: 🟢 VERIFIED
Source: src/auth/login.ts:65
Evidence: return { token: jwt.sign({ userId: user.id }, SECRET) }

Claim 3: "Password hashing uses bcrypt with 12 rounds"
Status: 🔴 INCORRECT
Source: src/auth/login.ts:52
Evidence: Actually uses 10 rounds, not 12
  → const hash = await bcrypt.hash(password, 10)
Correction: The code uses bcrypt.hash() with 10 rounds by default

Claim 4: "There are unit tests for authentication"
Status: 🟢 VERIFIED
Source: tests/auth/login.test.ts:15-89
Evidence: 8 test cases covering happy path, invalid credentials, expired tokens

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 VERIFICATION SUMMARY
───────────────────────────────────

Total Claims: 4
✓ Verified: 3 (75%)
⚠ Partially Verified: 0 (0%)
✗ Incorrect: 1 (25%)

Overall Confidence: 🟢 HIGH (75% verified)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 CORRECTED RESPONSE

Here's the updated response with corrections:

[Provide corrected version with inline citations]

The authenticate() function is in src/auth/login.ts:45 and returns
a JWT token (line 65). Password hashing uses bcrypt with 10 rounds
(line 52), not 12 as initially stated. There are comprehensive unit
tests covering 8 scenarios in tests/auth/login.test.ts.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Verification Strategies

### Strategy 1: Direct Code Lookup
**Use when:** Claims about specific files, functions, or code locations

```
1. Use Grep to search for function/class name
2. Use Read to verify implementation
3. Check line numbers and signatures
4. Cite exact file:line references
```

### Strategy 2: Pattern Matching
**Use when:** Claims about general code patterns or conventions

```
1. Use Grep with regex patterns
2. Search across multiple files
3. Count occurrences
4. Identify patterns vs exceptions
```

### Strategy 3: Test Evidence
**Use when:** Claims about behavior or functionality

```
1. Search for test files (Glob: **/*.test.ts)
2. Find relevant test cases (Grep)
3. Read test assertions
4. Verify claimed behavior is tested
```

### Strategy 4: Documentation Cross-Check
**Use when:** Claims about design decisions or architecture

```
1. Check README, ARCHITECTURE.md
2. Search code comments
3. Review API documentation
4. Verify consistency
```

## Common Verification Patterns

### Verifying File Locations
```markdown
Claim: "Configuration is in config/database.js"

Verification Steps:
1. Glob: config/**/*.js
2. Read: Check if database.js exists
3. Verify: Contains database configuration

Result: 🟢 VERIFIED - config/database.js:1-45
```

### Verifying Function Behavior
```markdown
Claim: "The validateEmail() function checks for @ symbol"

Verification Steps:
1. Grep: "validateEmail" in codebase
2. Read: src/utils/validation.ts:34-42
3. Check implementation:
   - return email.includes('@') && email.includes('.')
4. Search tests: Grep "validateEmail" in tests/

Result: 🟢 VERIFIED - src/utils/validation.ts:36
Additional: Tests confirm @ and . validation (tests/validation.test.ts:45-67)
```

### Verifying Configuration Values
```markdown
Claim: "Rate limiting is set to 100 requests per minute"

Verification Steps:
1. Grep: "rate" or "rateLimit" or "100"
2. Read: config/api.ts or .env files
3. Check actual value

Result: 🔴 INCORRECT
Evidence: config/api.ts:23 shows rateLimit: 50
Correction: Rate limiting is set to 50 requests per minute, not 100
```

## Quick Reference: Verification Tools

| Claim Type | Tool | Example |
|------------|------|---------|
| File exists | Glob | `Glob: src/auth/*.ts` |
| Function signature | Grep + Read | `Grep: "function authenticate"` |
| Variable value | Grep + Read | `Grep: "const MAX_RETRIES"` |
| API endpoint | Grep | `Grep: "app.post\|app.get"` |
| Test exists | Glob + Grep | `Glob: **/*.test.ts` then `Grep: "describe.*Auth"` |
| Documentation | Read | `Read: README.md` or `Read: docs/**` |
| Config value | Read | `Read: config/*.ts` or `Read: .env*` |

## Escalation to Cross-Check Subagent

For complex claims requiring deep analysis, invoke the Cross-Check subagent:

**Escalate when:**
- Claims involve multiple interacting components
- Need to trace execution flow
- Requires understanding of complex algorithms
- Need to validate architectural decisions
- Claims about performance characteristics
- Security-related claims needing thorough audit

**How to escalate:**
```markdown
This claim requires deeper analysis. Invoking Cross-Check subagent for
comprehensive verification of [specific claim].
```

Then provide context to subagent:
- Original claim to verify
- Files and components involved
- Specific concerns or edge cases
- What you've verified so far

## Best Practices

1. **Be Specific**: Cite exact file:line references
2. **Be Honest**: If you can't verify, say so (MEDIUM/LOW confidence)
3. **Be Fast**: Focus on quick checks (30-60 seconds total)
4. **Be Thorough**: Check multiple sources when possible
5. **Be Clear**: Use confidence indicators (🟢🟡🔴)
6. **Be Helpful**: Provide corrections, not just "wrong"
7. **Be Transparent**: Show your verification process

## Time Budget Guidelines

⏱️ **Total time: 30-60 seconds**

- Claim identification: 5-10 seconds
- Verification (per claim): 5-10 seconds
  - Simple code lookup: 5 seconds
  - Pattern matching: 10 seconds
  - Test verification: 10 seconds
- Output formatting: 10 seconds

**Speed tips:**
- Use Grep for fast searches (faster than Read for finding)
- Limit Read to relevant line ranges
- Skip obvious claims (e.g., "JavaScript is a programming language")
- Focus on verifiable technical claims
- For complex verification, escalate to subagent instead of spending 2+ minutes

## Examples

### Example 1: Quick File Verification

**User Response to Check:**
"The user authentication logic is in src/auth/authenticate.ts and uses JWT tokens."

**Fact-Check Process:**
```
1. Grep: "authenticate" in src/auth/
   → Found: src/auth/authenticate.ts ✓

2. Read: src/auth/authenticate.ts (lines 1-100)
   → Imports jsonwebtoken ✓
   → Exports authenticate function ✓
   → Returns JWT token at line 67 ✓

Result: 🟢 VERIFIED (100%)
- File location: CORRECT
- JWT usage: CONFIRMED at line 67
```

### Example 2: Correction Needed

**User Response to Check:**
"The API has a POST endpoint at /api/v1/login that accepts email and password."

**Fact-Check Process:**
```
1. Grep: "/api/v1/login" or "app.post.*login"
   → Found: src/routes/auth.ts:34

2. Read: src/routes/auth.ts:34-45
   → Endpoint is /api/v2/login (not v1!) ✗
   → Does accept email and password ✓

Result: 🔴 PARTIALLY INCORRECT
- Endpoint: WRONG - Should be /api/v2/login
- Parameters: CORRECT - Accepts email and password
```

### Example 3: Cannot Verify

**User Response to Check:**
"The system can handle 10,000 concurrent users based on our load testing."

**Fact-Check Process:**
```
1. Grep: "load test" or "10000" or "concurrent"
   → No load test results found in codebase

2. Check for documentation
   → No performance documentation found

3. Check for monitoring/metrics code
   → Found monitoring, but no load test data

Result: 🟡 CANNOT VERIFY
- No load test results in codebase
- Cannot confirm 10,000 concurrent user claim
- Would need access to test infrastructure or reports
- Claim may be correct but unverifiable from code alone
```

---

**Remember**: The goal is **quick accuracy verification**, not comprehensive code review. If verification requires >60 seconds, escalate to Cross-Check subagent.
