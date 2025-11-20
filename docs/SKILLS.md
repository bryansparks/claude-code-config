# Claude Code Skills Guide

**Automatic, intelligent task assistance through Claude Code Skills**

## What are Skills?

Skills are **auto-invoked capabilities** that Claude automatically activates based on your requests. Unlike slash commands that you explicitly call, Skills work in the background—Claude decides when to use them based on what you're asking for.

### Skills vs Other Features

| Feature | Invocation | Best For |
|---------|-----------|----------|
| **Skills** | Automatic (Claude decides) | Frequent, task-specific workflows |
| **Slash Commands** | Manual (`/command`) | Explicit, structured operations |
| **Subagents** | Manual or referenced | Complex, role-based specialists |
| **Hooks** | Event-triggered | Automated workflows on events |

## How Skills Work

1. **You describe what you need**: "Can you review my code?" or "This is running slow"
2. **Claude analyzes your request**: Matches it against available Skill descriptions
3. **Skill auto-activates**: Claude uses the appropriate Skill to help you
4. **You get expert assistance**: Structured, comprehensive help for your specific task

## Available Skills by Persona

### Engineer Persona

#### 🔍 code-review
**Automatically activates when you:**
- Ask for code review or feedback
- Want quality assessment
- Need pull request review
- Request best practices analysis

**Provides:**
- Comprehensive quality analysis (SOLID, design patterns, code smells)
- Security vulnerability assessment
- Performance optimization opportunities
- Prioritized actionable recommendations
- Language-specific best practices

**Example triggers:**
- "Can you review this code?"
- "Is this implementation good?"
- "Review my pull request"
- "What could be improved here?"

---

#### 🐛 debug-analysis
**Automatically activates when you:**
- Report bugs or errors
- Share stack traces
- Describe unexpected behavior
- Need troubleshooting help

**Provides:**
- Systematic root cause analysis
- Clear problem identification
- Step-by-step investigation
- Specific fix recommendations
- Regression test suggestions
- Prevention strategies

**Example triggers:**
- "I'm getting this error..."
- "This isn't working as expected"
- "Help me debug this"
- "Why is this crashing?"

---

#### ⚡ performance-optimization
**Automatically activates when you:**
- Mention performance issues
- Ask about optimization
- Report slow code or lag
- Want to improve speed

**Provides:**
- Performance metric analysis
- Bottleneck identification
- Frontend optimization (bundle size, Core Web Vitals)
- Backend optimization (queries, caching, algorithms)
- Database query optimization
- Prioritized improvement roadmap

**Example triggers:**
- "This is running slow"
- "How can I optimize this?"
- "The page load time is too long"
- "Performance issues with this query"

---

## Using Skills Effectively

### 1. Natural Language Works

Skills are designed to understand natural requests:

✅ **Good examples:**
- "Can you review the authentication code?"
- "I'm getting a TypeError on line 42"
- "The dashboard is loading slowly"
- "Is this the right way to handle errors?"

❌ **No need for formal commands:**
- You don't need to say "invoke code-review skill"
- Just describe what you need naturally

### 2. Provide Context

Skills work better with context:

**Include:**
- Relevant code snippets or file paths
- Error messages and stack traces
- What you've already tried
- Expected vs actual behavior
- Environment details (browser, Node version, etc.)

### 3. Skills are Complementary

Skills work alongside other features:

```bash
# Use slash command for explicit operations
/refactor --pattern "Extract Method"

# Then Claude might auto-invoke code-review Skill
# to validate the refactored code

# Use hooks for automation
# (e.g., code-review-hook.sh runs on commit)
```

## File Structure

Skills are markdown files with YAML frontmatter:

```markdown
---
name: skill-name
description: Clear description of when to use this Skill
---

# Skill Title

Instructions and guidelines for Claude to follow...
```

### Location

After installation, Skills live in:
```
~/.claude/skills/
├── code-review.md
├── debug-analysis.md
└── performance-optimization.md
```

## Creating Custom Skills

You can create your own Skills! Follow this structure:

### 1. Create the Skill File

```bash
# Create in your persona's skills directory
touch personas/engineer/skills/my-custom-skill.md
```

### 2. Write the Skill

```markdown
---
name: my-custom-skill
description: Detailed description of when Claude should invoke this Skill. Be specific about trigger conditions.
---

# My Custom Skill

## When to Use This Skill

Automatically invoke when the user:
- [Specific trigger condition 1]
- [Specific trigger condition 2]

## Process

1. **Step 1**: Clear instructions
2. **Step 2**: More instructions

## Output Format

Provide example of expected output format...
```

