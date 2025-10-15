# Retrospective Analysis Command

## Purpose
Analyzes retrospective data to identify patterns, track action item completion, and generate insights for continuous improvement.

## Usage
```
/retrospective-analysis [--timeframe=sprint|quarter|year]
```

## Parameters
- `--timeframe`: Analysis period
  - `sprint`: Single sprint retrospective
  - `quarter`: Quarterly trends (default)
  - `year`: Annual patterns
- `--export`: Output format (markdown, presentation, csv)
- `--action-items`: Track action item completion

## Execution Flow

### 1. Data Collection
Gather retrospective data from:
- Past retrospective notes
- Action item tracking
- Sprint metrics
- Team surveys
- Incident reports

### 2. Pattern Recognition
Identify recurring themes:
- Frequently mentioned strengths
- Repeated pain points
- Common improvement areas
- Cyclical issues

### 3. Action Item Analysis
**Track action items:**
- Completion rate
- Time to complete
- Impact measurement
- Abandoned items

### 4. Trend Analysis
**Delegates to:** metrics-reporter subagent

Correlate retrospective themes with:
- Velocity trends
- Quality metrics
- Team morale
- Deployment frequency

### 5. Generate Insights

```
RETROSPECTIVE ANALYSIS
======================
Period: Q3 2025 (6 sprints)
Team: Backend API

EXECUTIVE SUMMARY
-----------------
Action Completion:   68% (17/25 items)
Top Theme:          Code review process (5/6 sprints)
Biggest Win:        Automated testing (+25% coverage)
Key Challenge:      Meeting overhead (4/6 sprints)

RECURRING THEMES
----------------

🟢 Strengths (Mentioned 3+ times):
1. Team Collaboration (6/6 sprints) ⭐
   "Great pair programming"
   "Helpful code reviews"
   "Knowledge sharing improved"

2. Deployment Pipeline (5/6 sprints)
   "Fast deployments"
   "CI/CD reliability excellent"

3. Technical Quality (4/6 sprints)
   "Good test coverage"
   "Clean code reviews"

🔴 Pain Points (Mentioned 3+ times):
1. Code Review Delays (5/6 sprints) ⚠️
   "PRs sit for days"
   "Blocking progress"
   "Need faster turnaround"

2. Meeting Overhead (4/6 sprints) ⚠️
   "Too many meetings"
   "Interrupting flow"
   "Need focus time"

3. Unclear Requirements (4/6 sprints) ⚠️
   "Requirements change mid-sprint"
   "Missing acceptance criteria"
   "Rework needed"

🟡 Improvement Areas (Mentioned 3+ times):
1. Documentation (4/6 sprints)
   "API docs outdated"
   "Need architecture diagrams"

2. Testing Strategy (3/6 sprints)
   "E2E tests flaky"
   "Need better integration tests"

ACTION ITEM TRACKER
-------------------
Total Created:      25 items
Completed:          17 (68%)
In Progress:        5 (20%)
Abandoned:          3 (12%)

Completed Actions (Highest Impact):
✅ "Implement PR size limits" (Sprint 42)
   Impact: Avg PR size down 40%, review time down 25%

✅ "Add test coverage gates" (Sprint 43)
   Impact: Coverage increased from 65% to 82%

✅ "Weekly tech talks" (Sprint 41)
   Impact: Knowledge sharing up, onboarding faster

✅ "Dedicated focus time blocks" (Sprint 44)
   Impact: Developer satisfaction +15%

In Progress:
🔄 "Reduce meeting time by 20%" (Sprint 46)
   Status: Cancelled 2 recurring meetings, WIP

🔄 "Improve requirements process" (Sprint 45)
   Status: Template created, adoption ongoing

Abandoned (Why):
❌ "Migrate to new testing framework" (Sprint 42)
   Reason: Too much effort, low ROI

❌ "Implement mob programming" (Sprint 41)
   Reason: Team preference for pairing

SENTIMENT ANALYSIS
------------------
Overall Mood Trend: 📈 IMPROVING

Sprint 40: 😐 Neutral (Velocity down, bugs up)
Sprint 41: 🙂 Positive (Good sprint)
Sprint 42: 😐 Neutral (Scope creep)
Sprint 43: 🙂 Positive (Tests improving)
Sprint 44: 😃 Very Positive (Great sprint!)
Sprint 45: 🙂 Positive (Focus time helping)

Correlation: Higher sentiment when:
  - Velocity stable or increasing
  - Clear sprint goals
  - Minimal scope changes
  - Action items completed

IMPACT ANALYSIS
---------------

Improvement Actions Taken:
1. PR Size Limits (Sprint 42)
   Before: Avg 450 LOC, 18h review time
   After:  Avg 180 LOC, 8h review time
   Impact: 🟢 SUCCESS

2. Test Coverage Gates (Sprint 43)
   Before: 65% coverage, 8 bugs/sprint
   After:  82% coverage, 3 bugs/sprint
   Impact: 🟢 SUCCESS

3. Focus Time Blocks (Sprint 44)
   Before: 12 context switches/day
   After:  6 context switches/day
   Impact: 🟢 SUCCESS

4. Improve Requirements (Sprint 45)
   Before: 40% rework rate
   After:  40% rework rate (no change yet)
   Impact: 🟡 IN PROGRESS

PATTERN INSIGHTS
----------------

⚠️  Code Review Issue (Recurring):
   - Mentioned 5 out of 6 sprints
   - Action items: 3 created, 1 completed
   - Recent completion: PR size limits helped
   - Remaining gap: Still delays on larger PRs

Recommendation:
   - Assign dedicated review time (2h/day)
   - Review rotation schedule
   - SLA: First review within 4 hours

✅ Testing Momentum (Positive):
   - Coverage improved 65% → 82%
   - Bug count reduced 60%
   - Action item completion: 100%

Recommendation:
   - Continue focus on test quality
   - Next: Improve E2E test stability

⚠️  Requirements Clarity (Ongoing):
   - 4 mentions, limited progress
   - Multiple action items, mixed results

Recommendation:
   - Escalate to product management
   - Implement story refinement session
   - Add DoD checklist

CROSS-TEAM PATTERNS
-------------------
(Comparing with other teams):

Common Strengths:
  - Deployment automation (3/3 teams)
  - Team collaboration (3/3 teams)

Common Pain Points:
  - Meeting overhead (3/3 teams)
  - Requirements clarity (2/3 teams)

Unique to Backend API:
  - Code review delays (only this team)

Recommendation: Backend team needs dedicated
review time or additional reviewers.

VELOCITY CORRELATION
--------------------
Sprints with high morale:    48 pts avg velocity
Sprints with low morale:     42 pts avg velocity

Difference: 6 points (14%)

Morale Drivers:
  ✅ Clear sprint goals
  ✅ Action items completed
  ✅ Minimal blockers
  ❌ Scope changes
  ❌ Meeting overload

RECOMMENDATIONS
---------------

🎯 HIGH PRIORITY:

1. Resolve Code Review Delays
   - Implement review rotation
   - Set 4-hour SLA for first review
   - Track and report review metrics
   Expected Impact: +10% velocity

2. Improve Requirements Process
   - Mandatory refinement session
   - Acceptance criteria template
   - Product owner attendance required
   Expected Impact: -50% rework, +8% velocity

3. Optimize Meeting Schedule
   - Audit all recurring meetings
   - Combine or eliminate low-value meetings
   - Target: 20% reduction
   Expected Impact: +5% velocity, +morale

🎯 MEDIUM PRIORITY:

4. Documentation Sprint
   - Allocate 1 sprint for doc catchup
   - Create architecture diagrams
   - Update API documentation

5. E2E Test Stability
   - Identify flaky tests
   - Implement retry logic
   - Fix or quarantine unstable tests

NEXT RETROSPECTIVE FOCUS
-------------------------
Monitor these themes:
  ✅ Code review turnaround time
  ✅ Meeting reduction progress
  ✅ Requirements clarity improvement

Celebrate wins:
  🎉 Test coverage achievement
  🎉 Deployment pipeline reliability

QUARTERLY GOALS
---------------
Based on retrospective trends:

Q4 2025 Improvement Goals:
1. Reduce code review time to 6h average
2. Eliminate requirements rework (<20%)
3. Reduce meeting time by 20%
4. Maintain 85%+ test coverage
5. Complete 80%+ of action items

Success Metrics:
  - Velocity: 48+ points
  - Morale: "Very Positive" majority
  - Action completion: 80%+
```

