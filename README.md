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
- **🔌 Persona-Specific MCP Bundles**: 6-7 optimized servers each
- **📚 Vision-Driven Development**: PROJECT.md + VISION.md templates
- **🛡️ Enterprise Standards**: Organization-wide policies preserved
- **🚀 One-Command Install**: Sparse checkout, selective downloads
- **📖 Comprehensive Documentation**: Guides for every persona

## 🎭 Personas

| Persona | MCP Servers | Focus Areas |
|---------|-------------|-------------|
| **Software Engineer** | 7 | Serena LSP, code quality, testing |
| **QA Engineer** | 7 | Playwright, A11y, test automation |
| **Product Manager** | 7 | Linear, PostHog, RICE prioritization |
| **Engineering Manager** | 7 | DORA metrics, team performance |
| **UX Designer** | 6 | Figma, accessibility, responsive design |

[View Full Persona Comparison →](docs/PERSONAS.md)

## 📁 What Gets Installed

```
~/.claude/                     # Everything lives here!
├── CLAUDE.md                 # Your configuration
├── ORGANIZATION.md           # Company standards
├── config/
│   └── mcp-servers/         # Persona MCP configs
├── templates/               # Project templates
├── commands/                # Slash commands
├── hooks/                   # Event hooks
└── scripts/                 # Helper scripts
```

**No clutter in your project root!** Everything stays in `~/.claude/`

## 📖 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Detailed setup
- **[Quick Start](docs/QUICK_START.md)** - 5-minute guide
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
