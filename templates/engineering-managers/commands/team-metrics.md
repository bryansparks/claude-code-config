# Team Metrics Command

## Purpose
Generate comprehensive team performance metrics including velocity, DORA metrics, code review stats, and team health indicators.

## Usage
```
/team-metrics [team-name] [--timeframe=week|month|quarter]
```

## Parameters
- `team-name` (optional): Specific team or defaults to current project team
- `--timeframe`: Reporting period
  - `week`: Last 7 days
  - `sprint`: Current sprint (default)
  - `month`: Last 30 days
  - `quarter`: Last 90 days
- `--compare`: Compare to previous period
- `--export`: Export format (text, markdown, csv, json)

## Execution Flow

### 1. Data Collection
**Delegates to:** metrics-reporter subagent

Collect metrics from:
- Git commit history
- GitHub PRs and reviews
- CI/CD pipelines
- Issue tracker (Jira/Linear)
- Incident management
- On-call rotation

### 2. Calculate Metrics

#### Delivery Metrics
- Sprint velocity and trend
- Story point completion rate
- Cycle time (start to done)
- Lead time (commit to production)
- Throughput (issues per week)

#### DORA Metrics
- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery (MTTR)

#### Code Review Metrics
- Time to first review
- Time to merge
- Review thoroughness score
- PR size distribution

#### Quality Metrics
- Bug creation rate
- Bug resolution rate
- Test coverage trend
- Production incidents

#### Team Health
- WIP limits adherence
- Blocker frequency
- Context switching
- On-call load

### 3. Generate Report

```
TEAM METRICS REPORT
===================
Team: Backend API
Period: Sprint 47 (Sep 23 - Oct 6)

DELIVERY PERFORMANCE
--------------------
Velocity:            48 points (↑ +8% vs avg)
Commitment:          50 points
Completion Rate:     96%
Carryover:           2 points

Sprint Goal:         ✅ ACHIEVED
Goal: "Launch user dashboard API"

DORA METRICS
------------
Deployment Frequency:    4.2/day ⭐ (Elite)
Lead Time for Changes:   2.3 hours ⭐ (Elite)
Change Failure Rate:     8% ⭐ (Elite: <15%)
MTTR:                    45 minutes ⭐ (Elite)

DORA Classification:     ELITE PERFORMER

CODE REVIEW
-----------
Average PR Size:         185 lines
Time to First Review:    2.4 hours
Time to Merge:           8.2 hours
Review Thoroughness:     8.5/10

PRs This Sprint:         45
  - Small (<200 LOC):    32 (71%)
  - Medium (200-500):    11 (24%)
  - Large (>500):        2 (5%)

Review Distribution:
  - Alice:  15 reviews (33%)
  - Bob:    12 reviews (27%)
  - Carol:  10 reviews (22%)
  - Dave:   8 reviews (18%)

QUALITY INDICATORS
------------------
Bugs Created:            3 (↓ 40% vs last sprint)
Bugs Resolved:           7 (includes backlog)
Production Incidents:    1 (P2)
Test Coverage:           82% (↑ +2%)
Flaky Tests:             2 (down from 5)

TEAM HEALTH
-----------
Active Work Items:       12
WIP Per Person:          1.5 (within limit)
Blockers This Sprint:    2 (avg 1.5 days to resolve)
Context Switches:        3.2/person (acceptable)

On-call Load:
  - Incidents:           4
  - Avg Response Time:   12 minutes
  - Pages at Night:      1

INDIVIDUAL CONTRIBUTIONS
------------------------
Developer    Commits  PRs  Reviews  Points
Alice          45     12    15      14
Bob            38     10    12      12
Carol          42     11    10      11
Dave           35     9     8       11
(More balanced than last sprint ✅)

TRENDS (Last 6 Sprints)
-----------------------
Velocity:          40 → 42 → 45 → 43 → 44 → 48
Deployment Freq:   3.1 → 3.5 → 3.8 → 4.0 → 4.1 → 4.2
Code Coverage:     76% → 77% → 78% → 79% → 80% → 82%
MTTR:              65m → 58m → 52m → 48m → 47m → 45m

INSIGHTS
--------
✅ Strengths:
  - Excellent deployment frequency and lead time
  - Velocity trending upward consistently
  - Bug count decreasing
  - Test coverage improving

⚠️  Areas for Improvement:
  - 2 large PRs took >24h to review
  - Context switching above ideal (<3/person)
  - On-call had 1 night page

RECOMMENDATIONS
---------------
1. Continue breaking down PRs (aim for <200 LOC)
2. Consider dedicated focus time to reduce context switching
3. Review incident that caused night page
4. Keep investing in test coverage
```

## Metric Categories

### Delivery Metrics
**What they measure:** Team productivity and predictability

