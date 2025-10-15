# Command: Write User Story

## Purpose
Creates well-formed user stories with acceptance criteria following INVEST principles.

## Usage
```bash
/write-user-story [feature-description or existing-file]
```

## What This Command Does

1. Activates **user-story-writer** subagent
2. Validates with **requirement-validator**
3. Runs **user-story-validator.sh** and **acceptance-criteria-checker.sh** hooks
4. Generates properly formatted user story

## Output Format

```markdown
# User Story: [Feature Name]

As a **[user role/persona]**
I want to **[goal/action]**
So that **[business value/benefit]**

**Context**: [Background information]

**Acceptance Criteria**:

1. **Given** [initial state]
   **When** [action occurs]
   **Then** [expected outcome]

2. **Given** [initial state]
   **When** [action occurs]
   **Then** [expected outcome]

**Edge Cases**:
- [Edge case scenario]

**Non-Functional Requirements**:
- Performance: [Requirement]
- Security: [Requirement]
- Accessibility: [Requirement]

**Dependencies**: [List]

**Technical Notes**: [Implementation details]

**Estimated Effort**: [Story points or T-shirt size]
```

## Examples

```bash
# From scratch
/write-user-story

# From existing requirements
/write-user-story ~/requirements/feature.md

# Quick mode
/write-user-story --quick "Users need to reset passwords"
```

## Options
- `--quick`: Basic story without full AC
- `--epic`: Create epic with child stories
- `--validate`: Run all quality checks
- `--output=<file>`: Save to file

## Validation

Automatically runs:
- Format check (As a/I want/So that)
- INVEST principles validation
- Acceptance criteria quality check
- Minimum 2 AC required
- Testability verification

## Success Criteria
- [ ] User role defined
- [ ] Goal stated clearly
- [ ] Value explained
- [ ] 2+ acceptance criteria
- [ ] Given/When/Then format
- [ ] Edge cases considered
- [ ] Story points estimated
- [ ] Quality score ≥70/100
