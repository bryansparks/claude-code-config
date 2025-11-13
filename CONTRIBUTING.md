# Contributing to Claude Code Configuration

Thank you for your interest in contributing to Claude Code Configuration! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Claude Code version, persona)
- **Screenshots** if applicable
- **Error messages** or logs

Use the bug report template when creating an issue.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful** to most users
- **List any similar features** in other projects (if applicable)

### Adding New Personas

To contribute a new persona:

1. Create a new directory: `personas/[persona-name]/`
2. Include:
   - `commands/` - Slash commands specific to the persona
   - `skills/` - Auto-invoked skills for the persona
   - `subagents/` - Specialized subagents
   - `README.md` - Documentation for the persona
3. Add MCP server configuration in `.claude/config/mcp-servers/[persona-name]/`
4. Update documentation in `docs/PERSONAS.md`

### Adding Skills

Skills should:

- Have a clear `invocationPattern` that triggers automatically
- Include comprehensive instructions in markdown format
- Follow the structure in existing skills (see `personas/engineer/skills/`)
- Include examples of expected input/output
- Be tested with real-world scenarios

### Improving Documentation

Documentation improvements are always welcome! This includes:

- Fixing typos or clarifying existing docs
- Adding examples or use cases
- Creating tutorials or guides
- Translating documentation

## Development Setup

### Prerequisites

- Git
- Bash (or compatible shell)
- Claude Code CLI installed

### Local Development

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-code-config.git
   cd claude-code-config
   ```

2. **Create a test installation**
   ```bash
   # Test the installation script
   ./install.sh engineer
   ```

3. **Make your changes**
   - Edit files in the appropriate directories
   - Test changes with Claude Code

4. **Test with different personas**
   ```bash
   ./install.sh qa
   ./install.sh pm
   # etc.
   ```

### Testing Your Changes

Before submitting:

- Test the `install.sh` script with your changes
- Verify persona-specific configurations work
- Check that MCP servers install correctly
- Test slash commands and skills
- Ensure documentation is accurate

## Submitting Changes

### Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the style guidelines below
   - Add or update tests if applicable
   - Update documentation to reflect changes

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

   Use conventional commit format:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `chore:` - Maintenance tasks
   - `refactor:` - Code refactoring
   - `test:` - Adding or updating tests

4. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request**
   - Use the PR template
   - Link to related issues
   - Describe your changes in detail
   - Add screenshots for UI changes

### Pull Request Guidelines

- **Keep PRs focused** - One feature or fix per PR
- **Update documentation** - Include relevant doc updates
- **Add tests** - If applicable
- **Follow code style** - Consistent with existing code
- **Descriptive commits** - Use conventional commit format
- **Respond to feedback** - Address review comments promptly

## Style Guidelines

### Bash Scripts

- Use `set -euo pipefail` for safety
- Add comments for complex logic
- Use meaningful variable names
- Follow existing formatting conventions
- Test on multiple platforms (macOS, Linux)

### Markdown Documentation

- Use ATX-style headers (`#`, `##`, `###`)
- Include a table of contents for long documents
- Use code blocks with language identifiers
- Add examples where helpful
- Keep line length reasonable (80-100 chars)

### YAML Configuration

- Use 2 spaces for indentation
- Add comments to explain non-obvious settings
- Group related configurations together
- Follow existing structure and naming

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Examples:
```
feat(engineer): add performance profiling skill

Add new auto-invoked skill for performance profiling that triggers
when users mention slow code, bottlenecks, or optimization.

Closes #123
```

```
fix(install): handle spaces in directory paths

Update install.sh to properly quote paths with spaces.

Fixes #456
```

## Community

### Getting Help

- **GitHub Issues** - Bug reports and feature requests
- **Discussions** - Questions and general discussion
- **Pull Requests** - Code contributions

### Response Times

We aim to:
- Acknowledge new issues within 48 hours
- Review PRs within 1 week
- Respond to questions within 72 hours

Please be patient - this is a community-driven project maintained by volunteers.

### Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes for significant contributions
- Special mentions for major features

## Questions?

Don't hesitate to ask! Open an issue with the "question" label or start a discussion.

---

Thank you for contributing to Claude Code Configuration!
