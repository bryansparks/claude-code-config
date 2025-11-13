# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- LICENSE file (MIT License)
- CONTRIBUTING.md with contribution guidelines
- SECURITY.md with security policy and reporting process
- CODE_OF_CONDUCT.md (Contributor Covenant v2.1)
- GitHub issue templates (bug report, feature request)
- GitHub pull request template
- CHANGELOG.md (this file)

## [2.3.0] - 2025-11-12

### Added
- Auto-invoked Skills system for intelligent task assistance
- Engineer persona skills:
  - `code-review` - Automated code quality and security analysis
  - `debug-analysis` - Root cause analysis for bugs and errors
  - `performance-optimization` - Bottleneck identification and improvements
- QA persona skills:
  - `accessibility-audit` - WCAG compliance checking
  - `bug-analysis` - Systematic bug investigation
  - `test-automation` - Test generation and coverage analysis
  - `visual-regression` - Visual testing and screenshot comparison
- Three-tier configuration architecture:
  - ORGANIZATION.md (company-wide standards)
  - PROJECT.md (project-specific context)
  - VISION.md (product goals and roadmap)
- Auto-detection of tech stack and project structure in `/init-project`
- Comprehensive skills documentation in `SKILLS.md`
- Skills training guide for engineers
- Metrics decision guide (disabled by default)
- Secrets management documentation

### Changed
- Simplified installation flow with persona-specific bundles
- Updated README with Skills showcase
- Improved documentation structure
- Enhanced MCP server configuration with per-persona optimization

### Fixed
- Installation script handling of spaces in directory paths
- Sparse checkout configuration for selective downloads

## [2.2.0] - 2025-11-11

### Added
- Organization deployment system
- `ORGANIZATION.md` template with engineering best practices
- `COPY_TO_ORGANIZATION.md` guide for enterprise deployments
- `prepare-for-org.sh` script for organization preparation
- Comprehensive organization setup documentation
- Support for custom repository URLs via `CLAUDE_CONFIG_REPO` env var

### Changed
- Restructured configuration hierarchy for organization support
- Updated installation script to preserve organization standards
- Enhanced backup and update workflows

## [2.1.0] - 2025-10-06

### Added
- Persona-specific subagents for specialized tasks:
  - Engineer: 9 subagents (code reviewer, debugger, performance optimizer, etc.)
  - QA: 5 subagents (accessibility auditor, bug analyst, test automation, etc.)
  - PM: 4 subagents (requirements analyst, feature planner, etc.)
  - EM: 4 subagents (capacity planner, technical debt auditor, etc.)
  - UX: 4 subagents (accessibility specialist, interaction designer, etc.)
- Comprehensive slash commands for each persona
- Vision document system with templates
- MCP server bundles optimized per persona

### Changed
- Improved persona activation patterns
- Enhanced command documentation with examples
- Better organization of persona-specific configurations

## [2.0.0] - 2025-10-04

### Added
- Multi-persona support (Engineer, QA, PM, EM, UX)
- One-command installation with `install.sh`
- Sparse checkout for efficient downloads
- MCP server auto-installation
- Global CLAUDE.md configuration
- Persona-specific MCP server bundles
- Project templates and initialization commands
- Comprehensive documentation system

### Changed
- **BREAKING**: Restructured configuration from single-user to multi-persona
- Moved all configuration to `~/.claude/` directory
- Simplified installation process

### Removed
- Legacy single-persona configuration structure

## [1.0.0] - 2025-09-15

### Added
- Initial release
- Basic Claude Code configuration
- Single persona (Software Engineer)
- Core MCP server integration
- Project templates
- Basic documentation

---

## Version History Summary

- **2.3.0** - Skills system and three-tier architecture
- **2.2.0** - Organization deployment support
- **2.1.0** - Subagents and enhanced persona capabilities
- **2.0.0** - Multi-persona support (breaking change)
- **1.0.0** - Initial release

## Upgrade Guides

### Upgrading from 2.2.x to 2.3.0

Skills are automatically installed with the persona. No migration needed.

To get skills:
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --update
```

### Upgrading from 2.1.x to 2.2.0

Organization standards are preserved during updates. To upgrade:

```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- --update
```

### Upgrading from 2.0.x to 2.1.0

Subagents and commands are added automatically. No breaking changes.

### Upgrading from 1.x to 2.0.0

This is a breaking change. Backup your configuration first:

```bash
mv ~/.claude ~/.claude.backup
```

Then run fresh installation:
```bash
curl -fsSL https://raw.githubusercontent.com/bryansparks/claude-code-config/main/install.sh | bash -s -- engineer
```

## Links

- [Repository](https://github.com/bryansparks/claude-code-config)
- [Documentation](https://github.com/bryansparks/claude-code-config/tree/main/docs)
- [Issues](https://github.com/bryansparks/claude-code-config/issues)
- [Discussions](https://github.com/bryansparks/claude-code-config/discussions)
