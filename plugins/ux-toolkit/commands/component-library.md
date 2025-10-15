---
description: Component library analysis and documentation
---

**Purpose**: Component library analysis and documentation

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Analyze component library for $ARGUMENTS"

Analyze component library structure, document components, identify gaps, and ensure consistency across the design system.

## Usage Examples
- `/component-library --audit --complete`
- `/component-library --document Button --storybook`
- `/component-library --analyze src/components --gaps`
- `/component-library --compare design-mockups`

## Command-Specific Flags
--audit: "Full component library audit"
--document: "Generate documentation for component"
--analyze: "Analyze directory for components"
--compare: "Compare with design specs/mockups"
--gaps: "Identify missing components"
--storybook: "Generate Storybook stories"
--complete: "Comprehensive analysis (usage, coverage, quality)"
--usage: "Find component usage across codebase"
--variants: "Document all component variants"

## Component Library Analysis

### 1. Component Inventory
**Categorize all components:**
```
Atomic Design Hierarchy:
├── Atoms (foundational)
│   ├── Button
│   ├── Input
│   ├── Label
│   ├── Icon
│   └── Badge
├── Molecules (combinations)
│   ├── FormField (Label + Input + Error)
│   ├── SearchBar (Input + Icon + Button)
│   └── Card
├── Organisms (complex)
│   ├── Header
│   ├── Navigation
│   ├── ProductCard
│   └── Modal
├── Templates (layouts)
│   ├── PageLayout
│   ├── DashboardLayout
│   └── FormLayout
└── Pages (specific instances)
    ├── Homepage
    ├── ProductPage
    └── CheckoutPage
```

### 2. Component Quality Assessment
**For each component evaluate:**
- Documentation completeness
- TypeScript prop types
- Accessibility (WCAG 2.1 AA)
- Design token compliance
- Responsive behavior
- Test coverage
- Storybook stories
- Usage examples

### 3. Component Coverage
**Identify:**
- Components in design system
- Components in codebase
- Components in designs but not implemented
- One-off components (duplicates)
- Deprecated components

### 4. Component Variants
**Document:**
- Sizes (sm, md, lg, xl)
- Colors/themes (primary, secondary, success, error)
- States (default, hover, active, focus, disabled, loading, error)
- Appearances (solid, outline, ghost, link)
- Special variants (compact, icon-only, etc.)

## Output Format

