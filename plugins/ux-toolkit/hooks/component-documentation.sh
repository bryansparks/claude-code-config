#!/bin/bash
# Component Documentation Hook - Auto-generates component documentation stubs

FILE_PATH="$1"
OPERATION="${2:-write}"

# Only process component files
if [[ ! "$FILE_PATH" =~ \.(jsx|tsx)$ ]] || [[ "$FILE_PATH" =~ \.(test|spec)\. ]]; then
    exit 0
fi

# Extract component name from file path
COMPONENT_NAME=$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')

echo "📝 Checking component documentation..."

# Check if component has corresponding documentation
DOC_FILE="${FILE_PATH%.*}.md"
STORIES_FILE="${FILE_PATH%.*}.stories.tsx"

# Check for Storybook stories
if [ ! -f "$STORIES_FILE" ] && [[ "$FILE_PATH" =~ components/ ]]; then
    echo "ℹ️  No Storybook story found for $COMPONENT_NAME"
    echo "   Consider creating: $STORIES_FILE"

    # Offer to create story stub
    if [ "$OPERATION" = "write" ]; then
        echo "💡 Would you like to create a Storybook story?"
        echo "   Story template would include:"
        echo "   - Default story"
        echo "   - Variants showcase"
        echo "   - Interactive controls"
        echo "   - Accessibility checks"
    fi
fi

# Check for component README/documentation
if [ ! -f "$DOC_FILE" ] && [[ "$FILE_PATH" =~ components/ ]]; then
    echo "ℹ️  No documentation file found for $COMPONENT_NAME"
fi

# Analyze component for documentation needs
if [ -f "$FILE_PATH" ]; then
    # Check if component is exported
    if grep -q "export.*$COMPONENT_NAME" "$FILE_PATH"; then
        echo "✅ Component $COMPONENT_NAME is exported"

        # Check for TypeScript props interface
        if grep -q "interface.*Props" "$FILE_PATH" || grep -q "type.*Props" "$FILE_PATH"; then
            echo "✅ Props interface defined"
        else
            echo "⚠️  No Props interface found - add TypeScript types for better documentation"
        fi

        # Check for JSDoc comments
        if grep -q "/\*\*" "$FILE_PATH"; then
            echo "✅ JSDoc comments present"
        else
            echo "ℹ️  Consider adding JSDoc comments for better documentation"
        fi

        # Check for prop-types (if not using TypeScript)
        if [[ ! "$FILE_PATH" =~ \.tsx$ ]] && ! grep -q "PropTypes" "$FILE_PATH"; then
            echo "⚠️  No PropTypes defined - add runtime prop validation"
        fi
    fi

    # Check for accessibility documentation
    if grep -q "aria-" "$FILE_PATH" || grep -q "role=" "$FILE_PATH"; then
        echo "✅ ARIA attributes detected - ensure they're documented"
    fi

    # Check for variants/states
    VARIANT_COUNT=$(grep -oE "variant.*=|size.*=|color.*=" "$FILE_PATH" | wc -l | tr -d ' ')
    if [ "$VARIANT_COUNT" -gt 0 ]; then
        echo "✅ Found $VARIANT_COUNT variant props - document in Storybook"
    fi
fi

# Check for tests
TEST_FILE="${FILE_PATH%.*}.test.tsx"
SPEC_FILE="${FILE_PATH%.*}.spec.tsx"

if [ ! -f "$TEST_FILE" ] && [ ! -f "$SPEC_FILE" ] && [[ "$FILE_PATH" =~ components/ ]]; then
    echo "⚠️  No test file found for $COMPONENT_NAME"
    echo "   Consider creating: $TEST_FILE"
fi

# Generate documentation checklist
echo ""
echo "📋 Documentation Checklist for $COMPONENT_NAME:"
echo "   [ ] Props documented with TypeScript/PropTypes"
echo "   [ ] JSDoc comments added"
echo "   [ ] Storybook stories created"
echo "   [ ] Usage examples provided"
echo "   [ ] Accessibility notes included"
echo "   [ ] All variants showcased"
echo "   [ ] Unit tests written"
echo "   [ ] Edge cases documented"

# Check if in a design system
if [ -f "package.json" ] && grep -q "storybook" package.json; then
    echo ""
    echo "🎨 Storybook detected!"
    echo "   Run: npm run storybook"
    echo "   Document in: $STORIES_FILE"
fi

# Provide helpful links
echo ""
echo "📚 Documentation Resources:"
echo "   Storybook: https://storybook.js.org/docs/react/writing-stories/introduction"
echo "   TypeScript: https://www.typescriptlang.org/docs/handbook/react.html"
echo "   Accessibility: https://www.w3.org/WAI/ARIA/apg/"

exit 0
