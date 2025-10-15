# Claude.md Multi-Layer Architecture

## 🎯 Design Philosophy

**Problem**: Engineers need:
1. **Organization-wide standards** (coding practices, tools, patterns)
2. **Project-specific context** (architecture, tech stack, team)
3. **Vision/PRD guidance** (goals, roadmap, autonomous execution)

**Solution**: 3-layer include-based CLAUDE.md system

## 📐 Architecture

### Layer 1: Organization Standards (Global)
**Location**: `~/.claude/CLAUDE.md`

**Purpose**: Organization-wide practices, tools, and policies

**Contains**:
- Coding standards and style guides
- Approved technology stack
- Security and compliance requirements
- Company-specific patterns and practices
- Persona configuration (SuperClaude, subagents)

**Scope**: NEVER changes per-project

### Layer 2: Project Context (Project-Specific)
**Location**: `~/.claude/projects/{project-name}/PROJECT.md`

**Purpose**: Project-specific architecture and team info

**Contains**:
- Project overview and objectives
- Technology stack for THIS project
- Team composition and roles
- File structure and key locations
- Integration points
- Development workflow

**Scope**: Changes per project, stable during project

### Layer 3: Vision/PRD (Living Document)
**Location**: `~/.claude/projects/{project-name}/VISION.md`

**Purpose**: Strategic direction and autonomous execution guidance

**Contains**:
- Strategic vision and goals
- Architectural decisions
- Implementation roadmap
- Success criteria
- Autonomous development instructions
- Current phase and next steps

**Scope**: Updates frequently as project evolves

## 🔗 How They Link Together

### Master CLAUDE.md (Organization Layer)

```markdown
# CLAUDE.md - [Organization Name]

## Organization Standards
@include shared/org-coding-standards.md
@include shared/org-tech-stack.md
@include shared/org-security-policies.md

## SuperClaude Configuration
@include shared/superclaude-core.yml#Core_Philosophy
@include shared/superclaude-personas.yml#All_Personas

## Project Context (Auto-detected or manually set)
@include projects/${PROJECT_NAME}/PROJECT.md

## Vision Document (If exists)
@include projects/${PROJECT_NAME}/VISION.md
```

### Project Context (PROJECT.md)

```markdown
# Project: [Project Name]

## Quick Reference
- **Tech Stack**: Java/Spring Boot, React, PostgreSQL
- **Architecture**: Microservices with event-driven patterns
- **Team**: 5 engineers, 2 QA, 1 PM
- **Timeline**: Q1 2025 launch

## Project Architecture
@include architecture/ARCHITECTURE.md

## File Structure
@include docs/FILE_STRUCTURE.md

## Development Workflow
@include docs/WORKFLOW.md

## Integration Points
@include docs/INTEGRATIONS.md
```

### Vision Document (VISION.md)

```markdown
# Vision: [Project Name]

Uses: PRD-Docs/MASTER_VISION_DOCUMENT.md template

## Current Phase: Implementation Phase 2
## Next: Backend API Layer (2 weeks)

[Full vision document content...]
```

## 🚀 Project Detection & Auto-Loading

### Automatic Project Detection

**Option 1: Git-based**
```bash
# Detect project from git remote
PROJECT_NAME=$(git remote -v | grep origin | head -1 | sed 's|.*/||' | sed 's|\.git||')
```

**Option 2: Environment Variable**
```bash
# Set per-project
export CLAUDE_PROJECT="ecommerce-platform"
```

**Option 3: Directory-based**
```bash
# Detect from current directory
PROJECT_NAME=$(basename $(pwd))
```

### Project Context Hook

```bash
# ~/.claude/hooks/project-context-loader.sh
# Automatically loads PROJECT.md and VISION.md if they exist

PROJECT_NAME=${CLAUDE_PROJECT:-$(basename $(pwd))}
PROJECT_DIR="$HOME/.claude/projects/$PROJECT_NAME"

if [ -f "$PROJECT_DIR/PROJECT.md" ]; then
    echo "📂 Loaded project context: $PROJECT_NAME"
fi

if [ -f "$PROJECT_DIR/VISION.md" ]; then
    echo "🎯 Loaded vision document: $PROJECT_NAME"
fi
```

## 📋 Persona-Specific Vision Templates

Each persona gets a specialized vision document template:

### Software Engineer Vision Template
**Focus**: Technical architecture, implementation details, code structure

```markdown
## Implementation Architecture
- Service layer design
- API contracts
- Database schema
- Testing strategy
- Performance targets

## Code Organization
- Package structure
- Dependency management
- Build configuration
- CI/CD pipeline
```

### QA Engineer Vision Template
**Focus**: Test strategy, quality metrics, automation approach

```markdown
## Quality Strategy
- Test coverage targets
- Test pyramid distribution
- Automation framework
- Performance benchmarks
- Accessibility requirements

## Testing Roadmap
- Phase 1: Unit tests (80% coverage)
- Phase 2: Integration tests
- Phase 3: E2E automation
```

### Engineering Manager Vision Template
**Focus**: Team coordination, metrics, delivery timeline

```markdown
## Team Structure
- Team composition
- Skill matrix
- Capacity planning
- Dependencies

## Delivery Roadmap
- Sprint planning
- Milestone tracking
- Risk management
- Team velocity
```

### Product Manager Vision Template
**Focus**: Business value, user stories, feature prioritization

```markdown
## Product Strategy
- User personas
- User stories
- Feature prioritization (RICE)
- Success metrics
- Go-to-market plan

## Requirements
- Functional requirements
- Acceptance criteria
- User flows
```

### UX Designer Vision Template
**Focus**: Design system, user flows, accessibility

```markdown
## Design Vision
- Design system components
- User journey maps
- Interaction patterns
- Accessibility standards
- Visual design language

## Design Deliverables
- Wireframes
- Prototypes
- Design specs
- Component library
```

## 🛠️ /create-vision-doc Command

### Universal Command (All Personas)

```markdown
**Purpose**: Generate persona-specific vision documents

**Usage**:
/create-vision-doc [options]

**Options**:
--project <name>        Project name (default: current directory)
--type <type>           greenfield|enhancement|refactor|multi-agent|infrastructure
--persona <persona>     engineer|qa|em|pm|ux (default: current persona)
--template <path>       Custom template path
--output <path>         Output location (default: ~/.claude/projects/{project}/VISION.md)

**Examples**:
# Software Engineer creating technical vision
/create-vision-doc --project ecom-api --type microservices

# PM creating product vision
/create-vision-doc --project user-dashboard --type greenfield --persona pm

# QA creating test strategy vision
/create-vision-doc --project checkout-flow --type enhancement --persona qa
```

### Persona-Specific Behavior

The command adapts based on persona:

**Software Engineer**:
- Uses technical architecture template
- Emphasizes: Code structure, patterns, testing
- Includes: Service design, API contracts, database schema

**QA Engineer**:
- Uses test strategy template
- Emphasizes: Test coverage, automation, quality gates
- Includes: Test pyramid, framework selection, CI/CD integration

**Engineering Manager**:
- Uses team coordination template
- Emphasizes: Team structure, timeline, dependencies
- Includes: Resource planning, risk management, metrics

**Product Manager**:
- Uses product strategy template
- Emphasizes: User value, stories, prioritization
- Includes: Requirements, success metrics, roadmap

**UX Designer**:
- Uses design vision template
- Emphasizes: User flows, design system, accessibility
- Includes: Journey maps, component library, interaction patterns

## 📂 Recommended Directory Structure

```
~/.claude/
├── CLAUDE.md                          # Master (includes org + project)
├── shared/                            # Organization-wide
│   ├── org-coding-standards.md
│   ├── org-tech-stack.md
│   ├── org-security-policies.md
│   └── superclaude-*.yml
├── projects/                          # Per-project
│   ├── ecommerce-platform/
│   │   ├── PROJECT.md                 # Project context
│   │   ├── VISION.md                  # Vision/PRD
│   │   ├── architecture/
│   │   │   └── ARCHITECTURE.md
│   │   └── docs/
│   │       ├── FILE_STRUCTURE.md
│   │       ├── WORKFLOW.md
│   │       └── INTEGRATIONS.md
│   └── user-dashboard/
│       ├── PROJECT.md
│       └── VISION.md
└── templates/                         # Persona templates
    ├── vision/
    │   ├── engineer-vision-template.md
    │   ├── qa-vision-template.md
    │   ├── em-vision-template.md
    │   ├── pm-vision-template.md
    │   └── ux-vision-template.md
    └── project/
        └── PROJECT-template.md
```

