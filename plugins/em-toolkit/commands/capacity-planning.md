---
description: 
---

# Capacity Planning Command

## Purpose
Strategic capacity planning for teams including resource allocation, hiring needs, workload forecasting, and roadmap feasibility analysis.

## Usage
```
/capacity-planning [--timeframe=quarter|year] [--team=name]
```

## Parameters
- `--timeframe`: Planning horizon
  - `quarter`: Next 3 months (default)
  - `half`: Next 6 months
  - `year`: Next 12 months
- `--team`: Specific team or all teams
- `--scenario`: Model different scenarios
- `--include-hiring`: Include hiring plan impact

## Execution Flow

### 1. Current State Analysis
**Delegates to:** metrics-reporter subagent

Assess current capacity:
- Team size and composition
- Current velocity
- Utilization rates
- Skill distribution
- Planned departures

### 2. Demand Forecasting
Review upcoming commitments:
- Roadmap features and epics
- Technical debt backlog
- Operational work
- Support and maintenance
- Unplanned work buffer

### 3. Capacity Projection
Project available capacity:
- Team size changes
- Productivity trends
- Holiday impacts
- On-call rotation
- Learning/ramp time

### 4. Gap Analysis
Identify mismatches:
- Over/under capacity periods
- Skill gaps
- Resource constraints
- Timeline feasibility

### 5. Scenario Planning
Model different scenarios:
- Current trajectory
- With planned hires
- Aggressive timeline
- Reduced scope

### 6. Generate Plan

