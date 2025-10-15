# Engineering Manager Persona

Complete configuration for engineering management workflows including team performance tracking, project health monitoring, and delivery excellence.

## Overview

This persona is designed for engineering managers who need to:
- Track team performance and velocity
- Monitor project health and technical debt
- Coordinate cross-team dependencies
- Plan sprints and capacity
- Analyze metrics and trends
- Make data-driven decisions

## Directory Structure

```
engineering-managers/
├── subagents/                    # Specialized AI subagents
│   ├── project-analyzer.md       # Project health and risk assessment
│   ├── team-coordinator.md       # Cross-team coordination
│   ├── technical-debt-assessor.md # Debt identification and prioritization
│   ├── metrics-reporter.md       # Performance metrics and DORA
│   └── code-health-monitor.md    # Code quality monitoring
│
├── hooks/                        # Automated scripts
│   ├── pr-review-summary.sh      # PR activity and review status
│   ├── sprint-health-check.sh    # Sprint progress monitoring
│   ├── technical-debt-tracker.sh # Technical debt reporting
│   ├── team-velocity-calculator.sh # Velocity trends
│   ├── dependency-analyzer.sh    # Dependency mapping
│   ├── code-quality-trends.sh    # Quality metrics over time
│   └── blocker-detector.sh       # Blocker detection and alerts
│
├── commands/                     # Management commands
│   ├── analyze-project.md        # Comprehensive project analysis
│   ├── estimate-effort.md        # Feature effort estimation
│   ├── technical-debt-audit.md   # Full debt assessment
│   ├── team-metrics.md          # Team performance metrics
│   ├── sprint-planning.md       # Sprint planning assistance
│   ├── capacity-planning.md     # Resource and capacity planning
│   ├── retrospective-analysis.md # Retro trends and insights
│   └── dependency-map.md        # Dependency visualization
│
├── mcp-servers/                  # MCP server configuration
│   └── mcp-config.json          # GitHub, Context7, Memory, Sequential-Thinking
│
├── settings.json                 # Persona configuration
└── README.md                     # This file
```

## Quick Start

### 1. Setup MCP Servers

The Engineering Manager persona uses these MCP servers (in priority order):

1. **GitHub** (Priority 1) - PR reviews, issues, repository management
2. **Context7** (Priority 2) - Long-term memory for decisions and patterns
3. **Memory** (Priority 3) - Short-term sprint context
4. **Sequential-Thinking** (Priority 4) - Complex decision analysis

#### Required Environment Variables

```bash
# Required for GitHub MCP
export GITHUB_TOKEN="ghp_your_token_here"

# Optional for Context7 (long-term memory)
export UPSTASH_REDIS_REST_URL="https://your-redis.upstash.io"
export UPSTASH_REDIS_REST_TOKEN="your_token_here"
```

#### GitHub Token Setup

Create a GitHub Personal Access Token with these scopes:
- `repo` - Full control of private repositories
- `read:org` - Read organization data
- `read:user` - Read user profile data

Get your token at: https://github.com/settings/tokens

### 2. Install Dependencies

All hooks require GitHub CLI:

```bash
# Install GitHub CLI
brew install gh

# Login to GitHub
gh auth login
```

### 3. Make Hooks Executable

```bash
chmod +x hooks/*.sh
```

### 4. Test a Hook

```bash
# Test PR review summary
./hooks/pr-review-summary.sh

# Test sprint health check
./hooks/sprint-health-check.sh
```

## Commands

### Project Analysis

#### Analyze Project Health
```
/analyze-project [repository] [--depth=full|standard|quick]
```

Comprehensive project health analysis including:
- Code quality metrics
- Technical debt assessment
- Team performance data
- Risk identification
- Recommendations

**Example:**
```
/analyze-project myapp --depth=full
```

#### Technical Debt Audit
```
/technical-debt-audit [repository] [--category=all|code|architecture]
```

Full technical debt assessment with:
- Debt categorization and prioritization
- Impact and effort analysis
- Remediation recommendations
- ROI calculations

**Example:**
```
/technical-debt-audit --category=code --export=markdown
```

### Team Performance

#### Team Metrics
```
/team-metrics [team-name] [--timeframe=week|month|quarter]
```

