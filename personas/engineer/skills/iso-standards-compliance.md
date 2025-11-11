---
name: iso-standards-compliance
description: ISO/IEC 25010 software quality model compliance assessment with automated scoring for functional suitability, performance efficiency, compatibility, usability, reliability, security, maintainability, and portability. Use when reviewing code quality, assessing software architecture, or when user mentions ISO standards.
---

# ISO Standards Compliance Skill

Comprehensive software quality assessment based on ISO/IEC 25010 quality model with automated scoring, detailed metrics, and actionable remediation guidance.

## When to Use This Skill

Automatically invoke when the user:
- Requests ISO compliance review or quality assessment
- Mentions "ISO 25010", "software quality model"
- Asks about maintainability, portability, or reliability
- Wants comprehensive code quality analysis
- Needs to meet regulatory or certification requirements
- Asks for quality metrics or scoring

## ISO/IEC 25010 Quality Model

### Eight Quality Characteristics

```
ISO/IEC 25010 Software Quality Model
═══════════════════════════════════

1. Functional Suitability
   └─ Does the software do what it should?

2. Performance Efficiency
   └─ How well does it use resources?

3. Compatibility
   └─ Can it coexist and interoperate?

4. Usability
   └─ Can users operate it effectively?

5. Reliability
   └─ Can it perform under stated conditions?

6. Security
   └─ Is data and functionality protected?

7. Maintainability
   └─ Can it be modified effectively?

8. Portability
   └─ Can it be transferred to other environments?
```

## Quality Characteristic Analysis

### 1. Functional Suitability

**Sub-characteristics:**
- **Functional Completeness**: All specified functions implemented
- **Functional Correctness**: Results are correct and precise
- **Functional Appropriateness**: Functions facilitate specified tasks

**Metrics:**
```typescript
// Functional Completeness Score
const functionalCompleteness =
  (implementedRequirements / totalRequirements) * 100;

// Functional Correctness Score
const functionalCorrectness =
  (passedTests / totalTests) * 100;
```

**Assessment:**
```
✓ Requirements Coverage
  - Implemented: 45/50 requirements (90%)
  - Tested: 42/45 implemented (93%)
  - Edge cases covered: 85%

✓ Functional Correctness
  - Unit test pass rate: 98%
  - Integration test pass rate: 95%
  - User acceptance test pass rate: 92%

⚠ Functional Appropriateness
  - User workflow efficiency: 75%
  - Task completion rate: 88%
  - Recommendation: Simplify checkout process (6 steps → 3 steps)
```

---

### 2. Performance Efficiency

**Sub-characteristics:**
- **Time Behavior**: Response times, throughput
- **Resource Utilization**: CPU, memory, network
- **Capacity**: Maximum limits

**Metrics:**
```typescript
// Performance Scoring
interface PerformanceMetrics {
  responseTimeP95: number;  // milliseconds
  throughput: number;       // requests/second
  cpuUsage: number;        // percentage
  memoryUsage: number;     // MB
  dbQueryTime: number;     // milliseconds
}

const calculatePerformanceScore = (metrics: PerformanceMetrics): number => {
  let score = 100;

  // Response time scoring (target: <500ms p95)
  if (metrics.responseTimeP95 > 500) {
    score -= ((metrics.responseTimeP95 - 500) / 500) * 20;
  }

  // Resource utilization (target: <70% CPU)
  if (metrics.cpuUsage > 70) {
    score -= ((metrics.cpuUsage - 70) / 30) * 15;
  }

  // Memory usage (target: <512MB)
  if (metrics.memoryUsage > 512) {
    score -= ((metrics.memoryUsage - 512) / 512) * 15;
  }

  return Math.max(0, Math.min(100, score));
};
```

**Assessment:**
```
⚡ Time Behavior: 78/100
  - API Response Time (p95): 680ms (Target: <500ms) ⚠️
  - Database Query Time (p95): 120ms (Target: <100ms) ⚠️
  - Frontend Load Time (LCP): 2.1s (Target: <2.5s) ✓

🔋 Resource Utilization: 85/100
  - CPU Usage (avg): 45% (Target: <70%) ✓
  - Memory Usage: 380MB (Target: <512MB) ✓
  - Network Bandwidth: 15MB/s (Target: <50MB/s) ✓

📊 Capacity: 82/100
  - Max Concurrent Users: 1,500 (Target: 2,000) ⚠️
  - Max Requests/sec: 850 (Target: 1,000) ⚠️
  - Database Connection Pool: 45/50 ✓

Overall Performance Score: 82/100 (Good)
```

