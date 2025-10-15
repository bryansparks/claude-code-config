#!/bin/bash
# Responsive Test Hook - Validates responsive design implementation

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only check style-related files
if [[ ! "$FILE_PATH" =~ \.(css|scss|sass|jsx|tsx|vue|svelte)$ ]]; then
    exit 0
fi

echo "📱 Checking responsive design implementation..."

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

ISSUES=0

# Check for media queries
check_media_queries() {
    local media_queries=$(grep -c '@media' "$FILE_PATH" | tr -d ' ')

    if [ "$media_queries" -gt 0 ]; then
        echo "✅ Found $media_queries media query/queries"

        # Check for common breakpoints
        if grep -q '@media.*320px\|@media.*375px' "$FILE_PATH"; then
            echo "✅ Mobile breakpoint detected (320px/375px)"
        fi

        if grep -q '@media.*768px' "$FILE_PATH"; then
            echo "✅ Tablet breakpoint detected (768px)"
        fi

        if grep -q '@media.*1024px\|@media.*1280px' "$FILE_PATH"; then
            echo "✅ Desktop breakpoint detected (1024px/1280px)"
        fi
    else
        echo "ℹ️  No media queries found"
        echo "   Consider responsive breakpoints:"
        echo "   - Mobile: 320px (min), 375px, 414px"
        echo "   - Tablet: 768px, 834px, 1024px"
        echo "   - Desktop: 1280px, 1440px, 1920px"
    fi
}

# Check for viewport units (vw, vh)
check_viewport_units() {
    local viewport_units=$(grep -oE '[0-9]+v[wh]' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ "$viewport_units" -gt 0 ]; then
        echo "✅ Using viewport units (${viewport_units} instances)"
        echo "ℹ️  Be cautious with vh on mobile (address bar issues)"
    fi
}

# Check for flexible layouts (flexbox, grid)
check_flexible_layouts() {
    local flexbox=$(grep -cE 'display:\s*(flex|inline-flex)' "$FILE_PATH" | tr -d ' ')
    local grid=$(grep -cE 'display:\s*(grid|inline-grid)' "$FILE_PATH" | tr -d ' ')

    if [ "$flexbox" -gt 0 ]; then
        echo "✅ Using Flexbox ($flexbox instances)"
    fi

    if [ "$grid" -gt 0 ]; then
        echo "✅ Using CSS Grid ($grid instances)"
    fi

    if [ "$flexbox" -eq 0 ] && [ "$grid" -eq 0 ]; then
        echo "⚠️  No flexible layouts detected (Flexbox/Grid)"
        echo "   Consider using modern layout techniques"
        ISSUES=$((ISSUES + 1))
    fi
}

# Check for fixed widths (potential responsiveness issues)
check_fixed_widths() {
    local fixed_widths=$(grep -oE 'width:\s*[0-9]+px' "$FILE_PATH" | wc -l | tr -d ' ')

    if [ "$fixed_widths" -gt 3 ]; then
        echo "⚠️  Found $fixed_widths fixed width declarations"
        echo "   Consider using: max-width, min-width, or percentage/rem units"
        ISSUES=$((ISSUES + 1))
    fi
}

# Check for touch-friendly targets
check_touch_targets() {
    # Look for interactive elements that might be too small
    if grep -qE 'button|\.btn|\.link' "$FILE_PATH"; then
        echo "ℹ️  Interactive elements detected"
        echo "   Ensure minimum touch target: 44x44px (iOS), 48x48px (Android)"

        # Check for explicit small sizes
        local small_buttons=$(grep -oE '(height|width):\s*[1-3][0-9]px' "$FILE_PATH" | wc -l | tr -d ' ')
        if [ "$small_buttons" -gt 0 ]; then
            echo "⚠️  Found potentially small interactive elements (<40px)"
            ISSUES=$((ISSUES + 1))
        fi
    fi
}

# Check for container queries (modern approach)
check_container_queries() {
    if grep -q '@container' "$FILE_PATH"; then
        echo "✅ Using container queries (modern responsive approach)"
    fi
}

# Check for responsive typography
check_responsive_typography() {
    # Check for clamp() or fluid typography
    if grep -q 'clamp(' "$FILE_PATH"; then
        echo "✅ Using clamp() for fluid typography"
    fi

    # Check for rem units
    local rem_units=$(grep -oE '[0-9.]+rem' "$FILE_PATH" | wc -l | tr -d ' ')
    if [ "$rem_units" -gt 0 ]; then
        echo "✅ Using rem units for scalable typography ($rem_units instances)"
    fi
}

# Check for mobile-first approach
check_mobile_first() {
    local min_width=$(grep -c '@media.*min-width' "$FILE_PATH" | tr -d ' ')
    local max_width=$(grep -c '@media.*max-width' "$FILE_PATH" | tr -d ' ')

    if [ "$min_width" -gt "$max_width" ]; then
        echo "✅ Mobile-first approach detected (min-width queries)"
    elif [ "$max_width" -gt "$min_width" ]; then
        echo "ℹ️  Desktop-first approach detected (max-width queries)"
        echo "   Consider mobile-first for better progressive enhancement"
    fi
}

# Check for print styles
check_print_styles() {
    if grep -q '@media print' "$FILE_PATH"; then
        echo "✅ Print styles included"
    else
        echo "ℹ️  No print styles detected - consider adding for better printing experience"
    fi
}

# Run all checks
check_media_queries
check_viewport_units
check_flexible_layouts
check_fixed_widths
check_touch_targets
check_container_queries
check_responsive_typography
check_mobile_first
check_print_styles

# Responsive design recommendations
echo ""
echo "📐 Responsive Design Best Practices:"
echo "   Mobile: 320px (iPhone SE), 375px (iPhone), 414px (iPhone Plus)"
echo "   Tablet: 768px (iPad portrait), 1024px (iPad landscape)"
echo "   Desktop: 1280px (laptop), 1440px, 1920px (1080p)"
echo ""
echo "   Touch Targets: 44x44px minimum (iOS), 48x48px (Android/Material)"
echo "   Font Scaling: Use rem/em, support text zoom to 200%"
echo "   Layout: Flexbox/Grid for flexible layouts"
echo "   Images: Use srcset for responsive images"
echo "   Testing: Chrome DevTools, real devices, BrowserStack"

# Check for common frameworks
if [ -f "tailwind.config.js" ] || [ -f "tailwind.config.ts" ]; then
    echo ""
    echo "🎨 Tailwind CSS detected - using responsive utilities"
    echo "   Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px), 2xl (1536px)"
fi

# Summary
if [ $ISSUES -eq 0 ]; then
    echo ""
    echo "✅ Responsive design implementation looks good"
else
    echo ""
    echo "⚠️  Found $ISSUES potential responsive design issue(s)"
    echo "🧪 Test on multiple devices and screen sizes"
fi

# Suggest testing tools
echo ""
echo "🧪 Responsive Testing Tools:"
echo "   - Chrome DevTools Device Mode"
echo "   - Firefox Responsive Design Mode"
echo "   - Real device testing (iOS, Android)"
echo "   - BrowserStack / LambdaTest (cross-browser)"
echo "   - Responsively App (https://responsively.app)"

exit 0
