# Sprint Planning Command

## Purpose
Assists with sprint planning by analyzing capacity, velocity, backlog, dependencies, and providing data-driven recommendations for sprint commitment.

## Usage
```
/sprint-planning [--sprint-number=N] [--team=name]
```

## Parameters
- `--sprint-number`: Sprint number (defaults to next sprint)
- `--team`: Team name (defaults to current team)
- `--days`: Sprint length in days (defaults to 10)
- `--export`: Export plan (markdown, jira, linear)

## Execution Flow

### 1. Capacity Planning
**Delegates to:** metrics-reporter subagent

Calculate available capacity:
- Team size and sprint days
- Planned time off / holidays
- On-call rotation impact
- Meetings and ceremonies
- Tech debt allocation

### 2. Velocity Analysis
**Delegates to:** metrics-reporter subagent

Analyze historical velocity:
- Last 6 sprints average
- Recent trend (improving/declining)
- Predictability (standard deviation)
- Seasonality factors

### 3. Backlog Analysis
Review candidate stories:
- Priority and business value
- Estimation accuracy
- Dependencies
- Prerequisites
- Risk factors

### 4. Dependency Check
**Delegates to:** team-coordinator subagent

Identify:
- Cross-team dependencies
- External dependencies
- Blocked items
- Prerequisite work

### 5. Risk Assessment
Evaluate sprint risks:
- Unknowns and complexity
- Team member experience
- External dependencies
- Technical debt impact

### 6. Generate Plan

```
SPRINT PLANNING ASSISTANT
=========================
Sprint: 48
Duration: Oct 7-18 (10 working days)
Team: Backend API (5 developers)

CAPACITY ANALYSIS
-----------------
Team Capacity:       50 person-days
Adjustments:
  - Time Off:        -5 days (Alice vacation)
  - On-Call:         -2 days (15% reduced capacity)
  - Meetings:        -3 days (standups, ceremonies)
  - Tech Debt:       -8 days (20% allocation)

Available Capacity:  32 person-days
Recommended Points:  45-50 points

VELOCITY INSIGHTS
-----------------
6-Sprint Average:    45 points
Recent Velocity:     48 points (last 3 sprints)
Trend:               ↑ IMPROVING (+8%)
Predictability:      HIGH (σ=3.2)

Conservative:        42 points (90% confidence)
Realistic:           45 points (75% confidence)
Optimistic:          48 points (50% confidence)

RECOMMENDATION: Commit to 45 points

SPRINT GOAL CANDIDATES
----------------------
Option 1: "Launch User Dashboard API"
  - Stories: #123, #124, #125, #126
  - Total: 42 points
  - Risk: LOW
  - Dependencies: None
  - Business Value: HIGH
  ✅ RECOMMENDED

Option 2: "Real-time Notifications"
  - Stories: #130, #131, #132
  - Total: 48 points
  - Risk: MEDIUM (new technology)
  - Dependencies: Infrastructure team (WebSocket support)
  - Business Value: MEDIUM
  ⚠️  RISKY - dependency not confirmed

BACKLOG RECOMMENDATION
----------------------
Priority 1 (Must Have - 32 points):
  ✅ #123: User dashboard endpoint (8 pts)
  ✅ #124: Dashboard data aggregation (13 pts)
  ✅ #125: Dashboard caching layer (8 pts)
  ✅ #126: Dashboard API tests (3 pts)

Priority 2 (Should Have - 13 points):
  🎯 #127: Performance optimization (5 pts)
  🎯 #128: Error handling improvements (3 pts)
  🎯 #129: API documentation (5 pts)

Priority 3 (Nice to Have - 8 points):
  💡 #140: Refactor user service (8 pts)

TOTAL COMMITMENT: 45 points
  - P1: 32 points (minimum viable sprint)
  - P2: 13 points (complete goal)

DEPENDENCIES & RISKS
--------------------
✅ No blocking dependencies identified

Risks:
  ⚠️  Alice on vacation days 6-10
      Mitigation: Front-load her critical work

  ⚠️  New caching approach (story #125)
      Mitigation: Spike in first 2 days

  ℹ️  Dashboard design may need iteration
      Mitigation: Early UX review scheduled

TEAM DISTRIBUTION
-----------------
Alice (before vacation):  10 points (#123, #127)
Bob:                     12 points (#124, #128)
Carol:                   11 points (#125, #129)
Dave:                     9 points (#126, #140)
Eve:                      3 points (#126 pair)

Load Balance:            ✅ BALANCED (σ=1.2)

TECHNICAL DEBT ALLOCATION
-------------------------
Allocated: 8 days (20% of capacity)

Recommended Items:
  1. Payment service tests (5 days) - CRITICAL
  2. Update deprecated endpoints (3 days) - HIGH

COMPARISON TO LAST SPRINT
--------------------------
                Last Sprint  Planned  Change
Commitment           50         45     -10%
Capacity            38         32     -16%
Team Members         5          5       0%
Debt Allocation     15%        20%    +33%

Note: Lower capacity due to vacation + increased
debt focus per retrospective action item.

SPRINT SCHEDULE
---------------
Week 1 (Oct 7-11):
  Mon: Sprint planning, kickoff #123, #124
  Tue: Caching spike (#125), continue dev
  Wed: Development, early UX review
  Thu: Complete #123, #124 50% done
  Fri: Alice hands off work (vacation starts)

Week 2 (Oct 14-18):
  Mon: Holiday (Columbus Day) - No work
  Tue: Complete #124, #125
  Wed: #126 testing, #127-129 progress
  Thu: Code reviews, integration testing
  Fri: Sprint review, retrospective

RECOMMENDATIONS
---------------
1. ✅ Commit to 45 points (Sprint Goal #1)
2. ✅ Front-load Alice's work (days 1-5)
3. ✅ Schedule caching spike Tuesday morning
4. ✅ Allocate 8 days to payment tests (debt)
5. ⚠️  Monitor #125 closely (new approach)
6. ⚠️  Have backup plan if #124 slips

SUCCESS CRITERIA
----------------
✅ Complete all Priority 1 stories (32 points minimum)
✅ Ship user dashboard API to production
✅ Achieve 85%+ test coverage on new code
✅ Complete payment service test suite
✅ Zero P0/P1 bugs introduced
```

