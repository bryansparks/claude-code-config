# Skill: Success Criteria Builder - Measurable Success Definition

## Skill Metadata
- **Skill ID**: `success-criteria-builder`
- **Version**: 1.0
- **Persona**: Product Manager
- **Auto-invocation**: Yes
- **Priority**: High

---

## Invocation Pattern

This skill automatically activates when Claude detects:

```yaml
triggers:
  - vague_goals:
      - "improve", "better", "faster", "easier", "more"
      - without quantifiable metrics
  - user_asks:
      - "how do we measure success"
      - "what are the success criteria"
      - "how do we know if this works"
  - missing_metrics:
      - PRD has goals section but no metrics
      - Feature description without success definition
```

---

## Skill Purpose

Convert vague product goals into SMART success criteria with primary metrics, leading indicators, and clear measurement plans.

---

## Core Framework: SMART Goals

Every success criterion must be:
- **Specific**: Exact metric, not directional
- **Measurable**: Can track in PostHog or similar
- **Achievable**: Based on benchmarks, not fantasy
- **Relevant**: Aligns with business objectives
- **Time-bound**: Has a deadline

---

## The Transformation Process

### Step 1: Detect Vague Language

```
VAGUE PATTERNS TO CATCH:
- "Improve the user experience"
- "Make it faster"
- "Increase engagement"
- "Better conversion"
- "More intuitive"
- "Reduce friction"

IMMEDIATE RESPONSE:
"Let's make this measurable. What specific metric defines success?"
```

### Step 2: Suggest Metric Categories

Based on feature type, suggest relevant metrics:

```python
FEATURE_TYPE_METRICS = {
  "checkout_optimization": [
    "conversion_rate",
    "abandonment_rate",
    "average_order_value",
    "time_to_complete",
    "error_rate",
    "customer_satisfaction"
  ],

  "onboarding_flow": [
    "completion_rate",
    "time_to_first_value",
    "activation_rate",
    "day_1_retention",
    "support_ticket_rate"
  ],

  "search_feature": [
    "click_through_rate",
    "zero_result_rate",
    "time_to_click",
    "search_refinement_rate",
    "search_success_rate"
  ],

  "content_feature": [
    "engagement_rate",
    "time_on_page",
    "scroll_depth",
    "return_visitor_rate",
    "share_rate"
  ],

  "performance_improvement": [
    "page_load_time",
    "time_to_interactive",
    "core_web_vitals",
    "api_response_time",
    "error_rate"
  ]
}
```

### Step 3: Build Metric Hierarchy

```
PRIMARY METRICS (Pick 2-3 max)
├─ Most important business outcome
├─ Directly ties to OKRs
└─ Lagging indicator (takes time to see impact)

SECONDARY METRICS (Supporting metrics)
├─ Related outcomes
├─ Nice-to-have improvements
└─ Context for primary metrics

LEADING INDICATORS (Early signals)
├─ Show progress before primary metrics move
├─ Predictive of success
└─ Can see impact in days/weeks, not months
```

### Step 4: Define Baselines & Targets

```
For each metric:
1. Current baseline (pull from PostHog if available)
2. Target value (based on industry benchmarks)
3. Minimum success threshold
4. Stretch goal
5. Timeline to achieve
```

---

## Interactive Workflow

### Interaction Pattern

