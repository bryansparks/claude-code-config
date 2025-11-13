# Skill: PRD Guide - Interactive PRD Creation Assistant

## Skill Metadata
- **Skill ID**: `prd-guide`
- **Version**: 1.0
- **Persona**: Product Manager
- **Auto-invocation**: Yes
- **Priority**: High

---

## Invocation Pattern

This skill automatically activates when Claude detects:

```yaml
triggers:
  - user_intent:
      - "write requirements"
      - "create PRD"
      - "requirements document"
      - "product requirements"
  - file_operations:
      - opens file matching: "*-requirements.md", "*-prd.md", "*-spec.md"
      - creates new file with "requirements" or "PRD" in name
  - explicit_request:
      - "/create-prd-interactive"
      - "/prd"
```

---

## Skill Purpose

Guide Product Managers through creating comprehensive, precise Product Requirements Documents (PRDs) using an interactive, step-by-step approach that ensures completeness and clarity.

---

## Core Responsibilities

### 1. Structured Guidance
- Lead PM through 7 key PRD sections sequentially
- Ask clarifying questions at each stage
- Validate completeness before progressing
- Suggest missing elements proactively

### 2. Precision Enhancement
- Detect vague language ("fast", "easy", "better")
- Request specific metrics and criteria
- Ensure all requirements are testable
- Help PM define "done" clearly

### 3. Context Integration
- Use Figma MCP to pull design context
- Use PostHog MCP to get usage data
- Use Linear MCP to check related issues
- Use Memory MCP to recall patterns

### 4. Quality Validation
- Check against PRD completeness checklist
- Validate acceptance criteria format
- Ensure success metrics are SMART
- Identify missing non-functional requirements

---

## Interactive Workflow

### Step 1: Problem Definition
**Goal**: Crystal-clear problem statement with evidence

```
Questions to ask:
1. What specific problem are we solving?
2. Who experiences this problem? (which user personas?)
3. How do we know this is a problem?
   - Usage data (PostHog metrics)
   - User feedback (support tickets, surveys)
   - Business impact (revenue loss, churn)
4. What happens if we don't solve it?
5. How severe is this problem? (P0/P1/P2/P3)

Validation:
- Problem statement is one clear sentence
- Supported by quantitative data
- Persona clearly identified
- Business impact quantified

Example of GOOD:
"35% of users abandon checkout at shipping selection (PostHog data),
costing $2M/year in lost revenue. The complexity of our 12 shipping
options overwhelms first-time buyers."

Example of BAD:
"Checkout is confusing and users don't like it."
```

---

### Step 2: Goals & Success Criteria
**Goal**: Measurable outcomes that define success

```
Questions to ask:
1. What are we trying to achieve? (business goals)
2. How will we measure success?
   - Primary metrics (1-3 max)
   - Secondary metrics
   - Leading indicators
3. What's the timeline?
4. What's explicitly out of scope?

Success Criteria Framework (SMART):
- Specific: Exact metric and target
- Measurable: Can be tracked in PostHog
- Achievable: Based on benchmarks
- Relevant: Aligns with business goals
- Time-bound: Has a deadline

Example:
PRIMARY SUCCESS METRICS:
1. Reduce checkout abandonment from 35% to 25% within 2 months
2. Increase conversion rate from 2.1% to 2.5%
3. Improve checkout CSAT from 6.5 to 8.0

LEADING INDICATORS (Week 1-2):
- Shipping selection error rate < 5%
- Average time at shipping step < 30 seconds
- Guest checkout adoption > 60%

OUT OF SCOPE:
- Payment method changes
- International shipping
- Gift options
```

---

### Step 3: User Research
**Goal**: Deep understanding of affected users

```
Questions to ask:
1. Which personas are affected? (list all)
2. For each persona:
   - What are their goals?
   - What are their pain points?
   - What have they told us? (quotes, feedback)
   - How tech-savvy are they?
3. What user research have we done?
   - Interviews (how many?)
   - Surveys (sample size?)
   - Usability tests (findings?)
4. What do we still need to learn?

Pull from Memory:
- Existing persona definitions
- Past user research on similar features

Pull from Linear/GitHub:
- User-reported issues related to this area
- Feature requests from customers

Example:
PERSONA: First-Time Buyer (40% of checkout attempts)
- Goals: Complete purchase quickly, understand costs upfront
- Pain Points: "Too many shipping options", "Can't compare costs easily"
- Quote: "I just want the cheapest option that arrives by Friday"
- Tech Savvy: Low to Medium
- Research: 12 user interviews, 250 survey responses
```