---

### 3. Compatibility

**Sub-characteristics:**
- **Co-existence**: Can coexist with other software
- **Interoperability**: Can exchange and use information

**Assessment:**
```
🔗 Interoperability: 88/100
  ✓ RESTful API (OpenAPI 3.0 compliant)
  ✓ JSON data format (standard)
  ✓ OAuth 2.0 authentication (standard)
  ✓ Webhooks for event notifications
  ⚠️ GraphQL API versioning inconsistent

🤝 Co-existence: 75/100
  ✓ No port conflicts (uses standard ports)
  ✓ Database isolation (separate schema)
  ⚠️ Shared Redis cache (potential conflicts)
  ⚠️ Log file naming may conflict with other apps

Recommendations:
  1. Namespace Redis keys: app:user:123 instead of user:123
  2. Use unique log file names: /var/log/myapp-{service}.log
  3. Standardize GraphQL API versioning
```

---

### 4. Usability

**Sub-characteristics:**
- **Appropriateness Recognizability**: Users recognize suitability
- **Learnability**: Users can learn to use it
- **Operability**: Users can operate and control it
- **User Error Protection**: Protects against user errors
- **User Interface Aesthetics**: Pleasing interface
- **Accessibility**: Usable by people with disabilities

**Metrics:**
```typescript
interface UsabilityMetrics {
  taskCompletionRate: number;    // percentage
  timeToComplete: number;        // seconds
  errorRate: number;             // errors per task
  satisfactionScore: number;     // 1-5 scale
  learnabilityScore: number;     // 1-5 scale
  accessibilityScore: number;    // WCAG compliance %
}

const calculateUsabilityScore = (metrics: UsabilityMetrics): number => {
  const weights = {
    taskCompletion: 0.25,
    efficiency: 0.20,
    errorPrevention: 0.20,
    satisfaction: 0.15,
    learnability: 0.10,
    accessibility: 0.10
  };

  const scores = {
    taskCompletion: metrics.taskCompletionRate,
    efficiency: Math.max(0, 100 - (metrics.timeToComplete - 60) / 60 * 50),
    errorPrevention: Math.max(0, 100 - metrics.errorRate * 20),
    satisfaction: (metrics.satisfactionScore / 5) * 100,
    learnability: (metrics.learnabilityScore / 5) * 100,
    accessibility: metrics.accessibilityScore
  };

  return Object.entries(weights).reduce((total, [key, weight]) => {
    return total + (scores[key as keyof typeof scores] * weight);
  }, 0);
};
```

**Assessment:**
```
👤 Usability: 81/100

  ✓ Task Completion: 92% (Excellent)
  ✓ User Satisfaction: 4.2/5 (Good)
  ⚠️ Learnability: 3.5/5 (Needs Improvement)
  ✓ Error Prevention: 88% (Good)
  ⚠️ Accessibility: 75% WCAG 2.1 AA (Needs Work)

Key Issues:
  1. Onboarding: Users take avg 15min to complete first task (Target: <5min)
  2. Navigation: 23% of users report difficulty finding features
  3. Error Messages: Only 65% of errors provide actionable guidance
  4. Accessibility: Missing ARIA labels on 15 components

Recommendations:
  - Add interactive tutorial for first-time users
  - Improve information architecture and navigation
  - Enhance error messages with specific solutions
  - Complete WCAG 2.1 AA accessibility audit
```

---

### 5. Reliability

**Sub-characteristics:**
- **Maturity**: Meets reliability needs under normal operation
- **Availability**: Operational and accessible when required
- **Fault Tolerance**: Operates despite faults
- **Recoverability**: Can recover data and re-establish state

**Metrics:**
```typescript
interface ReliabilityMetrics {
  uptime: number;              // percentage (99.9% = "three nines")
  mtbf: number;                // Mean Time Between Failures (hours)
  mttr: number;                // Mean Time To Recovery (minutes)
  errorRate: number;           // errors per 1000 requests
  dataIntegrity: number;       // percentage
  failoverTime: number;        // seconds
}

const calculateReliabilityScore = (metrics: ReliabilityMetrics): number => {
  let score = 100;

  // Uptime scoring (target: 99.9%)
  const uptimeTarget = 99.9;
  if (metrics.uptime < uptimeTarget) {
    score -= (uptimeTarget - metrics.uptime) * 10;
  }

  // MTBF scoring (target: >720 hours / 30 days)
  if (metrics.mtbf < 720) {
    score -= ((720 - metrics.mtbf) / 720) * 20;
  }

  // MTTR scoring (target: <15 minutes)
  if (metrics.mttr > 15) {
    score -= ((metrics.mttr - 15) / 15) * 15;
  }

  // Error rate (target: <1 per 1000)
  if (metrics.errorRate > 1) {
    score -= (metrics.errorRate - 1) * 10;
  }

  return Math.max(0, Math.min(100, score));
};
```

