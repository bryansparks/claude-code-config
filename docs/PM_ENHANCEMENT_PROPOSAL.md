# PM Persona Enhancement Proposal

**Version**: 1.0
**Date**: 2025-11-13
**Focus**: Precision Requirements & AI-Powered Ideation

---

## 🎯 Problem Statement

Product Managers using Claude Code face unique challenges:

1. **Precision Gap**: PMs often start with vague ideas ("make checkout better") but need precise requirements ("reduce guest checkout abandonment by 15% via 3-click flow")

2. **Solution Blindness**: Traditional PM training focuses on problem definition, but AI opens entirely new solution spaces that PMs may not consider

3. **Success Ambiguity**: "Feature is successful" needs to mean something measurable, testable, and time-bound

4. **Requirements Completeness**: Hard to know if you've thought through all edge cases, dependencies, and implications

5. **AI Opportunity Blindness**: PMs may not recognize where AI/ML could transform a solution

---

## 🚀 Proposed Solution: Two-Tier Enhancement

### Tier 1: Auto-Invoked Skills (Intelligent Assistance)

Skills that **automatically activate** when Claude detects specific PM workflows.

#### Skill 1: `prd-guide` - Interactive PRD Creation Assistant

**Triggers when:**
- PM starts writing a PRD or requirements doc
- PM mentions "write requirements" or "create PRD"
- PM opens a file named `*-requirements.md` or `*-prd.md`

**What it does:**
- Guides PM through structured PRD sections step-by-step
- Asks clarifying questions at each stage
- Validates completeness before moving forward
- Suggests sections PM may have forgotten

**Example interaction:**
```
PM: "I need to write a PRD for guest checkout"

Claude (auto-activates prd-guide):
"I'll help you create a comprehensive PRD. Let's start with the problem statement.

1. What specific problem are we solving?
2. Who experiences this problem? (user personas)
3. How do we know this is a problem? (data/metrics)
4. What happens if we don't solve it?

Let me know when you've answered these, and we'll move to goals and success criteria."
```

---

#### Skill 2: `success-criteria-builder` - Measurable Success Definition

**Triggers when:**
- PM writes goals without metrics
- PM uses vague success language ("improve", "better", "faster")
- PM asks "how do we measure success?"

**What it does:**
- Converts vague goals into SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound)
- Suggests appropriate metrics based on feature type
- Helps PM define leading vs lagging indicators
- Creates testable hypotheses

**Example interaction:**
```
PM: "Goal: Improve the checkout experience"

Claude (auto-activates success-criteria-builder):
"Let's make this measurable. Here's what I suggest:

Instead of "improve checkout experience", let's define:

SUCCESS CRITERIA (Pick 2-3):
1. Reduce checkout abandonment from 35% to 25% within 3 months
2. Increase conversion rate from 2.1% to 2.8%
3. Decrease average checkout time from 4min to 2min
4. Improve CSAT score for checkout from 6.5 to 8.0

LEADING INDICATORS (Early signals):
- Reduced form field errors (-30% in week 1)
- Increased guest checkout adoption (+15% in week 2)

Which metrics align best with your business goals?"
```

---

#### Skill 3: `ai-solution-ideation` - AI-Powered Solution Explorer

**Triggers when:**
- PM describes a problem or feature concept
- PM asks "how could we build this?"
- PM mentions manual/repetitive tasks

**What it does:**
- Analyzes the problem space
- Suggests AI/ML solutions PM might not consider
- Explains trade-offs of different approaches
- Shows examples from other products
- Estimates feasibility and complexity

**Example interaction:**
```
PM: "Users are frustrated finding relevant products in our catalog"

Claude (auto-activates ai-solution-ideation):
"I see an opportunity for AI here. Let me explore solution possibilities:

TRADITIONAL APPROACHES:
1. Better filtering/facets
2. Improved search keywords
3. Category reorganization

AI-POWERED SOLUTIONS:
1. **Semantic Search**: Understand intent ("red dress for wedding") not just keywords
   - Complexity: Medium
   - Impact: High (40-60% better relevance)
   - Examples: Shopify, Etsy

2. **Personalized Recommendations**: ML-based "You might like"
   - Complexity: High
   - Impact: Very High (2-3x engagement)
   - Data needed: 6 months user behavior

3. **Visual Search**: Upload photo, find similar products
   - Complexity: High
   - Impact: Medium (niche use case)
   - Examples: Pinterest, ASOS

4. **Conversational Product Finder**: AI chat to narrow choices
   - Complexity: Medium (using GPT-4)
   - Impact: High (reduces time to purchase)
   - NEW POSSIBILITY with modern LLMs

Would you like me to detail any of these approaches?"
```

---

