# Command: Validate Requirements

## Purpose
Comprehensive requirements completeness check that identifies vague language, missing sections, and gaps.

## Usage
```bash
/validate-requirements [file-path or current-document]
```

## What This Command Does

1. Scans requirements for completeness
2. Detects vague/ambiguous language
3. Checks acceptance criteria quality
4. Validates non-functional requirements
5. Identifies missing edge cases
6. Generates scored report with actionable fixes

---

## Validation Checks

### 1. Completeness Check (30 points)

```
✅ Required Sections Present:
- [ ] Problem statement (clear and specific)
- [ ] Success criteria (SMART metrics)
- [ ] User personas (identified)
- [ ] Functional requirements (documented)
- [ ] Acceptance criteria (for each requirement)
- [ ] Edge cases (documented)
- [ ] Non-functional requirements (performance, security, a11y)
- [ ] Dependencies (listed with owners)
- [ ] Risks (assessed with mitigation)
- [ ] Launch plan (rollout strategy)
```

### 2. Precision Check (25 points)

```
❌ Vague Language Detected:
- "fast" → Define: < Xms
- "easy" → Define: X% success rate, WCAG level
- "many" → Define: exact number
- "should" → Define: MUST/SHOULD/COULD
- "improved" → Define: X% improvement in [metric]

Score: -5 points per vague term
```

### 3. Acceptance Criteria Quality (20 points)

```
✅ Each AC must have:
- [ ] Given/When/Then format
- [ ] Specific values (not "fast", "many")
- [ ] Observable outcome (testable)
- [ ] Clear pass/fail criteria

❌ Common AC Issues:
- Missing Given context
- Vague When action
- Untestable Then outcome
- No specific thresholds
```

### 4. Non-Functional Requirements (15 points)

```
✅ Must Include:
- [ ] Performance (load time, API response)
- [ ] Security (authentication, encryption)
- [ ] Accessibility (WCAG level, keyboard, screen reader)
- [ ] Browser/Device support (versions)
- [ ] Scalability (concurrent users, data volume)

Score: -3 points per missing NFR category
```

### 5. Edge Cases (10 points)

```
✅ Common Edge Cases to Document:
- [ ] Network failures (timeout, offline)
- [ ] Invalid input (malformed data)
- [ ] Rate limiting (too many requests)
- [ ] Concurrent operations (race conditions)
- [ ] Empty states (no data)
- [ ] Error recovery (retry logic)

Score: +2 points per documented edge case
```

---

## Output Format

```markdown
# Requirements Validation Report

## Overall Score: X/100

🟢 Excellent (90-100): Ship-ready
🟡 Good (70-89): Minor improvements needed
🟠 Fair (50-69): Significant gaps
🔴 Poor (<50): Major rework required

---

## Summary

✅ **Strengths** (What's good):
- [Strength 1]
- [Strength 2]

⚠️ **Critical Issues** (Must fix before proceeding):
1. [Issue 1]
2. [Issue 2]

📝 **Recommendations** (Should improve):
1. [Recommendation 1]
2. [Recommendation 2]

---

## Detailed Analysis

### 1. Completeness (X/30 points)

#### Missing Sections
❌ **Non-Functional Requirements** (Priority: Critical)
**Impact**: Engineering won't know performance, security, or accessibility requirements

**What to add**:
```yaml
performance:
  page_load: "< 500ms (p95)"
  api_response: "< 200ms (p95)"
security:
  authentication: "OAuth 2.0"
  data_encryption: "TLS 1.3"
accessibility:
  standard: "WCAG 2.1 AA"
  keyboard: "All elements navigable"
