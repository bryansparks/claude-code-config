# Project: [PROJECT_NAME]

**Status**: [Planning | Active Development | Maintenance]
**Start Date**: [Date]
**Team Size**: [Number]
**Timeline**: [Duration]

---

## Quick Reference

- **Primary Tech Stack**: [Languages/Frameworks]
- **Architecture**: [Pattern/Style]
- **Team Composition**: [Roles]
- **Target Launch**: [Date/Milestone]

---

## Project Overview

### Purpose
[1-2 sentences describing what this project does and why it exists]

### Business Value
[What problem this solves, who it helps, what value it creates]

### Current State
[Where the project is now - planning, in progress, percentage complete]

---

## Technology Stack

### Frontend
- [Framework] ([Version])
- [Library] ([Version])
- [Tool] ([Version])

### Backend
- [Framework] ([Version])
- [Language] ([Version])
- [Database] ([Version])

### Infrastructure
- [Platform] (e.g., AWS, GCP, Kubernetes)
- [CI/CD] (e.g., GitHub Actions)
- [Monitoring] (e.g., DataDog, Prometheus)

### AI/ML (if applicable)
- [Model/Service]
- [Framework]

---

## Team Structure

### Team Members
- **[Role]**: [Name] - [Responsibilities]
- **[Role]**: [Name] - [Responsibilities]

### Communication
- **Daily Standup**: [Time/Location]
- **Sprint Planning**: [Schedule]
- **Slack Channel**: [#channel-name]
- **Documentation**: [Link]

---

## Architecture

### High-Level Architecture
[Brief description or ASCII diagram]

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Frontend  │────▶│   Backend    │────▶│  Database   │
└─────────────┘     └──────────────┘     └─────────────┘
                            │
                            ▼
                    ┌──────────────┐
                    │ External APIs│
                    └──────────────┘
```

### Architectural Patterns
- [Pattern 1] - [Why/Where used]
- [Pattern 2] - [Why/Where used]

### Key Design Decisions
1. **[Decision]**: [Rationale]
2. **[Decision]**: [Rationale]

---

## File Structure

### Key Directories
```
project-root/
├── src/
│   ├── api/           # REST API endpoints
│   ├── services/      # Business logic
│   ├── models/        # Data models
│   └── utils/         # Utilities
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
│   ├── api/           # API documentation
│   ├── architecture/  # Architecture docs
│   └── guides/        # Developer guides
└── scripts/           # Build/deploy scripts
```

### Important Files
- **Main Entry**: [Path]
- **Configuration**: [Path]
- **Environment**: [Path]
- **Database Schema**: [Path]

---

## Development Workflow

### Getting Started
```bash
# Clone repository
git clone [repo-url]

# Install dependencies
[package-manager install command]

# Setup environment
cp .env.example .env

# Run locally
[run command]
```

### Branch Strategy
- **main**: Production-ready code
- **develop**: Integration branch
- **feature/[name]**: Feature branches
- **hotfix/[name]**: Emergency fixes

### Code Review Process
1. Create PR from feature branch
2. Automated checks (CI/CD)
3. Peer review (1+ approver)
4. Merge to develop
5. Deploy to staging
6. Merge to main for production

---

## Integration Points

### Internal Systems
- **[System 1]**: [Integration method, API endpoint, auth]
- **[System 2]**: [Integration method, API endpoint, auth]

### External Services
- **[Service 1]**: [Purpose, API, credentials location]
- **[Service 2]**: [Purpose, API, credentials location]

### Data Flow
[Describe how data flows between systems]

---

## Environment Configuration

### Development
- **URL**: [Local development URL]
- **Database**: [Local database]
- **API Keys**: [Location of dev keys]

### Staging
- **URL**: [Staging URL]
- **Database**: [Staging database]
- **Deployment**: [How to deploy]

### Production
- **URL**: [Production URL]
- **Database**: [Production database]
- **Deployment**: [How to deploy]
- **Monitoring**: [Monitoring dashboard]

---

## Testing Strategy

### Test Coverage Targets
- **Unit Tests**: 80%+
- **Integration Tests**: 60%+
- **E2E Tests**: Critical paths

### Testing Tools
- **Unit**: [Framework]
- **Integration**: [Framework]
- **E2E**: [Framework]
- **Performance**: [Tool]

### Running Tests
```bash
# Unit tests
[command]

# Integration tests
[command]

# E2E tests
[command]

# Coverage report
[command]
```

---

## Dependencies

### Critical Dependencies
- **[Dependency]**: [Why critical, version constraints]

### Upstream Dependencies
- [System/Service this project depends on]

### Downstream Dependencies
- [Systems/Services that depend on this project]

---

## Documentation

### Developer Documentation
- **API Docs**: [Link/Path]
- **Architecture Docs**: [Link/Path]
- **Setup Guide**: [Link/Path]
- **Troubleshooting**: [Link/Path]

### User Documentation
- **User Guide**: [Link/Path]
- **FAQ**: [Link/Path]
- **Release Notes**: [Link/Path]

---

## Monitoring & Observability

### Logging
- **Tool**: [Logging system]
- **Location**: [Where to find logs]
- **Log Levels**: [DEBUG, INFO, WARN, ERROR]

### Metrics
- **Dashboard**: [Link to dashboard]
- **Key Metrics**: [List important metrics]
- **Alerts**: [Alert configuration]

### Tracing
- **Tool**: [Tracing system, e.g., Jaeger]
- **Distributed Tracing**: [Enabled/Disabled]

---

## Known Issues & Limitations

### Current Limitations
- [Limitation 1]
- [Limitation 2]

### Technical Debt
- [Debt item 1] - [Priority, plan to address]
- [Debt item 2] - [Priority, plan to address]

### Open Issues
- [Issue 1] - [Link to issue tracker]
- [Issue 2] - [Link to issue tracker]

---

## Persona-Specific Notes

### For Engineers
- Focus on: [Specific areas]
- Key patterns: [Patterns used in this project]
- Performance targets: [Targets]

### For QA Engineers
- Focus on: [Critical test areas]
- Quality gates: [What must pass]
- Test data: [Where to find test data]

### For Product Managers
- Focus on: [Business metrics]
- User stories: [Location]
- Feature flags: [Where configured]

### For UX Designers
- Focus on: [Design system location]
- Component library: [Link]
- User flows: [Documentation]

---

## Quick Links

- **Repository**: [Git URL]
- **CI/CD**: [Link to pipeline]
- **Project Board**: [Link to Jira/GitHub Projects]
- **Slack Channel**: [#channel]
- **Design Files**: [Figma/Sketch link]
- **API Docs**: [Swagger/OpenAPI link]

---

**Context Loading**: This PROJECT.md is automatically loaded when working in this project
**Vision Document**: See VISION.md for strategic direction and roadmap
**Organization Standards**: Inherited from ~/.claude/CLAUDE.md