#### Skill 4: `requirements-refiner` - Precision Improvement

**Triggers when:**
- Claude detects vague or incomplete requirements
- PM uses ambiguous language ("fast", "easy", "simple")
- Requirements lack acceptance criteria

**What it does:**
- Identifies vague language and asks for specifics
- Suggests missing requirements (security, accessibility, performance)
- Validates completeness against checklist
- Helps PM think through edge cases

**Example interaction:**
```
PM writes: "The form should be fast and easy to use"

Claude (auto-activates requirements-refiner):
"I notice some vague requirements. Let's make these precise:

VAGUE: "form should be fast"
SPECIFIC OPTIONS:
- Form renders in < 500ms
- Form submits in < 2s
- Real-time validation completes in < 100ms per field

Which performance metrics matter for this form?

VAGUE: "easy to use"
SPECIFIC OPTIONS:
- Maximum 5 form fields
- Passes WCAG 2.1 AA (accessibility)
- 90%+ users complete without errors
- Average completion time < 2 minutes

What does "easy" mean in this context?"
```

---

### Tier 2: New Slash Commands (Explicit Tools)

Commands PMs invoke explicitly for specific workflows.

#### Command 1: `/create-prd-interactive`

**Purpose**: Wizard-style PRD creation with step-by-step guidance

**Usage:**
```bash
/create-prd-interactive [feature-name]
```

**What it does:**
- Interactive Q&A session through all PRD sections
- Validates each section before moving forward
- Uses MCP servers (Figma, PostHog, Linear) to pull context
- Generates comprehensive PRD at the end

**Workflow:**
```
Step 1: Problem Definition
├─ What problem are we solving?
├─ Who has this problem?
├─ How severe is it? (data/metrics)
└─ What if we don't solve it?

Step 2: Goals & Success Criteria
├─ What are we trying to achieve?
├─ How will we measure success?
├─ What's the timeline?
└─ What's out of scope?

Step 3: User Research
├─ Which personas are affected?
├─ What are their goals?
├─ What are their pain points?
└─ What have they told us? (feedback)

Step 4: Solution Exploration
├─ What solutions have we considered?
├─ Why this approach?
├─ What are the alternatives?
└─ Are there AI opportunities?

Step 5: Requirements
├─ Functional requirements
├─ Non-functional requirements
├─ Acceptance criteria
└─ Edge cases

Step 6: Technical Feasibility
├─ Dependencies
├─ Risks
├─ Constraints
└─ Effort estimate

Step 7: Go-to-Market
├─ Launch plan
├─ Success metrics tracking
├─ Rollout strategy
└─ Communication plan
```

---

#### Command 2: `/define-success-criteria`

**Purpose**: Create measurable success metrics for features

**Usage:**
```bash
/define-success-criteria [feature-name]
```

**What it does:**
- Analyzes feature type
- Suggests relevant metric categories
- Helps PM choose 2-3 primary metrics
- Defines leading indicators
- Creates measurement plan

**Output:**
```markdown
# Success Criteria: [Feature Name]

## Primary Success Metrics (Pick 2-3)
1. **Conversion Rate**: Increase from X% to Y% within Z weeks
2. **User Engagement**: Increase from X to Y sessions/user/week
3. **Revenue Impact**: Generate $X in incremental revenue

## Secondary Metrics
- Time to complete task
- Error rate
- Support ticket reduction

## Leading Indicators (Early Signals)
- Week 1: Feature adoption rate
- Week 2: User feedback sentiment
- Week 3: Completion rate trends

## Measurement Plan
- **Tracking**: PostHog events: feature_started, feature_completed
- **Dashboard**: [Link to PostHog dashboard]
- **Review Cadence**: Weekly for 1 month, then monthly
- **Success Threshold**: 2 of 3 primary metrics hit targets

## Validation Plan
- A/B test: 10% rollout week 1
- Expand to 50% if metrics positive week 2
- Full rollout week 3 if validated
```

---

#### Command 3: `/ideate-solutions`

**Purpose**: AI-powered brainstorming of solution approaches

**Usage:**
```bash
/ideate-solutions [problem-description]
```

**What it does:**
- Analyzes the problem
- Generates 5-8 solution approaches
- Categorizes by complexity and impact
- Highlights AI/ML opportunities
- Provides examples from other products

