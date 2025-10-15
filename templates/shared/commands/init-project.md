# /init-project - Smart Project Initialization

**Purpose**: Initialize new project while preserving organization standards and persona configuration

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Initialize project [name] with organization standards preservation"

## Overview

The `/init-project` command is a **smart wrapper** around Claude Code's native `/init` that:
1. ✅ Preserves organization standards in CLAUDE.md
2. ✅ Calls native `/init` for project setup
3. ✅ Creates PROJECT.md structure automatically
4. ✅ Offers to create vision document
5. ✅ Never overwrites protected configuration files

## Problem Solved

**Without /init-project**:
```bash
# Engineer sets up environment
./claude-config.sh engineer    # Creates CLAUDE.md with org standards

# Later, in a project directory
/init                           # ❌ OVERWRITES CLAUDE.md, org standards LOST
```

**With /init-project**:
```bash
# Engineer sets up environment
./claude-config.sh engineer    # Creates protected ORGANIZATION.md

# Later, in a project directory
/init-project my-api-service   # ✅ Preserves org standards, adds project context
```

## Usage

### Basic Usage
```bash
/init-project <project-name>
```

### With Options
```bash
/init-project <project-name> [options]

Options:
  --type <type>           Project type: greenfield|enhancement|refactor|microservices|infrastructure
  --persona <persona>     Override current persona: engineer|qa|em|pm|ux
  --skip-vision          Skip vision document creation prompt
  --skip-init            Skip native /init call (only create PROJECT.md)
  --interactive          Ask detailed questions before setup
  --dry-run             Show what would be created without making changes
```

## Examples

### Example 1: Software Engineer - New Microservice
```bash
/init-project payment-service --type microservices

# Process:
# 1. Detects current persona: engineer
# 2. Protects ORGANIZATION.md (if exists)
# 3. Calls /init for project setup
# 4. Creates PROJECT.md with microservices template
# 5. Prompts: "Create technical vision document? [Y/n]"
# 6. If yes: runs /create-vision-doc --type microservices
# 7. Updates CLAUDE.md to include project context
```

### Example 2: Product Manager - New Feature
```bash
/init-project guest-checkout --type feature --persona pm

# Process:
# 1. Switches to PM persona context
# 2. Creates PROJECT.md with feature template
# 3. Prompts: "Create product vision document? [Y/n]"
# 4. If yes: runs /create-vision-doc --type feature --persona pm
```

### Example 3: QA Engineer - Test Strategy
```bash
/init-project api-testing --type enhancement --persona qa

# Process:
# 1. Uses QA persona context
# 2. Creates PROJECT.md focused on testing
# 3. Prompts: "Create test strategy vision? [Y/n]"
# 4. If yes: runs /create-vision-doc --type enhancement --persona qa
```

### Example 4: Dry Run
```bash
/init-project ecommerce-platform --dry-run

# Output:
# 📋 DRY RUN - No changes will be made
#
# Would create:
#   ~/.claude/projects/ecommerce-platform/PROJECT.md
#   ~/.claude/projects/ecommerce-platform/docs/
#
# Would update:
#   ~/.claude/CLAUDE.md (add project include)
#
# Would preserve:
#   ~/.claude/ORGANIZATION.md (organization standards)
#   ~/.claude/config/persona.md (current persona config)
#
# Would prompt:
#   Create vision document? [Y/n]
```

## Execution Flow

### Phase 1: Pre-Flight Checks
```bash
1. Detect current directory
2. Check if project already initialized
3. Detect or prompt for project name
4. Detect current persona (or use --persona flag)
5. Verify ORGANIZATION.md exists (warn if not)
```

### Phase 2: Protection
```bash
1. Backup current CLAUDE.md → CLAUDE.md.backup
2. Extract organization standards to ORGANIZATION.md (if not exists)
3. Create ~/.claude/projects/${PROJECT_NAME}/ directory
```

### Phase 3: Native Init (Optional)
```bash
IF --skip-init NOT set:
  1. Call native /init command
  2. Capture project-specific content
  3. Move to ~/.claude/projects/${PROJECT_NAME}/INIT.md
```