- **Velocity**: Average story points completed per sprint
- **Completion Rate**: % of committed work finished
- **Cycle Time**: Days from started to done
- **Lead Time**: Days from committed to deployed
- **Throughput**: Issues completed per time period

### DORA Metrics
**What they measure:** Software delivery performance

- **Deployment Frequency**: Deployments per day/week
  - Elite: Multiple per day
  - High: Once per day to once per week
  - Medium: Once per week to once per month
  - Low: Less than once per month

- **Lead Time for Changes**: Time from commit to production
  - Elite: Less than one hour
  - High: One day to one week
  - Medium: One week to one month
  - Low: More than one month

- **Change Failure Rate**: % of deployments causing failures
  - Elite: 0-15%
  - High: 16-30%
  - Medium: 31-45%
  - Low: 46-100%

- **MTTR**: Time to restore service after incident
  - Elite: Less than one hour
  - High: Less than one day
  - Medium: One day to one week
  - Low: More than one week

### Code Review Metrics
**What they measure:** Code review efficiency and quality

- **Time to First Review**: Hours until first review comment
- **Time to Merge**: Hours from PR opened to merged
- **Review Thoroughness**: Comments per 100 LOC
- **PR Size**: Lines of code changed
- **Review Distribution**: Balance across team members

### Quality Metrics
**What they measure:** Software quality and reliability

- **Bug Density**: Bugs per KLOC
- **Bug Escape Rate**: Production bugs vs. caught in dev
- **Test Coverage**: % of code covered by tests
- **Flaky Test Rate**: % of tests that fail intermittently
- **Production Incidents**: Count and severity

### Team Health Metrics
**What they measure:** Team sustainability and efficiency

- **WIP Limits**: Work in progress per person
- **Blocker Frequency**: Blocked items and resolution time
- **Context Switching**: Concurrent active issues
- **On-call Load**: Incidents and impact on team
- **Review Load Balance**: Distribution of review work

## Output Formats

### Dashboard (text)
Formatted console output with colors and symbols

### Report (markdown)
Comprehensive markdown report for documentation

### Spreadsheet (csv)
```csv
Metric,Value,Target,Status
Velocity,48,45,✅
Deployment Frequency,4.2/day,>1/day,✅
Lead Time,2.3h,<24h,✅
```

### Data (json)
Structured data for automation and dashboards

## Examples

### Sprint Summary
```
/team-metrics --timeframe=sprint

SPRINT 47 SUMMARY
-----------------
Velocity:        48 points (↑ 9%)
Deployment Freq: 4.2/day
MTTR:            45 minutes
Bugs Created:    3

Status: ✅ EXCELLENT SPRINT
```

### Monthly Report
```
/team-metrics backend-team --timeframe=month --export=markdown

Generating monthly metrics for backend-team...

Period: September 2025
Sprints: 4 (43, 44, 45, 46)

Average Velocity: 45 points
Deployments: 84 (2.8/day)
Incidents: 6 (1.5/week)

Report saved: team-metrics-sep-2025.md
```

### Comparison
```
/team-metrics --compare

Comparing current sprint to previous:

Metric              Current  Previous  Change
Velocity               48       44     +9%
Deployment Freq      4.2/d    4.1/d    +2%
Lead Time            2.3h     2.8h    -18%
Bug Count              3        5     -40%

Trend: ✅ IMPROVING
```

### Team Comparison
```
/team-metrics --teams=frontend,backend,mobile

Team        Velocity  Deploy/Day  MTTR    Coverage
frontend       42       3.8      52m      78%
backend        48       4.2      45m      82%
mobile         38       2.1      68m      75%
```

## Automation

### Weekly Report
```yaml
schedule:
  - cron: "0 9 * * MON"
    command: /team-metrics --timeframe=week --export=markdown
    post-to: slack:#engineering
```

### Sprint Retrospective
```yaml
sprint-end:
  - run: /team-metrics --timeframe=sprint --compare
  - generate-insights: true
  - create-action-items: true
```

## Configuration

`.claude/engineering-manager/team-metrics.yml`:
```yaml
targets:
  velocity: 45
  deployment_frequency_per_day: 3
  lead_time_hours: 24
  change_failure_rate: 0.15
  mttr_minutes: 60
  test_coverage: 80

alerts:
  velocity_decline_pct: 15
  deployment_freq_decline: 20
  bug_spike_threshold: 5

team:
  members: 8
  wip_limit_per_person: 2
  sprint_days: 10
```

## Best Practices

1. **Regular Reviews**: Share metrics in standup and retrospectives
2. **Trend Focus**: Look at trends, not absolute numbers
3. **Context Matters**: Understand the "why" behind metrics
4. **Balanced View**: Don't optimize for one metric alone
5. **Team Ownership**: Let team set their own improvement goals
6. **Celebrate Wins**: Recognize improvements publicly
7. **Action Items**: Convert insights to concrete actions
