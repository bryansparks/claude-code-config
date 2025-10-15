# Technical Debt Audit Command

## Purpose
Comprehensive technical debt assessment with prioritization, impact analysis, and remediation planning.

## Usage
```
/technical-debt-audit [repository] [--category=all|code|architecture|infrastructure]
```

## Parameters
- `repository` (optional): Target repository. Defaults to current directory.
- `--category`: Focus area for audit
  - `all`: Complete audit (default)
  - `code`: Code-level debt
  - `architecture`: Design and structure debt
  - `infrastructure`: Deployment and ops debt
  - `dependencies`: Third-party dependencies
- `--prioritize`: Sort by impact, effort, or value
- `--export`: Export format (markdown, csv, jira)

## Execution Flow

### 1. Debt Discovery
**Delegates to:** technical-debt-assessor subagent

Scan for:
- TODO/FIXME/HACK comments
- Code smells and anti-patterns
- Outdated dependencies
- Missing tests
- Documentation gaps
- Performance bottlenecks
- Security vulnerabilities

### 2. Categorization
Classify debt by type:
- **Code Quality**: Complexity, duplication, smells
- **Architecture**: Design violations, coupling
- **Testing**: Coverage gaps, flaky tests
- **Dependencies**: Outdated packages, vulnerabilities
- **Documentation**: Missing or outdated docs
- **Performance**: Known bottlenecks
- **Security**: Vulnerabilities, insecure patterns

### 3. Impact Assessment
For each item, evaluate:
- **Business Impact**: Customer-facing, revenue, brand
- **Technical Impact**: Velocity, reliability, scalability
- **Risk Level**: Probability and severity of issues
- **Maintenance Burden**: Ongoing cost

### 4. Effort Estimation
Estimate remediation effort:
- Hours/days required
- Team skills needed
- Dependencies on other work
- Risk of introducing bugs

### 5. Prioritization
Create priority matrix:
```
          HIGH IMPACT
          │
    2     │     1
  MEDIUM  │  CRITICAL
  EFFORT  │   LOW EFFORT
─────────────────────────
    4     │     3
   LOW    │   MEDIUM
  IMPACT  │   PRIORITY
          │
         LOW IMPACT
```

### 6. Generate Report

```
TECHNICAL DEBT AUDIT
====================
Repository: [NAME]
Date: [DATE]
Total Debt: 45 days effort

EXECUTIVE SUMMARY
-----------------
Debt Score: 62/100 (NEEDS ATTENTION)

Critical Issues:     5 (15 days)
High Priority:      12 (18 days)
Medium Priority:    23 (10 days)
Low Priority:       15 (2 days)

DEBT BY CATEGORY
----------------
Code Quality:        40% (18 days)
Architecture:        25% (11 days)
Testing:             20% (9 days)
Dependencies:        10% (4.5 days)
Documentation:       5% (2.5 days)

CRITICAL ITEMS (Immediate Action)
----------------------------------
1. Payment Processing Service - No Tests
   Category: Testing
   Impact: HIGH (Customer-facing, revenue risk)
   Effort: 5 days
   Risk: Data corruption, failed payments
   Recommendation: Add comprehensive test suite

2. User Authentication - SQL Injection Vulnerability
   Category: Security
   Impact: CRITICAL (Data breach risk)
   Effort: 2 days
   Risk: Account compromise, data loss
   Recommendation: Implement parameterized queries

3. Database Schema - Missing Indexes
   Category: Performance
   Impact: HIGH (Page load >3s, customer churn)
   Effort: 3 days
   Risk: Continued performance degradation
   Recommendation: Add indexes on high-traffic queries

4. Legacy API v1 - Deprecated, Still in Use
   Category: Architecture
   Impact: HIGH (Blocks v2 adoption, security)
   Effort: 3 days
   Risk: Maintenance burden, security holes
   Recommendation: Migrate remaining clients to v2

5. Outdated Dependencies - 15 Critical CVEs
   Category: Dependencies
   Impact: CRITICAL (Security vulnerabilities)
   Effort: 2 days
   Risk: Known exploits, data breach
   Recommendation: Upgrade immediately

HIGH PRIORITY (Next Sprint)
----------------------------
[12 items listed...]

TECHNICAL DEBT TRENDS
---------------------
Last Month:    +8 days (+22%)
Last Quarter:  +15 days (+50%)
Resolution:    -3 days this quarter

Fastest Growing Areas:
1. Testing debt: +12 days
2. Architecture debt: +5 days

PAYDOWN RECOMMENDATIONS
-----------------------
Sprint Allocation Suggestion:
  20% capacity to tech debt (9 days/sprint)

Recommended Order:
  Sprint N:     Critical items 1-5 (15 days)
  Sprint N+1:   High priority items 1-6 (9 days)
  Sprint N+2:   High priority items 7-12 (9 days)

Expected ROI:
  - 30% reduction in production incidents
  - 2 hour/week savings in maintenance
  - 15% improvement in deployment speed

RISK ANALYSIS
-------------
Without Remediation:
  - 40% chance of security incident (high severity)
  - 60% chance of major performance incident
  - Estimated cost: $50K+ in lost revenue/quarter

DETAILED INVENTORY
------------------
[Full list of 55 items with descriptions...]
```

