#!/bin/bash
# Contrast Checker Hook - Validates color contrast ratios for WCAG compliance

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only check files that might contain color definitions
if [[ ! "$FILE_PATH" =~ \.(css|scss|sass|jsx|tsx|ts|js|vue|svelte)$ ]]; then
    exit 0
fi

echo "🎨 Checking color contrast ratios..."

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# Function to convert hex to RGB
hex_to_rgb() {
    local hex=$1
    # Remove # if present
    hex=${hex#\#}

    # Handle 3-digit hex
    if [ ${#hex} -eq 3 ]; then
        hex=$(echo $hex | sed 's/\(.\)/\1\1/g')
    fi

    # Convert to RGB
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))

    echo "$r $g $b"
}

# Function to calculate relative luminance
calc_luminance() {
    local r=$1
    local g=$2
    local b=$3

    # Simplified luminance calculation (proper formula requires more complex math)
    # This is an approximation
    local lum=$(echo "scale=3; (0.299 * $r + 0.587 * $g + 0.114 * $b) / 255" | bc)
    echo "$lum"
}

# Extract color values from file
extract_colors() {
    # Extract hex colors
    grep -oE '#[0-9A-Fa-f]{3,6}' "$FILE_PATH" | sort -u
}

# Check for common color combinations
check_common_combinations() {
    local colors=$(extract_colors)
    local color_count=$(echo "$colors" | grep -c '^' || echo 0)

    if [ "$color_count" -gt 0 ]; then
        echo "🎨 Found $color_count unique color(s) in file"

        # Show colors found
        echo "   Colors detected:"
        echo "$colors" | head -5 | sed 's/^/     /'
        if [ "$color_count" -gt 5 ]; then
            echo "     ... and $((color_count - 5)) more"
        fi
    fi
}

# Check for low contrast warnings
check_low_contrast_patterns() {
    local warnings=0

    # Common low-contrast combinations
    if grep -qiE '#fff.*#f[0-9a-f]{3}|#f[0-9a-f]{3}.*#fff' "$FILE_PATH"; then
        echo "⚠️  Potential low contrast: white with light colors"
        warnings=$((warnings + 1))
    fi

    if grep -qiE '#000.*#[0-3][0-9a-f]{3}|#[0-3][0-9a-f]{3}.*#000' "$FILE_PATH"; then
        echo "⚠️  Potential low contrast: black with dark colors"
        warnings=$((warnings + 1))
    fi

    # Gray on gray
    if grep -qiE '#[8-9a-f]{6}.*#[8-9a-f]{6}' "$FILE_PATH"; then
        echo "⚠️  Potential low contrast: gray on gray"
        warnings=$((warnings + 1))
    fi

    return $warnings
}

# Check for accessible color combinations
check_accessible_colors() {
    # Common accessible combinations
    local good_patterns=0

    # High contrast combinations
    if grep -qiE '#fff.*#000|#000.*#fff|white.*black|black.*white' "$FILE_PATH"; then
        echo "✅ High contrast combination found (black/white)"
        good_patterns=$((good_patterns + 1))
    fi

    # Check for color + sufficient text size notes
    if grep -qE 'font-size.*2[4-9]px|font-size.*[3-9][0-9]px' "$FILE_PATH"; then
        echo "✅ Large text detected (24px+) - can use 3:1 contrast ratio"
    fi
}

# Provide WCAG guidelines
show_wcag_guidelines() {
    echo ""
    echo "📋 WCAG 2.1 Contrast Requirements:"
    echo ""
    echo "   Normal Text (< 24px or < 19px bold):"
    echo "     • Level AA:  4.5:1 minimum"
    echo "     • Level AAA: 7:1 minimum"
    echo ""
    echo "   Large Text (≥ 24px or ≥ 19px bold):"
    echo "     • Level AA:  3:1 minimum"
    echo "     • Level AAA: 4.5:1 minimum"
    echo ""
    echo "   UI Components & Graphics:"
    echo "     • Level AA:  3:1 minimum"
    echo ""
}

# Suggest contrast checking tools
suggest_tools() {
    echo "🛠️  Contrast Checking Tools:"
    echo "   Online:"
    echo "     • WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/"
    echo "     • Coolors Contrast Checker: https://coolors.co/contrast-checker"
    echo "     • Accessible Colors: https://accessible-colors.com/"
    echo ""
    echo "   Browser Extensions:"
    echo "     • axe DevTools (Chrome/Firefox)"
    echo "     • WAVE Evaluation Tool"
    echo "     • Lighthouse (Chrome DevTools)"
    echo ""
    echo "   Design Tools:"
    echo "     • Figma: Stark plugin, A11y - Color Contrast Checker"
    echo "     • Sketch: Stark plugin"
    echo "     • Adobe XD: Built-in contrast checker"
}

# Check for color-only information
check_color_only_information() {
    # Look for error/success classes that might rely on color alone
    if grep -qE 'class.*error.*color|\.error.*{.*color' "$FILE_PATH"; then
        echo "ℹ️  Error styling detected - ensure not relying on color alone"
        echo "   Add icons, text, or patterns for color-blind users"
    fi

    if grep -qE 'class.*success.*color|\.success.*{.*color' "$FILE_PATH"; then
        echo "ℹ️  Success styling detected - ensure not relying on color alone"
        echo "   Add icons, text, or patterns for color-blind users"
    fi
}

# Run checks
check_common_combinations
check_low_contrast_patterns
warnings=$?
check_accessible_colors
check_color_only_information

# Show guidelines and tools
show_wcag_guidelines
suggest_tools

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $warnings -eq 0 ]; then
    echo "✅ No obvious contrast issues detected"
else
    echo "⚠️  Found $warnings potential contrast issue(s)"
fi

echo ""
echo "💡 Best Practices:"
echo "   • Use online tools to verify exact contrast ratios"
echo "   • Test with color blindness simulators"
echo "   • Don't rely on color alone to convey information"
echo "   • Use semantic color names (primary, danger) not colors (red, blue)"
echo "   • Include sufficient color contrast in design system tokens"

# Check if running in CI/CD
if [ -n "$CI" ]; then
    echo ""
    echo "🤖 CI/CD detected - consider automated contrast checking:"
    echo "   npm install --save-dev @axe-core/cli"
    echo "   npx axe --tags wcag2aa https://your-site.com"
fi

exit 0