**Output:**
```markdown
# Solution Ideation: [Problem]

## Problem Analysis
[Claude's understanding of the problem]

## Solution Approaches

### 1. Traditional UX Improvement (Low Complexity, Medium Impact)
- **Approach**: [Description]
- **Pros**: [List]
- **Cons**: [List]
- **Effort**: 2 weeks
- **Example**: Airbnb checkout

### 2. AI-Powered Personalization (High Complexity, High Impact)
- **Approach**: Use ML to personalize flow based on user behavior
- **Pros**: 40-60% better conversion, adaptive over time
- **Cons**: Requires data, complex to maintain
- **Effort**: 2 months
- **Example**: Amazon checkout
- **AI Details**: Recommend payment method, shipping, prefill based on patterns

### 3. Conversational Assistant (Medium Complexity, High Impact) ⭐ NEW
- **Approach**: AI chatbot guides user through checkout
- **Pros**: Handles edge cases, reduces support, personalized help
- **Cons**: Requires LLM integration, needs guardrails
- **Effort**: 3-4 weeks
- **Example**: Shopify Sidekick
- **AI Details**: GPT-4 based, context-aware, can handle "I'm stuck"

## Recommended Approach
[Claude's recommendation with rationale]

## Next Steps
1. Validate solution with users
2. Technical feasibility assessment
3. Prototype and test
```

---

#### Command 4: `/validate-requirements`

**Purpose**: Comprehensive requirements completeness check

**Usage:**
```bash
/validate-requirements [file-path or feature-name]
```

**What it does:**
- Scans requirements for vague language
- Checks for missing sections
- Validates acceptance criteria
- Ensures success metrics exist
- Identifies edge cases not covered

**Output:**
```markdown
# Requirements Validation Report

## Overall Score: 72/100

## ✅ Strengths
- Clear problem statement
- Well-defined user personas
- SMART success criteria

## ⚠️ Issues Found

### Critical (Must Fix)
1. **Missing Non-Functional Requirements**
   - No performance requirements specified
   - Security requirements unclear
   - Accessibility not mentioned

2. **Vague Acceptance Criteria**
   - "Form should be fast" → Define: < 500ms render time?
   - "Easy to use" → Specify: WCAG 2.1 AA compliance?

### Medium Priority
3. **Incomplete Edge Cases**
   - What happens if API timeout occurs?
   - How do we handle duplicate submissions?
   - What's the error recovery flow?

4. **Missing Dependencies**
   - Payment gateway integration dependency not mentioned
   - Requires email service configuration

### Low Priority
5. **Documentation**
   - Add diagrams for user flows
   - Link to Figma designs

## Recommendations
1. Add performance requirements: page load, API response times
2. Specify accessibility: WCAG 2.1 AA minimum
3. Document all edge cases with Given/When/Then
4. Add dependency list with owners

## Completeness Checklist
- [x] Problem statement
- [x] User personas
- [x] Success criteria
- [ ] Non-functional requirements (MISSING)
- [ ] Edge cases documented (INCOMPLETE)
- [x] Acceptance criteria
- [ ] Dependencies listed (MISSING)
- [x] Risks identified
```

---

#### Command 5: `/explore-ai-features`

**Purpose**: Specifically explore how AI/ML could enhance a feature

**Usage:**
```bash
/explore-ai-features [feature-description]
```

**What it does:**
- Analyzes feature for AI opportunities
- Suggests specific AI capabilities
- Estimates feasibility and data requirements
- Provides implementation guidance
- Shows cost/benefit analysis

**Output:**
```markdown
# AI Enhancement Opportunities: [Feature]

## Feature Analysis
Current approach: [Traditional solution]
User pain points: [List]

## AI/ML Opportunities

### 1. Predictive Text & Autocomplete
**What**: ML-powered suggestions as user types
**Benefit**: 30-40% faster form completion
**Complexity**: Low (use existing APIs)
**Data Required**: None (pretrained models)
**Cost**: ~$0.01 per 1000 requests
**Example**: Google Places API
**Implementation**: 1 week

### 2. Intelligent Form Prefill
**What**: ML predicts and prefills likely values
**Benefit**: 50% reduction in fields user must complete
**Complexity**: Medium (custom ML model)
**Data Required**: 6 months historical form data
**Cost**: ~$500/month inference
**Example**: Stripe Radar
**Implementation**: 6-8 weeks

### 3. Fraud Detection
**What**: Real-time ML fraud scoring
**Benefit**: 90% fraud reduction, <1% false positives
**Complexity**: High (if custom) or Low (if vendor)
**Data Required**: Transaction history
**Cost**: $0.05-0.10 per transaction (vendor)
**Example**: Stripe Radar, Sift
**Implementation**: 2 weeks (vendor) or 3 months (custom)

### 4. Conversational Form Filling (NEW!)
**What**: Chat interface powered by GPT-4 to collect info
**Benefit**: Handles complex cases, reduces abandonment
**Complexity**: Medium (LLM integration)
**Data Required**: None (prompt engineering)
**Cost**: ~$0.02 per conversation
**Example**: Intercom Fin
**Implementation**: 3-4 weeks

## Recommended Prioritization
1. **Quick Win**: Predictive text (1 week, low cost, proven benefit)
2. **High Impact**: Conversational form (new capability, differentiator)
3. **Long-term**: Intelligent prefill (requires data collection first)

## Implementation Roadmap
**Phase 1 (Month 1)**: Predictive text integration
**Phase 2 (Month 2-3)**: Conversational form prototype
**Phase 3 (Month 4-6)**: ML prefill model development

## Success Metrics
- Form completion time: -40%
- Abandonment rate: -25%
- Error rate: -60%
- User satisfaction: +2 points NPS
```