---

### Step 4: Solution Exploration
**Goal**: Evaluate approaches, highlight AI opportunities

```
Questions to ask:
1. What solutions have we considered?
2. Why did we choose this approach?
3. What are the alternatives?
4. Are there AI/ML opportunities? (CRITICAL QUESTION)
   - Could AI personalize this experience?
   - Could AI predict user intent?
   - Could AI automate any manual steps?
   - Could conversational AI guide users?

Solution Comparison Template:
SOLUTION 1: [Traditional Approach]
- Pros: [List]
- Cons: [List]
- Complexity: Low/Medium/High
- Time: [Estimate]

SOLUTION 2: [AI-Enhanced Approach]
- AI Component: [What AI does]
- Pros: [List]
- Cons: [List]
- Complexity: Low/Medium/High
- Time: [Estimate]
- Data Requirements: [What data needed]
- Example: [Similar product using this]

RECOMMENDATION: [Which and why]

Example:
CONSIDERED:
1. Simplify to 3 shipping tiers (Standard, Express, Overnight)
2. ML-powered "Recommended for you" based on past behavior
3. Conversational AI: "When do you need this by?" → suggests option

CHOSEN: Hybrid approach
- Simplify to 3 tiers (Phase 1, 2 weeks)
- Add ML recommendations (Phase 2, 6 weeks)
- Rationale: Quick win + long-term personalization
```

---

### Step 5: Requirements
**Goal**: Complete functional and non-functional requirements

```
Functional Requirements:
For each requirement:
- Description (What it does)
- Priority (Must/Should/Could Have)
- Acceptance Criteria (Given/When/Then)

Example:
FR-1: Simplified Shipping Selection
Priority: Must Have
Description: Display 3 shipping options with clear pricing and delivery dates

Acceptance Criteria:
1. Given user is at shipping step
   When page loads
   Then display exactly 3 shipping options

2. Given user views shipping options
   When comparing options
   Then each shows: price, delivery date range, and description

3. Given user selects an option
   When clicking "Continue"
   Then selection is saved and user advances to payment

Non-Functional Requirements:
- Performance: Page loads in < 500ms
- Accessibility: WCAG 2.1 AA compliant, keyboard navigable
- Security: Shipping address encrypted in transit and at rest
- Mobile: Responsive design, works on 375px+ screens
- Browser Support: Chrome, Safari, Firefox, Edge (last 2 versions)
- API: 99.9% uptime, < 200ms response time p95

EDGE CASES:
- What if only 1 shipping option available?
- What if user's address is invalid?
- What if shipping API times out?
- What if user goes back to change address?
```

---

### Step 6: Technical Feasibility
**Goal**: Understand constraints and risks

```
Questions to ask:
1. Dependencies:
   - What other features/systems does this depend on?
   - Are there any blockers?
   - Who owns the dependencies?

2. Risks:
   - Technical risks (API reliability, performance)
   - Business risks (regulation, competition)
   - User risks (adoption, satisfaction)
   - Mitigation plan for each

3. Constraints:
   - Technical limitations
   - Timeline constraints
   - Resource constraints
   - Regulatory/legal constraints

4. Effort Estimate:
   - Engineering: [Person-weeks]
   - Design: [Person-weeks]
   - QA: [Person-weeks]
   - Total: [Person-weeks]

Example:
DEPENDENCIES:
- Shipping provider API v2 integration (Eng team, Q1)
- Design system button variants (Design team, available)
- A/B testing infrastructure (Platform team, ready)

RISKS:
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Shipping API downtime | High | Medium | Fallback to cached rates, queue updates |
| Users confused by 3 options | Medium | Low | User testing before launch, help text |
| ML model accuracy low | Medium | Medium | Start with rule-based, add ML in Phase 2 |

EFFORT ESTIMATE:
- Engineering: 4 weeks (2 engineers)
- Design: 1 week
- QA: 1 week
- Total: 6 person-weeks
```

---

### Step 7: Launch & Measurement
**Goal**: Clear launch plan and success tracking

