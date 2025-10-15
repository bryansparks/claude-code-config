# Claude Code Plugins - Role-Specific Toolkits

Official Claude Code plugins providing specialized agents, commands, and automation hooks for different engineering roles.

## 🚀 Quick Start

```bash
# Add this marketplace
/plugin marketplace add your-org/claude-config

# Install your role's toolkit
/plugin install engineer-toolkit  # For software engineers
/plugin install qa-toolkit        # For QA engineers
/plugin install pm-toolkit        # For product managers
/plugin install em-toolkit        # For engineering managers
/plugin install ux-toolkit        # For UX designers
```

## 📦 Available Plugins

### 🔧 engineer-toolkit

**For:** Software Engineers, Full-Stack Developers

**What's Included:**
- **9 Specialized Agents:**
  - code-reviewer: SOLID principles, code smells, best practices
  - debugger: Systematic debugging, root cause analysis
  - api-designer: RESTful, GraphQL, API versioning
  - backend-engineer: Database, APIs, architecture
  - frontend-ux-engineer: React, Vue, accessibility
  - devops: CI/CD, Docker, Kubernetes
  - ai-ml-engineer: Model development, training
  - performance-optimizer: Profiling, caching
  - refactorer: Code smell detection, patterns

- **3 Commands:**
  - `/debug`: Systematic debugging assistance
  - `/optimize`: Performance optimization analysis
  - `/refactor`: Code refactoring recommendations

- **5 Automation Hooks:**
  - Auto-test on file changes
  - Lint on save
  - Complexity analysis
  - Dependency security checks
  - Commit message validation

**Install:** `/plugin install engineer-toolkit`

---

### 🧪 qa-toolkit

**For:** QA Engineers, Test Automation Specialists

**What's Included:**
- **5 Specialized Agents:**
  - test-automation-specialist: Jest, Pytest, Playwright, Cypress
  - bug-analyst: P0-P4 classification, reproduction
  - performance-tester: Lighthouse, k6, load testing
  - accessibility-auditor: WCAG 2.1 AA/AAA compliance
  - visual-regression-tester: Screenshot comparison

- **7 Commands:**
  - `/test-coverage`: Analyze test coverage gaps
  - `/test-flakiness`: Detect flaky tests
  - `/accessibility-audit`: WCAG compliance check
  - `/performance-test`: Performance benchmarks
  - `/visual-test`: Visual regression testing
  - `/bug-report`: Structured bug reports
  - `/test-plan`: Generate test plans

- **7 Automation Hooks:**
  - Auto-test on code changes
  - Coverage reporting
  - Visual regression on UI changes
  - Accessibility validation
  - Flakiness detection
  - Bug severity classification
  - Performance baseline tracking

**Install:** `/plugin install qa-toolkit`

---

### 📊 pm-toolkit

**For:** Product Managers, Product Owners

**What's Included:**
- **5 Specialized Agents:**
  - feature-analyzer: Feature breakdown, impact analysis
  - requirement-validator: SMART criteria validation
  - user-story-writer: As a/I want/So that format
  - roadmap-planner: Now/Next/Later framework
  - ux-evaluator: User flow analysis

- **8 Commands:**
  - `/analyze-feature`: Feature analysis and breakdown
  - `/write-user-story`: Generate user stories
  - `/create-acceptance-criteria`: Given/When/Then format
  - `/estimate-feature`: RICE prioritization
  - `/roadmap-planning`: Quarterly roadmap generation
  - `/requirements-doc`: PRD documentation
  - `/stakeholder-update`: Stakeholder communications
  - `/ux-flow-analysis`: User flow evaluation

- **6 Automation Hooks:**
  - User story validation
  - Acceptance criteria checker
  - Feature completeness check
  - Documentation generation
  - Stakeholder summary
  - Feature impact analysis

**Install:** `/plugin install pm-toolkit`

---

### 👔 em-toolkit

**For:** Engineering Managers, Tech Leads

**What's Included:**
- **5 Specialized Agents:**
  - project-analyzer: Sprint health, velocity trends
  - team-coordinator: Cross-team dependencies
  - technical-debt-assessor: ROI analysis, categorization
  - metrics-reporter: team performance metrics tracking
  - code-health-monitor: Quality trends

- **8 Commands:**
  - `/analyze-project`: Project health analysis
  - `/estimate-effort`: Story point estimation
  - `/technical-debt-audit`: Technical debt assessment
  - `/team-metrics`: team performance metrics reporting
  - `/sprint-planning`: Sprint capacity planning
  - `/capacity-planning`: Team capacity analysis
  - `/retrospective-analysis`: Retro insights
  - `/dependency-map`: Cross-team dependencies

- **7 Automation Hooks:**
  - PR review summary
  - Sprint health check
  - Technical debt tracker
  - Velocity calculator
  - Dependency analyzer
  - Code quality trends
  - Blocker detector

**Install:** `/plugin install em-toolkit`

---

### 🎨 ux-toolkit

**For:** UX Designers, Design System Maintainers

**What's Included:**
- **5 Specialized Agents:**
  - ui-component-reviewer: Component consistency
  - accessibility-specialist: WCAG compliance
  - design-system-expert: Token management
  - interaction-designer: Micro-interactions
  - user-flow-architect: Flow optimization