### 3. Key Elements

**Name**: Short, descriptive kebab-case identifier
**Description**: Critical! This is how Claude decides when to use it. Be specific and clear.
**Instructions**: Detailed process for Claude to follow
**Examples**: Show expected behavior and output

### 4. Best Practices

✅ **Do:**
- Write clear, specific trigger conditions in description
- Provide structured step-by-step processes
- Include output format examples
- Focus on a single, well-defined task

❌ **Don't:**
- Make Skills too broad (they become less effective)
- Use vague descriptions (Claude won't know when to invoke)
- Duplicate functionality across Skills
- Forget to test your Skill

## Installation

Skills are automatically installed with the persona installer:

```bash
# Install engineer persona (includes Skills)
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- engineer

# Skills are copied to ~/.claude/skills/
```

## Skills for Other Personas

### QA Persona (5 Skills Available)

**✓ test-automation** - Automated test generation from requirements
**✓ accessibility-audit** - WCAG compliance checking with Axe-core
**✓ bug-analysis** - Systematic bug investigation and root cause analysis
**✓ visual-regression** - UI change detection and screenshot comparison
**✓ fact-check** ✨ NEW! - Quick verification of responses for accuracy

**Fact-Check Skill Highlights:**
- Auto-activates on: "verify", "is this correct", "are you sure"
- Verifies claims against codebase in 30-60 seconds
- Provides confidence scores (High/Medium/Low)
- Cites exact file:line references
- Commands: `/verify-response`, `/fact-check [claim]`

### PM Persona (4 Skills Available)

**✓ prd-guide** - Interactive 7-step PRD creation wizard
**✓ success-criteria-builder** - Converts vague goals to SMART metrics
**✓ requirements-refiner** - Detects vague language, ensures precision
**✓ ai-solution-ideation** - Explores AI/ML opportunities with cost estimates

### Coming Soon

**EM Persona:**
- `technical-debt-assessment` - Debt identification and prioritization
- `team-capacity-planning` - Resource allocation
- `metrics-analysis` - DORA metrics interpretation

**UX Persona:**
- `design-system-audit` - Consistency checking
- `interaction-design` - User flow optimization
- `responsive-design-review` - Multi-device validation

## Troubleshooting

### Skill Not Activating?

1. **Check description clarity**: Is it specific enough?
2. **Use direct language**: "I need to debug this error"
3. **Provide context**: Include code/errors
4. **Verify installation**: `ls ~/.claude/skills/`

### Skill Activating Too Often?

1. **Refine description**: Make trigger conditions more specific
2. **Check for overlaps**: Skills with similar descriptions may conflict

### Creating Better Skill Descriptions

**Good description example:**
```yaml
description: Perform comprehensive code review analyzing quality, security, performance, and best practices. Use when user requests code review, asks to review changes, wants feedback on pull requests, or needs quality assessment of their code.
```

**Why it's good:**
- Lists specific trigger phrases
- Clear scope (quality, security, performance)
- Explicit use cases (code review, PRs, feedback)

**Poor description example:**
```yaml
description: Help with code.
```

**Why it's poor:**
- Too vague
- No specific triggers
- Claude won't know when to invoke

## Resources

- **Official Docs**: [docs.claude.com/en/docs/claude-code/skills](https://docs.claude.com/en/docs/claude-code/skills)
- **Skill Examples**: Browse `personas/*/skills/` for templates
- **Issues**: Report problems at [github.com/bryansparks/claude-code-config/issues](https://github.com/bryansparks/claude-code-config/issues)

## FAQ

### Q: Can I have Skills for multiple personas?

A: Yes! Each persona can have its own Skills. When you switch personas, the appropriate Skills are available.

### Q: How do Skills differ from MCP servers?

A: MCP servers provide **tools and data access** (e.g., read files, query databases). Skills provide **workflow expertise** (e.g., how to review code systematically). They're complementary!

### Q: Can I disable a Skill?

A: Yes, just remove it from `~/.claude/skills/` or rename it to have a different extension (e.g., `.md.disabled`).

### Q: How many Skills should I have?

A: Start with 3-5 high-value Skills per persona. Too many can cause confusion in auto-invocation.

### Q: Can Skills call other Skills?

A: Skills are invoked independently by Claude. However, Claude can use multiple Skills in a conversation as needed.

---

**Version**: 1.0.0 (Engineer Persona Skills)
**Last Updated**: 2025-10-20
