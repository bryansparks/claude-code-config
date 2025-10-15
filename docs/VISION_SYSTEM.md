# Vision Document System - Complete Guide

## 🎯 Executive Summary

A **3-layer Claude.md architecture** that enables vision-driven, autonomous development across all personas:

1. **Organization Layer**: Company-wide standards and practices
2. **Project Layer**: Project-specific context and architecture
3. **Vision Layer**: Strategic direction and autonomous execution guidance

**Key Innovation**: Same vision document, different persona lenses - PM focuses on user value, Engineer on architecture, QA on testing, etc.

## 🏗️ Architecture Overview

### The 3 Layers

```
~/.claude/CLAUDE.md (Organization)
    ↓ @includes
~/.claude/projects/{project}/PROJECT.md (Project Context)
    ↓ @includes
~/.claude/projects/{project}/VISION.md (Vision/PRD)
```

### What Each Layer Contains

#### Layer 1: Organization Standards (`CLAUDE.md`)
**Purpose**: Company-wide practices that NEVER change per-project

**Contains**:
- Coding standards (Java style guide, Python PEP 8)
- Approved tech stack (Spring Boot 3.x, React 18, PostgreSQL 14)
- Security policies (OWASP compliance, data encryption)
- Development workflow (git branching, PR process)
- Persona configuration (SuperClaude, subagents)

**Update Frequency**: Quarterly or when org standards change

#### Layer 2: Project Context (`PROJECT.md`)
**Purpose**: Project-specific setup and architecture

**Contains**:
- Project overview and objectives
- Technology stack for THIS project
- Team composition and roles
- File structure and key locations
- Integration points
- Development workflow specifics

**Update Frequency**: Monthly or when project structure changes

#### Layer 3: Vision/PRD (`VISION.md`)
**Purpose**: Strategic direction and autonomous execution

**Contains**:
- Strategic vision and business goals
- Architectural decisions and rationale
- Implementation roadmap (phased)
- Success criteria (checkboxes)
- Autonomous development instructions
- Current phase and next steps

**Update Frequency**: Sprint-based as implementation progresses

## 🚀 The /create-vision-doc Command

### Universal Command for All Personas

```bash
/create-vision-doc [options]
```

### Options

```
--project <name>        Project name (default: current directory)
--type <type>           greenfield|enhancement|refactor|microservices|multi-agent|infrastructure|feature
--persona <persona>     engineer|qa|em|pm|ux (default: current active persona)
--template <path>       Custom template path
--output <path>         Output location (default: ~/.claude/projects/{project}/VISION.md)
--interactive           Ask clarifying questions before generation
```

### How It Adapts Per Persona

| Persona | Focus | Template Sections |
|---------|-------|-------------------|
| **Engineer** | Technical architecture | Implementation details, API contracts, database schema, code structure, testing |
| **QA** | Test strategy | Test coverage, automation framework, quality gates, test pyramid, CI/CD |
| **EM** | Team coordination | Team structure, sprint planning, resource allocation, risk management, metrics |
| **PM** | Product strategy | User stories, RICE prioritization, requirements, success metrics, roadmap |
| **UX** | Design vision | Design system, user journeys, interaction patterns, accessibility, components |

### Example Usage

#### Software Engineer
```bash
/create-vision-doc --project order-service --type microservices

# Generates technical vision:
- Event-driven architecture with Kafka
- Service boundaries and API contracts
- PostgreSQL schema + Redis caching
- Testing with TestContainers
- Kubernetes deployment
```

#### QA Engineer
```bash
/create-vision-doc --project checkout-flow --type enhancement --persona qa

# Generates test strategy vision:
- 80% unit test coverage target
- Playwright for E2E automation
- Performance baseline tests
- Accessibility WCAG AA compliance
- CI/CD integration with GitHub Actions
```

#### Product Manager
```bash
/create-vision-doc --project guest-checkout --type feature --persona pm

# Generates product vision:
- User persona: Anonymous shopper
- User stories with acceptance criteria
- RICE scores for prioritization
- Success metric: +15% conversion
- 3-phase feature roadmap
```

## 🔄 Autonomous Development Workflow

### 1. Initialize Project

```bash
# Set project context
export CLAUDE_PROJECT="ecommerce-api"

# Create vision document
/create-vision-doc --type microservices
```

### 2. Generate Vision

Claude Code:
1. Detects current persona (engineer/qa/pm/em/ux)
2. Loads persona-specific template
3. Reads existing PROJECT.md if available
4. Scans codebase for patterns
5. Generates comprehensive vision document
6. Validates against checklist

### 3. Execute Autonomous Development

