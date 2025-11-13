# Command: Create PRD (Interactive)

## Purpose
Interactive wizard-style PRD creation with step-by-step guidance, validation, and MCP integration.

## Usage
```bash
/create-prd-interactive [feature-name]
```

## What This Command Does

Launches an interactive Q&A session that guides you through creating a comprehensive PRD:

1. **Problem Definition** - Clear problem statement with data
2. **Goals & Success Criteria** - SMART metrics and measurement plan
3. **User Research** - Personas, pain points, feedback
4. **Solution Exploration** - Traditional + AI-powered approaches
5. **Requirements** - Functional, non-functional, edge cases
6. **Technical Feasibility** - Dependencies, risks, estimates
7. **Launch Plan** - Rollout strategy and validation

**Automatically integrates with:**
- **Figma MCP**: Pull design specs and references
- **PostHog MCP**: Get current metrics and baseline data
- **Linear MCP**: Find related issues and user feedback
- **Memory MCP**: Recall patterns and previous decisions

---

## Interactive Workflow

### Step 1: Problem Definition

```
Claude: "Let's start with the problem statement.

1. What specific problem are we solving?
   > [Your answer]

2. Who experiences this problem? (which personas?)
   > [Your answer]

Checking PostHog for data...
📊 Found: 35% checkout abandonment at shipping step

3. This matches the data. Is shipping selection the focus?
   > Yes

Let me draft a problem statement:

'35% of users abandon checkout at shipping selection (PostHog),
costing $2M/year. User interviews show confusion over 12 options,
with first-time buyers most affected (45% abandonment).'

Looks good? (yes/no/edit)
> yes

✅ Problem statement complete. Moving to goals..."
```

### Step 2: Goals & Success Criteria

```
Claude: "Now let's define measurable success.

Checking current performance in PostHog...

CURRENT METRICS:
- Conversion rate: 2.1%
- Abandonment: 35%
- Checkout CSAT: 6.5/10

Which metrics matter most? Choose 2-3:

A) Conversion-focused
   1. Conversion: 2.1% → 2.8% (+33%)
   2. Abandonment: 35% → 25% (-10pp)

B) UX-focused
   1. Checkout time: 4.2min → 2.5min
   2. Error rate: 12% → <5%
   3. CSAT: 6.5 → 8.0

C) Custom
   > Enter your own

Your choice: [A/B/C]
> A

Perfect. Timeline for these goals?
> 6 weeks

✅ Success criteria:
1. Conversion: 2.1% → 2.8% within 6 weeks
2. Abandonment: 35% → 25% within 6 weeks

Leading indicators (week 1-2):
- Shipping step errors < 5%
- Time at shipping < 60s

PostHog events needed:
- checkout_shipping_viewed
- checkout_shipping_selected
- checkout_shipping_completed

✅ Success criteria complete. Moving to user research..."
```

### Step 3: User Research

```
Claude: "Let's understand the users.

Searching Linear for related feedback...
📋 Found:
- LIN-1234: 'Too many shipping options' (45 upvotes)
- LIN-5678: 'Can't tell which is fastest' (32 upvotes)

Which personas are affected?
1. First-time buyers
2. Returning customers
3. International users
4. Other

> 1, 2

For First-time buyers:
- What are their goals?
  > Complete purchase quickly, understand costs

- What are their pain points?
  > Too many options, unclear delivery dates

- Any user quotes?
  > 'I just want cheapest option that arrives by Friday'

[Repeat for Returning customers]

✅ User research complete. Moving to solution exploration..."
```

### Step 4: Solution Exploration

```
Claude: "Let's explore solution approaches, including AI opportunities.

TRADITIONAL APPROACHES:
1. Simplify to 3 tiers (Standard, Express, Overnight)
2. Add comparison table
3. Recommend most popular option

AI-POWERED APPROACHES:
🤖 4. ML Recommendation: Learn user preferences
   - Complexity: High
   - Requires: 6 months data
   - Impact: High

✨ 5. Conversational Assistant (NEW!)
   - LLM guides user: 'When do you need this by?'
   - Complexity: Medium
   - Requires: OpenAI/Anthropic API
   - Cost: ~$0.02 per conversation
   - Impact: Very High
   - Examples: Shopify Sidekick, Intercom Fin

Which approaches should we consider?
> 1, 5

Great! Hybrid approach:
- Phase 1: Simplify to 3 tiers (2 weeks)
- Phase 2: Add AI assistant (4 weeks)

Rationale?
> Quick win + innovation differentiator

✅ Solution strategy complete. Moving to requirements..."
```