- **8 Commands:**
  - `/design-review`: Component design review
  - `/accessibility-audit`: A11y compliance check
  - `/component-library`: Component documentation
  - `/design-system-check`: Design token validation
  - `/user-flow`: User flow analysis
  - `/interaction-spec`: Interaction specifications
  - `/responsive-audit`: Responsive design check
  - `/prototype-feedback`: Prototype evaluation

- **6 Automation Hooks:**
  - Accessibility checker (4.5:1 contrast)
  - Design token validator
  - Component documentation
  - Responsive design test
  - Contrast checker
  - Design system sync

**Install:** `/plugin install ux-toolkit`

## 🔧 Usage Examples

### Software Engineer Workflow
```bash
# Install plugin
/plugin install engineer-toolkit

# Debug an issue
/debug --error "TypeError: Cannot read property 'map'" --file src/UserList.jsx

# Request code review
# The code-reviewer agent will analyze your changes

# Optimize performance
/optimize --performance "Slow page load times"

# Refactor code
/refactor --file src/services/api.js --pattern "Extract duplicate logic"
```

### QA Engineer Workflow
```bash
# Install plugin
/plugin install qa-toolkit

# Analyze test coverage
/test-coverage --threshold 80

# Check accessibility
/accessibility-audit --wcag AA --pages "homepage,dashboard"

# Detect flaky tests
/test-flakiness --suite integration

# Generate bug report
/bug-report --severity P1 --description "Login fails on mobile"
```

### Product Manager Workflow
```bash
# Install plugin
/plugin install pm-toolkit

# Analyze feature request
/analyze-feature "User authentication with OAuth"

# Write user story
/write-user-story --persona "registered user" --goal "social login"

# Generate acceptance criteria
/create-acceptance-criteria --story US-123

# Plan roadmap
/roadmap-planning --quarter Q1-2025
```

### Engineering Manager Workflow
```bash
# Install plugin
/plugin install em-toolkit

# Check project health
/analyze-project --sprint "Sprint 42"

# Review technical debt
/technical-debt-audit --categorize --roi-analysis

# Generate team metrics
/team-metrics --period "last-quarter" --metrics DORA

# Plan sprint capacity
/sprint-planning --team "backend" --points 40
```

### UX Designer Workflow
```bash
# Install plugin
/plugin install ux-toolkit

# Review design system compliance
/design-system-check --components "Button,Input,Card"

# Audit accessibility
/accessibility-audit --wcag AAA --component "navigation"

# Analyze user flow
/user-flow --flow "checkout-process"

# Review responsive design
/responsive-audit --breakpoints "mobile,tablet,desktop"
```

## 🎯 Plugin Features

### Agents (Formerly Subagents)
Specialized AI agents with focused expertise:
```yaml
---
name: code-reviewer
description: Senior code reviewer with SOLID principles expertise
tools: Read, Grep, TodoWrite, Bash
model: sonnet
color: blue
---
```

Agents are automatically available in conversations and can be called explicitly when needed.

### Commands (Slash Commands)
Quick access to common workflows:
```bash
/command-name --flag value
```

Commands support:
- Flags for customization
- Plan mode (`--plan`)
- Multiple arguments
- Contextual help

### Hooks (Automation)
Background automation triggered by Claude Code events:

**Hook Events:**
- `PreToolUse`: Before tool execution
- `PostToolUse`: After tool completion
- `UserPromptSubmit`: When user submits prompt
- `SessionStart`: Session begins
- `SessionEnd`: Session ends

**Example Hook:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./hooks/lint-on-save.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## 🛠️ Plugin Management

### Installation
```bash
# Add marketplace
/plugin marketplace add your-org/claude-config

# Install plugin
/plugin install <plugin-name>

# Install multiple
/plugin install engineer-toolkit qa-toolkit
```

### Management
```bash
# List installed
/plugin list

# Enable/disable
/plugin enable engineer-toolkit
/plugin disable engineer-toolkit

# Uninstall
/plugin uninstall engineer-toolkit

# Validate
/plugin validate ./plugins/engineer-toolkit
```

### Updates
```bash
# Check for updates
/plugin update

# Update specific plugin
/plugin update engineer-toolkit
```

## 📚 Documentation

Each plugin includes:
- **README.md**: Plugin overview and usage
- **Agent docs**: Detailed agent expertise and capabilities
- **Command docs**: Command reference with examples
- **Hook docs**: Automation triggers and configuration

## 🔗 Related Resources

- **Migration Guide:** [PLUGIN_MIGRATION_GUIDE.md](../PLUGIN_MIGRATION_GUIDE.md)
- **Official Plugin Docs:** https://docs.claude.com/en/docs/claude-code/plugins
- **Anthropic Examples:** https://github.com/anthropics/claude-code/tree/main/plugins
- **Community Resources:** https://github.com/hesreallyhim/awesome-claude-code

## 🤝 Contributing

Improvements welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes with `/plugin validate`
4. Submit a pull request

## 📄 License

MIT License - see LICENSE file

---

**Questions?** Open an issue or consult the [migration guide](../PLUGIN_MIGRATION_GUIDE.md).