```
CAPACITY PLANNING ANALYSIS
==========================
Team: Engineering
Timeframe: Q4 2025 (Oct-Dec)
Planning Date: Oct 4, 2025

CURRENT STATE
-------------
Team Size:              40 developers
Average Velocity:       450 points/sprint (10 days)
Utilization:            85% (healthy)
Sprint Capacity:        ~225 person-days/sprint

Composition:
  - Senior:    12 (30%)
  - Mid-level: 18 (45%)
  - Junior:    10 (25%)

DEMAND FORECAST (Q4)
--------------------
Total Estimated Work:   2,800 points (6.2 sprints)

Breakdown:
  Roadmap Features:     1,800 points (64%)
    - User Dashboard:     450 pts (Oct-Nov)
    - Mobile App:         600 pts (Nov-Dec)
    - Analytics v2:       450 pts (Nov-Dec)
    - Notifications:      300 pts (Dec)

  Technical Debt:        400 points (14%)
    - Test Coverage:      150 pts
    - Performance:        150 pts
    - Refactoring:        100 pts

  Bug Fixes:            200 points (7%)
  Operational:          200 points (7%)
  Buffer (Unplanned):   200 points (7%)

CAPACITY PROJECTION (Q4)
------------------------
Available Capacity:     2,475 points

Sprint Breakdown:
  Oct 7-18:     450 pts (6 sprints × 412.5 avg)
  Oct 21-Nov 1: 450 pts
  Nov 4-15:     450 pts
  Nov 18-29:    405 pts (-1 person holiday week)
  Dec 2-13:     450 pts
  Dec 16-31:    270 pts (holiday season, reduced)

Adjustments:
  - Thanksgiving week:  -45 pts (10% reduction)
  - Holiday season:     -180 pts (40% reduction Dec 16-31)
  - New hire ramp:      +0 pts (productive in Q1)

CAPACITY vs. DEMAND
-------------------
Demand:       2,800 points
Capacity:     2,475 points
Gap:          -325 points (12% OVERCAPACITY)

Status: ⚠️  OVERCOMMITTED

RISK ANALYSIS
-------------
🔴 Critical Risks:
  1. Overcommitted by 325 points (~0.7 sprints)
     Impact: Likely to miss Dec deadlines
     Probability: HIGH

  2. Key person dependency (Alice - auth system)
     Impact: Blocker if unavailable
     Probability: MEDIUM

🟡 Medium Risks:
  1. New mobile tech stack (learning curve)
     Impact: 20-30% velocity reduction for mobile team
     Probability: MEDIUM

  2. Analytics v2 scope unclear
     Impact: Potential 50% estimate error
     Probability: MEDIUM

SCENARIO ANALYSIS
-----------------

Scenario 1: CURRENT PLAN (No Changes)
  Demand: 2,800 pts | Capacity: 2,475 pts
  Result: Deliver ~88% of roadmap
  Miss: Likely slip Notifications to Q1

Scenario 2: DESCOPE NOTIFICATIONS
  Demand: 2,500 pts | Capacity: 2,475 pts
  Result: Deliver 99% of remaining roadmap
  Risk: LOW

Scenario 3: HIRE 2 SENIOR DEVS (Start Nov 1)
  Demand: 2,800 pts | Capacity: 2,550 pts (minimal Q4 impact)
  Result: Still 10% gap, better Q1 positioning
  Note: New hires productive in Q1

Scenario 4: REDUCE SCOPE 15% ACROSS BOARD
  Demand: 2,380 pts | Capacity: 2,475 pts
  Result: 4% buffer, healthy delivery
  Risk: LOW
  Trade-off: Reduced feature completeness

RECOMMENDATIONS
---------------
1. ⚠️  IMMEDIATE: Descope or defer Notifications (300 pts)
   - Moves Q4 to 89% capacity (healthy)
   - Maintains Dec ship date for core features

2. 🎯 Prioritize ruthlessly within remaining work
   - Focus on User Dashboard + Mobile App
   - Analytics v2 may need scope reduction

3. 📊 Increase tech debt allocation to 20%
   - Current 14% below recommended
   - Critical issues need addressing

4. 👥 Begin hiring for Q1 2026
   - 2 senior developers
   - Start date: Jan 6, 2026
   - Productive by end of Q1

5. 🔄 Weekly capacity reviews
   - Monitor actual vs. planned velocity
   - Adjust scope dynamically

TEAM ALLOCATION
---------------
Backend Team (15 people):
  Dashboard API:      6 people × 8 weeks = 24 person-weeks
  Mobile Backend:     5 people × 6 weeks = 15 person-weeks
  Analytics API:      4 people × 6 weeks = 12 person-weeks

Frontend Team (12 people):
  Dashboard UI:       6 people × 6 weeks = 18 person-weeks
  Mobile App:         6 people × 8 weeks = 24 person-weeks

Platform Team (8 people):
  Infrastructure:     4 people × 12 weeks = 24 person-weeks
  DevOps/CI/CD:       2 people × 12 weeks = 12 person-weeks
  Tech Debt:          2 people × 12 weeks = 12 person-weeks

QA Team (5 people):
  Test Automation:    3 people × 12 weeks = 18 person-weeks
  Manual Testing:     2 people × 12 weeks = 12 person-weeks

MONTHLY BREAKDOWN
-----------------
October (2 sprints):
  Planned: 900 points
  Focus: Dashboard (backend + frontend)
  Risk: LOW

November (2 sprints):
  Planned: 855 points
  Focus: Mobile app + Analytics start
  Risk: MEDIUM (new tech stack)

December (1.6 sprints):
  Planned: 720 points
  Focus: Analytics completion
  Risk: HIGH (holiday capacity, scope clarity)

HIRING PLAN IMPACT
------------------
Current Plan:
  - 2 senior devs in January
  - Ramp time: 6 weeks to 50%, 12 weeks to 100%
  - Q1 capacity boost: +120 points/sprint by March

If Accelerated to November:
  - Q4 capacity boost: +40 points (limited)
  - Q1 capacity boost: +180 points/sprint
  - Cost: Higher, but better Q1 delivery

Recommendation: Hire in January per plan

LONG-TERM FORECAST (2026)
--------------------------
Assuming no attrition and January hires:

Q1 2026: 2,800 points capacity
  With new hires productive: +120 pts by March
  Projected: 2,920 points

Q2 2026: 3,000 points capacity
  Full productivity of new hires: +180 pts

This supports ambitious 2026 roadmap.

KEY METRICS
-----------
Team Growth:         0% (Q4), 5% (Q1 2026)
Capacity Trend:      Stable Q4, +8% Q1
Utilization Target:  85% (healthy sustainable)
Current Commitment:  112% (OVERCOMMITTED)

ACTIONS REQUIRED
----------------
📋 By Oct 7:
  - [ ] Finalize scope decision (descope Notifications?)
  - [ ] Communicate roadmap adjustments
  - [ ] Align stakeholders on priorities

📋 By Oct 14:
  - [ ] Begin senior dev hiring process
  - [ ] Lock Analytics v2 scope
  - [ ] Create mobile tech stack learning plan

📋 Ongoing:
  - [ ] Weekly velocity tracking vs. plan
  - [ ] Bi-weekly scope reviews
  - [ ] Monthly capacity forecasting
```

