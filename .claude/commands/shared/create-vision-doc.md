**Purpose**: Generate persona-specific vision/PRD documents for autonomous development

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Create vision document for [project] with [persona] focus"

Generate comprehensive vision/PRD documents tailored to specific personas and project types, enabling autonomous Claude Code development.

## Usage Examples
```bash
# Software Engineer - Technical architecture vision
/create-vision-doc --project order-service --type microservices

# QA Engineer - Test strategy vision
/create-vision-doc --project checkout --type enhancement --persona qa

# Product Manager - Product strategy vision
/create-vision-doc --project user-dashboard --persona pm

# Engineering Manager - Team coordination vision
/create-vision-doc --project platform-rewrite --persona em --type refactor

# UX Designer - Design system vision
/create-vision-doc --project design-refresh --persona ux

# Custom template
/create-vision-doc --template ./custom-vision.md --output ./docs/VISION.md
```

## Command-Specific Flags

### Required
--project: "Project name (default: current directory name)"

### Optional
--type: "Project type: greenfield|enhancement|refactor|multi-agent|infrastructure|microservices|feature"
--persona: "Target persona: engineer|qa|em|pm|ux (default: current active persona)"
--template: "Custom template path (default: persona-specific template)"
--output: "Output file path (default: ~/.claude/projects/{project}/VISION.md)"
--context: "Additional context file to include"
--interactive: "Ask clarifying questions before generation"

## Project Types

### greenfield
**Best for**: New projects from scratch
**Emphasizes**: Architecture principles, tech stack selection, MVP approach, scalability

### enhancement
**Best for**: Adding features to existing systems
**Emphasizes**: Integration points, current architecture, migration strategy, backwards compatibility

### refactor
**Best for**: Redesigning/rewriting existing systems
**Emphasizes**: Before/After architecture, migration plan, risk mitigation, data migration

### microservices
**Best for**: Microservices architecture projects
**Emphasizes**: Service boundaries, communication patterns, data consistency, deployment

### multi-agent
**Best for**: Systems with autonomous agents
**Emphasizes**: Agent coordination, task delegation, inter-agent protocols, learning mechanisms

### infrastructure
**Best for**: Platform/infrastructure projects
**Emphasizes**: Deployment architecture, security, monitoring, disaster recovery, scaling

### feature
**Best for**: Single feature additions
**Emphasizes**: User stories, acceptance criteria, implementation approach, testing

## Persona-Specific Templates

### Software Engineer (engineer)
**Template**: `~/.claude/templates/vision/engineer-vision-template.md`

**Focus Areas**:
- Technical architecture and design patterns
- Service layer design and API contracts
- Database schema and data models
- Code organization and structure
- Testing strategy and coverage
- Performance and scalability targets
- CI/CD pipeline and deployment

**Output Sections**:
- Implementation Architecture
- API Design
- Data Model
- Code Structure
- Testing Approach
- Performance Requirements
- Deployment Strategy

### QA Engineer (qa)
**Template**: `~/.claude/templates/vision/qa-vision-template.md`

**Focus Areas**:
- Test strategy and coverage targets
- Test pyramid distribution (unit/integration/e2e)
- Automation framework selection
- Quality gates and acceptance criteria
- Performance and load testing
- Accessibility testing requirements
- CI/CD integration

**Output Sections**:
- Quality Strategy
- Test Coverage Plan
- Automation Approach
- Framework Selection
- Quality Metrics
- Testing Roadmap
- CI/CD Integration

### Engineering Manager (em)
**Template**: `~/.claude/templates/vision/em-vision-template.md`

**Focus Areas**:
- Team structure and composition
- Sprint planning and timeline
- Resource allocation
- Risk management
- Dependencies and blockers
- Velocity and metrics
- Stakeholder communication

**Output Sections**:
- Team Organization
- Delivery Timeline
- Resource Plan
- Risk Register
- Dependency Map
- Success Metrics
- Communication Plan

### Product Manager (pm)
**Template**: `~/.claude/templates/vision/pm-vision-template.md`

**Focus Areas**:
- Business value and user impact
- User personas and stories
- Feature prioritization (RICE)
- Requirements and acceptance criteria
- Success metrics and KPIs
- Go-to-market strategy
- Roadmap and phasing

**Output Sections**:
- Product Strategy
- User Personas
- User Stories
- Feature Prioritization
- Requirements
- Success Criteria
- Product Roadmap

### UX Designer (ux)
**Template**: `~/.claude/templates/vision/ux-vision-template.md`

**Focus Areas**:
- Design system and components
- User journey mapping
- Interaction patterns
- Accessibility standards (WCAG)
- Visual design language
- Responsive design strategy
- Component library

**Output Sections**:
- Design Vision
- Design System
- User Journeys
- Interaction Patterns
- Accessibility Plan
- Component Library
- Design Deliverables

## Generation Process

### 1. Context Gathering
```
[AUTOMATIC]
- Detect current persona (or use --persona flag)
- Determine project type (--type or infer from context)
- Load persona-specific template
- Read existing PROJECT.md if available
- Scan codebase for architecture patterns
```