```
📚 COMPONENT LIBRARY ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Library: Design System v2.4.0
Components Analyzed: 47
Date: 2025-10-04

COMPONENT INVENTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Atoms (12 components):
✅ Button (5 variants, 3 sizes, 8 states)
✅ Input (4 types, 3 sizes, 6 states)
✅ Label
✅ Icon (120 icons available)
✅ Badge (3 variants, 4 colors)
✅ Avatar (3 sizes, with/without image)
✅ Checkbox
✅ Radio
✅ Switch
✅ Spinner (3 sizes)
✅ Tooltip
✅ Divider

Molecules (15 components):
✅ FormField (Label + Input + Helper + Error)
✅ SearchBar
✅ Card (3 variants: flat, outlined, elevated)
✅ Alert (4 severities: info, success, warning, error)
✅ Toast/Notification
✅ Breadcrumb
✅ Pagination
✅ Tabs (2 variants: line, enclosed)
✅ Dropdown/Select
✅ DatePicker
✅ FileUpload
✅ ProgressBar
✅ Accordion
⚠️  Rating (exists but undocumented)
⚠️  Stepper (inconsistent implementation)

Organisms (12 components):
✅ Header/AppBar
✅ Navigation (sidebar, top)
✅ Footer
✅ Modal/Dialog
✅ Drawer/Sidebar
✅ Table (with sorting, filtering, pagination)
✅ ProductCard
✅ UserProfile
⚠️  Form (no standardized layout component)
⚠️  DataGrid (performance issues reported)
❌ CommandPalette (in roadmap, not implemented)
❌ FileTree (needed but missing)

Templates (5 layouts):
✅ PageLayout (header, content, footer)
✅ DashboardLayout (sidebar, header, main)
✅ FormLayout (single column, two column)
⚠️  SplitLayout (undocumented)
❌ WizardLayout (multi-step forms - needed)

Pages (8 documented):
✅ Login
✅ Dashboard
✅ UserSettings
✅ ProductListing
✅ ProductDetails
⚠️  Checkout (exists but not in design system)
⚠️  Profile (multiple implementations)
❌ Error pages (404, 500 - inconsistent)

COMPONENT QUALITY SCORES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Button:
  Documentation: ✅ 95% (excellent)
  TypeScript: ✅ 100% (fully typed)
  Accessibility: ✅ 92% (AA compliant)
  Design Tokens: ✅ 98% (2 hardcoded values)
  Tests: ✅ 88% coverage
  Storybook: ✅ Complete (all variants)
  Usage: 142 instances across codebase
  Overall: ⭐⭐⭐⭐⭐ (5/5)

Card:
  Documentation: ⚠️  68% (missing examples)
  TypeScript: ✅ 100% (fully typed)
  Accessibility: ⚠️  74% (missing ARIA landmarks)
  Design Tokens: ⚠️  82% (some hardcoded shadows)
  Tests: ⚠️  64% coverage
  Storybook: ⚠️  Only 2 of 3 variants
  Usage: 89 instances
  Overall: ⭐⭐⭐ (3/5)

Modal:
  Documentation: ❌ 45% (severely lacking)
  TypeScript: ✅ 100% (fully typed)
  Accessibility: ❌ 58% (keyboard trap, no ARIA)
  Design Tokens: ✅ 95% (good compliance)
  Tests: ❌ 42% coverage
  Storybook: ⚠️  Basic story only
  Usage: 34 instances
  Issues: Keyboard trap (P0), focus management
  Overall: ⭐⭐ (2/5) - Needs improvement

DataGrid:
  Documentation: ⚠️  72% (good but could improve)
  TypeScript: ✅ 95% (mostly typed, some anys)
  Accessibility: ⚠️  68% (table semantics good, keyboard nav issues)
  Design Tokens: ✅ 90%
  Tests: ⚠️  55% coverage
  Storybook: ✅ Comprehensive examples
  Usage: 28 instances
  Issues: Performance with >1000 rows, sorting bugs
  Overall: ⭐⭐⭐ (3/5)

GAPS & MISSING COMPONENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Critical (Needed Immediately):
1. WizardLayout - Multi-step forms used in 12 places
   Current: 5 different custom implementations
   Impact: Inconsistent UX, duplicated code

2. CommandPalette - Requested by 3 teams
   Current: None exists
   Use case: Quick actions, navigation

3. FileTree - Needed for document management
   Current: Basic custom version in 2 places
   Impact: Inconsistent, not accessible

🟡 Important (Should Add):
4. EmptyState - Used inconsistently across app
   Current: 15 different implementations
   Impact: Inconsistent messaging, no pattern

5. SkeletonLoader - Loading states inconsistent
   Current: Mix of spinners, custom skeletons
   Impact: Poor perceived performance

6. Timeline - Feature roadmap, activity feeds
   Current: 2 custom implementations
   Impact: Inconsistency

7. ColorPicker - User preferences, theming
   Current: None (using browser default)
   Impact: Poor UX, not branded

🟢 Nice to Have:
8. Calendar (full month view)
9. RichTextEditor
10. CodeEditor/Viewer
11. Chart components (beyond existing)

DUPLICATE/REDUNDANT COMPONENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 23 one-off components that duplicate design system:

❌ CustomButton (src/pages/checkout/CustomButton.tsx)
   Duplicates: Design system Button
   Diff: Minor styling differences (10px padding vs 12px)
   Action: Migrate to Button with size="compact"

❌ ProductCardVariant (src/components/product/ProductCardVariant.tsx)
   Duplicates: Design system Card + ProductCard
   Diff: Different hover effect
   Action: Add hover variant to ProductCard or use Card

❌ LoadingSpinner (src/utils/LoadingSpinner.tsx)
   Duplicates: Design system Spinner
   Diff: Different animation speed
   Action: Migrate to Spinner, adjust animation token

... (showing 3 of 23 duplicates)

Total tech debt: ~1200 lines of duplicate code
Estimated migration effort: 3 days

COMPONENT USAGE ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Most Used Components:
1. Button - 142 instances
2. Input - 98 instances
3. Card - 89 instances
4. Icon - 87 instances
5. Modal - 34 instances

Least Used Components:
1. Stepper - 2 instances (consider deprecation)
2. Rating - 3 instances
3. FileUpload - 5 instances

Unused Components (0 instances):
- None (good adoption!)

Design System Adoption Rate:
- Components using DS: 87%
- One-off custom components: 13%
- Target: 95%+

DESIGN TOKEN COMPLIANCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Token Usage Across Library:
✅ Colors: 94% (excellent)
⚠️  Spacing: 86% (good, could improve)
⚠️  Typography: 89% (good)
✅ Shadows: 92% (excellent)
✅ BorderRadius: 96% (excellent)
⚠️  Animation: 78% (needs improvement)

Components with Hardcoded Values:
• Card - 3 hardcoded shadow values
• Modal - 2 hardcoded z-index values
• Dropdown - 4 hardcoded spacing values
• DataGrid - 6 hardcoded color values

Total Violations: 23 across library
Target: <5 violations

ACCESSIBILITY COMPLIANCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WCAG 2.1 AA Compliance by Component:

Excellent (90-100%):
✅ Button - 92%
✅ Input - 94%
✅ Checkbox - 96%
✅ Radio - 95%

Good (75-89%):
⚠️  Card - 82%
⚠️  Tabs - 78%
⚠️  Dropdown - 85%

Needs Work (<75%):
❌ Modal - 58% (keyboard trap, focus management)
❌ DataGrid - 68% (keyboard navigation)
❌ DatePicker - 72% (screen reader issues)

Overall Library Compliance: 81%
Target: 95%+ (WCAG 2.1 AA)

DOCUMENTATION STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Storybook Coverage:
✅ 42 of 47 components have stories (89%)
⚠️  5 components missing stories

Documentation Completeness:
✅ Props tables: 100%
✅ Usage examples: 85%
⚠️  Accessibility notes: 68%
⚠️  Do's and don'ts: 52%
⚠️  Migration guides: 34%

MDX Documentation:
✅ All atoms documented
⚠️  3 molecules missing docs
❌ 2 organisms missing docs

Code Examples:
✅ Copy-paste ready: 78%
⚠️  Need improvement: 22%

RECOMMENDATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Immediate Actions (P0):
1. Fix Modal accessibility (keyboard trap, ARIA)
2. Document Rating and Stepper components
3. Add WizardLayout component (high demand)
4. Migrate 23 duplicate components

High Priority (P1):
5. Improve DataGrid accessibility
6. Add missing Storybook stories (5 components)
7. Standardize EmptyState component
8. Add SkeletonLoader component
9. Increase accessibility notes to 90%+
10. Fix design token violations (23 found)

Medium Priority (P2):
11. Add CommandPalette component
12. Add FileTree component
13. Add do's and don'ts to all components
14. Create migration guides for breaking changes
15. Improve animation token usage

Component Library Roadmap:
Q4 2025:
- Fix critical accessibility issues
- Add WizardLayout, EmptyState, SkeletonLoader
- Migrate duplicate components
- Reach 95% token compliance

Q1 2026:
- Add CommandPalette, FileTree, Timeline
- Improve documentation to 95%+ completeness
- Reach 95%+ accessibility compliance
- Add advanced components (Calendar, RichText)

METRICS & KPIs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current State:
- Components: 47
- Design System Adoption: 87%
- Token Compliance: 89%
- Accessibility: 81% (AA)
- Documentation: 72%
- Test Coverage: 68%

Targets (End of Q1 2026):
- Components: 55+
- Design System Adoption: 95%+
- Token Compliance: 95%+
- Accessibility: 95%+ (AA)
- Documentation: 95%+
- Test Coverage: 85%+

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Next Steps:
1. Review and prioritize recommendations
2. Create tickets for component gaps
3. Schedule design system working group
4. Plan migration for duplicate components
5. Update component library roadmap
```