## Planning Dimensions

### Time Horizons
- **Sprint**: 2 weeks tactical planning
- **Quarter**: 3 months strategic planning
- **Half/Year**: Long-term roadmap alignment

### Capacity Factors
- **Team size**: Headcount and composition
- **Velocity**: Historical and projected
- **Utilization**: Target 80-85% for sustainability
- **Skill mix**: Senior/mid/junior distribution
- **Learning curve**: New hires and new tech

### Demand Components
- **Feature work**: Roadmap commitments
- **Technical debt**: 15-20% allocation
- **Bugs/support**: Operational overhead
- **Unplanned work**: 10-15% buffer
- **Platform/infrastructure**: Foundational work

## Scenario Modeling

### Common Scenarios
1. **Status Quo**: Current trajectory
2. **Optimistic**: Best case (no attrition, high velocity)
3. **Pessimistic**: Worst case (attrition, delays)
4. **With Hiring**: Impact of new team members
5. **Descoped**: Reduced feature set

### Variables to Model
- Team size changes
- Velocity fluctuations
- Scope adjustments
- Timeline shifts
- Skill mix changes

## Output Formats

### Executive Summary
```
Q4 Capacity: 2,475 points
Q4 Demand: 2,800 points
Gap: -325 points (12% over)
Recommendation: Descope Notifications
```

### Detailed Plan (markdown)
Comprehensive capacity analysis and recommendations

### Gantt Chart (text)
```
Oct  Nov  Dec
Dashboard ████████
Mobile       ████████████
Analytics      ██████████
```

## Examples

### Quarterly Planning
```
/capacity-planning --timeframe=quarter

Q4 2025 CAPACITY ANALYSIS
-------------------------
Capacity: 2,475 points
Demand: 2,800 points
Status: ⚠️  OVERCOMMITTED by 12%

Recommendation: Descope 325 points
```

### Multi-Team Planning
```
/capacity-planning --team=all

ENGINEERING CAPACITY (All Teams)
--------------------------------
Backend:   900 pts/sprint
Frontend:  750 pts/sprint
Platform:  450 pts/sprint
QA:        300 pts/sprint

Total:     2,400 pts/sprint
```

### With Hiring Impact
```
/capacity-planning --include-hiring

HIRING IMPACT ANALYSIS
----------------------
Current (Q4):    2,475 pts
With 2 hires (Q1): 2,920 pts (+18%)

ROI: +445 pts capacity by end Q1
```

## Best Practices

1. **Plan Regularly**: Review quarterly, adjust monthly
2. **Model Scenarios**: Always have plan B and C
3. **Buffer for Unknown**: Reserve 10-15% capacity
4. **Sustainable Pace**: Target 80-85% utilization
5. **Invest in Debt**: Maintain 15-20% tech debt allocation
6. **Track Actuals**: Compare plan vs. actual continuously
7. **Communicate Early**: Alert stakeholders to gaps ASAP
8. **Be Data-Driven**: Use historical velocity, not wishful thinking