```bash
# Claude Code reads all 3 layers:
# 1. CLAUDE.md (org standards)
# 2. PROJECT.md (project context)
# 3. VISION.md (strategic vision)

# Execute phase-by-phase
/implement --phase 1

# Process:
# 1. Read vision for strategic direction
# 2. Generate implementation plan
# 3. Coordinate specialized agents
# 4. Execute with continuous testing
# 5. Validate against success criteria
# 6. Report completion with next phase recommendations
```

### 4. Update Vision (Living Document)

```bash
# As implementation reveals insights
/update-vision --learnings "Discovered need for circuit breaker pattern"

# Vision doc updates:
- Adds architectural decision
- Updates roadmap
- Flags new requirements
- Maintains alignment
```

## 📁 Directory Structure

### Complete Structure

```
~/.claude/
├── CLAUDE.md                          # Master (org + project loader)
│
├── shared/                            # Organization-wide
│   ├── org-coding-standards.md        # Java/Python style guides
│   ├── org-tech-stack.md              # Approved technologies
│   ├── org-security-policies.md       # Security requirements
│   ├── org-dev-workflow.md            # Git, PR process
│   └── superclaude-*.yml              # Persona configs
│
├── projects/                          # Per-project context
│   ├── ecommerce-api/
│   │   ├── PROJECT.md                 # Project-specific context
│   │   ├── VISION.md                  # Vision/PRD (living doc)
│   │   ├── architecture/
│   │   │   ├── ARCHITECTURE.md
│   │   │   └── diagrams/
│   │   └── docs/
│   │       ├── FILE_STRUCTURE.md
│   │       ├── WORKFLOW.md
│   │       └── INTEGRATIONS.md
│   │
│   └── user-dashboard/
│       ├── PROJECT.md
│       └── VISION.md
│
├── templates/                         # Templates
│   ├── vision/
│   │   ├── engineer-vision-template.md
│   │   ├── qa-vision-template.md
│   │   ├── em-vision-template.md
│   │   ├── pm-vision-template.md
│   │   └── ux-vision-template.md
│   └── project/
│       └── PROJECT-template.md
│
└── PRD-Docs/                          # Original templates
    ├── MASTER_VISION_DOCUMENT.md
    └── PRD-Prompt
```

## 🎭 Same Vision, Different Lenses

### How All Personas Use Same VISION.md

**Product Manager** creates initial VISION.md:
- Business goals and user value
- User stories and acceptance criteria
- Feature prioritization (RICE)
- Success metrics
- Product roadmap

**Software Engineer** reads same VISION.md, focuses on:
- Architectural decisions
- Implementation approach
- Technical requirements
- Code structure
- Testing strategy

**QA Engineer** reads same VISION.md, focuses on:
- Success criteria (as test cases)
- Acceptance criteria (as validation)
- Quality gates
- Test coverage targets
- Automation approach

**Engineering Manager** reads same VISION.md, focuses on:
- Roadmap and timeline
- Resource requirements
- Risk management
- Team coordination
- Dependencies

**UX Designer** reads same VISION.md, focuses on:
- User stories (as user flows)
- Success criteria (as UX metrics)
- Design requirements
- Accessibility standards
- Component needs

**Result**: Single source of truth, interpreted through role-specific lens! 🎯

## 🔗 Integration with Existing System

### Automatic Project Detection

**Option 1: Environment Variable**
```bash
export CLAUDE_PROJECT="order-service"
```

**Option 2: Git Repository**
```bash
# Auto-detects from git remote
PROJECT_NAME=$(git remote -v | grep origin | head -1 | sed 's|.*/||' | sed 's|\.git||')
```

**Option 3: Directory Name**
```bash
# Uses current directory
PROJECT_NAME=$(basename $(pwd))
```

### Session Hook

```bash
# ~/.claude/hooks/session-start.sh
# Automatically loads project context

PROJECT_NAME=${CLAUDE_PROJECT:-$(basename $(pwd))}

if [ -f "~/.claude/projects/$PROJECT_NAME/PROJECT.md" ]; then
    echo "📂 Loaded: $PROJECT_NAME"
fi

if [ -f "~/.claude/projects/$PROJECT_NAME/VISION.md" ]; then
    echo "🎯 Vision loaded"
fi
```

## 🎯 Benefits

### For Individuals
✅ **Consistent Standards**: Org practices always loaded
✅ **Project Context**: Auto-loads relevant info
✅ **Vision Guidance**: Strategic direction for autonomous work
✅ **Persona-Specific**: Tailored focus and templates

### For Teams
✅ **Shared Understanding**: Same vision, different perspectives
✅ **Smooth Handoffs**: PM creates → Engineers implement → QA validates
✅ **Living Docs**: Vision updates as project evolves
✅ **Easy Onboarding**: New members read PROJECT.md + VISION.md

### For Organizations
✅ **Standards Enforcement**: Org-wide CLAUDE.md ensures compliance
✅ **Best Practices**: Captured in shared/ directory
✅ **Knowledge Retention**: Vision docs preserve decisions
✅ **Autonomous Execution**: Claude Code executes with full context