**Assessment:**
```
🛡️ Reliability: 87/100

  ✓ Availability (Last 30 days)
    - Uptime: 99.92% (Target: 99.9%) ✓
    - Downtime: 35 minutes (Target: <43 minutes) ✓
    - Planned Maintenance: 15 minutes
    - Unplanned Outages: 20 minutes

  ✓ Maturity
    - MTBF: 840 hours (Target: >720 hours) ✓
    - Error Rate: 0.7 per 1000 requests (Target: <1) ✓
    - Critical Bugs in Production: 2 in last 90 days

  ⚠️ Fault Tolerance
    - Database Replication: 2 replicas ✓
    - Load Balancer: Active (2 nodes) ✓
    - Circuit Breaker: Partially implemented ⚠️
    - Graceful Degradation: Not implemented ❌

  ⚠️ Recoverability
    - MTTR: 22 minutes (Target: <15 minutes) ⚠️
    - Backup Frequency: Daily ✓
    - Recovery Time Objective (RTO): 1 hour ✓
    - Recovery Point Objective (RPO): 24 hours ⚠️
    - Last Disaster Recovery Test: 6 months ago ⚠️

Critical Improvements Needed:
  1. Implement circuit breaker for all external API calls
  2. Add graceful degradation (serve cached content when DB unavailable)
  3. Reduce MTTR with better monitoring and automated recovery
  4. Increase backup frequency to hourly (reduce RPO to 1 hour)
  5. Conduct quarterly disaster recovery drills
```

---

### 6. Security

**Assessment:**
```
🔒 Security: 85/100

(See security-analysis.md skill for comprehensive security review)

ISO 27001 Controls Implemented: 78/114 (68%)

Key Strengths:
  ✓ Authentication & Authorization
  ✓ Data Encryption (at rest & in transit)
  ✓ Security Headers (CSP, HSTS)
  ✓ Input Validation

Key Gaps:
  ⚠️ Penetration Testing: Not conducted in 12 months
  ⚠️ Security Awareness Training: 60% of team completed
  ⚠️ Incident Response Plan: Not tested in 6 months
```

---

### 7. Maintainability

**Sub-characteristics:**
- **Modularity**: Composed of discrete components
- **Reusability**: Asset can be used in multiple systems
- **Analyzability**: Assess impact of changes
- **Modifiability**: Can be modified without defects
- **Testability**: Can establish test criteria

**Metrics:**
```typescript
interface MaintainabilityMetrics {
  cyclomaticComplexity: number;     // avg per function
  linesPerFunction: number;         // avg
  duplicateCode: number;            // percentage
  testCoverage: number;             // percentage
  codeChurn: number;                // lines changed/week
  technicalDebt: number;            // hours to fix
  documentationCoverage: number;    // percentage
}

const calculateMaintainabilityScore = (metrics: MaintainabilityMetrics): number => {
  let score = 100;

  // Complexity (target: ≤10)
  if (metrics.cyclomaticComplexity > 10) {
    score -= ((metrics.cyclomaticComplexity - 10) / 10) * 20;
  }

  // Function length (target: ≤50 lines)
  if (metrics.linesPerFunction > 50) {
    score -= ((metrics.linesPerFunction - 50) / 50) * 15;
  }

  // Duplicate code (target: <3%)
  if (metrics.duplicateCode > 3) {
    score -= (metrics.duplicateCode - 3) * 5;
  }

  // Test coverage (target: ≥80%)
  if (metrics.testCoverage < 80) {
    score -= (80 - metrics.testCoverage) * 0.5;
  }

  // Technical debt (normalized to hours per 1000 LOC)
  const debtRatio = metrics.technicalDebt / (metrics.linesPerFunction * 20);
  if (debtRatio > 5) {
    score -= (debtRatio - 5) * 2;
  }

  return Math.max(0, Math.min(100, score));
};
```