Generate comprehensive team metrics:
- Sprint velocity and trends
- DORA metrics
- Code review statistics
- Quality indicators
- Team health

**Example:**
```
/team-metrics backend-team --timeframe=month --export=markdown
```

#### Sprint Planning
```
/sprint-planning [--sprint-number=N] [--team=name]
```

Sprint planning assistance with:
- Capacity analysis
- Velocity-based recommendations
- Dependency checking
- Risk assessment
- Work distribution

**Example:**
```
/sprint-planning --sprint-number=48 --export=jira
```

### Planning & Estimation

#### Estimate Effort
```
/estimate-effort [feature-description] [--method=historical|complexity|hybrid]
```

Data-driven effort estimation:
- Historical data analysis
- Complexity assessment
- Similar work comparison
- Confidence intervals

**Example:**
```
/estimate-effort "Add real-time collaboration" --method=hybrid --breakdown
```

#### Capacity Planning
```
/capacity-planning [--timeframe=quarter|year] [--team=name]
```

Strategic capacity planning:
- Resource allocation
- Hiring impact analysis
- Scenario modeling
- Roadmap feasibility

**Example:**
```
/capacity-planning --timeframe=quarter --scenario=with-hiring
```

### Analysis & Insights

#### Retrospective Analysis
```
/retrospective-analysis [--timeframe=sprint|quarter|year]
```

Analyze retrospective data for:
- Recurring themes and patterns
- Action item tracking
- Sentiment trends
- Impact measurement

**Example:**
```
/retrospective-analysis --timeframe=quarter --export=presentation
```

#### Dependency Map
```
/dependency-map [--scope=team|service|feature] [--format=text|mermaid]
```

Visualize and analyze dependencies:
- Team dependencies
- Service architecture
- Critical path analysis
- Blocker identification

**Example:**
```
/dependency-map --scope=team --format=mermaid --critical-path
```

## Hooks

### Automated Execution

Hooks can run automatically on schedule (configured in settings.json):

#### Daily
- **blocker-detector** (9:00 AM) - Morning blocker scan

#### Weekly
- **pr-review-summary** (Monday 9:00 AM) - Weekly PR status
- **team-velocity-calculator** (Friday 4:00 PM) - Velocity update
- **technical-debt-tracker** (Sunday 8:00 PM) - Debt report
- **code-quality-trends** (Sunday 8:00 PM) - Quality trends

#### Sprint Events
- **sprint-health-check** - At sprint start, mid, and end

### Manual Execution

Run any hook manually:

```bash
# PR Review Summary
./hooks/pr-review-summary.sh [repo] [days] [format]

# Sprint Health Check
./hooks/sprint-health-check.sh [project] [sprint-number] [format]

# Technical Debt Tracker
./hooks/technical-debt-tracker.sh [repo-path] [format]

# Team Velocity Calculator
./hooks/team-velocity-calculator.sh [project] [num-sprints] [format]

# Dependency Analyzer
./hooks/dependency-analyzer.sh [repo-path] [type] [format]

# Code Quality Trends
./hooks/code-quality-trends.sh [repo-path] [timeframe-days] [format]

# Blocker Detector
./hooks/blocker-detector.sh [repo] [format] [notify]
```

### Output Formats

All hooks support multiple output formats:
- **text** - Formatted console output (default)
- **json** - Structured data for automation
- **markdown** - Documentation and reports

## Subagents

The Engineering Manager persona uses specialized subagents:

### Project Analyzer
Analyzes project health, technical debt, and overall engineering execution.

**Invoked by:** analyze-project, sprint-planning

### Team Coordinator
Coordinates work across teams, identifies blockers, manages dependencies.

**Invoked by:** dependency-map, sprint-planning

### Technical Debt Assessor
Identifies, categorizes, and prioritizes technical debt.

**Invoked by:** technical-debt-audit, analyze-project, estimate-effort

### Metrics Reporter
Generates sprint metrics, velocity, DORA metrics, team performance.

**Invoked by:** team-metrics, sprint-planning, capacity-planning

### Code Health Monitor
Monitors codebase health, complexity trends, quality metrics.

**Invoked by:** analyze-project, technical-debt-audit

## Workflows

