---
description: Design system compliance verification
---

**Purpose**: Design system compliance verification

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Check design system compliance for $ARGUMENTS"

Verify adherence to design system standards including token usage, component library adoption, and pattern consistency.

## Usage Examples
- `/design-system-check --file src/components/Button.tsx`
- `/design-system-check --directory src/pages --score`
- `/design-system-check --project --report`
- `/design-system-check --compare design-tokens.json`

## Command-Specific Flags
--file: "Check specific file"
--directory: "Check all files in directory"
--project: "Check entire project"
--score: "Generate compliance score"
--report: "Detailed compliance report"
--compare: "Compare with design token spec"
--fix: "Auto-fix common issues where possible"
--strict: "Strict mode (fail on any violation)"

## Compliance Checks

### 1. Design Token Usage
✅ **Check for:**
- Colors from design token system
- Spacing using defined scale
- Typography using type scale
- Shadows from elevation system
- Border radius from token system
- Z-index from defined layers
- Animation timing from tokens

❌ **Flag violations:**
- Hardcoded hex colors (#3B82F6)
- Hardcoded px values (16px instead of spacing[4])
- Hardcoded font-size (14px instead of fontSize.sm)
- Magic numbers (z-index: 999)
- Custom shadows not from system

### 2. Component Library Adoption
✅ **Check for:**
- Using design system components
- Proper import paths
- Correct prop usage
- Documented variants only

❌ **Flag violations:**
- Custom/duplicate components
- Direct HTML instead of components (<button> vs <Button>)
- Incorrect prop names
- Undocumented variants

### 3. Pattern Consistency
✅ **Check for:**
- Following established patterns
- Consistent naming conventions
- Proper file structure
- CSS-in-JS or utility classes

❌ **Flag violations:**
- Inline styles
- Inconsistent naming
- Pattern deviations without docs
- Mixed styling approaches

## Output Format

```
📐 DESIGN SYSTEM COMPLIANCE CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Target: src/components/ProductCard.tsx
Design System: v2.4.0
Date: 2025-10-04

COMPLIANCE SCORE: 73% ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Target: 95%+ for design system compliance
Gap: 22% (needs improvement)

Breakdown:
  Token Usage: 68% ❌
  Component Library: 85% ⚠️
  Pattern Consistency: 90% ✅
  Documentation: 65% ❌

DESIGN TOKEN VIOLATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 12 token violations:

❌ Hardcoded Colors (5 violations):
  Line 23: color: #3B82F6
    Should use: tokens.colors.brand.primary[500]

  Line 34: backgroundColor: '#F3F4F6'
    Should use: tokens.colors.neutral[100]

  Line 45: border: '1px solid #E5E7EB'
    Should use: tokens.colors.neutral[200]

  Line 67: color: 'rgba(0, 0, 0, 0.6)'
    Should use: tokens.colors.text.secondary

  Line 89: background: 'linear-gradient(to right, #3B82F6, #8B5CF6)'
    Should use: tokens.gradients.primaryToPurple or create token

❌ Hardcoded Spacing (3 violations):
  Line 28: padding: '12px 24px'
    Should use: padding: ${tokens.spacing[3]} ${tokens.spacing[6]}

  Line 56: margin: '16px 0'
    Should use: margin: ${tokens.spacing[4]} 0

  Line 78: gap: '8px'
    Should use: gap: ${tokens.spacing[2]}

❌ Hardcoded Typography (2 violations):
  Line 38: fontSize: '14px'
    Should use: tokens.typography.fontSize.sm

  Line 52: lineHeight: 1.5
    Should use: tokens.typography.lineHeight.normal

❌ Hardcoded Shadows (1 violation):
  Line 61: boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
    Should use: tokens.shadows.sm

❌ Hardcoded Border Radius (1 violation):
  Line 72: borderRadius: '8px'
    Should use: tokens.borderRadius.md

Auto-fix available: Yes (8 of 12 can be auto-fixed)
Run: /design-system-check --fix src/components/ProductCard.tsx

COMPONENT LIBRARY COMPLIANCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Using design system components:
  - Button (line 45)
  - Badge (line 67)

⚠️  Potential duplicates:
  Line 89: Custom <div> with button styling
    Consider: Replace with <Button variant="ghost">

❌ Missing imports:
  Card component not imported from design system
    Add: import { Card } from '@/components/Card'
    Replace: <div className="card"> with <Card>

⚠️  Non-standard props:
  Line 45: <Button color="blue">
    Design system uses: variant="primary"
    Migrate to standard props

PATTERN CONSISTENCY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ File structure: Correct
  ✓ Component in src/components/
  ✓ Named exports used
  ✓ TypeScript types defined

✅ Naming conventions: Good
  ✓ PascalCase for component
  ✓ camelCase for props
  ✓ Descriptive variable names

⚠️  Styling approach: Inconsistent
  Found mix of:
    - Styled components (60%)
    - Inline styles (30%)
    - CSS modules (10%)

  Design system standard: Styled components or Tailwind
  Recommendation: Convert inline styles to styled components

✅ State management: Consistent
  ✓ Using React hooks appropriately
  ✓ Prop drilling avoided

⚠️  Accessibility: Needs improvement
  Missing aria-label on icon button (line 78)
  Missing alt text on image (line 56)

DOCUMENTATION COMPLIANCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Component documentation: 65%
  ✅ TypeScript props interface defined
  ✅ JSDoc comment present
  ❌ No Storybook story
  ❌ No usage examples
  ⚠️  Props table incomplete

Missing files:
  ❌ ProductCard.stories.tsx (create Storybook story)
  ❌ ProductCard.test.tsx (add unit tests)
  ⚠️  ProductCard.md (optional documentation)

RECOMMENDATIONS (Prioritized)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Critical (Fix Immediately):
1. Replace 5 hardcoded colors with design tokens
   Impact: Brand consistency, theme support
   Effort: 10 minutes
   Auto-fix: Yes

2. Import and use Card component from design system
   Impact: Consistency, maintenance
   Effort: 5 minutes
   Auto-fix: Partial

🟡 High Priority:
3. Replace 3 hardcoded spacing values with tokens
   Impact: Consistent spacing scale
   Effort: 5 minutes
   Auto-fix: Yes

4. Standardize styling approach (remove inline styles)
   Impact: Code consistency
   Effort: 20 minutes
   Auto-fix: No

5. Add missing accessibility attributes
   Impact: WCAG compliance
   Effort: 10 minutes
   Auto-fix: No

🟢 Medium Priority:
6. Create Storybook story
   Impact: Documentation, visual testing
   Effort: 30 minutes

7. Fix non-standard Button props
   Impact: API consistency
   Effort: 5 minutes

8. Replace hardcoded typography values
   Impact: Typography consistency
   Effort: 5 minutes
   Auto-fix: Yes

AUTO-FIX PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The following changes can be auto-applied:

```diff
- color: #3B82F6
+ color: ${tokens.colors.brand.primary[500]}

- backgroundColor: '#F3F4F6'
+ backgroundColor: ${tokens.colors.neutral[100]}

- padding: '12px 24px'
+ padding: ${tokens.spacing[3]} ${tokens.spacing[6]}

- fontSize: '14px'
+ fontSize: ${tokens.typography.fontSize.sm}

- boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
+ boxShadow: ${tokens.shadows.sm}

... (8 total auto-fixes available)
```

Run auto-fix: /design-system-check --fix src/components/ProductCard.tsx
Review changes before committing

COMPARISON WITH DESIGN SYSTEM SPEC
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Design Tokens Version: 2.4.0
Component using: Unknown (no import)

Token Changes Since Last Update:
⚠️  colors.primary[500] renamed to colors.brand.primary[500]
⚠️  spacing scale updated (8px base → 4px base)
✅ Component using old token names

Migration needed: Yes
Migration guide: /docs/migrations/v2.3-to-v2.4.md

CODEBASE-WIDE STATISTICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(Only shown with --project flag)

Token Compliance:
  Colors: 82% (432 of 527 usages)
  Spacing: 86% (298 of 347 usages)
  Typography: 89% (189 of 213 usages)
  Overall: 85%

Component Library Adoption:
  Using DS components: 87%
  Custom/duplicate: 13% (23 components)

Most Common Violations:
1. Hardcoded colors: 95 instances
2. Inline styles: 67 instances
3. Hardcoded spacing: 49 instances
4. Custom buttons: 12 instances
5. Old token names: 8 instances

FILES NEEDING ATTENTION:
src/components/ProductCard.tsx - 73% compliance
src/pages/checkout/PaymentForm.tsx - 68% compliance
src/components/custom/CustomButton.tsx - 45% compliance (migrate)

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Run auto-fix on current file
   /design-system-check --fix src/components/ProductCard.tsx

2. Review and test changes
   npm test src/components/ProductCard.test.tsx

3. Fix remaining manual issues (accessibility, documentation)

4. Run full project scan
   /design-system-check --project --report

5. Create migration plan for codebase-wide improvements

TARGET: 95%+ Design System Compliance
Current: 73% | Gap: 22% | ETA to target: 2-3 hours

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Resources:
- Design System Docs: /docs/design-system.md
- Token Reference: /docs/design-tokens.md
- Migration Guide: /docs/migrations/
- Component Library: /storybook
```

## Automated Fixes

The design-system-check command can automatically fix:

**Auto-fixable:**
- ✅ Hardcoded colors → design tokens
- ✅ Hardcoded spacing → spacing tokens
- ✅ Hardcoded font-size → typography tokens
- ✅ Hardcoded shadows → shadow tokens
- ✅ Hardcoded border-radius → border tokens
- ✅ Old token names → new token names

**Manual fixes required:**
- ⚠️ Inline styles → styled components
- ⚠️ Custom components → design system components
- ⚠️ Non-standard props → standard props
- ⚠️ Missing documentation
- ⚠️ Accessibility issues

## Integration with CI/CD

```yaml
# .github/workflows/design-system-check.yml
name: Design System Compliance

on: [pull_request]

jobs:
  check-compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Check design system compliance
        run: |
          npm run design-system:check -- --strict
          # Fails if compliance < 90%
```

## Collaboration

**Led by:**
- **design-system-expert**: Token and component compliance

**Supports:**
- **ui-component-reviewer**: Component usage patterns
- **frontend-engineers**: Implementation and migration

Focus on maintaining high design system compliance to ensure consistency, maintainability, and scalability.