## 📊 Real-World Example

### Scenario: Building Microservices Platform

#### 1. Organization Setup (One Time)
```bash
# ~/.claude/CLAUDE.md includes:
# - Java/Spring Boot 3.x standards
# - PostgreSQL + Redis patterns
# - Kubernetes deployment requirements
# - Spring Cloud microservices patterns
```

#### 2. Project Manager Creates Vision
```bash
cd ~/projects/payment-service
export CLAUDE_PROJECT="payment-service"

/create-vision-doc --persona pm --type microservices

# Generates:
# - Business goals: Process payments securely
# - User stories: "As a customer, I want to pay with credit card..."
# - Success metrics: 99.9% uptime, <200ms p95 latency
# - Roadmap: 3 phases over 6 sprints
```

#### 3. Engineer Implements
```bash
# Same directory, same vision doc
export CLAUDE_PERSONA="engineer"

/create-vision-doc --type microservices

# Adds technical sections to VISION.md:
# - Event-driven architecture (Kafka)
# - API contracts (OpenAPI spec)
# - Database schema (PostgreSQL + Redis)
# - Circuit breaker patterns (Resilience4j)
# - Testing strategy (TestContainers)

# Execute autonomous development
/implement --phase 1

# Claude Code:
# 1. Reads CLAUDE.md (Spring Boot patterns)
# 2. Reads PROJECT.md (team, tech stack)
# 3. Reads VISION.md (goals + architecture)
# 4. Coordinates: backend-engineer, devops, qa agents
# 5. Implements service layer with tests
# 6. Validates against success criteria
```

#### 4. QA Validates
```bash
# Same directory, same vision doc
export CLAUDE_PERSONA="qa"

/create-vision-doc --type microservices --persona qa

# Adds QA sections to VISION.md:
# - Test coverage: 80% unit, 60% integration
# - E2E with Playwright
# - Performance tests (k6): <200ms p95
# - Contract tests between services

/test-plan --implement

# Claude Code:
# 1. Reads success criteria from PM's vision
# 2. Reads technical architecture from Engineer's vision
# 3. Generates comprehensive test suite
# 4. Validates against quality gates
```

#### 5. Manager Tracks
```bash
export CLAUDE_PERSONA="em"

/team-metrics --project payment-service

# Claude Code:
# 1. Reads roadmap from VISION.md
# 2. Checks current phase completion
# 3. Reports velocity and blockers
# 4. Recommends next phase timing
```

## 🛠️ Quick Start

### Step 1: Setup Organization CLAUDE.md
```bash
cp templates/CLAUDE-org-template.md ~/.claude/CLAUDE.md

# Customize with your org's:
# - Coding standards
# - Tech stack
# - Security policies
```

### Step 2: Start New Project
```bash
cd ~/projects/my-new-project
export CLAUDE_PROJECT="my-new-project"

# Create project structure
mkdir -p ~/.claude/projects/my-new-project

# Generate vision document
/create-vision-doc --type greenfield
```

### Step 3: Develop Autonomously
```bash
# Claude Code auto-loads:
# 1. ~/.claude/CLAUDE.md (org standards)
# 2. ~/.claude/projects/my-new-project/PROJECT.md
# 3. ~/.claude/projects/my-new-project/VISION.md

# Execute
/implement --phase 1
```

## 📝 Summary

This vision document system provides:

| Layer | Update Frequency | Scope | Purpose |
|-------|-----------------|-------|---------|
| **Org Standards** | Quarterly | All projects | Company practices |
| **Project Context** | Monthly | Single project | Project setup |
| **Vision/PRD** | Sprint-based | Single project | Strategic direction |

**Key Innovation**:
- ✅ Single vision document
- ✅ Multiple persona perspectives
- ✅ Autonomous execution guidance
- ✅ Living documentation
- ✅ Version controlled decisions

**Result**: Vision-driven, context-aware, autonomous development across all engineering roles! 🚀

---

## 📚 Related Documents

- [CLAUDE_MD_ARCHITECTURE.md](docs/CLAUDE_MD_ARCHITECTURE.md) - Detailed architecture
- [create-vision-doc command](templates/shared/commands/create-vision-doc.md) - Command reference
- [MASTER_VISION_DOCUMENT.md](PRD-Docs/MASTER_VISION_DOCUMENT.md) - Original template
- [PRD-Prompt](PRD-Docs/PRD-Prompt) - Prompt guide
- [PROJECT-template.md](templates/PROJECT-template.md) - Project context template
- [CLAUDE-org-template.md](templates/CLAUDE-org-template.md) - Organization template

---

**Version**: 2.0.0
**Status**: ✅ Complete
**Ready to Use**: Yes - integrate into all persona configurations