**Assessment:**
```
🔧 Maintainability: 76/100

  ✓ Modularity: 85/100
    - Module Cohesion: High (well-defined boundaries)
    - Module Coupling: Low (dependencies managed via DI)
    - Average Module Size: 450 LOC (Target: <500) ✓
    - Circular Dependencies: 2 detected ⚠️

  ⚠️ Reusability: 68/100
    - Shared Components: 42% of codebase
    - Utility Functions: Well-organized ✓
    - Code Duplication: 4.2% (Target: <3%) ⚠️
    - Abstract Interfaces: 55% (Target: >70%) ⚠️

  ✓ Analyzability: 82/100
    - Cyclomatic Complexity (avg): 8.5 (Target: ≤10) ✓
    - Lines per Function (avg): 38 (Target: ≤50) ✓
    - Nesting Depth (max): 4 (Target: ≤4) ✓
    - Code Comments: 18% (Target: 15-20%) ✓

  ⚠️ Modifiability: 72/100
    - Change Impact Analysis: Manual ⚠️
    - Regression Test Coverage: 75% (Target: >90%) ⚠️
    - Build Time: 12 minutes (Target: <10 min) ⚠️
    - Hot Reload: Enabled ✓

  ✓ Testability: 85/100
    - Unit Test Coverage: 84% (Target: ≥80%) ✓
    - Integration Test Coverage: 68% (Target: ≥60%) ✓
    - Mocking Framework: Used appropriately ✓
    - Test Execution Time: 8 minutes (Target: <10 min) ✓

Technical Debt:
  - Total Hours: 280 hours
  - High Priority: 45 hours
  - Medium Priority: 135 hours
  - Low Priority: 100 hours

Recommendations:
  1. Refactor 2 circular dependencies
  2. Reduce code duplication from 4.2% → 3%
  3. Increase abstract interfaces usage
  4. Improve regression test coverage to 90%
  5. Optimize build time (12min → 8min)
  6. Address high-priority technical debt (45 hours)
```

---

### 8. Portability

**Sub-characteristics:**
- **Adaptability**: Can be adapted for different environments
- **Installability**: Can be installed and/or uninstalled
- **Replaceability**: Can replace another system

**Assessment:**
```
🌍 Portability: 79/100

  ✓ Adaptability: 82/100
    - Environment Configuration: Externalized ✓
    - Database Abstraction: ORM used (Prisma) ✓
    - Cloud-Agnostic: Runs on AWS, GCP, Azure ✓
    - Container Support: Docker + Kubernetes ✓
    - Cross-Platform Code: 95% (5% OS-specific) ✓

  ⚠️ Installability: 75/100
    - Installation Documentation: Comprehensive ✓
    - Automated Installation: Partial (Docker only) ⚠️
    - Installation Time: 15 minutes (Target: <10 min) ⚠️
    - Uninstallation: Manual cleanup required ⚠️
    - Installation Success Rate: 92% (Target: >95%) ⚠️

  ✓ Replaceability: 80/100
    - Data Export: Standard formats (JSON, CSV) ✓
    - API Migration Path: Documented ✓
    - Backward Compatibility: 2 versions ✓
    - Migration Tools: Basic scripts provided ⚠️

Environment Dependencies:
  ✓ Node.js: 18.x LTS (standard)
  ✓ PostgreSQL: 14+ (standard)
  ✓ Redis: 7+ (standard)
  ⚠️ OS-Specific: File path handling (Windows/Unix)
  ⚠️ External Services: 3 third-party APIs (vendor lock-in risk)

Recommendations:
  1. Create automated installation script for all platforms
  2. Reduce installation time with pre-built images
  3. Add automated uninstallation/cleanup
  4. Abstract file path handling (use path.join everywhere)
  5. Document migration path from third-party APIs
```

---

## Overall ISO/IEC 25010 Compliance Score