```

#### Incomplete Sections
⚠️ **Edge Cases** (Priority: High)
**Current**: 2 edge cases documented
**Expected**: 5-7 edge cases

**Missing edge cases**:
- What if API times out?
- What if user loses connection mid-operation?
- What if duplicate submission?
- What if data exceeds size limit?

---

### 2. Precision (X/25 points)

#### Vague Terms Detected (12 instances)

1. Line 23: "The form should load fast"
   - **Issue**: "fast" is subjective
   - **Suggestion**: "Form renders in < 500ms (p95)"
   - **Impact**: -2 points

2. Line 45: "Display many results"
   - **Issue**: "many" is unspecific
   - **Suggestion**: "Display 10-50 results, default 25"
   - **Impact**: -2 points

3. Line 67: "System should be reliable"
   - **Issue**: "reliable" is vague
   - **Suggestion**: "99.9% uptime SLA, < 0.1% error rate"
   - **Impact**: -2 points

[Continue for all vague terms]

---

### 3. Acceptance Criteria Quality (X/20 points)

#### Good Examples Found
✅ FR-3, AC-2:
```
Given user submits valid email
When form submitted
Then display "Check your inbox" message
And send email within 5 seconds
```
**Why good**: Specific timing, observable outcome

#### Issues Found

❌ FR-1, AC-1:
```
"When user clicks button, show results"
```
**Issues**:
- Missing Given (what's the initial state?)
- No Then specifics (what results? how many? in what order?)
- Not testable (no pass/fail criteria)

**Suggested Rewrite**:
```
Given user has entered search query with 3+ characters
When user clicks "Search" button
Then display 10 results within 1 second
And highlight matching keywords in results
And show "0 results" message if no matches
```

---

### 4. Non-Functional Requirements (X/15 points)

#### Covered (✅)
- Performance requirements specified
- Security authentication method defined

#### Missing (❌)

**Accessibility** (Critical - 0/5 points)
**What's missing**:
- WCAG compliance level
- Keyboard navigation requirements
- Screen reader support
- Color contrast requirements

**Suggested Addition**:
```markdown
## Accessibility Requirements
- WCAG 2.1 AA compliance (minimum)
- All interactive elements keyboard accessible
- Focus indicators visible (3:1 contrast)
- Screen reader tested with NVDA and VoiceOver
- Color contrast: 4.5:1 for text, 3:1 for UI components
```

**Browser Support** (Important - 0/3 points)
**What's missing**: Which browsers and versions?

**Suggested Addition**:
```markdown
## Browser Support
- Chrome: Last 2 versions
- Safari: Last 2 versions
- Firefox: Last 2 versions
- Edge: Last 2 versions
- Mobile: iOS 14+, Android 10+
```

---

### 5. Edge Cases (X/10 points)

#### Documented (✅)
1. Empty search results - handled
2. Invalid input format - handled

#### Missing (❌)

**Critical Edge Cases**:

1. **Network Timeout**
   - Scenario: API request exceeds 30 seconds
   - Expected: Show "Taking longer than usual..." message, retry 3 times
   - Current: Not documented

2. **Concurrent Edits**
   - Scenario: Two users edit same record simultaneously
   - Expected: Last write wins with conflict warning
   - Current: Not documented

3. **Data Validation Mismatch**
   - Scenario: Client-side validation passes, server-side fails
   - Expected: Show server error inline, preserve user data
   - Current: Not documented

4. **Session Expiry**
   - Scenario: User's session expires during operation
   - Expected: Redirect to login, preserve draft data
   - Current: Not documented

---

## Action Items (Prioritized)

### Priority 1: Must Fix Before Engineering

1. ❌ **Add Non-Functional Requirements** (Est: 30 min)
   - Add performance thresholds
   - Add security requirements
   - Add accessibility standards
   - Add browser support matrix

2. ❌ **Make Vague Terms Specific** (Est: 45 min)
   - Replace 12 instances of vague language
   - Add specific metrics and thresholds
   - Define all "should" statements as MUST/COULD/WON'T

3. ❌ **Complete Edge Case Documentation** (Est: 30 min)
   - Document 4 critical missing edge cases
   - Add error handling specifications
   - Define fallback behavior

### Priority 2: Should Improve

4. ⚠️ **Enhance Acceptance Criteria** (Est: 45 min)
   - Rewrite 5 ACs in Given/When/Then format
   - Add specific thresholds to 3 ACs
   - Make all ACs testable

5. ⚠️ **Add Success Metrics** (Est: 20 min)
   - Define 2-3 primary metrics
   - Add leading indicators
   - Specify measurement plan

### Priority 3: Nice to Have

6. 📝 **Add Diagrams** (Est: 1 hour)
   - User flow diagram
   - System architecture
   - Error flow diagram

---

## Comparison to Best Practices

### Industry Benchmark: High-Quality PRD

| Criteria | Your PRD | Best Practice | Gap |
|----------|----------|---------------|-----|
| Vague language | 12 instances | 0-2 | -10 |
| AC coverage | 70% | 100% | -30% |
| NFRs complete | 40% | 100% | -60% |
| Edge cases | 2 | 7+ | -5 |
| SMART metrics | Partial | Complete | -3 |

---

## Estimated Time to Fix

**Priority 1 (Critical)**: 1.5-2 hours
**Priority 2 (Important)**: 1-1.5 hours
**Priority 3 (Nice to have)**: 1 hour

**Total to Ship-Ready**: 3.5-4.5 hours

---

## Next Steps

1. **Fix Priority 1 items** (required before engineering review)
2. **Run /validate-requirements again** (verify improvements)
3. **Get engineering review** (once score ≥ 75)
4. **Iterate based on feedback**

---

## Re-Validation

After fixing issues, run:
```bash
/validate-requirements --compare-to=original
```

This will show before/after score improvement.

---

## Questions?

If any feedback is unclear, ask:
- "Why is [X] considered vague?"
- "What's a good example of [Y]?"
- "How do I write [Z] section?"
```

---

## Command Options

```bash
# Basic usage
/validate-requirements

# Validate specific file
/validate-requirements ~/docs/prd.md

# Quick validation (scores only)
/validate-requirements --quick

# Focus on specific area
/validate-requirements --focus=acceptance-criteria

# Compare to previous validation
/validate-requirements --compare-to=previous

# Show only critical issues
/validate-requirements --critical-only
```

---

## Success Criteria

Validation is useful when:
- ✅ Identifies specific issues (not vague feedback)
- ✅ Provides actionable fixes
- ✅ Scores accurately (matches manual review)
- ✅ Time estimates are realistic
- ✅ Reduces eng clarification requests by 75%+

---

**This command ensures requirements are precise, complete, and ready for engineering.**