### Step 5: Requirements

```
Claude: "Let's define detailed requirements.

FUNCTIONAL REQUIREMENTS:

FR-1: Simplified Shipping Selection
Priority: [Must Have/Should Have/Could Have/Won't Have]
> Must Have

Description:
> Display 3 shipping options with clear pricing

Let me help with acceptance criteria:

1. Given user at shipping step
   When page loads
   Then display exactly 3 options: Standard, Express, Overnight

2. Given user views options
   When comparing
   Then show: price, delivery date range, and icon

Complete? (yes/add more)
> yes

Any edge cases to consider?
- What if only 1 option available?
- What if user's address is invalid?
- What if shipping API times out?
- What if user changes address?

Which should we document?
> all

[Document each edge case]

NON-FUNCTIONAL REQUIREMENTS:

Let's ensure we cover:
- Performance: How fast should it load?
  > < 500ms

- Accessibility: What standard?
  > WCAG 2.1 AA

- Security: Any requirements?
  > Encrypt shipping address

- Mobile: Support level?
  > Fully responsive, 375px+

✅ Requirements complete. Moving to technical feasibility..."
```

### Step 6: Technical Feasibility

```
Claude: "Let's assess feasibility and risks.

DEPENDENCIES:
Looking at your codebase...

Found:
- Shipping provider API v2 (available)
- Design system components (available)

Missing:
- A/B testing infrastructure (Platform team, Q1)

Any blockers?
> None currently

RISKS:

I see these risks:
1. Shipping API downtime
   - Impact: High
   - Probability: Medium
   - Mitigation: ?
   > Cache rates, fallback to static

2. Users confused by 3 options (fewer might not be better)
   - Impact: Medium
   - Probability: Low
   - Mitigation: ?
   > User testing before launch

[Continue for other risks]

EFFORT ESTIMATE:
Based on similar features:
- Engineering: 3-4 weeks (2 engineers)
- Design: 1 week
- QA: 1 week
Total: 5-6 weeks

Does this match your expectation?
> Yes

✅ Technical feasibility complete. Moving to launch plan..."
```

### Step 7: Launch Plan

```
Claude: "Finally, let's plan the launch.

ROLLOUT STRATEGY:

Option A: Big bang (100% day 1)
Option B: Phased (10% → 50% → 100%)
Option C: A/B test (50% treatment, 50% control)

Which approach?
> B

Phase 1: 10% rollout
- Who: First-time buyers only
- Duration: 1 week
- Success criteria: Abandonment < 30%, no P0 bugs

Phase 2: 50% rollout
- Who: All users
- Duration: 1 week
- Success criteria: Conversion trending up

Phase 3: 100% rollout
- When: If Phase 2 successful

MEASUREMENT:

I'll generate PostHog setup:

Events to track:
✅ checkout_shipping_viewed
✅ checkout_shipping_selected {option}
✅ checkout_shipping_error {error_type}
✅ checkout_shipping_completed

Dashboard: [Will create in PostHog]

Review cadence:
- Daily: Week 1 (leading indicators)
- Weekly: Weeks 2-6 (primary metrics)

ROLLBACK PLAN:

Rollback if:
- Abandonment increases > 5pp
- P0 bugs detected
- API error rate > 10%

✅ Launch plan complete!

═══════════════════════════════════════
PRD GENERATION COMPLETE
═══════════════════════════════════════

Generating final PRD document...

✅ Created: ~/documents/shipping-optimization-prd.md

Summary:
- Problem: Clear and data-backed
- Success Metrics: SMART and measurable
- Requirements: Complete with edge cases
- AI Solution: LLM assistant in Phase 2
- Launch: Phased rollout with validation

Would you like me to:
1. Create Linear issues from requirements
2. Generate PostHog dashboard
3. Share PRD with stakeholders
4. Other

Your choice:
> 1

Creating Linear issues...
✅ LIN-2341: Simplify shipping options to 3 tiers
✅ LIN-2342: Add AI shipping assistant (Phase 2)
✅ LIN-2343: Set up PostHog tracking events

PRD and issues ready for review! 🎉"
```