### Phase 4: PROJECT.md Creation
```bash
1. Load template based on --type flag
2. Auto-fill from current directory:
   - Git repository URL
   - Package.json (if Node.js)
   - Pom.xml/build.gradle (if Java)
   - Detect tech stack
3. Create ~/.claude/projects/${PROJECT_NAME}/PROJECT.md
4. Create supporting docs structure
```

### Phase 5: CLAUDE.md Reconstruction
```bash
1. Create new CLAUDE.md from template:

# CLAUDE.md - [Detected from ORGANIZATION.md]

## Organization Standards (Protected - DO NOT EDIT)
@include ORGANIZATION.md

## Project Context (Auto-loaded)
@include projects/${PROJECT_NAME}/PROJECT.md

## Vision Document
@include projects/${PROJECT_NAME}/VISION.md

## Session Information
Project: ${PROJECT_NAME}
Persona: ${CLAUDE_PERSONA}
Context: Organization + Project + Vision

2. Preserve any user customizations from backup
```

### Phase 6: Vision Document (Interactive)
```bash
IF --skip-vision NOT set:
  PROMPT: "Create vision document for ${PROJECT_NAME}? [Y/n]"

  IF yes:
    PROMPT: "Project type? [greenfield/enhancement/refactor/microservices/infrastructure]"
    RUN: /create-vision-doc --project ${PROJECT_NAME} --type ${TYPE}

  IF no:
    SHOW: "You can create it later with: /create-vision-doc"
```

### Phase 7: Summary
```bash
DISPLAY:
═══════════════════════════════════════════════════════════
✅ Project initialized: ${PROJECT_NAME}
═══════════════════════════════════════════════════════════

Created:
  📂 ~/.claude/projects/${PROJECT_NAME}/PROJECT.md
  📂 ~/.claude/projects/${PROJECT_NAME}/docs/
  🎯 ~/.claude/projects/${PROJECT_NAME}/VISION.md (if created)

Updated:
  📝 ~/.claude/CLAUDE.md (includes project context)

Preserved:
  🛡️  ~/.claude/ORGANIZATION.md (organization standards)

Next steps:
  1. Review PROJECT.md and customize as needed
  2. Update VISION.md with specific goals
  3. Start development: /implement --phase 1

Quick commands:
  /create-vision-doc    - Create/update vision document
  /update-vision        - Update vision with learnings
  /implement --phase N  - Execute autonomous development
═══════════════════════════════════════════════════════════
```

## File Structure After /init-project

```
~/.claude/
├── CLAUDE.md                          # Reconstructed (safe)
├── CLAUDE.md.backup                   # Backup of previous state
├── ORGANIZATION.md                    # Protected org standards
│
├── config/
│   └── persona.md                     # Current persona config
│
├── projects/
│   └── ${PROJECT_NAME}/
│       ├── PROJECT.md                 # Auto-generated from template
│       ├── VISION.md                  # Created if user confirms
│       ├── INIT.md                    # Output from native /init (if used)
│       └── docs/
│           ├── FILE_STRUCTURE.md
│           ├── WORKFLOW.md
│           └── INTEGRATIONS.md
│
└── shared/
    ├── org-coding-standards.md
    ├── org-tech-stack.md
    └── ...
```

## ORGANIZATION.md Structure

Created automatically on first `/init-project` if doesn't exist:

```markdown
# Organization Standards - [Your Organization]

**Protected File**: DO NOT EDIT manually. Managed by claude-config.sh
**Version**: 1.0.0
**Updated**: [Date]

---

## Coding Standards
@include shared/org-coding-standards.md

## Technology Stack
@include shared/org-tech-stack.md

## Security & Compliance
@include shared/org-security-policies.md

## Development Workflow
@include shared/org-dev-workflow.md

## SuperClaude Configuration
@include shared/superclaude-core.yml#Core_Philosophy
@include shared/superclaude-personas.yml#All_Personas
@include shared/superclaude-mcp.yml#MCP_Persona_Integration

---

*This file is protected and preserved across all projects*
```

