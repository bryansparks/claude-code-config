# Organization Standards - [Your Organization Name]

**Protected File**: DO NOT EDIT manually. Managed by claude-config.sh
**Version**: 1.0.0
**Last Updated**: [Date]
**Purpose**: Organization-wide standards preserved across all projects

---

## 🎯 Core Philosophy

This file contains your organization's engineering standards and best practices.
It is **automatically included** in every project's CLAUDE.md via `/init-project`.

**Key Principle**: Organization standards NEVER change per-project.
- ✅ Coding standards are consistent across all projects
- ✅ Approved tech stack is organization-wide
- ✅ Security policies apply universally
- ✅ Development workflow is standardized

---

## 📋 Coding Standards

@include shared/org-coding-standards.md

### Language-Specific Standards

#### Java
- **Style Guide**: Google Java Style Guide
- **Version**: Java 17+ (LTS)
- **Build Tool**: Maven 3.8+ or Gradle 8+
- **Testing**: JUnit 5, Mockito, TestContainers
- **Code Quality**: SonarQube, Checkstyle, SpotBugs

#### JavaScript/TypeScript
- **Style Guide**: Airbnb JavaScript Style Guide
- **Version**: ES2022+, TypeScript 5+
- **Package Manager**: npm 9+ or yarn 3+
- **Testing**: Jest, Vitest, Playwright
- **Code Quality**: ESLint, Prettier, TypeScript strict mode

#### Python
- **Style Guide**: PEP 8
- **Version**: Python 3.11+
- **Package Manager**: Poetry or pip-tools
- **Testing**: pytest, pytest-cov
- **Code Quality**: black, flake8, mypy

---

## 🛠️ Technology Stack

@include shared/org-tech-stack.md

### Approved Frameworks

#### Backend
- **Java**: Spring Boot 3.x, Spring Cloud, Micronaut
- **JavaScript/TypeScript**: Express.js, NestJS, Fastify
- **Python**: Django 4.x, FastAPI, Flask

#### Frontend
- **React**: 18.x with TypeScript
- **Vue**: 3.x with Composition API
- **Angular**: 16.x+ (for enterprise applications)

#### Database
- **Relational**: PostgreSQL 14+, MySQL 8+
- **NoSQL**: MongoDB 6+, Redis 7+
- **Search**: Elasticsearch 8+

#### Message Queue
- **Primary**: Apache Kafka 3+
- **Alternative**: RabbitMQ 3.11+, AWS SQS

#### Cloud & Infrastructure
- **Cloud**: AWS (primary), GCP (approved), Azure (approved)
- **Container**: Docker 20+, Kubernetes 1.27+
- **CI/CD**: GitHub Actions, GitLab CI, Jenkins

---

## 🔒 Security & Compliance

@include shared/org-security-policies.md

### Security Requirements

#### Authentication & Authorization
- **Standard**: OAuth 2.0 / OIDC
- **JWT**: Required for API authentication
- **MFA**: Mandatory for production access
- **Session Management**: 30-minute timeout, secure cookies

#### Data Protection
- **Encryption at Rest**: AES-256
- **Encryption in Transit**: TLS 1.3
- **PII Handling**: GDPR/CCPA compliant
- **Data Retention**: Per company policy (90 days default)

#### OWASP Top 10
- ✅ Injection Prevention (parameterized queries, input validation)
- ✅ Broken Authentication (strong password policy, MFA)
- ✅ Sensitive Data Exposure (encryption, secure storage)
- ✅ XML External Entities (disable XML entity expansion)
- ✅ Broken Access Control (RBAC, least privilege)
- ✅ Security Misconfiguration (secure defaults, hardening)
- ✅ Cross-Site Scripting (XSS) (input sanitization, CSP)
- ✅ Insecure Deserialization (avoid untrusted sources)
- ✅ Using Components with Known Vulnerabilities (dependency scanning)
- ✅ Insufficient Logging & Monitoring (structured logging, alerts)

#### Compliance
- **SOC 2 Type II**: Required for all customer-facing services
- **HIPAA**: Required for healthcare data processing
- **PCI DSS**: Required for payment processing
- **ISO 27001**: Organization-wide certification

---

## 🔄 Development Workflow

@include shared/org-dev-workflow.md

### Git Workflow

#### Branch Strategy
- **main**: Production-ready code (protected)
- **develop**: Integration branch (protected)
- **feature/[name]**: Feature development branches
- **hotfix/[name]**: Emergency production fixes
- **release/[version]**: Release preparation branches

#### Commit Message Convention
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: feat, fix, docs, style, refactor, test, chore
**Example**: `feat(auth): add OAuth 2.0 login support`

#### Pull Request Requirements
- ✅ All CI checks pass (tests, linting, security scan)
- ✅ Minimum 1 peer review approval
- ✅ Code coverage ≥80% for new code
- ✅ No merge conflicts
- ✅ PR description includes: What, Why, How, Testing

### Code Review Standards
- **Response Time**: 4 hours for blocking PRs, 24 hours for others
- **Review Depth**: Logic, security, performance, maintainability
- **Approval**: Senior engineer for architectural changes
- **Auto-merge**: Enabled for dependency updates (after CI pass)

### Testing Requirements
- **Unit Tests**: 80% minimum coverage
- **Integration Tests**: 60% minimum coverage
- **E2E Tests**: Critical user journeys only
- **Performance Tests**: Required for API endpoints
- **Security Tests**: SAST/DAST in CI pipeline

---

## 🤖 SuperClaude Configuration

@include shared/superclaude-core.yml#Core_Philosophy

### Core Principles
- **Efficiency First**: Minimize token usage while maintaining quality
- **Evidence-Based**: All decisions backed by data or rationale
- **Autonomous**: Capable of end-to-end feature delivery
- **Context-Aware**: Understands organization, project, and vision layers