---

## 📊 Integration with Existing PM Workflow

### How Skills Work Together

```
PM starts working → Skills auto-activate based on context

Example Flow:
1. PM: "Write PRD for guest checkout"
   ├─ [prd-guide activates] → Guides through sections
   └─ [success-criteria-builder activates] → Helps define metrics

2. PM: "The checkout should be fast and easy"
   └─ [requirements-refiner activates] → "Let's make this specific..."

3. PM: "Users struggle to find the right shipping option"
   └─ [ai-solution-ideation activates] → "Have you considered ML recommendations?"

4. PM runs: /validate-requirements
   └─ [requirements-refiner activates] → Full completeness check
```

### Integration with MCP Servers

**Figma MCP:**
- Auto-pull design specs during PRD creation
- Reference designs in requirements
- Generate user stories from Figma frames

**PostHog MCP:**
- Pull actual usage data for problem validation
- Suggest metrics based on existing events
- Show historical performance for similar features

**Linear MCP:**
- Create issues directly from PRD sections
- Link requirements to backlog items
- Auto-populate effort estimates

**Memory MCP:**
- Remember PM's preferred PRD format
- Store successful patterns and templates
- Recall past decisions and rationale

---

## 🎯 Expected Outcomes

### For PMs:
1. **30-50% faster PRD creation** (guided workflows)
2. **Higher quality requirements** (validation & precision)
3. **Better decision making** (data-driven, AI-aware)
4. **Reduced back-and-forth** (complete requirements upfront)

### For Engineering Teams:
1. **Clearer requirements** (less ambiguity)
2. **Better scoped work** (edge cases considered)
3. **Measurable success** (know when "done")
4. **AI opportunities identified** (don't miss innovation)

### For Business:
1. **Faster time to market** (less rework)
2. **Better feature ROI** (data-driven prioritization)
3. **Innovation advantage** (AI-first thinking)
4. **Reduced technical debt** (better upfront planning)

---

## 📅 Implementation Plan

### Phase 1: Core Skills (Week 1-2)
- [x] Analyze current PM persona
- [ ] Implement `prd-guide` skill
- [ ] Implement `success-criteria-builder` skill
- [ ] Implement `requirements-refiner` skill
- [ ] Testing and refinement

### Phase 2: AI Ideation (Week 3)
- [ ] Implement `ai-solution-ideation` skill
- [ ] Implement `/explore-ai-features` command
- [ ] Implement `/ideate-solutions` command

### Phase 3: Interactive Tools (Week 4)
- [ ] Implement `/create-prd-interactive` command
- [ ] Implement `/define-success-criteria` command
- [ ] Implement `/validate-requirements` command

### Phase 4: Documentation & Training (Week 5)
- [ ] Create PM Skills guide
- [ ] Update PM persona documentation
- [ ] Create workflow examples
- [ ] Record demo videos

---

## 📚 Skills vs Commands: When to Use What

### Use Auto-Invoked Skills When:
- PM is actively writing (real-time assistance)
- Detecting vague/incomplete work
- Offering proactive suggestions
- Continuous guidance needed

### Use Slash Commands When:
- Explicit workflow initiation (/create-prd-interactive)
- Validation checkpoints (/validate-requirements)
- Structured ideation sessions (/ideate-solutions)
- One-time analysis (/explore-ai-features)

---

## 🔬 Success Metrics for This Enhancement

**Adoption Metrics:**
- 80%+ PMs use at least one new skill per week
- 50%+ PRDs created with /create-prd-interactive
- Average 3+ validations per PRD with /validate-requirements

**Quality Metrics:**
- PRD completeness score: 70 → 90+ (measured by validator)
- Requirements precision score: 60 → 85+
- AI opportunities identified: 0 → 2+ per feature

**Efficiency Metrics:**
- Time to create PRD: 4 hours → 2 hours
- Eng clarification requests: 8 per PRD → 2 per PRD
- Rework cycles: 3 → 1

---

**Next Steps**: Review proposal → Implement Phase 1 Skills → Get PM feedback → Iterate