## Auto-Detection Features

### Tech Stack Detection
```bash
# Node.js project
IF package.json exists:
  - Extract: name, version, dependencies
  - Set primary tech: JavaScript/TypeScript
  - Detect framework: React/Vue/Express/Next.js

# Java project
IF pom.xml OR build.gradle exists:
  - Extract: groupId, artifactId, version
  - Set primary tech: Java
  - Detect framework: Spring Boot/Micronaut/Quarkus

# Python project
IF requirements.txt OR pyproject.toml exists:
  - Extract: dependencies
  - Set primary tech: Python
  - Detect framework: Django/Flask/FastAPI

# Go project
IF go.mod exists:
  - Extract: module name
  - Set primary tech: Go
  - Detect framework: Gin/Echo/Fiber
```

### Git Integration
```bash
IF .git directory exists:
  - Extract repository URL
  - Extract current branch
  - Detect CI/CD (GitHub Actions, GitLab CI)
  - Set project name from repo name
```

### Team Detection
```bash
IF .github/CODEOWNERS exists:
  - Parse team structure
  - Identify code owners

IF package.json "contributors" exists:
  - Extract team members
```

## Interactive Mode

With `--interactive` flag:

```bash
/init-project --interactive

# Interactive prompts:
1. Project name? [auto-detected from directory]
2. Project type? [greenfield/enhancement/refactor/microservices/infrastructure]
3. Primary programming language? [auto-detected]
4. Framework? [auto-detected]
5. Team size? [1-5/6-10/11-20/20+]
6. Timeline? [weeks/months/quarter/year]
7. Current phase? [Planning/Design/Development/Testing/Production]
8. Create vision document now? [Y/n]
9. If yes, project approach? [use template from type]
```

## Error Handling

### Scenario 1: ORGANIZATION.md Missing
```
⚠️  Warning: ORGANIZATION.md not found

This file contains your organization's standards and should exist.
It may have been created by claude-config.sh installation.

Options:
  1. Create from current CLAUDE.md
  2. Skip and continue (not recommended)
  3. Cancel and run claude-config.sh first

Choice [1]:
```

### Scenario 2: Project Already Exists
```
❌ Error: Project 'payment-service' already initialized

Found existing:
  ~/.claude/projects/payment-service/PROJECT.md
  ~/.claude/projects/payment-service/VISION.md

Options:
  1. Reinitialize (backup existing files)
  2. Update PROJECT.md only
  3. Cancel

Choice [3]:
```

### Scenario 3: Native /init Fails
```
❌ Error: Native /init command failed

The native Claude Code /init command encountered an error.
We can continue without it by creating PROJECT.md manually.

Continue? [Y/n]:
```

## Integration with Existing Commands

### Works With
- ✅ `/create-vision-doc` - Called automatically if user confirms
- ✅ `/update-vision` - Available after initialization
- ✅ `/implement` - Works with created project structure
- ✅ Native `/init` - Wrapped and enhanced

### Replaces
- ❌ Direct use of `/init` (still available, but not recommended)

## Best Practices

1. **Always use /init-project** instead of native /init
2. **Let auto-detection work** - it fills in most PROJECT.md fields
3. **Use --interactive** for new project types
4. **Create vision document** during init for best results
5. **Review PROJECT.md** after initialization and customize

## Hooks Integration

### Pre-Init Hook
Called before any initialization:
```bash
~/.claude/hooks/pre-init-project.sh
```

### Post-Init Hook
Called after successful initialization:
```bash
~/.claude/hooks/post-init-project.sh ${PROJECT_NAME}
```

## Related Commands

- `/create-vision-doc` - Create vision document (called by init-project)
- `/update-vision` - Update vision with learnings
- `/sync-context` - Reload project context
- Native `/init` - Claude Code's built-in init (wrapped by this)

---

@include shared/universal-constants.yml#Standard_Messages_Templates

**This command ensures organization standards are never lost while providing seamless project initialization across all personas.**