### Token Economy
- **Budget**: 200,000 tokens per session
- **Reserved**: 50,000 tokens for context (org + project + vision)
- **Available**: 150,000 tokens for work
- **Optimization**: UltraCompressed mode for large codebases

---

## 👥 Personas

@include shared/superclaude-personas.yml#All_Personas

### Available Personas
1. **Software Engineer** - Full-stack development, architecture, testing
2. **QA Engineer** - Test automation, quality assurance, performance testing
3. **Engineering Manager** - Team coordination, velocity, technical debt management
4. **Product Manager** - Requirements, user stories, roadmap, prioritization
5. **UX Designer** - Design system, user flows, accessibility, visual design

### Persona Switching
```bash
export CLAUDE_PERSONA="engineer"  # or qa, em, pm, ux
```

---

## 🔌 MCP Integration

@include shared/superclaude-mcp.yml#MCP_Persona_Integration

### Configured MCP Servers

#### Essential (All Personas)
- **filesystem**: File operations with permissions
- **memory**: Persistent context and learning
- **sequential-thinking**: Complex problem decomposition

#### Code Navigation (Engineers, QA)
- **serena**: Semantic code understanding (LSP-based)
- **claude-context**: Semantic search and RAG

#### Project Management (PM, EM)
- **github**: Issues, PRs, project boards
- **context7**: Analytics and metrics

#### Testing & QA (QA, Engineers)
- **playwright**: Browser automation and testing

---

## 📊 Quality Standards

### Code Quality
- **Cyclomatic Complexity**: ≤10 per function
- **Function Length**: ≤50 lines (guideline, not hard rule)
- **Class Size**: ≤300 lines
- **Duplication**: ≤3% code duplication
- **Documentation**: Public APIs fully documented

### Performance Standards
- **API Response Time**: p95 ≤500ms, p99 ≤1000ms
- **Frontend**: LCP ≤2.5s, FID ≤100ms, CLS ≤0.1
- **Database**: Query time ≤100ms for 95th percentile
- **Memory**: JVM heap ≤2GB, Node.js ≤512MB

### Observability
- **Logging**: Structured JSON logs with correlation IDs
- **Metrics**: Prometheus format, 1-minute granularity
- **Tracing**: Distributed tracing with OpenTelemetry
- **Alerting**: PagerDuty for P0/P1, Slack for P2/P3

---

## 🚀 Deployment Standards

### Environments
1. **Development**: Local development, rapid iteration
2. **Testing**: Automated test execution, QA validation
3. **Staging**: Production-like, final validation
4. **Production**: Customer-facing, high availability

### Deployment Process
- **Frequency**: Multiple times per day (CI/CD)
- **Strategy**: Blue-green or canary deployment
- **Rollback**: Automated on health check failure
- **Monitoring**: 30-minute post-deployment observation

### Infrastructure as Code
- **Tool**: Terraform 1.5+
- **Repository**: Separate infra repo
- **Review**: Required for all infrastructure changes
- **State**: Remote state in S3 with locking

---

## 📚 Documentation Standards

### Required Documentation
- **README.md**: Every repository
- **ARCHITECTURE.md**: Services and libraries
- **API.md**: All REST/GraphQL APIs (OpenAPI/GraphQL schema)
- **RUNBOOK.md**: Production services (deployment, troubleshooting)

### Documentation Location
- **Code**: Inline comments for complex logic
- **Architecture**: docs/ directory in repository
- **API**: Auto-generated from code (Swagger, GraphQL Playground)
- **User Guides**: Separate documentation repository

---

## 🎓 Learning & Development

### Required Training
- **Security**: Annual security awareness training
- **New Technologies**: Before adoption in production
- **Incident Response**: Quarterly incident response drills
- **Code Review**: For all new team members

### Knowledge Sharing
- **Tech Talks**: Bi-weekly (30 minutes)
- **Architecture Reviews**: Monthly
- **Post-Mortems**: After all incidents
- **Documentation**: Update after major changes

---

## 🔧 Tool Standards

### IDE/Editor
- **Recommended**: IntelliJ IDEA, VS Code, Vim/Neovim
- **Required Plugins**: Linter, formatter, security scanner
- **Settings**: Shared team settings in repository

### Version Control
- **Tool**: Git 2.40+
- **Hosting**: GitHub Enterprise (primary)
- **Workflow**: GitHub Flow (for most projects)

### Communication
- **Sync**: Slack (primary), Zoom (meetings)
- **Async**: GitHub Issues/Discussions, Confluence
- **Incidents**: PagerDuty, Slack #incidents channel

---

## 📈 Metrics & Monitoring

### DORA Metrics (Goals)
- **Deployment Frequency**: Multiple per day
- **Lead Time for Changes**: <1 hour
- **Change Failure Rate**: <15%
- **Time to Restore Service**: <1 hour

### Code Metrics
- **Test Coverage**: ≥80%
- **Build Time**: ≤10 minutes
- **Code Review Time**: ≤4 hours
- **Merge Time**: ≤24 hours

---

## 🎯 Organizational Goals

### Engineering Excellence
- Build high-quality, maintainable software
- Continuous improvement of processes
- Knowledge sharing and documentation
- Work-life balance and sustainable pace

### Innovation
- Experiment with new technologies (in sandboxes)
- Quarterly hackathons
- 20% time for learning/side projects
- Encourage failing fast and learning

---

**Version**: 1.0.0
**Status**: ✅ Active
**Protected**: This file is preserved across all projects by /init-project

---

*These standards apply to ALL projects in the organization*
*Updated via claude-config.sh - DO NOT EDIT MANUALLY*
