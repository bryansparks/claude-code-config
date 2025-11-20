# Command: Verify Response

## Purpose
Quick fact-checking of Claude's last response by cross-referencing claims with actual code, tests, and documentation.

## Usage
```bash
/verify-response
```

## What This Command Does

1. Analyzes the last Claude response for factual claims
2. Cross-checks claims against codebase
3. Verifies function names, file paths, and behavior claims
4. Runs quick validation tests where applicable
5. Provides confidence scores (High/Medium/Low)
6. Corrects any inaccuracies found

---

## Verification Process

### Step 1: Claim Extraction (5-10 seconds)
Automatically identify verifiable claims:
- File paths and locations
- Function/class/variable names
- API endpoints
- Configuration values
- Behavior descriptions
- Architectural statements

### Step 2: Quick Verification (20-40 seconds)
- **Code checks**: Grep + Read for exact matches
- **Test checks**: Search for related test cases
- **Documentation**: Compare against README/docs

### Step 3: Confidence Scoring
- 🟢 **HIGH**: Direct code match, tests confirm
- 🟡 **MEDIUM**: Partial match, likely correct
- 🔴 **LOW**: No match found, incorrect

### Step 4: Present Results
- List each claim with verification status
- Cite exact file:line sources
- Provide corrections for incorrect claims
- Show overall confidence percentage

---

## Output Format

```markdown
✓ RESPONSE VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analyzing last response for accuracy...

Verified Claims:
───────────────
✓ [Claim 1] - VERIFIED (source: file.ts:123)
✓ [Claim 2] - VERIFIED (source: test.ts:45)
⚠ [Claim 3] - PARTIALLY CORRECT (see correction below)
✗ [Claim 4] - INCORRECT (see correction below)

Corrections Needed:
───────────────────
❌ Claim 3: "Uses bcrypt with 12 rounds"
   → Actually uses 10 rounds (config/auth.ts:34)

Overall Confidence: 🟢 HIGH (75% verified)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## When to Use This Command

**Use /verify-response when:**
- You want to double-check Claude's answer
- Response contains technical implementation details
- Making critical decisions based on the response
- Response claims specific file locations or code patterns
- Need to ensure accuracy before proceeding

**Examples:**
```
User: "Where is the authentication logic?"
Claude: "It's in src/auth/login.ts and uses JWT tokens"
User: /verify-response

→ Verifies file exists, checks for JWT usage, confirms claim
```

---

## Advantages Over Manual Verification

✅ **Faster**: 30-60 seconds vs 5-10 minutes manual checking
✅ **Comprehensive**: Checks code, tests, and documentation
✅ **Objective**: Provides evidence-based confidence scores
✅ **Convenient**: Single command, automatic analysis
✅ **Accurate**: Cites exact line numbers and sources

---

## Command Options

```bash
# Basic usage - verify last response
/verify-response

# Verify specific response (by number)
/verify-response --message=3

# Quick verification (skip tests)
/verify-response --quick

# Deep verification (invoke Cross-Check subagent)
/verify-response --deep
```

---

## Limitations

**This command CANNOT verify:**
- Subjective opinions or recommendations
- Claims requiring external data (API calls, databases)
- Future behavior or planned features
- Performance claims without benchmarks
- Claims about running systems without access

**For these, use:**
- `/cross-check` for deep analysis
- Manual testing for runtime behavior
- Performance profiling for performance claims

---

## Integration with Fact-Check Skill

This command automatically invokes the **fact-check skill**, which:
- Performs systematic verification in 30-60 seconds
- Uses Grep/Read/Glob for code verification
- Provides structured output with citations
- Escalates to Cross-Check subagent for complex claims

---

## Examples

### Example 1: Simple Verification

**Command:**
```bash
/verify-response
```

**Last Response:**
"The database configuration is in config/database.ts and uses PostgreSQL with connection pooling."

**Verification Output:**
```
✓ RESPONSE VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ File location: config/database.ts - VERIFIED
✓ PostgreSQL usage: VERIFIED (line 12: dialect: 'postgres')
✓ Connection pooling: VERIFIED (line 24: pool config present)

Overall Confidence: 🟢 HIGH (100% verified)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Example 2: Correction Needed

**Command:**
```bash
/verify-response
```

**Last Response:**
"The API rate limit is 100 requests per minute, configured in middleware/rateLimit.ts."

**Verification Output:**
```
✓ RESPONSE VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ File location: middleware/rateLimit.ts - VERIFIED
✗ Rate limit value: INCORRECT

Correction:
❌ Claimed: 100 requests per minute
✓ Actual: 50 requests per minute (middleware/rateLimit.ts:18)

Evidence:
```typescript
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 50 // <-- 50, not 100
})
```

Overall Confidence: 🟡 MEDIUM (50% verified)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Example 3: Complex Claim - Escalates to Subagent

**Command:**
```bash
/verify-response
```

**Last Response:**
"The authentication flow involves three services: AuthService validates credentials, TokenService generates JWTs, and SessionService manages sessions with Redis."

**Verification Output:**
```
✓ RESPONSE VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Detected complex multi-service claim requiring deep analysis.

Invoking Cross-Check subagent for comprehensive verification...

[CROSS-CHECKER] 🔎

Verified service interaction flow:
✓ AuthService: src/services/AuthService.ts:23
✓ TokenService: src/services/TokenService.ts:45
✓ SessionService: src/services/SessionService.ts:67
✓ Redis integration: Confirmed in SessionService:89

All claims verified. Authentication flow is accurate.

Overall Confidence: 🟢 HIGH (100% verified)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Success Criteria

This command is successful when:
- ✅ Completes verification in 30-60 seconds
- ✅ Identifies factual inaccuracies if present
- ✅ Provides specific corrections with citations
- ✅ Confidence scores match reality
- ✅ Increases user trust in Claude's responses

---

## Tips

💡 **Run this command when:**
- Claude's response contains 3+ technical claims
- You're about to make changes based on the response
- Response conflicts with your understanding
- Need to document the verification for others

💡 **Don't run for:**
- Simple conceptual questions
- Opinion-based responses
- Well-known facts (e.g., "JavaScript is a language")

---

**This command ensures you can trust Claude's technical responses with evidence-based verification.**
