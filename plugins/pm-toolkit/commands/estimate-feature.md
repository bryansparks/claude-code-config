---
description: 
---

# Command: Estimate Feature

## Purpose
Provides effort estimation for features including development, design, testing, and total timeline.

## Usage
```bash
/estimate-feature [feature-file or description]
```

## What This Command Does

1. Analyzes feature complexity
2. Breaks down into tasks/stories
3. Estimates by discipline (dev, design, QA)
4. Considers dependencies and risks
5. Provides range estimates (best/likely/worst case)

## Output Format

```markdown
# Effort Estimation: [Feature Name]

## Summary
- **Complexity**: Medium
- **Total Effort**: 21-34 story points (3-5 weeks)
- **Confidence**: 80%

## Breakdown by Discipline

### Development: 13-21 points (2-3 weeks)
- **Frontend**: 8 points
  - User interface components (3 pts)
  - Form validation (2 pts)
  - State management (3 pts)
- **Backend**: 5-8 points
  - API endpoints (3 pts)
  - Database schema (2-3 pts)
  - Integration (2 pts)
- **Infrastructure**: 3 points
  - Deployment config (2 pts)
  - Monitoring (1 pt)

### Design: 5-8 points (1 week)
- User research (2-3 pts)
- Wireframes/mockups (2 pts)
- Design system updates (1-2 pts)
- Usability testing (1 pt)

### QA/Testing: 3-5 points (3-5 days)
- Test plan creation (1 pt)
- Manual testing (1-2 pts)
- Automated tests (1-2 pts)

## Timeline

**Sequential Timeline**: 4-6 weeks
- Design: Week 1
- Development: Weeks 2-4
- QA: Week 5
- Buffer: Week 6

**Parallel Timeline**: 3-4 weeks (with parallel work)

## Risk Factors

- ⚠️ External API dependency (add 20% buffer)
- ⚠️ New technology (add 30% learning curve)
- ✅ Well-understood domain

## Assumptions

- Team velocity: 25 points/sprint
- No major blockers
- Requirements stable
- Resources available

## Confidence Level: 80%
Lower confidence due to: [reasons]
```

## Estimation Methods

- **Story Points**: Relative sizing (1,2,3,5,8,13,21)
- **T-Shirt Sizes**: XS, S, M, L, XL
- **Time-Based**: Hours/days/weeks

## Examples

```bash
# Estimate from file
/estimate-feature ~/features/dark-mode.md

# Quick estimate
/estimate-feature --quick "Add export to CSV feature"

# Detailed with breakdown
/estimate-feature --detailed --format=points ~/features/api-v2.md
```

## Options
- `--format=[points|time|tshirt]`: Estimation format
- `--detailed`: Full task breakdown
- `--quick`: High-level only
- `--team-velocity=<num>`: Specify team velocity
