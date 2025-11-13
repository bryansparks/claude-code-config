# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 2.3.x   | :white_check_mark: |
| < 2.3   | :x:                |

## Reporting a Vulnerability

We take the security of Claude Code Configuration seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Please DO NOT:

- Open a public GitHub issue for security vulnerabilities
- Disclose the vulnerability publicly before it has been addressed

### Please DO:

1. **Email the maintainers** at the email address listed in the repository
2. **Provide detailed information** including:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if you have one)

### What to Expect:

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Assessment**: We will assess the vulnerability and determine its severity within 5 business days
- **Updates**: We will keep you informed of our progress as we work on a fix
- **Resolution**: Once fixed, we will:
  - Release a patch
  - Publicly disclose the vulnerability (with credit to you, if desired)
  - Notify users to update

### Timeline:

- **48 hours**: Initial acknowledgment
- **5 business days**: Vulnerability assessment and severity determination
- **30 days**: Target for releasing a fix (may vary based on complexity)

## Security Best Practices

When using Claude Code Configuration:

### 1. Protect Sensitive Information

- Never commit API keys, tokens, or credentials to your repository
- Use environment variables for sensitive configuration
- Review `.gitignore` to ensure secrets are excluded
- Use the secrets management guide: [docs/SECRETS_MANAGEMENT.md](docs/SECRETS_MANAGEMENT.md)

### 2. MCP Server Security

- Only install MCP servers from trusted sources
- Review server code before installation
- Use isolated environments for testing new servers
- Keep MCP servers updated to latest versions

### 3. Organization Standards

- Review `ORGANIZATION.md` before distribution
- Ensure it doesn't contain proprietary or sensitive information
- Customize security standards for your organization
- Regularly audit and update organization policies

### 4. Installation Security

- Always verify the install script source before running
- Use HTTPS URLs when installing via curl
- Review the installation script if you have concerns
- Keep backups of your `~/.claude/` directory

### 5. Script Execution

- Review bash scripts before running with elevated permissions
- Be cautious of scripts that modify system-level configurations
- Use the `--dry-run` flag where available to preview changes
- Monitor hook execution for unexpected behavior

## Known Security Considerations

### 1. Bash Script Execution

The `install.sh` script:
- Modifies files in `~/.claude/` directory
- Creates symlinks to `$HOME/CLAUDE.md`
- Downloads and installs MCP servers

**Mitigation**: Review the script before running. All operations are restricted to user directories (no sudo required).

### 2. MCP Server Installation

MCP servers may:
- Access local files
- Make network requests
- Execute system commands

**Mitigation**: Review server configurations in `.claude/config/mcp-servers/` and only install servers you trust.

### 3. Hook Execution

Hooks can execute arbitrary bash commands:
- Pre-commit hooks
- Post-tool-call hooks
- Custom workflow hooks

**Mitigation**: Review hooks in `.claude/hooks/` and ensure they only perform expected operations.

### 4. Metrics Collection (Optional)

When metrics are enabled:
- Local metrics stored in `~/.claude/metrics/`
- Centralized metrics require database connection
- May collect usage patterns and command history

**Mitigation**: Metrics are disabled by default. Review `docs/METRICS_DECISION_GUIDE.md` before enabling.

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find similar problems
3. Prepare fixes for all supported versions
4. Release patches as soon as possible

We will publicly acknowledge security researchers who report vulnerabilities responsibly.

## Security Updates

Security updates will be:
- Released as patch versions (e.g., 2.3.1)
- Announced in release notes with `[SECURITY]` tag
- Documented in CHANGELOG.md
- Communicated via GitHub Security Advisories

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Claude Code Security Best Practices](https://docs.claude.com/en/docs/claude-code/security)
- [MCP Server Security Guidelines](https://github.com/modelcontextprotocol/servers)

## Questions?

If you have questions about security but don't have a vulnerability to report, please:
- Open a GitHub Discussion
- Tag your question with "security"
- We'll respond as soon as possible

---

Thank you for helping keep Claude Code Configuration secure!