## Audit Categories

### Code Quality Debt
- High cyclomatic complexity
- Code duplication
- Long functions/classes
- Inconsistent formatting
- Dead code

### Architecture Debt
- Layer violations
- Circular dependencies
- Tight coupling
- Missing abstractions
- God classes/modules

### Testing Debt
- Low test coverage
- Missing tests for critical paths
- Flaky tests
- No integration tests
- Manual testing required

### Dependency Debt
- Outdated packages
- Security vulnerabilities
- License incompatibilities
- Deprecated dependencies
- Version conflicts

### Documentation Debt
- Missing README
- Outdated docs
- No API documentation
- Missing architecture diagrams
- No runbook/playbook

### Infrastructure Debt
- Manual deployment steps
- No monitoring/alerting
- Single points of failure
- No disaster recovery plan
- Unscalable architecture

## Prioritization Criteria

### Impact Scoring (1-10)
- **10**: Critical customer-facing, revenue, or security impact
- **7-9**: High impact to velocity, reliability, or scalability
- **4-6**: Medium impact, technical quality concerns
- **1-3**: Low impact, nice-to-have improvements

### Effort Scoring (1-10)
- **1-3**: Quick wins (< 2 days)
- **4-6**: Medium effort (2-5 days)
- **7-10**: Large effort (> 5 days)

### Priority Matrix
```
Impact/Effort | 1-3 days  | 4-6 days  | 7+ days
--------------|-----------|-----------|----------
HIGH (8-10)   | CRITICAL  | HIGH      | MEDIUM
MEDIUM (5-7)  | HIGH      | MEDIUM    | LOW
LOW (1-4)     | MEDIUM    | LOW       | AVOID
```

## Output Formats

### Summary Report (text)
```
Technical Debt: 45 days
Critical: 5 items (15 days)
High: 12 items (18 days)
```

### Detailed Report (markdown)
Full report with recommendations and action plan

### CSV Export
For importing into project management tools:
```csv
ID,Category,Item,Impact,Effort,Priority,Status
TD-001,Security,SQL Injection,10,2,CRITICAL,Open
TD-002,Testing,No Payment Tests,9,5,CRITICAL,Open
```

### Jira Integration
Automatically create Jira issues:
```
Created 17 technical debt issues:
- 5 Critical (P0)
- 12 High (P1)
```

## Examples

### Quick Audit
```
/technical-debt-audit --category=code

Scanning code quality debt...

Found 23 items (10 days effort):
  - 15 files with high complexity
  - 8% code duplication
  - 45 TODO/FIXME comments

Top Priority:
1. src/payment/processor.ts - Complexity: 45
```

### Full Audit with Export
```
/technical-debt-audit myapp --export=markdown --output=debt-audit.md

Running comprehensive technical debt audit...

✅ Code analysis complete
✅ Architecture review complete
✅ Dependency scan complete
✅ Security audit complete

Report generated: debt-audit.md
Total debt: 45 days across 55 items
```

### Category-Specific Audit
```
/technical-debt-audit --category=dependencies

Dependency Audit Results:

Outdated Packages:    15
Security Issues:      8 (3 critical)
License Issues:       2

Critical CVEs:
- lodash 4.17.15: Prototype Pollution (CVE-2020-8203)
- axios 0.19.2: SSRF (CVE-2021-3749)
- moment 2.24.0: ReDoS (CVE-2022-24785)

Recommendation: Upgrade immediately (2 days effort)
```

### Trend Analysis
```
/technical-debt-audit --trends --timeframe=90d

Technical Debt Trends (Last 90 Days)

Total Debt:     45 days (+50% from 30 days)
Resolution Rate: 3 days/month
Accumulation:   6 days/month

Net Change:     +3 days/month (GROWING)

Fastest Growing:
1. Testing: +12 days
2. Architecture: +5 days

Action Required: Increase debt paydown capacity
```

## Automation

### Scheduled Audits
```yaml
schedule:
  - cron: "0 0 * * 0"  # Weekly on Sunday
    command: /technical-debt-audit --export=markdown
    notify: slack
```

### PR Quality Gate
```yaml
pr-gate:
  - run: /technical-debt-audit --quick
  - fail-if: new_critical_debt > 0
  - warn-if: new_high_debt > 2
```

## Configuration

`.claude/engineering-manager/debt-audit.yml`:
```yaml
thresholds:
  complexity_max: 15
  duplication_max: 5
  coverage_min: 70

categories:
  enabled:
    - code
    - architecture
    - testing
    - dependencies
    - documentation
    - security

prioritization:
  weight_impact: 0.7
  weight_effort: 0.3

output:
  default_format: markdown
  save_history: true
  trend_lookback_days: 90
```

## Best Practices

1. **Regular Cadence**: Run monthly full audits, weekly quick scans
2. **Track Trends**: Monitor debt accumulation vs. resolution
3. **Allocate Capacity**: Reserve 15-20% of sprint for debt paydown
4. **Quick Wins First**: Knock out high-impact, low-effort items
5. **Prevent New Debt**: Use PR gates to prevent debt introduction
6. **Measure ROI**: Track velocity and incident improvements