### 2. Interactive Mode (--interactive)
```
[PROMPTS USER]
- What is the primary goal of this project?
- What are the key technical challenges?
- What existing systems must this integrate with?
- What are the success criteria?
- What is the timeline/deadline?
- Are there any constraints or requirements?
```

### 3. Template Population
```
[AUTOMATIC]
- Fill template with gathered context
- Apply persona-specific focus
- Include project type-specific sections
- Generate initial architecture diagrams
- Create phased roadmap
- Add success criteria checkboxes
```

### 4. Validation
```
[AUTOMATIC]
- Check completeness against checklist
- Ensure all required sections present
- Validate technical feasibility
- Flag ambiguities for human review
- Add "Open Questions" section
```

### 5. Output Generation
```
[CREATES FILES]
- ~/.claude/projects/{project}/VISION.md (main vision doc)
- ~/.claude/projects/{project}/PROJECT.md (if not exists)
- ~/.claude/projects/{project}/docs/ (supporting docs)
```

## Integration with Autonomous Development

### Multi-Phase Execution
Once vision document is created, enable autonomous development:

```bash
# Claude Code reads vision and executes phases
/implement --phase 1

# Process:
1. Read VISION.md for strategic direction
2. Read PROJECT.md for project context
3. Read CLAUDE.md for org standards
4. Generate implementation plan for phase
5. Coordinate specialized agents
6. Execute with continuous testing
7. Validate against success criteria
8. Report completion
```

### Agent Coordination
Vision doc specifies which agents to use:

**Software Engineer Vision** → Coordinates:
- backend-engineer (API implementation)
- frontend-ux-engineer (UI components)
- devops (deployment)
- qa-testing-engineer (test coverage)

**QA Engineer Vision** → Coordinates:
- test-automation-specialist (framework setup)
- performance-tester (load tests)
- accessibility-auditor (a11y tests)
- visual-regression-tester (screenshot tests)

## Output Structure

Generated vision document includes:

### Common Sections (All Personas)
- Executive Summary
- Strategic Vision
- Architectural Principles
- Core Workflows
- Integration Points
- Success Criteria
- Technology Stack
- Development Approach
- Roadmap
- Architecture Decisions
- Risk & Mitigation

### Persona-Specific Sections
Added based on persona template:
- **Engineer**: Implementation details, code structure
- **QA**: Test strategy, quality gates
- **EM**: Team plan, resource allocation
- **PM**: User stories, product roadmap
- **UX**: Design system, user flows

## Examples

### Example 1: Engineer Creating Microservices Vision
```bash
/create-vision-doc --project payment-service --type microservices

# Generates:
- Technical architecture (event-driven, saga pattern)
- Service boundaries and API contracts
- Database schema (PostgreSQL + Redis)
- Communication patterns (Kafka, gRPC)
- Testing strategy (TestContainers, contract tests)
- Deployment (Kubernetes, Helm)
```

### Example 2: PM Creating Feature Vision
```bash
/create-vision-doc --project guest-checkout --type feature --persona pm

# Generates:
- User personas (anonymous shopper)
- User stories (As a guest, I want to...)
- Acceptance criteria (Given/When/Then)
- RICE prioritization scores
- Success metrics (conversion rate +15%)
- Feature roadmap (3 phases)
```

### Example 3: QA Creating Test Strategy
```bash
/create-vision-doc --project api-testing --type enhancement --persona qa

# Generates:
- Test coverage targets (80% unit, 60% integration)
- Test pyramid distribution
- Framework selection (Pytest, TestContainers)
- Quality gates (coverage, performance, security)
- Automation approach (CI/CD with GitHub Actions)
- Testing roadmap (6 sprints)
```

## Validation Checklist

Generated vision document validated against:

- [ ] Clear executive summary (non-technical)
- [ ] Explicit architectural principles
- [ ] Persona-specific focus areas covered
- [ ] Integration points documented
- [ ] Phased roadmap with timelines
- [ ] Success criteria (measurable)
- [ ] Technology stack listed
- [ ] Testing requirements specified
- [ ] Architecture decisions with rationale
- [ ] File locations and references
- [ ] Autonomous execution guidance
- [ ] Open questions flagged

## Post-Generation

After vision document is created:

1. **Review**: Human review for accuracy and completeness
2. **Refine**: Use follow-up prompts to deepen sections
3. **Approve**: Mark as approved for autonomous development
4. **Version**: Commit to version control
5. **Execute**: Begin autonomous development with `/implement`

## Living Document

Vision documents are living:

- **Update regularly** as implementation reveals insights
- **Track decisions** in Architecture Decisions section
- **Maintain alignment** between vision and implementation
- **Version control** all changes
- **Review milestones** and adjust roadmap

## Related Commands

- `/init-project` - Initialize project structure with PROJECT.md
- `/implement --phase N` - Execute autonomous development
- `/update-vision` - Update vision doc based on learnings
- `/validate-vision` - Check vision doc against checklist
- `/sync-vision` - Sync vision with actual implementation

---

@include shared/universal-constants.yml#Standard_Messages_Templates

**This command enables autonomous, vision-driven development across all personas, ensuring strategic alignment and context-aware execution.**
