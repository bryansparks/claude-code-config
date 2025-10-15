# Command: Roadmap Planning

## Purpose
Creates and maintains product roadmaps with prioritization, sequencing, and capacity planning.

## Usage
```bash
/roadmap-planning [quarter or period]
```

## What This Command Does

1. Activates **roadmap-planner** subagent
2. Analyzes features for prioritization (RICE, value/effort)
3. Maps dependencies and sequencing
4. Allocates based on team capacity
5. Generates roadmap in selected format

## Output Formats

### Now/Next/Later Roadmap
```markdown
## 🎯 Now (Current Sprint)
- Feature A: User authentication (In Progress - 70%)
- Feature B: Dashboard redesign (In Progress - 40%)

## 🔜 Next (1-2 Months)
- Feature C: API v2 (Dependencies: Feature A)
- Feature D: Mobile app (Design phase)

## 🔮 Later (3+ Months)
- Feature E: AI recommendations
- Feature F: Advanced analytics
```

### Quarterly Roadmap
```markdown
# Q1 2025 Product Roadmap

## Theme: Improve User Experience

### January
- ✅ Feature A (Complete)
- 🔄 Feature B (In Progress)

### February
- 📋 Feature C (Planned)
- 📋 Feature D (Planned)

### March
- 📋 Feature E (Planned)

**Capacity**: 75 story points
**Allocated**: 68 points (90%)
**Buffer**: 7 points (10%)
```

### Strategic Roadmap
```markdown
## 2025 Product Strategy

### H1 2025: Foundation
**Objective**: Establish market presence
- User onboarding optimization
- Core feature parity
- Mobile experience

### H2 2025: Growth
**Objective**: Scale and retention
- Advanced features
- Integrations
- Enterprise capabilities
```

## Prioritization Methods

### RICE Scoring
- **Reach**: Users impacted
- **Impact**: Value multiplier
- **Confidence**: Certainty %
- **Effort**: Cost in time/points

### Value vs Effort Matrix
```
High Value, Low Effort  → Do First (Quick Wins)
High Value, High Effort → Plan Carefully (Major Projects)
Low Value, Low Effort   → Fill-ins
Low Value, High Effort  → Avoid
```

## Examples

```bash
# Create Q1 roadmap
/roadmap-planning Q1-2025

# Now/Next/Later format
/roadmap-planning --format=now-next-later

# With team capacity
/roadmap-planning Q2-2025 --capacity=80 --velocity=25

# Update existing roadmap
/roadmap-planning --update ~/roadmaps/2025-roadmap.md
```

## Options
- `--format=[quarterly|now-next-later|strategic]`
- `--capacity=<points>`: Team capacity
- `--velocity=<points>`: Sprint velocity
- `--prioritize=[rice|value-effort|moscow]`
- `--update=<file>`: Update existing roadmap

## Capacity Planning

```markdown
## Team Capacity Analysis

**Team**: 5 developers
**Sprint Length**: 2 weeks
**Historical Velocity**: 35 points/sprint
**Sprints in Q1**: 6
**Total Capacity**: 210 points

**Allocation**:
- Features: 160 points (76%)
- Bugs/Tech Debt: 30 points (14%)
- Support: 20 points (10%)
```

## Success Criteria
- [ ] Strategic themes defined
- [ ] Features prioritized
- [ ] Dependencies mapped
- [ ] Capacity validated
- [ ] Milestones set
- [ ] Stakeholder alignment
- [ ] Risk assessment complete