### Sprint Start Workflow
1. Run `sprint-health-check` hook
2. Review blockers from `blocker-detector`
3. Check dependencies via `dependency-analyzer`
4. Review capacity via `/sprint-planning` command

### Sprint Mid Workflow
1. Run `sprint-health-check` hook
2. Check for new blockers
3. Review PR status
4. Assess if sprint goal is at risk

### Sprint End Workflow
1. Run `sprint-health-check` hook
2. Calculate velocity via `team-velocity-calculator`
3. Generate retrospective data
4. Update technical debt tracker

### Quarterly Planning Workflow
1. Run `/capacity-planning` command
2. Review `/technical-debt-audit`
3. Analyze `/retrospective-analysis` for trends
4. Generate `/dependency-map` for roadmap
5. Create strategic plan

## Metrics Tracked

### Team Performance
- Sprint velocity
- Commitment vs. delivery
- Velocity trends and predictability
- Team capacity utilization

### DORA Metrics
- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery (MTTR)

### Code Quality
- Test coverage
- Code complexity
- Code duplication
- Technical debt

### Team Health
- Work in progress (WIP)
- Blocker frequency and resolution time
- Context switching
- On-call load

### PR Metrics
- PR size distribution
- Time to first review
- Time to merge
- Review thoroughness

## Configuration

### settings.json

Main configuration file controlling:
- Hook automation schedules
- Available commands
- Subagent definitions
- Workflow sequences
- Metric targets
- Notification settings
- Integration configurations

### Customization

Edit `settings.json` to customize:

```json
{
  "preferences": {
    "default_timeframe": "sprint",
    "velocity_calculation_sprints": 6,
    "tech_debt_allocation_pct": 20,
    "sprint_length_days": 10
  },
  "metrics": {
    "targets": {
      "test_coverage": "> 80%",
      "pr_review_time": "< 4 hours",
      "deployment_frequency": "> 1 per day"
    }
  }
}
```

## Integrations

### Supported Platforms

#### Project Management
- Jira (configure in settings.json)
- Linear (configure in settings.json)
- GitHub Projects (via GitHub MCP)

#### CI/CD
- GitHub Actions (via GitHub MCP)
- Jenkins (configure in settings.json)

#### Monitoring
- DataDog (configure in settings.json)
- Custom metrics via hooks

## Best Practices

### Daily
1. Review blocker-detector output each morning
2. Check PR review summary
3. Monitor sprint health if mid-sprint

### Weekly
1. Review team velocity trends
2. Check technical debt report
3. Analyze code quality trends
4. Review PR review statistics

### Sprint Cadence
1. **Sprint Start:** Run sprint planning, set goals
2. **Mid-Sprint:** Check sprint health, address blockers
3. **Sprint End:** Calculate metrics, prep retrospective

### Quarterly
1. Run capacity planning analysis
2. Review retrospective trends
3. Conduct technical debt audit
4. Map dependencies for roadmap
5. Set improvement goals

### Continuous Improvement
1. Track action items from retrospectives
2. Measure impact of changes
3. Adjust processes based on data
4. Celebrate wins with the team

## Troubleshooting

### GitHub CLI Issues
```bash
# Verify installation
gh --version

# Re-authenticate
gh auth login

# Test API access
gh api user
```

### Hook Permissions
```bash
# Make hooks executable
chmod +x hooks/*.sh

# Check permissions
ls -la hooks/
```

### MCP Server Issues
```bash
# Verify environment variables
echo $GITHUB_TOKEN
echo $UPSTASH_REDIS_REST_URL

# Test MCP connection
# (Use Claude Code MCP testing features)
```

## Resources

### Documentation
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [DORA Metrics Guide](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)
- [Sprint Planning Best Practices](https://www.scrum.org/resources/blog/sprint-planning-guide)

### Tools
- [GitHub](https://github.com) - Source control and project management
- [Upstash](https://upstash.com) - Redis for Context7 MCP (optional)
- [Mermaid](https://mermaid.live) - Dependency diagram visualization

## Support

For issues or questions:
1. Check hook output for error messages
2. Verify environment variables are set
3. Ensure GitHub CLI is authenticated
4. Review settings.json configuration

## Version

Engineering Manager Persona v1.0.0
Last Updated: October 4, 2025
