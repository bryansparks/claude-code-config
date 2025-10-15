---
description: 
---

# Estimate Effort Command

## Purpose
Provides data-driven effort estimation for features, epics, and technical initiatives based on historical data and complexity analysis.

## Usage
```
/estimate-effort [feature-description] [--method=historical|complexity|hybrid]
```

## Parameters
- `feature-description`: Description of the work to estimate
- `--method`: Estimation approach
  - `historical`: Based on similar past work (default)
  - `complexity`: Complexity-based estimation
  - `hybrid`: Combines both approaches
- `--breakdown`: Include detailed task breakdown
- `--confidence`: Show confidence intervals

## Execution Flow

### 1. Analyze Feature Request
- Parse feature description
- Extract key components and requirements
- Identify similar historical work
- Assess technical complexity

### 2. Historical Analysis
**Delegates to:** metrics-reporter subagent

- Search for similar features in git history
- Analyze time-to-completion patterns
- Review story point assignments
- Calculate average effort

### 3. Complexity Assessment
**Delegates to:** technical-debt-assessor subagent

Evaluate:
- Number of files to modify
- Integration points
- Database changes required
- API changes needed
- Testing requirements
- Documentation needs

### 4. Generate Estimate

Combine historical data with complexity analysis:

```
EFFORT ESTIMATE
===============

Feature: User Profile Dashboard
Method: Hybrid (Historical + Complexity)

ESTIMATE: 8-13 days (Confidence: 75%)
Most Likely: 10 days

BREAKDOWN
---------
Backend Development:     3-5 days
  - API endpoints:       1-2 days
  - Database schema:     1 day
  - Business logic:      1-2 days

Frontend Development:    3-5 days
  - Components:          2-3 days
  - State management:    1 day
  - Styling:             1 day

Testing:                 1-2 days
  - Unit tests:          0.5 day
  - Integration tests:   0.5 day
  - E2E tests:           0.5-1 day

Documentation:           0.5 day
Code Review:             0.5 day

DEPENDENCIES
------------
- User service API (Team B)
- Analytics service (Team C)

RISKS
-----
⚠️  Analytics API still in development
⚠️  Limited experience with new dashboard library

SIMILAR WORK
------------
1. Admin Dashboard (Sprint 42): 12 days actual
2. Reports Page (Sprint 38): 9 days actual
3. Settings Panel (Sprint 35): 8 days actual

CONFIDENCE FACTORS
------------------
✅ Well-defined requirements
✅ Similar work completed recently
⚠️  New technology (dashboard library)
⚠️  External dependencies
```

## Estimation Methods

### Historical Method
Uses past performance data:
- Searches git commits for similar features
- Analyzes PR size and review time
- Reviews completed story points
- Calculates weighted average

### Complexity Method
Analyzes technical complexity:
- Lines of code estimate
- Number of files affected
- Integration complexity
- Testing requirements
- Documentation needs

### Hybrid Method (Recommended)
Combines both approaches:
1. Use historical data as baseline
2. Adjust for complexity differences
3. Factor in team capacity
4. Include risk buffer

## Output Formats

### Standard Estimate
```
Feature: [NAME]
Estimate: [MIN]-[MAX] days
Confidence: [%]
```

### Detailed Breakdown
```
EFFORT ESTIMATE: [NAME]
=======================

Total Estimate: [MIN]-[MAX] days (Confidence: [%])

Task Breakdown:
  - [TASK]: [MIN]-[MAX] days
  - [TASK]: [MIN]-[MAX] days

Dependencies: [LIST]
Risks: [LIST]
Similar Work: [LIST]
```

### Story Points
```
Recommended Story Points: [POINTS]

Based on team velocity:
  - Sprint commitment: [POINTS]
  - Days per point: [RATIO]
  - Estimated effort: [DAYS]
  - Suggested points: [POINTS]
```

## Examples

### Simple Feature Estimation
```
/estimate-effort "Add export to CSV button"

ESTIMATE: 1-2 days (Confidence: 90%)

This is a small feature similar to:
- Export to PDF (1.5 days actual)
- Print functionality (1 day actual)

Breakdown:
- Backend endpoint: 0.5 day
- Frontend button: 0.5 day
- Testing: 0.5 day
```

### Complex Feature with Breakdown
```
/estimate-effort "Real-time collaboration editing" --breakdown --method=hybrid

ESTIMATE: 15-25 days (Confidence: 60%)

This is a complex feature requiring:

Backend (8-12 days):
  - WebSocket infrastructure: 3-5 days
  - Conflict resolution: 3-4 days
  - State synchronization: 2-3 days

Frontend (5-8 days):
  - Real-time editor: 3-5 days
  - Presence indicators: 1-2 days
  - Network handling: 1-2 days

Testing (2-4 days):
  - Unit tests: 1 day
  - Integration: 1-2 days
  - Load testing: 1 day

RISKS:
🔴 No prior experience with real-time features
🔴 Performance concerns at scale
🟡 Complex state management
```

### Epic Estimation
```
/estimate-effort "Multi-tenant architecture migration" --method=historical

ESTIMATE: 45-60 days (3-4 sprints)

Major Epic Breakdown:

Sprint 1: Foundation (12-15 days)
  - Schema changes
  - Tenant isolation layer
  - Migration scripts

Sprint 2: API Updates (15-20 days)
  - Endpoint modifications
  - Authentication changes
  - Testing

Sprint 3: Frontend (10-15 days)
  - Tenant context
  - UI updates
  - Testing

Sprint 4: Migration & Rollout (8-10 days)
  - Data migration
  - Monitoring
  - Rollback plan

Similar epics:
- Database sharding: 52 days actual
- API versioning: 38 days actual
```

## Integration Points

### Data Sources
- Git history analysis
- Jira/Linear historical data
- GitHub PR metrics
- Team velocity data
- Code complexity tools

### Subagents Used
- metrics-reporter: Historical velocity data
- technical-debt-assessor: Complexity analysis
- project-analyzer: Risk assessment

## Configuration

`.claude/engineering-manager/estimate-effort.yml`:
```yaml
estimation:
  default_method: hybrid
  confidence_threshold: 70
  buffer_percentage: 20

historical:
  lookback_days: 180
  min_similar_features: 3

complexity:
  weights:
    backend: 1.0
    frontend: 0.8
    testing: 0.3
    documentation: 0.2

team:
  velocity_average: 45
  points_per_day: 0.5
```

## Best Practices

1. **Multiple Perspectives**: Use hybrid method for important features
2. **Include Buffer**: Add 20-30% buffer for unknowns
3. **Break Down**: Large estimates should be broken into smaller tasks
4. **Review Actuals**: Compare estimates to actuals for continuous improvement
5. **Team Input**: Validate estimates with team before committing
6. **Update Frequently**: Re-estimate as requirements become clearer