## Component Documentation Template

When documenting a component, include:

```markdown
# ComponentName

Brief description of component purpose.

## Usage

\`\`\`tsx
import { ComponentName } from '@/components';

<ComponentName
  variant="primary"
  size="md"
  onClick={handleClick}
>
  Content
</ComponentName>
\`\`\`

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | 'primary' \| 'secondary' | 'primary' | Visual style |
| size | 'sm' \| 'md' \| 'lg' | 'md' | Component size |
| disabled | boolean | false | Disable interaction |

## Variants

### Primary
[Image/example]
Use for main actions

### Secondary
[Image/example]
Use for less important actions

## States

- Default
- Hover
- Active
- Focus
- Disabled
- Loading
- Error

## Accessibility

- WCAG 2.1 AA compliant
- Keyboard navigable (Tab, Enter, Space)
- Screen reader friendly
- Focus indicator visible
- ARIA labels present

## Best Practices

✅ Do:
- Use for [specific use case]
- Provide clear labels
- Use semantic variants

❌ Don't:
- Use for [anti-pattern]
- Nest inside [component]
- Override core styles

## Examples

[Multiple real-world examples]

## Related Components

- ComponentA
- ComponentB
```

## Collaboration

**Led by:**
- **design-system-expert**: Component library architecture and governance

**Supports:**
- **ui-component-reviewer**: Quality assessment
- **accessibility-specialist**: Accessibility compliance
- **interaction-designer**: Component interactions
- **frontend-engineers**: Implementation and usage

Focus on creating a comprehensive, well-documented component library that accelerates development and ensures consistency.
