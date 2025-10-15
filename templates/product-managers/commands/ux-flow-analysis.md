# Command: UX Flow Analysis

## Purpose
Analyzes and validates user experience, user flows, accessibility, and usability against best practices.

## Usage
```bash
/ux-flow-analysis [feature or flow-file]
```

## What This Command Does

1. Activates **ux-evaluator** subagent
2. Analyzes user flows and journey maps
3. Evaluates against Nielsen's 10 Heuristics
4. Validates WCAG 2.1 accessibility compliance
5. Identifies UX issues and improvements
6. Can use **playwright** MCP for automated testing

## Output Format

```markdown
# UX Flow Analysis: [Feature/Flow Name]

## Overall UX Score: 72/100 ⭐⭐⭐⭐☆

## User Flow

### Current Flow
```
[Home] → [Search] → [Results] → [Details] → [Checkout] → [Confirmation]
            ↓
       [Abandoned - 35%]
```

### Pain Points
1. **Search Results** (Critical 🔴)
   - Issue: Too many filters, overwhelming
   - Impact: 35% abandonment rate
   - Fix: Reduce to 5 core filters, collapse advanced

2. **Details Page** (Medium 🟡)
   - Issue: CTA below fold on mobile
   - Impact: 20% lower mobile conversion
   - Fix: Sticky CTA button on mobile

## Heuristic Evaluation

| Heuristic | Score | Issues | Recommendations |
|-----------|-------|--------|-----------------|
| Visibility of Status | 7/10 | Loading states good, form validation slow | Add inline validation |
| Match System/World | 8/10 | Good terminology | Change "SKU" to "Product Code" |
| User Control | 6/10 | No undo for deletions | Add confirmation + undo |
| Consistency | 9/10 | Well-aligned | - |
| Error Prevention | 5/10 | Can submit incomplete forms | Client-side validation |

**Overall**: 64/100 - Needs Improvement

## Accessibility (WCAG 2.1)

### Critical Issues (Must Fix) 🔴
- Button contrast 3.2:1 (need 4.5:1)
- Error states only in color (need icon + text)
- Modal not keyboard-navigable

### Level A: 85% Compliant
### Level AA: 70% Compliant

**Blockers**: Contrast and keyboard navigation

## Cognitive Load: Medium-High 🟡

**Sources**:
1. Form too long (12 fields) → Split into multi-step
2. 3 competing CTAs → Single primary CTA
3. 3-level navigation → Flatten to 2 levels

## Mobile/Responsive

- Desktop (1920px): ✅ Excellent
- Tablet (768px): ⚠️ Sidebar issues
- Mobile (375px): 🔴 Critical issues
  - Touch targets 38px (need 44px)
  - Table not responsive
  - Font size 12px (need 16px)

## User Journey Map

| Stage | Actions | Emotions | Pain Points | Opportunities |
|-------|---------|----------|-------------|---------------|
| Awareness | Receives email | 😊 Neutral | Unclear offer | Clear value prop |
| Purchase | Adds to cart | 😤 Frustrated | Re-enter shipping | Save addresses |
| Post-Purchase | Checks status | 😟 Anxious | No delivery estimate | Add tracking |

## Recommendations

### Critical (Must Fix Before Launch)
1. Fix WCAG contrast - Accessibility blocker
2. Keyboard navigation - Accessibility blocker
3. Mobile touch targets - Usability blocker

### High Priority (Should Fix Soon)
1. Simplify search filters - Reduce abandonment
2. Multi-step checkout - Reduce cognitive load
3. Saved addresses - Improve returning users

### Medium Priority (Next Quarter)
1. Keyboard shortcuts - Power users
2. Flatten navigation - Improve findability

## Metrics to Track

**Pre-Launch**:
- Usability Score: 64/100 → Target 80/100
- Accessibility: 70% → Target 100% Level AA
- Mobile Usability: 45/100 → Target 80/100

**Post-Launch**:
- Task Success Rate: Target > 85%
- Time on Task: Baseline TBD
- Error Rate: Target < 5%
- CSAT: Target > 4.0/5.0

## Testing Recommendations

### Usability Testing
- 5-8 users per persona
- Tasks: Navigation, checkout, account
- Method: Moderated remote

### A/B Tests
- Simplified filters vs current
- Multi-step vs single-page checkout

### Accessibility Testing
- Screen reader (NVDA/JAWS)
- Keyboard-only navigation
- Automated: aXe DevTools

## Launch Readiness: 🟡 Not Ready

**Blockers**: 4 critical issues
**Timeline**: 2-3 weeks to resolve
**Status**: Fix accessibility issues, then retest
```

## Analysis Focus Areas

### User Flows
- Flow efficiency
- Drop-off points
- Alternative paths
- Error recovery

### Interaction Patterns
- Consistency
- Learnability
- Efficiency
- Error prevention

### Visual Design
- Hierarchy
- Contrast
- Whitespace
- Typography

### Accessibility
- WCAG compliance
- Keyboard navigation
- Screen reader support
- Color contrast

## Examples

```bash
# Analyze feature UX
/ux-flow-analysis ~/features/checkout-flow.md

# Analyze live site with Playwright
/ux-flow-analysis --url=https://app.example.com/checkout --live

# Accessibility audit
/ux-flow-analysis --focus=accessibility ~/designs/mockups.md

# Mobile-specific
/ux-flow-analysis --device=mobile ~/flows/signup.md
```

## Options
- `--focus=[flow|accessibility|heuristics|mobile]`
- `--url=<url>`: Analyze live site (uses Playwright)
- `--device=[desktop|tablet|mobile]`
- `--automated`: Run automated accessibility tests
- `--output=<file>`

## Integration

### Subagents
- `ux-evaluator.md` (primary)

### MCP Servers
- **playwright**: Automated accessibility testing, live site analysis
- **github**: Track UX issues
- **memory**: Store UX patterns

## Success Criteria
- [ ] All critical UX issues identified
- [ ] WCAG compliance level determined
- [ ] Usability score calculated
- [ ] Recommendations prioritized
- [ ] Metrics defined
- [ ] Testing plan created