## 🔄 Workflow Examples

### Scenario 1: Engineer Starting New Microservice

```bash
# 1. Set project context
export CLAUDE_PROJECT="order-service"

# 2. Create project structure
mkdir -p ~/.claude/projects/order-service

# 3. Generate technical vision
/create-vision-doc --type microservices

# 4. Claude Code reads:
#    ~/.claude/CLAUDE.md (org standards)
#    ~/.claude/projects/order-service/PROJECT.md (project context)
#    ~/.claude/projects/order-service/VISION.md (technical vision)

# 5. Start development with full context
/implement --phase 1
```

### Scenario 2: QA Creating Test Strategy

```bash
# 1. Switch to QA persona
export CLAUDE_PERSONA="qa"

# 2. Use existing project
export CLAUDE_PROJECT="checkout-flow"

# 3. Generate QA-specific vision
/create-vision-doc --persona qa --type enhancement

# 4. Vision includes:
#    - Test coverage targets
#    - Automation framework
#    - Quality gates
#    - CI/CD integration

# 5. Execute test strategy
/test-plan --implement
```

### Scenario 3: PM Defining Product Vision

```bash
# 1. Switch to PM persona
export CLAUDE_PERSONA="pm"

# 2. New feature
export CLAUDE_PROJECT="guest-checkout"

# 3. Generate product vision
/create-vision-doc --persona pm --type feature

# 4. Vision includes:
#    - User stories
#    - RICE prioritization
#    - Success metrics
#    - Acceptance criteria

# 5. Hand off to engineering
# Engineers read same VISION.md but focus on implementation sections
```

## 🎯 Benefits of This Architecture

### For Individuals
✅ **Consistent Standards**: Org-wide practices always loaded
✅ **Project Context**: Automatically loads relevant project info
✅ **Vision Guidance**: Strategic direction for autonomous work
✅ **Persona-Specific**: Tailored templates and focus areas

### For Teams
✅ **Shared Understanding**: Same vision doc, different perspectives
✅ **Handoff Simplicity**: PM creates vision → Engineers implement → QA validates
✅ **Living Documentation**: Vision updates as project evolves
✅ **Onboarding**: New team members read PROJECT.md + VISION.md

### For Organizations
✅ **Standards Enforcement**: Org-wide CLAUDE.md ensures compliance
✅ **Best Practices**: Captured in shared/ directory
✅ **Knowledge Retention**: Vision docs preserve decisions
✅ **Autonomous Execution**: Claude Code can execute with full context

## 🔧 Implementation Steps

### Step 1: Organization Setup
```bash
# Create org-wide CLAUDE.md
cp templates/CLAUDE-org-template.md ~/.claude/CLAUDE.md

# Add org standards
mkdir -p ~/.claude/shared
# Add org-coding-standards.md, org-tech-stack.md, etc.
```

### Step 2: Project Initialization
```bash
# Use init-project command
/init-project --name ecommerce-platform --type microservices

# Creates:
# - ~/.claude/projects/ecommerce-platform/PROJECT.md
# - ~/.claude/projects/ecommerce-platform/VISION.md (template)
```

### Step 3: Generate Vision
```bash
# Persona-specific vision generation
/create-vision-doc --persona engineer

# Or from template
/create-vision-doc --template ~/.claude/templates/vision/custom-template.md
```

### Step 4: Start Development
```bash
# Claude Code automatically reads all 3 layers
# Org standards + Project context + Vision

# Execute autonomous development
/implement --phase 1
```

## 📊 Summary

This 3-layer architecture provides:

| Layer | Purpose | Update Frequency | Scope |
|-------|---------|-----------------|-------|
| **Org Standards** | Company-wide practices | Rarely (quarterly) | All projects |
| **Project Context** | Project-specific setup | Stable (monthly) | Single project |
| **Vision/PRD** | Strategic direction | Frequently (sprint) | Single project |

**Key Innovation**: Same vision document, different persona lenses
- **PM**: Focuses on user value and stories
- **Engineer**: Focuses on architecture and implementation
- **QA**: Focuses on quality and testing
- **EM**: Focuses on team and timeline
- **UX**: Focuses on design and user flows

All reading the same source of truth, interpreting through their role lens! 🎯
