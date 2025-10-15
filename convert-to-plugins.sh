#!/usr/bin/env bash
# Convert existing persona structure to Claude Code plugins

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Converting Claude-Config to Plugin Format${NC}"
echo "=============================================="

# Persona to plugin name mapping (simple arrays for compatibility)
PERSONAS=("engineer" "qa" "pm" "em" "ux")
PLUGINS=("engineer-toolkit" "qa-toolkit" "pm-toolkit" "em-toolkit" "ux-toolkit")

# Convert subagent to agent with YAML frontmatter
convert_subagent_to_agent() {
    local source_file="$1"
    local dest_file="$2"
    local agent_name=$(basename "$source_file" .md)

    # Extract key information
    local visual_identity=$(grep "Visual Identity:" "$source_file" | sed 's/\*\*Visual Identity: //' | sed 's/\*\*//')
    local color=$(echo "$visual_identity" | awk '{print tolower($2)}')

    # Determine description from first meaningful line
    local description=$(sed -n '/^You are/p' "$source_file" | head -1 | sed 's/^You are //' | sed 's/\.$//')

    # Create YAML frontmatter
    cat > "$dest_file" << EOF
---
name: $agent_name
description: $description
tools: Read, Write, Edit, Grep, Glob, WebFetch, TodoWrite, Bash
model: sonnet
color: $color
---

EOF

    # Append content without the header and visual identity line
    sed '1,3d' "$source_file" >> "$dest_file"

    echo -e "${GREEN}✓${NC} Converted $agent_name"
}

# Convert command to add frontmatter
convert_command() {
    local source_file="$1"
    local dest_file="$2"
    local command_name=$(basename "$source_file" .md)

    # Extract purpose/description from file
    local description=$(sed -n '/\*\*Purpose\*\*/p' "$source_file" | head -1 | sed 's/\*\*Purpose\*\*: //')

    if [ -z "$description" ]; then
        description=$(sed -n '2p' "$source_file")
    fi

    # Create frontmatter
    cat > "$dest_file" << EOF
---
description: $description
---

EOF

    # Append original content
    cat "$source_file" >> "$dest_file"

    echo -e "${GREEN}✓${NC} Converted command: $command_name"
}

# Convert each persona
for i in "${!PERSONAS[@]}"; do
    persona="${PERSONAS[$i]}"
    plugin_name="${PLUGINS[$i]}"
    echo -e "\n${BLUE}Converting $persona → $plugin_name${NC}"

    # Convert subagents to agents
    if [ -d "personas/$persona/subagents" ]; then
        echo "Converting subagents..."
        for subagent in personas/$persona/subagents/*.md; do
            if [ -f "$subagent" ]; then
                agent_file="plugins/$plugin_name/agents/$(basename $subagent)"
                convert_subagent_to_agent "$subagent" "$agent_file"
            fi
        done
    fi

    # Convert commands
    if [ -d "personas/$persona/commands" ]; then
        echo "Converting commands..."
        for command in personas/$persona/commands/*.md; do
            if [ -f "$command" ]; then
                command_file="plugins/$plugin_name/commands/$(basename $command)"
                convert_command "$command" "$command_file"
            fi
        done
    fi

    # Copy hooks (we'll handle hooks.json separately)
    if [ -d "personas/$persona/hooks" ]; then
        echo "Copying hooks..."
        cp -r personas/$persona/hooks/* "plugins/$plugin_name/hooks/" 2>/dev/null || true
    fi

    echo -e "${GREEN}✓ Completed $plugin_name${NC}"
done

echo -e "\n${GREEN}Conversion complete!${NC}"
echo -e "\nNext steps:"
echo "1. Review generated agents in plugins/*/agents/"
echo "2. Review generated commands in plugins/*/commands/"
echo "3. Convert bash hooks to hooks.json format"
echo "4. Create marketplace.json"
echo "5. Test plugins with /plugin install"
