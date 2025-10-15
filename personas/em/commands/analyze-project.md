# Analyze Project Command

## Purpose
Comprehensive project health analysis combining code quality, technical debt, team metrics, and risk assessment.

## Usage
```
/analyze-project [repository] [--depth=full|standard|quick]
```

## Parameters
- `repository` (optional): Target repository path or GitHub URL. Defaults to current directory.
- `--depth`: Analysis depth
  - `full`: Complete analysis with historical trends
  - `standard`: Current metrics and basic trends (default)
  - `quick`: Essential metrics only

## Execution Flow

### 1. Initialize Analysis
- Validate repository access
- Check required tools (git, gh CLI)
- Set analysis scope based on depth parameter

### 2. Code Health Assessment
**Delegates to:** code-health-monitor subagent

Collect:
- Code complexity metrics
- Test coverage statistics
- Code duplication percentages
- File size distribution
- Comment density

### 3. Technical Debt Audit
**Delegates to:** technical-debt-assessor subagent

Analyze:
- TODO/FIXME/HACK comments
- Deprecated code usage
- Outdated dependencies
- Security vulnerabilities
- Architecture violations

### 4. Team Metrics
**Delegates to:** metrics-reporter subagent

Gather:
- Recent sprint velocity
- PR review metrics
- Deployment frequency
- Incident rates
- On-call load

### 5. Risk Identification
**Delegates to:** project-analyzer subagent

Assess:
- Critical code paths without tests
- Single points of failure
- Knowledge silos (one contributor per module)
- Scalability concerns
- Performance bottlenecks

### 6. Generate Report

Combine all subagent outputs into comprehensive report:

```
PROJECT HEALTH ANALYSIS
=======================

OVERALL SCORE: [85]/100

CODE HEALTH
-----------
Maintainability: 82/100 ✅
Reliability:     78/100 ⚠️
Security:        90/100 ✅

TECHNICAL DEBT
--------------
Total: 15 days effort
Priority Distribution:
  Critical: 3 days
  High:     7 days
  Medium:   5 days

TEAM PERFORMANCE
----------------
Velocity:     45 pts/sprint (↑ improving)
PR Cycle:     1.5 days average
Deploy Rate:  3.2/day
Incidents:    2/week

RISKS
-----
🔴 Critical:
  - Payment service has 0% test coverage
  - Database migration pending for 45 days

🟡 High:
  - Authentication module maintained by 1 person only
  - API gateway at 85% capacity

RECOMMENDATIONS
---------------
1. [URGENT] Add tests to payment service
2. [HIGH] Complete database migration
3. [MEDIUM] Document authentication module
4. [MEDIUM] Plan API gateway scaling
```

## Output Formats
- **text**: Formatted console output (default)
- **markdown**: Markdown report for documentation
- **json**: Structured data for automation
- **html**: Interactive dashboard

## Integration Points

### Tools Used
- Git for commit history analysis
- GitHub CLI for PR/issue metrics
- Static analysis tools (ESLint, SonarQube)
- Dependency scanners (npm audit, Snyk)
- Test coverage tools

### Subagents Invoked
1. project-analyzer - Overall project assessment
2. code-health-monitor - Code quality metrics
3. technical-debt-assessor - Debt identification
4. metrics-reporter - Team performance data

## Examples

### Quick Check
```
/analyze-project --depth=quick

Running quick project analysis...

Overall Health: 85/100 ✅
Code Quality:   82/100
Technical Debt: 15 days
Team Velocity:  45 pts/sprint
```

### Full Analysis with Report
```
/analyze-project myapp --depth=full --format=markdown --output=report.md

Performing comprehensive analysis of myapp...

✅ Code health assessment complete
✅ Technical debt audit complete
✅ Team metrics collected
✅ Risk analysis complete

Report generated: report.md
```

### Multi-Repository Analysis
```
/analyze-project --repos=frontend,backend,mobile --compare

Comparing 3 repositories...

Repository    Health  Debt    Velocity
frontend      85/100  12d     48 pts
backend       78/100  23d     42 pts
mobile        92/100  5d      38 pts
```

## Automation

### Scheduled Reports
Run automatically on schedule:
```yaml
schedule:
  - cron: "0 9 * * MON"
    command: /analyze-project --depth=standard --notify=slack
```

### Pre-Release Gate
```yaml
pre-release:
  - run: /analyze-project --depth=full
  - gate: health_score >= 80
  - gate: critical_debt == 0
  - gate: test_coverage >= 70
```

## Best Practices

1. **Regular Cadence**: Run weekly standard analysis, monthly full analysis
2. **Track Trends**: Compare against previous analysis to identify degradation
3. **Action Items**: Convert recommendations into tracked tasks
4. **Team Review**: Share reports in engineering meetings
5. **Set Baselines**: Establish minimum acceptable scores and enforce

## Configuration

`.claude/engineering-manager/analyze-project.yml`:
```yaml
thresholds:
  health_score_min: 75
  test_coverage_min: 70
  complexity_max: 15
  duplication_max: 5

notifications:
  slack_channel: "#engineering"
  alert_on_decline: true
  critical_risks_to: ["tech-lead@company.com"]

output:
  default_format: text
  save_history: true
  history_path: .claude/reports/
```
