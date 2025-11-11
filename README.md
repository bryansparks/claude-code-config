# Claude Code Configuration Framework

**Production-ready Claude Code configuration with persona-specific workflows, MCP server bundles, and vision-driven development.**

[![Version](https://img.shields.io/badge/version-2.3.0-blue.svg)](https://github.com/bryansparks/claude-code-config)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🚀 Quick Start

One command installation:

```bash
# Software Engineer
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- engineer

# QA Engineer
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- qa

# Product Manager
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- pm

# Engineering Manager
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- em

# UX Designer
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- ux
```

**After installation:**
1. Restart Claude Code
2. Try `/init-project` to create a new project
3. Check MCP servers: `claude mcp list`

## ✨ Features

- **🎭 5 Persona Configurations**: Engineer, QA, PM, EM, UX
- **🧠 Auto-Invoked Skills**: Intelligent task assistance (NEW!)
- **🔌 Persona-Specific MCP Bundles**: 6-7 optimized servers each
- **📚 Vision-Driven Development**: PROJECT.md + VISION.md templates
- **🛡️ Enterprise Standards**: Organization-wide policies preserved
- **🚀 One-Command Install**: Sparse checkout, selective downloads
- **📖 Comprehensive Documentation**: Guides for every persona

## 🎭 Personas

| Persona | MCP Servers | Skills | Focus Areas |
|---------|-------------|--------|-------------|
| **Software Engineer** | 7 | 3 | Code review, debugging, performance |
| **QA Engineer** | 7 | Coming soon | Playwright, A11y, test automation |
| **Product Manager** | 7 | Coming soon | Linear, PostHog, RICE prioritization |
| **Engineering Manager** | 7 | Coming soon | DORA metrics, team performance |
| **UX Designer** | 6 | Coming soon | Figma, accessibility, responsive design |

[View Full Persona Comparison →](docs/PERSONAS.md)

## 📁 What Gets Installed

```
~/.claude/                     # Everything lives here!
├── CLAUDE.md                 # Your configuration
├── ORGANIZATION.md           # Company standards
├── config/
│   └── mcp-servers/         # Persona MCP configs
├── skills/                  # Auto-invoked Skills (NEW!)
├── templates/               # Project templates
├── commands/                # Slash commands
├── hooks/                   # Event hooks
└── scripts/                 # Helper scripts
```

**No clutter in your project root!** Everything stays in `~/.claude/`

## 🧠 Skills (NEW!)

**Auto-invoked intelligent assistance** - Claude automatically activates Skills based on your requests.

### Engineer Persona Skills

| Skill | Auto-activates when you... | Provides |
|-------|---------------------------|----------|
| 🔍 **code-review** | Ask for code review or feedback | Quality, security, performance analysis |
| 🐛 **debug-analysis** | Report bugs or errors | Root cause analysis and fixes |
| ⚡ **performance-optimization** | Mention slow code or optimization | Bottleneck identification and improvements |

**How it works:**
1. You: "Can you review my authentication code?"
2. Claude: *Automatically activates code-review Skill*
3. Result: Comprehensive analysis with prioritized recommendations

[Full Skills Guide →](SKILLS.md)

## 🏗️ Three-Tier Configuration Architecture

**Organization → Project → Vision** - Every Claude Code session has full context automatically.

### 1. ORGANIZATION.md (Company-Wide Standards)

**What it is**: Engineering best practices, security standards, and workflows that apply to ALL projects.

**What's included**:
- ✅ OWASP Top 10 security compliance
- ✅ WCAG 2.1 accessibility standards
- ✅ ISO/IEC 25010 quality model (8 characteristics)
- ✅ Test-Driven Development (TDD) requirements
- ✅ Code review standards and SLAs
- ✅ Git workflow and commit conventions
- ✅ API design standards (RESTful, OpenAPI)
- ✅ Documentation requirements

**Key principle**: Organization standards **never change per-project**. They provide consistency across your entire engineering organization.

**Customization**: Edit ORGANIZATION.md for your company, then distribute via `install.sh --update`.

### 2. PROJECT.md (Project-Specific Context)

**What it is**: Project architecture, tech stack, team structure, and file organization.

**What's included**:
- Project overview and business value
- Technology stack (frontend, backend, infrastructure)
- Team structure and communication channels
- Architecture patterns and design decisions
- File structure and important locations
- Development workflow and getting started guide
- Integration points (internal systems, external services)
- Environment configuration (dev, staging, production)
- Testing strategy and tools

**Key principle**: Stable during project lifetime. Changes infrequently.

**Creation**: Automatically created by `/init-project` command with auto-detection of tech stack, git repo, and team.

### 3. VISION.md (Product Goals & Roadmap)

**What it is**: Strategic direction, implementation phases, and success criteria.

**What's included**:
- Product vision and goals
- Implementation roadmap (phase by phase)
- Architectural decisions and rationale
- Success metrics and acceptance criteria
- Technical constraints and assumptions

**Key principle**: Living document, updated sprint-by-sprint as the project evolves.

**Creation**: Created by `/create-vision-doc` command or during `/init-project`.

### How It Works Together

```
┌─────────────────────────────────────────────────────────────┐
│ ORGANIZATION.md (Global)                                     │
│ "How we build software as an organization"                   │
│ • Security standards      • Testing requirements             │
│ • Code quality rules      • Documentation standards          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PROJECT.md (Per-Repository)                                  │
│ "What this project is and how it's structured"              │
│ • Architecture            • Tech stack                       │
│ • Team composition        • File structure                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ VISION.md (Per-Repository, Living)                           │
│ "Where we're going and how we'll get there"                 │
│ • Product goals           • Implementation phases            │
│ • Success criteria        • Architectural decisions          │
└─────────────────────────────────────────────────────────────┘
```

**On Claude Code startup**, all three layers are automatically loaded, giving Claude complete context without any manual setup.

### Example Workflow

```bash
# 1. Install Claude-Config with your persona
curl -fsSL https://url/install.sh | bash -s -- engineer

# This installs ORGANIZATION.md with your company's standards

# 2. Navigate to a project and initialize it
cd ~/my-project
claude-code /init-project my-api-service

# This creates:
# - ~/.claude/projects/my-api-service/PROJECT.md (auto-detected tech stack)
# - ~/.claude/projects/my-api-service/VISION.md (optional)

# 3. Start working - Claude has full context automatically
claude-code
> "Review my authentication code"
# Claude uses: Organization security standards + Project architecture + Vision goals
```

### Benefits

✅ **Consistency**: Organization standards apply everywhere
✅ **Context-Aware**: Claude knows your project architecture and goals
✅ **Zero Setup**: Auto-loading on startup, no manual configuration
✅ **Separation of Concerns**: Company standards vs project details vs product vision
✅ **Easy Updates**: Update organization standards centrally, push to all users

**Learn more**: [Vision System Guide](docs/VISION_SYSTEM.md)

## 📊 Metrics (Optional)

**Status**: ⚠️ **Disabled by default** - No metrics collected unless you enable them

Metrics are **completely optional** and designed for mature Claude Code adoption (6+ months). Most organizations should keep metrics disabled.

### Three Levels of Metrics

| Level | Infrastructure | When to Use | Cost |
|-------|---------------|-------------|------|
| **Disabled** (default) | None | Starting out (0-6 months) | $0 |
| **Local** (optional) | None | Early adoption (3-6 months) | $0 |
| **Centralized** (advanced) | PostgreSQL + 2 servers | Mature adoption (6+ months) | $500-2000/mo |

**To enable local metrics** (lightweight, no infrastructure):
```yaml
# Edit ~/.claude/config/metrics.yml
metrics_mode: local
local_metrics:
  enabled: true
```

**For centralized dashboard** (requires infrastructure):
- Read decision guide: [`docs/METRICS_DECISION_GUIDE.md`](docs/METRICS_DECISION_GUIDE.md)
- Installation: [`optional-features/metrics-dashboard/`](optional-features/metrics-dashboard/)

💡 **Recommendation**: Keep metrics disabled initially. Focus on getting value from skills first. Add metrics later if needed.

## 📖 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Detailed setup
- **[Quick Start](docs/QUICK_START.md)** - 5-minute guide
- **[Skills Guide](SKILLS.md)** - Auto-invoked task assistance (NEW!)
- **[Metrics Decision Guide](docs/METRICS_DECISION_GUIDE.md)** - Should you enable metrics? (NEW!)
- **[MCP Servers](docs/MCP_SERVERS.md)** - Server reference
- **[Vision System](docs/VISION_SYSTEM.md)** - Vision-driven development

## 🔧 Advanced Usage

### Install All Personas
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --all
```

### Update Installation
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --update
```

### Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --uninstall
```

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

**Made with ❤️ for Claude Code** | Version 2.3.0