## Planning Considerations

### Capacity Factors
- **Time off**: Vacations, sick days, holidays
- **On-call**: ~15-20% capacity reduction
- **Meetings**: Standups, planning, retrospectives
- **Context switching**: 10-15% overhead
- **Tech debt**: 15-20% recommended allocation
- **Learning**: New technologies reduce capacity

### Velocity Predictability
- **High** (σ < 5): Can commit aggressively
- **Medium** (σ 5-10): Conservative estimates
- **Low** (σ > 10): Focus on improving consistency

### Story Selection Criteria
1. **Aligned with sprint goal**: Coherent objective
2. **Right-sized**: Fits in sprint with buffer
3. **Well-estimated**: Team confidence in estimates
4. **Minimal dependencies**: Or dependencies confirmed
5. **Value-driven**: High business/technical value

### Risk Mitigation
- **Unknown complexity**: Add spikes or buffer
- **New technology**: Pair programming, time-boxing
- **Dependencies**: Get commitments in writing
- **Key person risk**: Cross-training, pairing

## Output Formats

### Planning Summary
```
Sprint 48: 45 points committed
Goal: Launch User Dashboard API
Capacity: 32 person-days
Risks: 2 medium, 0 high
```

### Detailed Plan (markdown)
Full planning document with all sections

### Jira/Linear Export
Automatically update sprint backlog

## Examples

### Basic Planning
```
/sprint-planning

Analyzing team capacity and backlog...

Recommended Commitment: 45 points
Sprint Goal: "Launch User Dashboard API"
Risk Level: LOW
Confidence: 75%
```

### With Constraints
```
/sprint-planning --days=8 --team=backend

Analyzing 8-day sprint for backend team...

Adjusted Capacity: 28 person-days
Recommended: 38-42 points (shorter sprint)

Note: 8-day sprint due to holiday week
```

### Export to Jira
```
/sprint-planning --export=jira

Creating Sprint 48 in Jira...

✅ Sprint created
✅ Added 12 stories (45 points)
✅ Set sprint goal
✅ Assigned work distribution

View in Jira: https://company.atlassian.net/sprint/48
```

## Integration Points

### Data Sources
- Historical velocity (Jira/Linear/GitHub)
- Team calendar (Google Calendar, Outlook)
- On-call schedule (PagerDuty, Opsgenie)
- Dependency tracking (project boards)

### Subagents Used
- metrics-reporter: Velocity and capacity analysis
- team-coordinator: Dependency identification
- technical-debt-assessor: Debt prioritization

## Automation

### Auto-Planning
```yaml
sprint-start:
  - run: /sprint-planning --export=markdown
  - notify: slack:#engineering
  - schedule-ceremonies: true
```

## Configuration

`.claude/engineering-manager/sprint-planning.yml`:
```yaml
sprint:
  length_days: 10
  ceremonies_overhead_days: 3
  tech_debt_pct: 20
  oncall_impact_pct: 15

confidence_levels:
  conservative: 0.9  # 90% confidence
  realistic: 0.75    # 75% confidence
  optimistic: 0.5    # 50% confidence

team:
  size: 5
  velocity_average: 45
  velocity_std_dev: 3.2
```

## Best Practices

1. **Plan Capacity First**: Start with realistic capacity
2. **Review Velocity Trends**: Use data, not gut feel
3. **Set Clear Goal**: One cohesive sprint objective
4. **Build in Buffer**: Aim for 80-90% of capacity
5. **Identify Risks Early**: Plan mitigations up front
6. **Balance Load**: Distribute work fairly
7. **Allocate Tech Debt**: Reserve 15-20% capacity
8. **Confirm Dependencies**: Get written commitments
9. **Plan for Unknowns**: Add spikes for uncertainty
10. **Review Together**: Whole team validates plan