```
═══════════════════════════════════════════════════════
ISO/IEC 25010 SOFTWARE QUALITY ASSESSMENT
═══════════════════════════════════════════════════════

Overall Quality Score: 82/100 (GOOD)
Compliance Level: HIGH (meets industry standards)

Quality Characteristic Breakdown:
───────────────────────────────────────────────────────

1. Functional Suitability     ████████████████░░░░  92/100  ✓
2. Performance Efficiency     ████████████████░░░░  82/100  ✓
3. Compatibility              ████████████████░░░░  82/100  ✓
4. Usability                  ████████████████░░░░  81/100  ✓
5. Reliability                ████████████████░░░░  87/100  ✓
6. Security                   ████████████████░░░░  85/100  ✓
7. Maintainability            ███████████████░░░░░  76/100  ⚠️
8. Portability                ████████████████░░░░  79/100  ✓

═══════════════════════════════════════════════════════

📊 Scoring Legend:
   90-100: EXCELLENT - Exceeds industry standards
   80-89:  GOOD      - Meets industry standards
   70-79:  FAIR      - Acceptable, needs improvement
   60-69:  POOR      - Below standards, action required
   <60:    CRITICAL  - Immediate attention required

═══════════════════════════════════════════════════════

🎯 Top 5 Improvement Priorities:

1. [Maintainability] Reduce Technical Debt
   Current: 280 hours  |  Target: <150 hours
   Impact: HIGH  |  Effort: 6 weeks

2. [Usability] Improve Accessibility
   Current: 75% WCAG 2.1  |  Target: 95% WCAG 2.1
   Impact: HIGH  |  Effort: 3 weeks

3. [Performance] Optimize API Response Times
   Current: 680ms p95  |  Target: <500ms p95
   Impact: MEDIUM  |  Effort: 2 weeks

4. [Reliability] Implement Graceful Degradation
   Current: None  |  Target: Full implementation
   Impact: HIGH  |  Effort: 4 weeks

5. [Portability] Automate Installation Process
   Current: Manual  |  Target: One-click install
   Impact: MEDIUM  |  Effort: 2 weeks

═══════════════════════════════════════════════════════

📈 Quality Trend (Last 6 Months):
   Jan: 75 → Feb: 77 → Mar: 78 → Apr: 80 → May: 81 → Jun: 82
   Trajectory: IMPROVING (+7 points in 6 months) ✓

═══════════════════════════════════════════════════════

🏆 ISO Certification Readiness:
   ISO/IEC 25010: READY (score ≥80)
   ISO 9001: READY (quality management)
   ISO 27001: PARTIAL (security - 68% controls)

Recommendation: Proceed with ISO/IEC 25010 certification audit
Estimated Preparation Time: 4-6 weeks

═══════════════════════════════════════════════════════
```

## Automated Quality Monitoring

```typescript
// quality-monitor.ts - Continuous quality tracking

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

interface QualityMetrics {
  complexity: number;
  coverage: number;
  duplication: number;
  violations: number;
  technicalDebt: number;
}

export class QualityMonitor {
  async calculateQualityScore(): Promise<number> {
    const metrics = await this.collectMetrics();
    return this.computeScore(metrics);
  }

  private async collectMetrics(): Promise<QualityMetrics> {
    // Run SonarQube analysis
    await execAsync('sonar-scanner');

    // Collect metrics from various tools
    const complexity = await this.getComplexity();
    const coverage = await this.getCoverage();
    const duplication = await this.getDuplication();
    const violations = await this.getViolations();
    const technicalDebt = await this.getTechnicalDebt();

    return {
      complexity,
      coverage,
      duplication,
      violations,
      technicalDebt
    };
  }

  private computeScore(metrics: QualityMetrics): number {
    const weights = {
      complexity: 0.20,
      coverage: 0.25,
      duplication: 0.15,
      violations: 0.25,
      technicalDebt: 0.15
    };

    // Normalize each metric to 0-100 scale
    const normalized = {
      complexity: Math.max(0, 100 - (metrics.complexity - 10) * 5),
      coverage: metrics.coverage,
      duplication: Math.max(0, 100 - metrics.duplication * 10),
      violations: Math.max(0, 100 - metrics.violations),
      technicalDebt: Math.max(0, 100 - (metrics.technicalDebt / 10))
    };

    // Calculate weighted average
    return Object.entries(weights).reduce((score, [key, weight]) => {
      return score + (normalized[key as keyof typeof normalized] * weight);
    }, 0);
  }

  // Additional metric collection methods...
}
```

## Best Practices

1. **Automate Quality Checks**: Integrate into CI/CD pipeline
2. **Regular Audits**: Quarterly ISO compliance reviews
3. **Track Trends**: Monitor quality score over time
4. **Prioritize Issues**: Focus on high-impact improvements
5. **Document Decisions**: Maintain architecture decision records (ADRs)
6. **Continuous Improvement**: Iterative quality enhancements
7. **Team Training**: Educate team on quality standards

---

**Remember**: ISO/IEC 25010 compliance is not a one-time achievement - it requires continuous monitoring and improvement to maintain high software quality standards.
