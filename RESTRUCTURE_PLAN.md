# Claude Config Restructure Plan

## Current Structure (Messy)
```
Claude-Config/                      # Project root - cluttered
├── templates/                      # Persona templates
├── install-scripts/                # Installation scripts
├── docs/                          # Documentation
├── *.md files (15+ at root)       # Documentation scattered
└── .claude/                       # Local test folder
```

## New Structure (Clean - GitHub Ready)

```
claude-config/                      # GitHub repo root
├── install.sh                     # Main installer (curl-able)
├── README.md                      # Installation instructions
├── LICENSE
├── .gitignore
│
├── .claude/                       # Target install location structure
│   ├── README.md                  # Explains .claude/ structure
│   ├── config/
│   │   ├── personas/             # Persona configs
│   │   │   ├── engineer.json
│   │   │   ├── qa.json
│   │   │   ├── pm.json
│   │   │   ├── em.json
│   │   │   └── ux.json
│   │   └── mcp-servers/          # MCP server configs by persona
│   │       ├── engineer/
│   │       │   └── mcp-config.json
│   │       ├── qa/
│   │       │   └── mcp-config.json
│   │       ├── pm/
│   │       │   └── mcp-config.json
│   │       ├── em/
│   │       │   └── mcp-config.json
│   │       └── ux/
│   │           └── mcp-config.json
│   │
│   ├── templates/                # Organization & project templates
│   │   ├── ORGANIZATION.md
│   │   ├── PROJECT.md
│   │   ├── VISION.md
│   │   └── CLAUDE.md
│   │
│   ├── commands/                 # Shared slash commands
│   │   ├── init-project.md
│   │   └── shared/
│   │       └── *.md
│   │
│   ├── hooks/                    # Event hooks
│   │   ├── post-init-project.sh
│   │   └── user-prompt-submit.sh
│   │
│   ├── agents/                   # Custom agent definitions (future)
│   │   └── README.md
│   │
│   ├── shared/                   # Shared resources (YAML configs, etc.)
│   │   ├── superclaude-core.yml
│   │   ├── superclaude-rules.yml
│   │   ├── superclaude-personas.yml
│   │   └── superclaude-mcp.yml
│   │
│   └── scripts/                  # Helper scripts
│       ├── install-mcp-servers.sh
│       ├── install-persona.sh
│       └── utils.sh
│
├── docs/                         # Documentation
│   ├── INSTALLATION.md
│   ├── PERSONAS.md
│   ├── MCP_SERVERS.md
│   ├── VISION_SYSTEM.md
│   └── QUICK_START.md
│
└── personas/                     # Persona-specific files (for sparse checkout)
    ├── engineer/
    │   ├── commands/
    │   ├── hooks/
    │   └── subagents/
    ├── qa/
    │   ├── commands/
    │   ├── hooks/
    │   └── subagents/
    ├── pm/
    │   ├── commands/
    │   ├── hooks/
    │   └── subagents/
    ├── em/
    │   ├── commands/
    │   ├── hooks/
    │   └── subagents/
    └── ux/
        ├── commands/
        ├── hooks/
        └── subagents/
```

## Installation Flow

### 1. User runs installer
```bash
curl -fsSL https://raw.githubusercontent.com/you/claude-config/main/install.sh | bash -s -- engineer
```

### 2. Installer does:
```bash
# 1. Clone with sparse checkout
git clone --filter=blob:none --sparse https://github.com/you/claude-config /tmp/claude-config-install
cd /tmp/claude-config-install

# 2. Set sparse-checkout paths based on persona
git sparse-checkout set \
  .claude/templates \
  .claude/commands \
  .claude/hooks \
  .claude/shared \
  .claude/scripts \
  .claude/config/personas/engineer.json \
  .claude/config/mcp-servers/engineer \
  personas/engineer

# 3. Copy to ~/.claude/
cp -r .claude/* ~/.claude/
cp -r personas/engineer/* ~/.claude/

# 4. Install organization standards
cp .claude/templates/ORGANIZATION.md ~/.claude/ORGANIZATION.md

# 5. Create CLAUDE.md with @include directives
cat > ~/.claude/CLAUDE.md << 'EOF'
# CLAUDE.md - Claude Code Configuration
@include ORGANIZATION.md
@include shared/superclaude-core.yml#Core_Philosophy
EOF

# 6. Install MCP servers for persona
~/.claude/scripts/install-mcp-servers.sh engineer

# 7. Set persona
echo "engineer" > ~/.claude/config/persona.conf

# 8. Cleanup
rm -rf /tmp/claude-config-install
```

## Migration Steps

### Phase 1: Restructure Repository
1. Create new `.claude/` directory structure
2. Move files to new locations
3. Update all path references

### Phase 2: Create Installation Scripts
1. Create `install.sh` (main installer)
2. Create `.claude/scripts/install-mcp-servers.sh`
3. Create `.claude/scripts/install-persona.sh`

### Phase 3: Update Documentation
1. Move docs to `docs/` folder
2. Create comprehensive README.md
3. Update all installation guides

### Phase 4: Create .gitignore
1. Ignore local-only files (persona.conf, projects/)
2. Include template files

## Benefits

1. **Clean User Installation**: Everything in `~/.claude/`, no project root clutter
2. **Selective Downloads**: Only download persona-specific files
3. **Easy Updates**: `git pull` in `~/.claude/` to update
4. **GitHub Ready**: One-command installation
5. **Maintainable**: Clear separation of concerns
6. **Scalable**: Easy to add new personas

## File Mapping (Old → New)

```
templates/engineers/mcp-servers/mcp-config.json
  → .claude/config/mcp-servers/engineer/mcp-config.json

templates/shared/commands/init-project.md
  → .claude/commands/init-project.md

templates/shared/hooks/post-init-project.sh
  → .claude/hooks/post-init-project.sh

templates/ORGANIZATION-template.md
  → .claude/templates/ORGANIZATION.md

install-scripts/claude-config.sh
  → .claude/scripts/install-persona.sh

install-scripts/install-mcp-servers.sh
  → .claude/scripts/install-mcp-servers.sh

MCP_SERVERS_BY_PERSONA.md
  → docs/MCP_SERVERS.md

VISION_DOC_SYSTEM.md
  → docs/VISION_SYSTEM.md
```

## Next Actions

1. Create new directory structure in `.claude/`
2. Move files to new locations
3. Update all path references in scripts
4. Create `install.sh`
5. Create `.gitignore`
6. Test installation flow
7. Update documentation