---

## Key Features

### Real-Time Validation

At each step:
- ✅ Checks for completeness
- ✅ Detects vague language
- ✅ Suggests improvements
- ✅ Validates SMART criteria

### MCP Integration

```
Auto-pulls context:
├─ PostHog: Current metrics, baselines
├─ Linear: Related issues, user feedback
├─ Figma: Design specs, mockups
└─ Memory: Past patterns, templates
```

### AI Awareness

```
At solution exploration:
✅ Always suggests AI possibilities
✅ Estimates feasibility and cost
✅ Shows real-world examples
✅ Compares with traditional approaches
```

### Quality Guarantees

```
Won't proceed to next step until:
- All required questions answered
- Vague terms made specific
- Acceptance criteria in Given/When/Then
- Edge cases documented
- Success metrics are SMART
```

---

## Output

Generates complete PRD in markdown:

```markdown
# Product Requirements Document: [Feature]

**Version**: 1.0
**Owner**: [PM Name]
**Last Updated**: [Date]

## 1. Executive Summary
[2-3 sentence overview]

## 2. Problem Statement
[Precise problem with PostHog data]

## 3. Goals & Success Criteria
### Primary Metrics
1. [Metric]: [Current] → [Target] in [Timeline]
2. [Metric]: [Current] → [Target] in [Timeline]

### Leading Indicators
- [Indicator 1]
- [Indicator 2]

### PostHog Setup
Events: [List]
Dashboard: [Link]

## 4. User Research
[Personas, pain points, quotes from Linear]

## 5. Solution
### Approach
[Chosen solution]

### AI Opportunities
[LLM or ML solutions considered]

### Phased Rollout
- Phase 1: [Traditional approach]
- Phase 2: [AI enhancement]

## 6. Requirements
[Complete functional + non-functional requirements]

## 7. Technical Feasibility
[Dependencies, risks, effort estimates]

## 8. Launch Plan
[Phased rollout with validation criteria]

## 9. Appendix
- Figma: [Links]
- PostHog: [Dashboard]
- Linear: [Issues]
```

---

## Command Options

```bash
# Basic usage
/create-prd-interactive "Guest Checkout Optimization"

# Skip certain sections (if already documented)
/create-prd-interactive --skip-research

# Use existing file as starting point
/create-prd-interactive --from=draft-prd.md

# Quick mode (less detailed)
/create-prd-interactive --quick

# Save to specific location
/create-prd-interactive --output=~/docs/prd.md
```

---

## Success Criteria

This command is successful when:
- ✅ PRD completeness score ≥ 90/100
- ✅ All SMART success metrics defined
- ✅ AI opportunities explored
- ✅ Requirements include edge cases
- ✅ Non-functional requirements complete
- ✅ Launch plan with validation gates
- ✅ PostHog tracking events specified
- ✅ No vague language in final PRD

---

## Time to Complete

**Expected Duration**: 45-90 minutes
- Problem: 5-10 min
- Goals: 10-15 min
- Research: 10-15 min
- Solution: 10-15 min
- Requirements: 20-30 min
- Technical: 10-15 min
- Launch: 5-10 min

**Comparison**: Traditional PRD writing = 3-4 hours

**Time Saved**: 2-3 hours per PRD

---

## Tips for Best Results

1. **Have Data Ready**: Pull PostHog metrics before starting
2. **Review Linear**: Check related user feedback
3. **Design Context**: Have Figma links ready
4. **Think AI-First**: Always consider AI solutions
5. **Be Specific**: Avoid "fast", "easy", "better"
6. **Document Edge Cases**: Think through failures
7. **Plan Validation**: Know how you'll measure success

---

**This command transforms PRD creation from a blank-page problem into a guided conversation.**
