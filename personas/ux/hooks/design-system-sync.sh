#!/bin/bash
# Design System Sync Hook - Ensures components stay in sync with design system

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only check component files
if [[ ! "$FILE_PATH" =~ \.(jsx|tsx)$ ]] || [[ "$FILE_PATH" =~ \.(test|spec)\. ]]; then
    exit 0
fi

echo "📐 Checking design system synchronization..."

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

SYNC_ISSUES=0

# Check for design system imports
check_design_system_imports() {
    # Look for design token imports
    if grep -qE 'from.*["\'].*tokens.*["\']|from.*["\'].*design-system.*["\']' "$FILE_PATH"; then
        echo "✅ Design system/tokens imported"
    else
        echo "ℹ️  No design system imports detected"
        echo "   Consider importing: tokens, theme, or design-system"
    fi
}

# Check for styled-components/emotion usage
check_css_in_js() {
    if grep -qE 'styled\.|styled\(|css`' "$FILE_PATH"; then
        echo "✅ CSS-in-JS detected (styled-components/emotion)"

        # Check if using theme
        if grep -q 'theme\.' "$FILE_PATH"; then
            echo "✅ Using theme values"
        else
            echo "⚠️  Not using theme - hardcoded values may cause inconsistency"
            SYNC_ISSUES=$((SYNC_ISSUES + 1))
        fi
    fi
}

# Check for Tailwind classes
check_tailwind_usage() {
    if grep -qE 'className.*=.*["\'].*text-|bg-|p-|m-' "$FILE_PATH"; then
        echo "✅ Tailwind CSS classes detected"

        # Check for arbitrary values (potential inconsistency)
        if grep -qE '\[.*px\]|\[.*#[0-9a-f]+\]' "$FILE_PATH"; then
            echo "⚠️  Arbitrary Tailwind values found - prefer design system utilities"
            SYNC_ISSUES=$((SYNC_ISSUES + 1))
        fi
    fi
}

# Check for component library usage
check_component_library() {
    # Common component library imports
    if grep -qE 'from.*["\']@/components|from.*["\'].*/components' "$FILE_PATH"; then
        echo "✅ Using component library imports"
    fi

    # Check for MUI, Chakra, Ant Design, etc.
    if grep -qE '@mui/|@chakra-ui/|antd/|@mantine/' "$FILE_PATH"; then
        echo "✅ Using established component library"
    fi

    # Check for custom components that might duplicate library components
    if grep -qE 'const Button|function Button|class Button' "$FILE_PATH"; then
        echo "ℹ️  Custom Button component - ensure it's not duplicating design system"
    fi
}

# Check for version compatibility
check_version_compatibility() {
    if [ -f "package.json" ]; then
        # Check if design system package is installed
        if grep -q '"@.*design-system' package.json || grep -q '"design-system' package.json; then
            echo "✅ Design system package detected in package.json"

            # Check for version
            local version=$(grep -o '"@.*design-system.*": ".*"' package.json | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
            if [ -n "$version" ]; then
                echo "   Version: $version"
            fi
        fi
    fi
}

# Check for deprecated patterns
check_deprecated_patterns() {
    # Common deprecated patterns
    if grep -qE 'makeStyles|withStyles' "$FILE_PATH"; then
        echo "⚠️  Deprecated MUI v4 patterns detected (makeStyles/withStyles)"
        echo "   Migrate to: MUI v5 styled() or sx prop"
        SYNC_ISSUES=$((SYNC_ISSUES + 1))
    fi

    # Old class-based components
    if grep -q 'extends React.Component' "$FILE_PATH"; then
        echo "ℹ️  Class component detected - consider functional components with hooks"
    fi
}

# Check for prop spreading (can bypass design system constraints)
check_prop_spreading() {
    if grep -qE '\{\.\.\.props\}|\{\.\.\.rest\}' "$FILE_PATH"; then
        echo "ℹ️  Prop spreading detected - ensure design system constraints aren't bypassed"
    fi
}

# Check for inline styles (anti-pattern)
check_inline_styles() {
    local inline_styles=$(grep -cE 'style=\{\{' "$FILE_PATH" | tr -d ' ')

    if [ "$inline_styles" -gt 0 ]; then
        echo "⚠️  Found $inline_styles inline style declaration(s)"
        echo "   Prefer design system utilities/classes over inline styles"
        SYNC_ISSUES=$((SYNC_ISSUES + 1))
    fi
}

# Check for CSS modules
check_css_modules() {
    local css_module="${FILE_PATH%.*}.module.css"
    local scss_module="${FILE_PATH%.*}.module.scss"

    if [ -f "$css_module" ] || [ -f "$scss_module" ]; then
        echo "✅ CSS Module detected"

        # Check if it imports design tokens
        if [ -f "$css_module" ]; then
            if grep -q '@import.*tokens' "$css_module"; then
                echo "✅ CSS Module imports design tokens"
            else
                echo "ℹ️  CSS Module doesn't import tokens - consider using design system values"
            fi
        fi
    fi
}

# Check for consistent naming
check_naming_conventions() {
    # Extract component name
    local component_name=$(basename "$FILE_PATH" .tsx | sed 's/\.jsx$//')

    # Check if component name matches PascalCase
    if [[ "$component_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
        echo "✅ Component name follows PascalCase convention"
    else
        echo "⚠️  Component name should be PascalCase: $component_name"
    fi
}

# Suggest sync actions
suggest_sync_actions() {
    if [ $SYNC_ISSUES -gt 0 ]; then
        echo ""
        echo "🔄 Design System Sync Actions:"
        echo "   1. Replace hardcoded values with design tokens"
        echo "   2. Use design system components instead of custom ones"
        echo "   3. Remove inline styles in favor of utilities"
        echo "   4. Update deprecated patterns to current standards"
        echo "   5. Import and use theme/token values"
        echo ""
        echo "📚 Design System Documentation:"
        if [ -f "docs/design-system.md" ]; then
            echo "   Local: docs/design-system.md"
        fi
        if [ -f "README.md" ] && grep -q "design system" README.md; then
            echo "   Project README has design system info"
        fi
    fi
}

# Run all checks
check_design_system_imports
check_css_in_js
check_tailwind_usage
check_component_library
check_version_compatibility
check_deprecated_patterns
check_prop_spreading
check_inline_styles
check_css_modules
check_naming_conventions

# Suggest actions if issues found
suggest_sync_actions

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $SYNC_ISSUES -eq 0 ]; then
    echo "✅ Design system sync looks good"
else
    echo "⚠️  Found $SYNC_ISSUES sync issue(s) with design system"
    echo "🎯 Goal: 100% design system compliance"
fi

# Check for Storybook
if [ -f ".storybook/main.js" ] || [ -f ".storybook/main.ts" ]; then
    echo ""
    echo "📖 Storybook detected - ensure component is documented"
    echo "   Story file: ${FILE_PATH%.*}.stories.tsx"
fi

# Check for design system documentation
if [ -d "docs" ]; then
    echo ""
    echo "📚 Documentation directory found: ./docs/"
fi

exit 0
