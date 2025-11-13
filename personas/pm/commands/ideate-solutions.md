# Command: Ideate Solutions

## Purpose
AI-powered brainstorming of solution approaches for a problem, including traditional and AI-powered options.

## Usage
```bash
/ideate-solutions [problem-description]
```

## What This Command Does

1. Analyzes the problem deeply
2. Generates 5-8 diverse solution approaches
3. Categorizes by complexity and impact
4. Highlights AI/ML opportunities
5. Provides examples from other products
6. Recommends prioritized approach

---

## Output Format

```markdown
# Solution Ideation: [Problem]

## Problem Analysis

**Problem Statement**: [Reframed clearly]

**Root Causes**:
1. [Underlying cause 1]
2. [Underlying cause 2]
3. [Underlying cause 3]

**Constraints**:
- Technical: [Limitations]
- Business: [Budget, timeline]
- User: [Expectations, behaviors]

**Why This Is Hard**: [Why simple solutions won't work]

---

## Solution Approaches

### 1. [Solution Name] (Low Complexity, Medium Impact) ⚙️

**Approach**: [Clear description]

**How It Works**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Pros**:
- ✅ [Benefit 1]
- ✅ [Benefit 2]

**Cons**:
- ❌ [Limitation 1]
- ❌ [Limitation 2]

**Effort**: [Timeline]
**Cost**: [Amount]
**Example**: [Company using this] - [Their result]

---

### 2. [AI-Powered Solution] (Medium Complexity, High Impact) 🤖

**Approach**: [AI-enhanced description]

**AI Component**: [What the AI does]

**How It Works**:
1. [AI processes what]
2. [AI decides what]
3. [User sees what]

**Pros**:
- ✅ Learns and improves
- ✅ Handles edge cases
- ✅ [Specific benefit]

**Cons**:
- ❌ Requires data/API
- ❌ [Limitation]

**Effort**: [Timeline]
**Cost**: $[Amount]/month
**AI Technology**: [LLM / ML / Computer Vision]
**Example**: [Company] - [Result]

---

### 3. [LLM-Powered Solution] (Medium Complexity, Very High Impact) ✨ NEW

**Approach**: [LLM-based description]

**Why This Is New/Innovative**:
- [What's possible now that wasn't before]
- [How this differentiates from competitors]

**User Experience**:
- User: [Action]
- AI: [Response]
- Result: [Outcome]

**Pros**:
- ✅ Natural interaction
- ✅ No training data needed
- ✅ Handles complex scenarios
- ✅ Fast to implement

**Cons**:
- ❌ API costs (~$0.0X per interaction)
- ❌ Requires prompt engineering
- ❌ Need guardrails

**Effort**: 3-4 weeks
**Cost**: $[Amount]/month
**AI Technology**: GPT-4, Claude 3.5, or similar
**Example**: [Company] - [Result]

---

[Continue for 5-8 total solutions]

---

## Solution Comparison Matrix

| # | Solution | Complexity | Impact | Timeline | Cost/mo | Innovation | Score |
|---|----------|------------|--------|----------|---------|------------|-------|
| 1 | [Name] | Low | Medium | 2w | $0 | ⚪ | ⭐⭐ |
| 2 | [Name] | Medium | High | 4w | $500 | 🟡 | ⭐⭐⭐ |
| 3 | [Name] | Medium | Very High | 4w | $600 | 🟢 | ⭐⭐⭐⭐ |
| 4 | [Name] | High | Very High | 12w | $2000 | 🟢 | ⭐⭐⭐ |
| 5 | [Name] | Low | Low | 1w | $0 | ⚪ | ⭐ |

**Legend**:
- ⚪ Traditional
- 🟡 AI-Enhanced
- 🟢 AI-First
- Score: Impact ÷ Complexity × Innovation

---

## Recommended Approach

### Quick Win (Phase 1): [Solution #X]
**Timeline**: [Weeks]
**Impact**: [Metric improvement estimate]
**Why**: [Rationale]

### Innovation Play (Phase 2): [Solution #Y]
**Timeline**: [Weeks after Phase 1]
**Impact**: [Metric improvement estimate]
**Why**: [Rationale]

### Long-term (Phase 3): [Solution #Z]
**Timeline**: [Months]
**Impact**: [Metric improvement estimate]
**Why**: [Rationale]

---

## Decision Framework

### Choose Solution #X if:
- ✅ Need results in < 4 weeks
- ✅ Budget < $500/month
- ✅ Risk-averse

### Choose Solution #Y if:
- ✅ Want to differentiate from competitors
- ✅ OK with 4-8 week timeline
- ✅ Budget up to $1000/month

### Choose Solution #Z if:
- ✅ Have 6+ months of data
- ✅ Willing to invest in ML team
- ✅ Long-term strategic bet

---

## Next Steps

1. **User Validation**: [Test concept with 10 users]
2. **Technical Feasibility**: [2-day spike to verify approach]
3. **Prototype**: [Build simplest version to validate]
4. **Measure**: [Define success metrics]
5. **Decide**: [Go/No-go by [date]]

---

## Resources

- [Industry benchmarks]
- [Competitor analysis]
- [Technical documentation]
- [Cost calculators]
```

---

## Example Interactions

### Example 1: Checkout Problem

```bash
PM: "35% of users abandon checkout at shipping step"

/ideate-solutions "checkout abandonment at shipping"

Output:
1. Simplify to 3 options (Low complexity, 2w, free)
2. Smart defaults based on location (Medium, 3w, $100/mo)
3. ML recommendation engine (High, 8w, $1500/mo)
4. ✨ LLM shopping assistant (Medium, 4w, $600/mo) RECOMMENDED
5. Remove step entirely (Low, 1w, free - but risky)

Recommendation: #4 (LLM assistant)
- Novel approach (competitors don't have)
- Handles complex scenarios ("arrives by Friday, cheapest")
- Fast to implement (no training data)
- Moderate cost ($600/mo for 30k users)
```

### Example 2: Search Problem

```bash
/ideate-solutions "users can't find products with keyword search"

Output:
1. Better synonyms (Low, 1w, free)
2. Fuzzy matching (Low, 2w, $100/mo)
3. Semantic search with embeddings (Medium, 4w, $200/mo) ⭐
4. Visual search (High, 12w, $2000/mo)
5. ✨ Conversational product finder (Medium, 4w, $500/mo)

Recommendation: #3 (Semantic search)
- Proven ROI (70-80% search success)
- Fast to implement (4 weeks)
- Affordable ($200/mo)
- Can add #5 in Phase 2
```

---

## Command Options

```bash
# Basic usage
/ideate-solutions "User onboarding is confusing"

# Focus on AI solutions only
/ideate-solutions --ai-only "Content creation"

# Set constraints
/ideate-solutions --max-timeline=4weeks --max-budget=500 "Problem"

# Include competitors
/ideate-solutions --show-competitors "Search feature"

# Generate 10 ideas instead of 5-8
/ideate-solutions --ideas=10 "Problem"
```

---

## Integration

**Auto-triggers after**:
- Problem statement defined in `/create-prd-interactive`
- PM asks "how should we solve this?"

**Feeds into**:
- `/explore-ai-features` (for chosen AI solutions)
- `/create-prd-interactive` (solution section)

---

## Success Criteria

Command succeeds when:
- ✅ 5-8 diverse solutions generated
- ✅ At least 2 AI-powered options
- ✅ Clear complexity/impact ratings
- ✅ Real-world examples provided
- ✅ Actionable recommendation with rationale
- ✅ PM discovers solution they hadn't considered

---

**This command prevents solution tunnel vision and ensures AI opportunities are explored.**
