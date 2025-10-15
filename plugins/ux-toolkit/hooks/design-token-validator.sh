#!/bin/bash
# Design Token Validator Hook - Ensures design token usage instead of hardcoded values

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only check style-related files
if [[ ! "$FILE_PATH" =~ \.(jsx|tsx|ts|js|css|scss|sass|vue|svelte|styled)$ ]]; then
    exit 0
fi

echo "📐 Validating design token usage..."

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

VIOLATIONS=0

# Check for hardcoded colors (hex, rgb, rgba, hsl)
check_hardcoded_colors() {
    local hex_colors=$(grep -oE '#[0-9A-Fa-f]{3,8}' "$FILE_PATH" | wc -l | tr -d ' ')
    local rgb_colors=$(grep -oE 'rgba?\([^)]+\)' "$FILE_PATH" | wc -l | tr -d ' ')
    local hsl_colors=$(grep -oE 'hsla?\([^)]+\)' "$FILE_PATH" | wc -l | tr -d ' ')

    local total_colors=$((hex_colors + rgb_colors + hsl_colors))

    if [ $total_colors -gt 0 ]; then
        echo "⚠️  Found $total_colors hardcoded color value(s)"
        echo "   Should use: tokens.colors.* or CSS custom properties"
        VIOLATIONS=$((VIOLATIONS + total_colors))

        # Show first few examples
        echo "   Examples:"
        grep -oE '#[0-9A-Fa-f]{3,8}' "$FILE_PATH" | head -3 | sed 's/^/     /'
    fi
}

# Check for hardcoded spacing/sizing (px values)
check_hardcoded_spacing() {
    # Common hardcoded px values (excluding 0px, 1px for borders)
    local px_values=$(grep -oE '[^0-1][0-9]+px' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ $px_values -gt 5 ]; then  # Allow some px for borders/fine-tuning
        echo "⚠️  Found $px_values hardcoded px value(s)"
        echo "   Should use: tokens.spacing.* or rem/em units"
        VIOLATIONS=$((VIOLATIONS + 1))
    fi
}

# Check for hardcoded font sizes
check_hardcoded_fonts() {
    local font_sizes=$(grep -oE 'font-size:\s*[0-9]+px' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ $font_sizes -gt 0 ]; then
        echo "⚠️  Found $font_sizes hardcoded font-size value(s)"
        echo "   Should use: tokens.typography.fontSize.*"
        VIOLATIONS=$((VIOLATIONS + font_sizes))
    fi
}

# Check for hardcoded shadows
check_hardcoded_shadows() {
    local shadows=$(grep -oE 'box-shadow:\s*[^;]+;' "$FILE_PATH" | grep -v 'var(' | wc -l | tr -d ' ')

    if [ $shadows -gt 0 ]; then
        echo "⚠️  Found $shadows hardcoded box-shadow value(s)"
        echo "   Should use: tokens.shadows.* or --shadow-*"
        VIOLATIONS=$((VIOLATIONS + shadows))
    fi
}

# Check for hardcoded border-radius
check_hardcoded_radius() {
    local radius=$(grep -oE 'border-radius:\s*[0-9]+px' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ $radius -gt 0 ]; then
        echo "⚠️  Found $radius hardcoded border-radius value(s)"
        echo "   Should use: tokens.borderRadius.*"
        VIOLATIONS=$((VIOLATIONS + radius))
    fi
}

# Check for hardcoded z-index
check_hardcoded_zindex() {
    local zindex=$(grep -oE 'z-index:\s*[0-9]{2,}' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ $zindex -gt 0 ]; then
        echo "⚠️  Found $zindex hardcoded z-index value(s)"
        echo "   Should use: tokens.zIndex.* (modal, dropdown, tooltip, etc.)"
        VIOLATIONS=$((VIOLATIONS + zindex))
    fi
}

# Check for magic numbers in animations
check_hardcoded_timing() {
    local durations=$(grep -oE '(transition|animation).*[0-9]+ms' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ $durations -gt 2 ]; then  # Allow a couple for custom needs
        echo "ℹ️  Found $durations animation timing value(s)"
        echo "   Consider using: tokens.duration.* (fast: 150ms, normal: 250ms, slow: 400ms)"
    fi
}

# Suggest token usage
suggest_token_usage() {
    if [ $VIOLATIONS -gt 0 ]; then
        echo ""
        echo "💡 Design Token Best Practices:"
        echo "   Colors: Use tokens.colors.brand.primary[500] instead of #3B82F6"
        echo "   Spacing: Use tokens.spacing[4] (16px) instead of hardcoded 16px"
        echo "   Typography: Use tokens.typography.fontSize.lg instead of 18px"
        echo "   Shadows: Use tokens.shadows.md instead of '0 4px 6px rgba(0,0,0,0.1)'"
        echo "   Radius: Use tokens.borderRadius.md instead of 8px"
        echo ""
        echo "📚 Design System Docs: ./docs/design-tokens.md"
    fi
}

# Run all checks
check_hardcoded_colors
check_hardcoded_spacing
check_hardcoded_fonts
check_hardcoded_shadows
check_hardcoded_radius
check_hardcoded_zindex
check_hardcoded_timing

# Provide suggestions if violations found
suggest_token_usage

# Summary
if [ $VIOLATIONS -eq 0 ]; then
    echo "✅ Design token compliance looks good"
else
    echo "📊 Token Compliance Score: $(echo "scale=0; (100 - $VIOLATIONS * 5)" | bc)%"
    echo "🎯 Target: 95%+ token usage"
fi

# Check if design tokens file exists
if [ -f "src/design-tokens.ts" ] || [ -f "src/tokens/index.ts" ] || [ -f "src/styles/tokens.ts" ]; then
    echo "✅ Design tokens file detected"
elif [ -f "tailwind.config.js" ] || [ -f "tailwind.config.ts" ]; then
    echo "✅ Tailwind config detected (using Tailwind design tokens)"
else
    echo "ℹ️  No design tokens file found - consider creating src/design-tokens.ts"
fi

# Always exit 0 (warnings only, don't block)
exit 0
