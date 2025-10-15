#!/usr/bin/env bash
# Fix plugin issues: YAML frontmatter, add vision commands, remove DORA

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Fixing Plugin Issues${NC}"
echo "====================="

# Fix empty YAML descriptions in QA agents
fix_qa_agents() {
    echo -e "\n${YELLOW}Fixing QA agent YAML frontmatter...${NC}"

    # test-automation-specialist
    if [ -f "plugins/qa-toolkit/agents/test-automation-specialist.md" ]; then
        sed -i.bak '3s/description: $/description: Expert in designing and implementing robust, maintainable test automation frameworks/' \
            plugins/qa-toolkit/agents/test-automation-specialist.md
        sed -i.bak '6s/color: $/color: blue/' plugins/qa-toolkit/agents/test-automation-specialist.md
        echo -e "${GREEN}✓${NC} Fixed test-automation-specialist"
    fi

    # bug-analyst
    if [ -f "plugins/qa-toolkit/agents/bug-analyst.md" ]; then
        sed -i.bak '3s/description: $/description: Expert in bug analysis, classification, root cause identification, and reproduction/' \
            plugins/qa-toolkit/agents/bug-analyst.md
        sed -i.bak '6s/color: $/color: red/' plugins/qa-toolkit/agents/bug-analyst.md
        echo -e "${GREEN}✓${NC} Fixed bug-analyst"
    fi

    # performance-tester
    if [ -f "plugins/qa-toolkit/agents/performance-tester.md" ]; then
        sed -i.bak '3s/description: $/description: Expert in performance testing, load testing, and optimization analysis/' \
            plugins/qa-toolkit/agents/performance-tester.md
        sed -i.bak '6s/color: $/color: orange/' plugins/qa-toolkit/agents/performance-tester.md
        echo -e "${GREEN}✓${NC} Fixed performance-tester"
    fi

    # accessibility-auditor
    if [ -f "plugins/qa-toolkit/agents/accessibility-auditor.md" ]; then
        sed -i.bak '3s/description: $/description: Expert in accessibility testing and WCAG compliance auditing/' \
            plugins/qa-toolkit/agents/accessibility-auditor.md
        sed -i.bak '6s/color: $/color: green/' plugins/qa-toolkit/agents/accessibility-auditor.md
        echo -e "${GREEN}✓${NC} Fixed accessibility-auditor"
    fi

    # visual-regression-tester
    if [ -f "plugins/qa-toolkit/agents/visual-regression-tester.md" ]; then
        sed -i.bak '3s/description: $/description: Expert in visual regression testing and screenshot comparison/' \
            plugins/qa-toolkit/agents/visual-regression-tester.md
        sed -i.bak '6s/color: $/color: purple/' plugins/qa-toolkit/agents/visual-regression-tester.md
        echo -e "${GREEN}✓${NC} Fixed visual-regression-tester"
    fi

    # Clean up backup files
    rm -f plugins/qa-toolkit/agents/*.bak
}

# Remove DORA mentions
remove_dora() {
    echo -e "\n${YELLOW}Removing DORA methodology references...${NC}"

    # Update team-metrics command description
    if [ -f "plugins/em-toolkit/commands/team-metrics.md" ]; then
        # Remove DORA from description
        sed -i.bak 's/DORA metrics/team performance metrics/g' plugins/em-toolkit/commands/team-metrics.md
        sed -i.bak 's/DORA/team performance/g' plugins/em-toolkit/commands/team-metrics.md
        echo -e "${GREEN}✓${NC} Removed DORA from team-metrics command"
        rm -f plugins/em-toolkit/commands/team-metrics.md.bak
    fi

    # Update plugin description
    if [ -f "plugins/em-toolkit/.claude-plugin/plugin.json" ]; then
        sed -i.bak 's/DORA metrics/team performance metrics/g' plugins/em-toolkit/.claude-plugin/plugin.json
        echo -e "${GREEN}✓${NC} Updated em-toolkit plugin.json"
        rm -f plugins/em-toolkit/.claude-plugin/plugin.json.bak
    fi

    # Update README
    if [ -f "plugins/README.md" ]; then
        sed -i.bak 's/DORA metrics/team performance metrics/g' plugins/README.md
        echo -e "${GREEN}✓${NC} Updated plugins README"
        rm -f plugins/README.md.bak
    fi
}

# Add vision document command to all plugins
add_vision_command() {
    echo -e "\n${YELLOW}Adding create-vision-doc command to all plugins...${NC}"

    for plugin_dir in plugins/*/; do
        plugin_name=$(basename "$plugin_dir")
        vision_file="$plugin_dir/commands/create-vision-doc.md"

        if [ ! -f "$vision_file" ]; then
            # Copy from template
            if [ -f "templates/shared/commands/create-vision-doc.md" ]; then
                cp "templates/shared/commands/create-vision-doc.md" "$vision_file"

                # Remove @include directives (not supported in plugins)
                sed -i.bak '/@include/d' "$vision_file"
                rm -f "$vision_file.bak"

                echo -e "${GREEN}✓${NC} Added create-vision-doc to $plugin_name"
            fi
        else
            echo -e "${BLUE}→${NC} create-vision-doc already exists in $plugin_name"
        fi
    done
}

