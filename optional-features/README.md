# Optional Features

This directory contains **advanced features** that are **NOT required** for basic Claude Code usage.

⚠️ **Important**: These features add complexity and infrastructure requirements. Only enable them when you have a clear need and resources to maintain them.

---

## 📊 Metrics Dashboard

**Location**: `optional-features/metrics-dashboard/`

**Status**: ⚠️ **NOT ENABLED BY DEFAULT**

**What it is**: A comprehensive metrics dashboard for tracking Claude Code skill usage, code quality, and team performance with real-time visualization.

**When to use it**:
- ❌ **DO NOT use if**: You're just starting with Claude Code (< 6 months)
- ❌ **DO NOT use if**: You haven't proven Claude Code value yet
- ❌ **DO NOT use if**: You don't have infrastructure resources
- ✅ **DO use if**: 6+ months of proven Claude Code value
- ✅ **DO use if**: Executive mandate to measure ROI
- ✅ **DO use if**: Have dedicated infrastructure team

**Infrastructure required**:
- PostgreSQL 14+ database server
- Node.js backend server (24/7)
- Frontend hosting
- 2-4 hours/week maintenance

**Cost**: $500-2000/month (infrastructure + maintenance)

**Documentation**:
- Decision guide: [`/docs/METRICS_DECISION_GUIDE.md`](../docs/METRICS_DECISION_GUIDE.md)
- Full README: [`metrics-dashboard/README.md`](./metrics-dashboard/README.md)
- Quick start: [`metrics-dashboard/QUICK_START.md`](./metrics-dashboard/QUICK_START.md)

**Alternatives**:
- **Local metrics** (recommended for Phase 2): Lightweight JSON logs, zero infrastructure
  - Config: `.claude/config/metrics.yml` → Set `metrics_mode: local`
  - Script: `.claude/scripts/local-metrics-logger.sh`

---

## When to Use Optional Features

### Phase 1: Starting Out (Months 0-3)
**Use**: Basic skills from personas
**Don't use**: Any optional features
**Goal**: Prove Claude Code helps your team

### Phase 2: Early Adoption (Months 3-6)
**Use**: Basic skills + local metrics (optional)
**Don't use**: Centralized dashboard
**Goal**: Understand which skills are most valuable

### Phase 3: Mature Adoption (Months 6+)
**Use**: All skills + centralized dashboard (if resources available)
**Goal**: Optimize organization-wide usage and measure ROI

---

## How to Add More Optional Features

Optional features should follow these guidelines:

1. **Default to OFF** - Never enabled without explicit user action
2. **Self-contained** - All code in its own directory
3. **Documented** - Clear README explaining when to use it
4. **Justified** - Only add if there's a clear use case

Example structure:
```
optional-features/
├── README.md                    # This file
├── feature-name/
│   ├── README.md               # Feature documentation
│   ├── install.sh              # Installation script
│   └── ...                     # Feature code
```

---

## Current Optional Features

| Feature | Status | Infrastructure Required | Best For |
|---------|--------|------------------------|----------|
| **Metrics Dashboard** | Available | PostgreSQL + 2 servers | Phase 3 (6mo+) |

---

## Planned Optional Features (Future)

- **Skill Marketplace**: Share custom skills across organization
- **AI Training Data Collector**: Opt-in to improve Claude Code
- **Advanced Analytics**: ML-powered insights from usage patterns

*These are not yet implemented. Only metrics dashboard is available.*

---

## Support

For questions about optional features:
- Read the decision guide: `/docs/METRICS_DECISION_GUIDE.md`
- Check feature-specific README files
- Open an issue on GitHub

**Remember**: Start simple. Add complexity only when justified.