```
Questions to ask:
1. Launch strategy:
   - Big bang or phased rollout?
   - Which user segments first?
   - Feature flag approach?

2. Measurement plan:
   - PostHog events to track
   - Dashboard setup
   - Review cadence (daily/weekly?)

3. Success validation:
   - When do we know if it worked?
   - What's the rollback plan?

4. Communication:
   - Internal: Who needs to know?
   - External: User communication?
   - Support: Training needed?

Example:
LAUNCH STRATEGY:
- Week 1: 10% rollout (first-time buyers only)
  - Monitor: checkout abandonment, completion time, errors
  - Success criteria: Abandonment < 30%, no P0 bugs

- Week 2: 50% rollout (all users)
  - Monitor: conversion rate, CSAT, support tickets
  - Success criteria: Conversion > 2.3%, CSAT > 7.0

- Week 3: 100% rollout
  - Full metrics dashboard active

MEASUREMENT PLAN:
PostHog Events:
- checkout_shipping_viewed
- checkout_shipping_selected (with option)
- checkout_shipping_error (with error type)
- checkout_shipping_completed

Dashboard: [Link to PostHog dashboard]
Review: Daily for week 1, weekly thereafter

ROLLBACK PLAN:
If abandonment > 40% in first 24 hours:
- Immediately rollback via feature flag
- Investigate user session replays
- Fix issues before re-launch
```

---

## Validation Checklist

Before finishing PRD, validate:

```
✅ Problem Definition
- [ ] Problem statement is one clear sentence
- [ ] Supported by quantitative data
- [ ] User personas identified
- [ ] Business impact quantified

✅ Success Criteria
- [ ] 2-3 primary metrics defined
- [ ] Metrics are SMART (specific, measurable, achievable, relevant, time-bound)
- [ ] Leading indicators identified
- [ ] Out of scope explicitly stated

✅ User Research
- [ ] All affected personas documented
- [ ] User quotes/feedback included
- [ ] Pain points clearly stated
- [ ] Research sources cited

✅ Solution
- [ ] Multiple approaches considered
- [ ] AI/ML opportunities evaluated
- [ ] Trade-offs documented
- [ ] Recommendation with rationale

✅ Requirements
- [ ] All functional requirements have acceptance criteria
- [ ] Non-functional requirements specified (performance, security, a11y)
- [ ] Edge cases documented
- [ ] Requirements are testable

✅ Technical Feasibility
- [ ] Dependencies identified with owners
- [ ] Risks assessed with mitigation
- [ ] Constraints documented
- [ ] Effort estimated

✅ Launch Plan
- [ ] Rollout strategy defined
- [ ] PostHog events specified
- [ ] Success validation criteria
- [ ] Rollback plan documented
```

---

## MCP Server Integration

### Figma
```python
# Pull design context automatically
figma_file = figma.get_file(file_key="checkout-redesign")
figma_frames = figma.get_frames(file_key, frame_ids=["shipping-selection"])

# Include in PRD:
"Design Reference: [Link to Figma frame]
Key design decisions:
- 3-column layout for shipping options
- Green checkmark for recommended option
- Collapsed details by default"
```

### PostHog
```python
# Pull actual usage data
current_metrics = posthog.query("""
  SELECT
    COUNT(DISTINCT user_id) as users,
    AVG(time_to_complete) as avg_time,
    SUM(abandoned) / COUNT(*) as abandonment_rate
  FROM checkout_events
  WHERE step = 'shipping'
  AND date >= NOW() - INTERVAL '30 days'
""")

# Use in problem statement:
"Current abandonment at shipping: 35% (12,450 users/month)"
```

### Linear
```python
# Find related issues
related_issues = linear.search_issues(query="shipping checkout", limit=10)

# Include in research section:
"Related user feedback:
- LIN-1234: 'Too many shipping options confusing' (45 upvotes)
- LIN-1235: 'Can't tell which option is fastest' (32 upvotes)"
```

### Memory
```python
# Store PRD patterns for future use
memory.store({
  "type": "prd_pattern",
  "feature_type": "checkout_optimization",
  "success_metrics": ["abandonment_rate", "conversion_rate", "csat"],
  "common_pitfalls": ["forgot_mobile_testing", "missing_error_states"]
})

# Recall for next similar PRD:
patterns = memory.recall("prd_pattern for checkout_optimization")
```

---

## Output Format

Generate final PRD in this structure:

```markdown
# Product Requirements Document: [Feature Name]

**Version**: 1.0
**Status**: Draft | In Review | Approved
**Owner**: [PM Name]
**Last Updated**: [Date]

---

## 1. Executive Summary
[2-3 sentences: What, Why, Expected outcome]

## 2. Problem Statement
[Clear problem with data]

## 3. Goals & Success Criteria
### Primary Metrics
### Leading Indicators
### Out of Scope

## 4. User Research
### Personas
### Pain Points
### User Feedback

## 5. Solution
### Approach
### Alternatives Considered
### AI/ML Opportunities
### Recommendation

## 6. Requirements
### Functional Requirements
### Non-Functional Requirements
### Edge Cases

## 7. Technical Feasibility
### Dependencies
### Risks & Mitigation
### Constraints
### Effort Estimate

## 8. Launch Plan
### Rollout Strategy
### Measurement Plan
### Success Validation
### Communication Plan

## 9. Appendix
### Design References (Figma links)
### Data Sources (PostHog dashboards)
### Related Issues (Linear)

---

## Approval Signatures
| Role | Name | Date | Status |
|------|------|------|--------|
| Product Manager | | | |
| Tech Lead | | | |
| Design Lead | | | |
| QA Lead | | | |
```

---

## Skill Behavior Notes

### When to Interrupt
- PM writes vague requirements → immediately ask for specifics
- PM skips a section → prompt to fill it before continuing
- PM forgets success metrics → stop and define them

### When to Let Flow
- PM is on a roll → don't interrupt unnecessarily
- PM has good existing draft → validate and enhance
- PM explicitly says "draft mode" → give feedback at end

### Tone & Approach
- **Collaborative, not prescriptive**: "Have you considered..." not "You must..."
- **Question-driven**: Ask questions that help PM think, don't just tell answers
- **Data-focused**: Always ground in metrics and evidence
- **AI-aware**: Proactively suggest AI opportunities

---

## Success Metrics for This Skill

- **Adoption**: 80%+ of PRDs created with this skill
- **Quality**: PRD completeness score 70 → 90+
- **Efficiency**: Time to create PRD 4 hours → 2 hours
- **Precision**: Vague requirements reduced by 75%
- **Eng Feedback**: Clarification requests 8 → 2 per PRD

---

## Examples

### Example Interaction 1: Starting Fresh

```
PM: "I need to write a PRD for improving our checkout"

Claude (prd-guide activates):
"I'll guide you through creating a comprehensive PRD. Let's start with
the problem statement.

STEP 1: PROBLEM DEFINITION

First, let me get some context:

1. What specific problem in checkout are we solving?
   (Is it speed? Errors? Abandonment? Confusion?)

2. Which part of checkout?
   - Cart summary
   - Shipping information
   - Payment details
   - Order confirmation

3. Do we have data on this? Let me check PostHog...
   [Checking checkout funnel metrics]

I see in PostHog that:
- 35% abandon at shipping step (highest drop-off)
- Average time at shipping: 2.5 minutes
- 18% error rate on shipping form

Is the shipping step what we're focusing on?"

PM: "Yes, the shipping step. Users say they're confused by too many options."

Claude:
"Perfect. Let me help you craft a precise problem statement:

DRAFT:
'35% of users abandon checkout at the shipping selection step
(PostHog data, 30-day average), costing an estimated $2M/year in
lost revenue. User research indicates confusion over 12 different
shipping options, with first-time buyers most affected (45%
abandonment rate vs 25% for returning customers).'

Does this accurately capture the problem? Any changes needed?"
```

### Example Interaction 2: Refining Vague Requirements

```
PM writes: "The form should be fast and easy to use"

Claude (prd-guide + requirements-refiner activate):
"I notice some vague language here. Let's make these requirements
precise and testable:

VAGUE: 'form should be fast'
QUESTIONS:
- Fast page load? → Target: < 500ms
- Fast to complete? → Target: < 2 minutes average
- Fast API responses? → Target: < 200ms p95

Which aspects of speed matter most for this feature?

VAGUE: 'easy to use'
QUESTIONS:
- Easy means... accessible? → WCAG 2.1 AA compliance
- Easy means... few fields? → Maximum 5 required fields
- Easy means... low error rate? → < 5% validation errors
- Easy means... intuitive? → 90%+ complete without help text

What does 'easy' mean for your users in this context?"
```

---

## Version History

- **v1.0** (2025-11-13): Initial release
  - 7-step interactive workflow
  - MCP integration (Figma, PostHog, Linear, Memory)
  - Validation checklist
  - AI opportunity prompting

---

**This skill makes PRD creation a guided, interactive process that ensures precision, completeness, and AI-awareness.**