```
PM says: "We want to improve checkout"

Claude (success-criteria-builder):
"Let's define what 'improve' means with specific metrics.

STEP 1: CURRENT STATE
Let me check PostHog for current checkout metrics...

Current Performance:
- Conversion rate: 2.1%
- Abandonment rate: 35%
- Average time: 4.2 minutes
- Error rate: 12%
- CSAT score: 6.5/10

STEP 2: PRIMARY SUCCESS METRICS
Which 2-3 metrics matter most for this project?

Option A: Conversion-Focused
1. Increase conversion rate from 2.1% to 2.8% (+33% lift)
2. Reduce abandonment from 35% to 25% (-10pp)
Timeline: Within 2 months post-launch

Option B: UX-Focused
1. Reduce average checkout time from 4.2min to 2.5min (-40%)
2. Reduce error rate from 12% to <5%
3. Improve CSAT from 6.5 to 8.0
Timeline: Within 1 month post-launch

Option C: Balanced
1. Increase conversion rate from 2.1% to 2.5% (+19% lift)
2. Improve CSAT from 6.5 to 8.0
Timeline: Within 6 weeks post-launch

Which approach aligns best with business goals?"

PM: "Option A - we need to focus on conversion"

Claude:
"Perfect. Let's add leading indicators to track progress early.

LEADING INDICATORS (Week 1-2):
These should predict if we'll hit our conversion goals:

1. Shipping step abandonment: 35% → 20% (target by week 2)
   - Rationale: Shipping is biggest drop-off point

2. Form field errors: 12% → <6% (target by week 1)
   - Rationale: Errors correlate with abandonment

3. Guest checkout adoption: 40% → 60% (target by week 2)
   - Rationale: Guest users convert better

4. Time at shipping step: 2.5min → <1min (target by week 1)
   - Rationale: Faster checkout = higher conversion

Would you like me to add these to the PRD?"
```

---

## Metric Templates by Feature Type

### Checkout Optimization

```yaml
primary_metrics:
  - metric: "Conversion Rate"
    current: "2.1%"
    target: "2.8%"
    minimum: "2.4%"
    stretch: "3.0%"
    timeline: "2 months"
    measurement: "PostHog funnel: cart_viewed → order_completed"

  - metric: "Abandonment Rate"
    current: "35%"
    target: "25%"
    minimum: "30%"
    stretch: "20%"
    timeline: "2 months"
    measurement: "PostHog: checkout_started - order_completed / checkout_started"

leading_indicators:
  - metric: "Shipping step errors"
    target: "<5%"
    timeline: "Week 1"

  - metric: "Time at shipping step"
    target: "<60 seconds"
    timeline: "Week 1"

validation_plan:
  - week_1: "10% rollout, monitor leading indicators"
  - week_2: "50% rollout if leading indicators hit targets"
  - week_4: "Full rollout"
  - week_8: "Evaluate primary metrics success"
```

### Search Feature

```yaml
primary_metrics:
  - metric: "Search Success Rate"
    definition: "% of searches resulting in click within 3 results"
    current: "45%"
    target: "65%"
    timeline: "6 weeks"

  - metric: "Zero Result Rate"
    definition: "% of searches returning no results"
    current: "15%"
    target: "<5%"
    timeline: "6 weeks"

leading_indicators:
  - metric: "Click-through rate on first result"
    target: ">40%"
    timeline: "Week 2"

  - metric: "Search refinement rate"
    definition: "% of users who search again after first search"
    target: "<30% (down from 50%)"
    timeline: "Week 2"
```

### Performance Improvement

```yaml
primary_metrics:
  - metric: "Largest Contentful Paint (LCP)"
    current: "4.2 seconds"
    target: "<2.5 seconds (Good per Core Web Vitals)"
    minimum: "<4.0 seconds"
    timeline: "1 month"

  - metric: "First Input Delay (FID)"
    current: "180ms"
    target: "<100ms (Good)"
    timeline: "1 month"

business_impact_metrics:
  - metric: "Bounce rate"
    hypothesis: "Better performance → lower bounce rate"
    current: "45%"
    target: "<35%"

  - metric: "Conversion rate"
    hypothesis: "1 second faster → +7% conversion"
    current: "2.1%"
    target: "2.25%"
```

---

## Success Criteria Validation

Use this checklist to validate metrics:

```
✅ Metric Quality Checklist

For each primary metric:
- [ ] Has clear definition (no ambiguity)
- [ ] Has current baseline (actual data, not estimate)
- [ ] Has specific target (number, not range)
- [ ] Has timeline (date or duration)
- [ ] Can be measured in PostHog (or specified tool)
- [ ] Aligns with business OKRs
- [ ] Is achievable (based on benchmarks)
- [ ] Owner is identified (who monitors this)

For leading indicators:
- [ ] Shows up faster than primary metrics (days/weeks not months)
- [ ] Is predictive of primary metric success
- [ ] Is actionable (team can influence it)
- [ ] Has clear target threshold

For measurement plan:
- [ ] PostHog events defined
- [ ] Dashboard created or specified
- [ ] Review cadence decided (daily/weekly)
- [ ] Success threshold defined (when to rollback)
- [ ] Decision criteria clear (when to proceed to next phase)
```

---

## PostHog Integration

### Auto-Generate Tracking Events

```python
# Given success criteria, suggest PostHog events

success_metric = "Reduce checkout abandonment from 35% to 25%"

suggested_events = [
  {
    "event": "checkout_started",
    "properties": {
      "user_id": "string",
      "cart_value": "number",
      "item_count": "number",
      "user_type": "first_time | returning"
    }
  },
  {
    "event": "checkout_step_completed",
    "properties": {
      "step": "shipping | payment | review",
      "duration": "milliseconds",
      "errors": "array"
    }
  },
  {
    "event": "checkout_abandoned",
    "properties": {
      "step": "string",
      "reason": "timeout | user_exit | error",
      "time_spent": "milliseconds"
    }
  },
  {
    "event": "order_completed",
    "properties": {
      "order_value": "number",
      "checkout_duration": "milliseconds",
      "user_type": "first_time | returning"
    }
  }
]

# Generate PostHog dashboard config
dashboard_query = """
SELECT
  COUNT(DISTINCT user_id) FILTER (WHERE event = 'checkout_started') as started,
  COUNT(DISTINCT user_id) FILTER (WHERE event = 'order_completed') as completed,
  1 - (completed::float / started) as abandonment_rate
FROM events
WHERE timestamp >= now() - interval '7 days'
GROUP BY date_trunc('day', timestamp)
ORDER BY day
"""
```

---

## Common Pitfalls to Avoid

### Pitfall 1: Too Many Metrics

```
❌ BAD:
"Success criteria:
1. Increase conversion
2. Reduce abandonment
3. Improve speed
4. Better UX
5. Higher satisfaction
6. More revenue
7. Lower support tickets"

✅ GOOD:
"Primary metrics (2):
1. Conversion rate: 2.1% → 2.8%
2. Checkout CSAT: 6.5 → 8.0

Secondary metrics:
- Abandonment rate (context for conversion)
- Support ticket rate (context for CSAT)"
```

### Pitfall 2: Vanity Metrics

```
❌ BAD:
"Increase page views by 50%"
(Doesn't tie to business value)

✅ GOOD:
"Increase engaged sessions (>2min, >2 pages) by 30%"
(Engagement tied to business outcomes)
```

### Pitfall 3: No Timeline

```
❌ BAD:
"Reduce load time to < 2 seconds"

✅ GOOD:
"Reduce load time from 4.2s to <2s within 6 weeks post-deployment"
```

### Pitfall 4: Unmeasurable

```
❌ BAD:
"Make users happier"

✅ GOOD:
"Improve CSAT score from 6.5 to 8.0 (measured via post-checkout survey)"
```

---

## Output Format

Generate success criteria in this format:

```markdown
## Success Criteria

### Primary Metrics (Choose when feature is successful)

1. **[Metric Name]**: [Current] → [Target] within [Timeline]
   - **Measurement**: [PostHog query or dashboard]
   - **Owner**: [PM/Engineering/Team]
   - **Review Cadence**: [Daily/Weekly]
   - **Success Threshold**: [Minimum acceptable result]
   - **Rationale**: [Why this metric matters]

2. **[Metric Name]**: [Current] → [Target] within [Timeline]
   - [Same structure]

### Secondary Metrics (Context and supporting data)

- **[Metric]**: [Target]
- **[Metric]**: [Target]

### Leading Indicators (Early signals of success)

1. **[Indicator]** (Week 1-2)
   - Target: [Value]
   - Predictive of: [Which primary metric]
   - Action if missed: [What team will do]

### Measurement Plan

**PostHog Setup**:
- Events: [List of events to track]
- Dashboard: [Link once created]
- Alerts: [When to notify team]

**Review Schedule**:
- Daily: First week post-launch (monitor leading indicators)
- Weekly: Weeks 2-4 (track primary metrics trend)
- Monthly: Long-term performance

**Decision Criteria**:
- **Proceed to 50% rollout**: If [leading indicators hit targets] in week 1
- **Proceed to 100% rollout**: If [primary metrics trending up] by week 2
- **Rollback**: If [abandonment increases >5pp] or [P0 bugs detected]

### Success Validation Timeline

```
Week 1: Leading indicators visible
Week 2: Early primary metric trends
Week 4: Primary metrics show clear signal
Week 8: Declare success or iterate
```

---

## Skill Behavior

### When to Activate

1. **Proactive**: Detect vague goals, immediately ask for specifics
2. **Requested**: PM asks about measurement or success
3. **Validation**: During PRD review, check if metrics are SMART

### Tone & Approach

- **Question-driven**: "What does 'better' mean in numbers?"
- **Data-grounded**: Pull current metrics from PostHog
- **Options-based**: Suggest 2-3 metric approaches, let PM choose
- **Benchmark-informed**: "Similar features see 20-30% lift"

---

## Examples

### Example 1: E-commerce Checkout

```
PM: "We want to improve checkout conversion"

Claude (success-criteria-builder):
"Let's define specific success metrics. Checking PostHog...

CURRENT PERFORMANCE:
- Conversion rate: 2.1%
- Abandonment: 35% (12,450 users/month)
- Revenue impact: ~$2M/year in lost sales

SUCCESS CRITERIA OPTIONS:

Option A: Aggressive (requires major changes)
- Conversion: 2.1% → 3.0% (+43% lift)
- Timeline: 3 months
- Benchmark: Top quartile for e-commerce

Option B: Realistic (incremental improvement)
- Conversion: 2.1% → 2.5% (+19% lift)
- Timeline: 6 weeks
- Benchmark: Industry median

Option C: Conservative (quick win)
- Conversion: 2.1% → 2.3% (+10% lift)
- Timeline: 2 weeks
- Benchmark: Minimal viable improvement

Which aligns with your scope and timeline?"

PM: "Option B sounds right"

Claude:
"Perfect. Here's your complete success criteria:

PRIMARY METRICS:
1. Conversion Rate: 2.1% → 2.5% (+19% lift) within 6 weeks
   - Measurement: PostHog funnel checkout_started → order_completed
   - Success threshold: Minimum 2.3% (10% lift)

2. Checkout CSAT: 6.5 → 8.0 within 6 weeks
   - Measurement: Post-purchase survey (NPS question)
   - Success threshold: Minimum 7.5

LEADING INDICATORS (Week 1):
- Shipping step abandonment: <20% (currently 35%)
- Form error rate: <5% (currently 12%)
- Time at shipping: <60s (currently 2.5min)

If leading indicators hit targets in week 1, strong signal that
conversion will improve by week 4-6.

Would you like me to generate the PostHog event tracking plan?"
```

---

## Success Metrics for This Skill

- **Adoption**: 90%+ of PRDs have SMART success criteria
- **Quality**: Success criteria completeness score 60 → 95+
- **Predictability**: Leading indicators correlate 80%+ with primary metrics
- **Measurement**: 100% of metrics trackable in PostHog

---

**This skill ensures every feature has measurable, achievable success criteria.**
