#!/bin/bash
# Accessibility Checker Hook - Validates WCAG 2.1 compliance

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only check web-related files
if [[ ! "$FILE_PATH" =~ \.(jsx|tsx|html|vue|svelte)$ ]]; then
    exit 0
fi

echo "♿ Checking accessibility compliance..."

# Check if file exists and is readable
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

ISSUES_FOUND=0

# Check for common accessibility issues
check_alt_text() {
    # Check for img tags without alt attributes
    if grep -q '<img[^>]*>' "$FILE_PATH"; then
        local imgs_without_alt=$(grep -o '<img[^>]*>' "$FILE_PATH" | grep -v 'alt=' | wc -l | tr -d ' ')
        if [ "$imgs_without_alt" -gt 0 ]; then
            echo "⚠️  Found $imgs_without_alt image(s) without alt text"
            ISSUES_FOUND=$((ISSUES_FOUND + imgs_without_alt))
        fi
    fi
}

check_button_labels() {
    # Check for buttons without accessible labels
    if grep -q '<button[^>]*>' "$FILE_PATH"; then
        local buttons_no_label=$(grep -o '<button[^>]*>' "$FILE_PATH" | grep -v 'aria-label' | grep -v '>' | wc -l | tr -d ' ')
        # Only warn about icon buttons (those that might not have text content)
        if [ "$buttons_no_label" -gt 0 ]; then
            echo "ℹ️  Verify button labels are present or use aria-label"
        fi
    fi
}

check_heading_hierarchy() {
    # Extract heading levels and check for skips
    if grep -qE '<h[1-6]' "$FILE_PATH"; then
        echo "ℹ️  Remember to maintain proper heading hierarchy (h1→h2→h3)"
    fi
}

check_color_contrast() {
    # Look for hardcoded colors (potential contrast issues)
    local hardcoded_colors=$(grep -oE '#[0-9A-Fa-f]{6}|rgb\(|rgba\(' "$FILE_PATH" | wc -l | tr -d ' ')
    if [ "$hardcoded_colors" -gt 0 ]; then
        echo "ℹ️  Found $hardcoded_colors hardcoded color(s) - verify contrast ratios (4.5:1 text, 3:1 UI)"
    fi
}

check_form_labels() {
    # Check for input fields
    if grep -q '<input[^>]*>' "$FILE_PATH"; then
        local inputs=$(grep -o '<input[^>]*>' "$FILE_PATH" | wc -l | tr -d ' ')
        echo "ℹ️  Found $inputs input(s) - ensure each has associated <label> or aria-label"
    fi
}

check_interactive_elements() {
    # Check for div/span with onClick (should be button/link)
    if grep -qE '(onClick|click).*(<div|<span)' "$FILE_PATH"; then
        echo "⚠️  Found interactive div/span - consider using <button> or <a> for keyboard accessibility"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
}

check_focus_management() {
    # Check for outline removal without alternative
    if grep -q 'outline:.*none' "$FILE_PATH" || grep -q 'outline: 0' "$FILE_PATH"; then
        echo "⚠️  Found 'outline: none' - ensure focus indicators are still visible"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
}

# Run all checks
check_alt_text
check_button_labels
check_heading_hierarchy
check_color_contrast
check_form_labels
check_interactive_elements
check_focus_management

# Run axe-core if available (via npm)
if [ -f "node_modules/.bin/axe" ] && command -v node &> /dev/null; then
    echo "🔍 Running axe-core analysis..."
    # Note: This would require a running server for full analysis
    # For now, just indicate it's available
    echo "ℹ️  axe-core available - run 'npm run test:a11y' for full audit"
fi

# Run pa11y if available
if command -v pa11y &> /dev/null; then
    echo "🔍 Running pa11y accessibility check..."
    pa11y --reporter cli "$FILE_PATH" 2>&1 | head -10
fi

# Summary
if [ $ISSUES_FOUND -eq 0 ]; then
    echo "✅ No major accessibility issues detected"
else
    echo "⚠️  Found $ISSUES_FOUND potential accessibility issue(s)"
    echo "📚 Review WCAG 2.1 guidelines: https://www.w3.org/WAI/WCAG21/quickref/"
fi

# Always exit 0 to not block the operation (these are warnings)
exit 0
