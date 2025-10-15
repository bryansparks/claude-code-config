# CLAUDE.md - [Your Organization Name]

**Version**: 1.0.0
**Last Updated**: [Date]
**Purpose**: Organization-wide Claude Code standards and project context loader

---

## Organization Standards

### Coding Standards
@include shared/org-coding-standards.md

### Technology Stack
@include shared/org-tech-stack.md

### Security & Compliance
@include shared/org-security-policies.md

### Development Workflow
@include shared/org-dev-workflow.md

---

## SuperClaude Configuration

### Core Philosophy
@include shared/superclaude-core.yml#Core_Philosophy

### Personas
@include shared/superclaude-personas.yml#All_Personas

### MCP Integration
@include shared/superclaude-mcp.yml#MCP_Persona_Integration

---

## Project Context (Auto-Loaded)

### Project Detection
```bash
# Auto-detect from:
# 1. Environment variable: $CLAUDE_PROJECT
# 2. Git repository name
# 3. Current directory name
```

### Project Context Loading
@include projects/${PROJECT_NAME}/PROJECT.md

### Vision Document Loading
@include projects/${PROJECT_NAME}/VISION.md

---

## Active Persona Configuration

### Current Persona: ${CLAUDE_PERSONA}
@include personas/${CLAUDE_PERSONA}/persona-config.md

---

## Session Information

**Organization**: [Your Org Name]
**Project**: ${PROJECT_NAME}
**Persona**: ${CLAUDE_PERSONA}
**Context Loaded**: Organization + Project + Vision

---

## Quick Commands

- `/create-vision-doc` - Generate vision document for current project
- `/init-project <name>` - Initialize new project structure
- `/switch-persona <persona>` - Switch to different persona
- `/update-vision` - Update vision based on learnings
- `/sync-context` - Reload project and vision context

---

*This configuration provides 3-layer context: Org Standards → Project Context → Vision/PRD*
*All personas read the same vision document through their specialized lens.*