# Fix "a" prefix in descriptions
fix_description_grammar() {
    echo -e "\n${YELLOW}Fixing description grammar...${NC}"

    find plugins -name "*.md" -type f -path "*/agents/*" | while read -r file; do
        if grep -q "^description: a " "$file"; then
            sed -i.bak 's/^description: a /description: /' "$file"
            echo -e "${GREEN}✓${NC} Fixed $(basename $file)"
            rm -f "${file}.bak"
        fi
    done
}

# Create hooks.json for remaining plugins
create_missing_hooks() {
    echo -e "\n${YELLOW}Creating hooks.json for plugins without one...${NC}"

    # QA toolkit hooks
    if [ ! -f "plugins/qa-toolkit/hooks/hooks.json" ]; then
        cat > "plugins/qa-toolkit/hooks/hooks.json" << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/auto-test-on-change.sh \"$TOOL_ARGS\"",
            "timeout": 60
          },
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/accessibility-validator.sh \"$TOOL_ARGS\"",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash.*test",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/test-coverage-reporter.sh",
            "timeout": 20
          }
        ]
      }
    ]
  }
}
EOF
        echo -e "${GREEN}✓${NC} Created hooks.json for qa-toolkit"
    fi

    # PM toolkit hooks
    if [ ! -f "plugins/pm-toolkit/hooks/hooks.json" ]; then
        cat > "plugins/pm-toolkit/hooks/hooks.json" << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/user-story-validator.sh \"$TOOL_ARGS\"",
            "timeout": 20
          },
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/acceptance-criteria-checker.sh \"$TOOL_ARGS\"",
            "timeout": 20
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/feature-completeness-check.sh",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
EOF
        echo -e "${GREEN}✓${NC} Created hooks.json for pm-toolkit"
    fi

    # EM toolkit hooks
    if [ ! -f "plugins/em-toolkit/hooks/hooks.json" ]; then
        cat > "plugins/em-toolkit/hooks/hooks.json" << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash.*git.*commit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/pr-review-summary.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/sprint-health-check.sh",
            "timeout": 20
          }
        ]
      }
    ]
  }
}
EOF
        echo -e "${GREEN}✓${NC} Created hooks.json for em-toolkit"
    fi

    # UX toolkit hooks
    if [ ! -f "plugins/ux-toolkit/hooks/hooks.json" ]; then
        cat > "plugins/ux-toolkit/hooks/hooks.json" << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/accessibility-checker.sh \"$TOOL_ARGS\"",
            "timeout": 30
          },
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/design-token-validator.sh \"$TOOL_ARGS\"",
            "timeout": 20
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write.*\\.css|Write.*\\.scss",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PLUGIN_ROOT\"/hooks/contrast-checker.sh \"$TOOL_ARGS\"",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
EOF
        echo -e "${GREEN}✓${NC} Created hooks.json for ux-toolkit"
    fi
}

# Run all fixes
fix_qa_agents
fix_description_grammar
remove_dora
add_vision_command
create_missing_hooks

echo -e "\n${GREEN}All fixes complete!${NC}"
echo ""
echo "Summary:"
echo "- Fixed QA agent YAML frontmatter (descriptions & colors)"
echo "- Fixed 'a' prefix in agent descriptions"
echo "- Removed DORA methodology references"
echo "- Added create-vision-doc command to all plugins"
echo "- Created hooks.json for plugins missing them"
echo ""
echo "Next: Test with /plugin validate ./plugins/<toolkit>"