## Analysis Categories

### Theme Tracking
- **Strengths**: What's working well
- **Pain Points**: Recurring problems
- **Improvements**: Areas to enhance
- **Kudos**: Individual/team recognition

### Action Item Tracking
- **Created**: New commitments
- **Completed**: Finished items
- **In Progress**: Work underway
- **Abandoned**: Cancelled items and why

### Sentiment Analysis
- **Team Morale**: Positive/negative trends
- **Frustration Points**: Pain areas
- **Celebration**: Wins and successes

### Correlation Analysis
- **Velocity**: Impact on delivery
- **Quality**: Bug rates, incidents
- **Satisfaction**: Team happiness

## Output Formats

### Summary
```
Q3 Retrospectives: 6 sprints
Action Completion: 68%
Top Theme: Code reviews
Trend: Improving
```

### Detailed Analysis (markdown)
Comprehensive retrospective analysis

### Presentation (slides)
Executive summary for leadership review

### Action Tracker (csv)
```csv
Action,Sprint,Owner,Status,Impact
PR size limits,42,Team,Completed,High
```

## Examples

### Sprint Retrospective
```
/retrospective-analysis --timeframe=sprint

SPRINT 47 RETROSPECTIVE
-----------------------
What Went Well:
  - Excellent sprint, hit all commitments
  - Great collaboration with frontend team

What to Improve:
  - Two PRs blocked for >24h
  - Requirements changed mid-sprint

Actions:
  - Set up review rotation (Owner: Alice)
  - Improve refinement process (Owner: PM)
```

### Quarterly Trends
```
/retrospective-analysis --timeframe=quarter

Q3 RETROSPECTIVE TRENDS
-----------------------
Most Common Theme: Code reviews (5/6)
Action Completion: 68%
Velocity Trend: Improving (+8%)
Morale: Positive and improving

Recommendation: Focus on review process
```

### Action Item Report
```
/retrospective-analysis --action-items

ACTION ITEM COMPLETION REPORT
------------------------------
Total: 25 items
Completed: 17 (68%)
Avg Time: 2.3 sprints

Highest Impact:
✅ PR size limits (-40% review time)
✅ Test coverage gates (+25% coverage)
```

## Best Practices

1. **Track Consistently**: Document every retrospective
2. **Follow Through**: Actually complete action items
3. **Measure Impact**: Quantify improvements
4. **Celebrate Wins**: Recognize progress
5. **Address Patterns**: Don't ignore recurring issues
6. **Close the Loop**: Report on previous action items
7. **Keep it Safe**: Maintain psychological safety
