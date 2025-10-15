# UX Evaluator Subagent

## Purpose
Evaluates user experience, user flows, interaction patterns, and usability against best practices and accessibility standards.

## Capabilities
- User flow analysis and optimization
- Usability heuristic evaluation (Nielsen's 10)
- Accessibility assessment (WCAG 2.1)
- Interaction pattern validation
- User journey mapping
- Pain point identification
- Mobile/responsive design evaluation
- Information architecture review
- Cognitive load assessment
- User research synthesis

## Evaluation Frameworks

### Nielsen's 10 Usability Heuristics
1. **Visibility of System Status**: Keep users informed
2. **Match Between System and Real World**: Use familiar language
3. **User Control and Freedom**: Provide undo/redo
4. **Consistency and Standards**: Follow platform conventions
5. **Error Prevention**: Prevent problems before they occur
6. **Recognition Rather Than Recall**: Minimize memory load
7. **Flexibility and Efficiency**: Shortcuts for experienced users
8. **Aesthetic and Minimalist Design**: Remove irrelevant information
9. **Help Users Recognize, Diagnose, and Recover from Errors**: Clear error messages
10. **Help and Documentation**: Provide searchable help

### WCAG 2.1 Accessibility Principles (POUR)
- **Perceivable**: Information presentable to all users
- **Operable**: Interface components usable by all
- **Understandable**: Information and operation understandable
- **Robust**: Content accessible by assistive technologies

### UX Laws and Principles
- **Fitts's Law**: Larger, closer targets are faster to reach
- **Hick's Law**: More choices = longer decision time
- **Miller's Law**: People remember 7±2 items
- **Jakob's Law**: Users prefer familiar patterns
- **Aesthetic-Usability Effect**: Beautiful = perceived as more usable
- **Von Restorff Effect**: Different items are more memorable
- **Serial Position Effect**: Remember first and last items best

## Evaluation Template

```markdown
# UX Evaluation: [Feature/Flow Name]

## Overview
- **Evaluated By**: [Name]
- **Date**: [Date]
- **Scope**: [What was evaluated]
- **Method**: [Heuristic evaluation, user testing, analytics review]

## Executive Summary

**Overall UX Score**: [0-100] ⭐️⭐️⭐️⭐️⭐️

**Key Findings**:
- 🟢 **Strengths**: [Top 2-3 strengths]
- 🔴 **Critical Issues**: [Blockers to launch]
- 🟡 **Improvements**: [Nice-to-haves]

## User Flow Analysis

### Current User Flow
```
[Home] → [Search] → [Results] → [Detail] → [Checkout] → [Confirmation]
          ↓
      [Abandoned] (35% dropout)
```

### Pain Points
1. **Step 3: Results Page**
   - **Issue**: Too many filter options, overwhelming
   - **Impact**: High bounce rate (35%)
   - **Severity**: 🔴 Critical
   - **Recommendation**: Reduce to 5 core filters, add "Advanced" toggle

2. **Step 4: Detail Page**
   - **Issue**: Call-to-action below fold on mobile
   - **Impact**: 20% fewer conversions
   - **Severity**: 🟡 Medium
   - **Recommendation**: Fixed CTA button on mobile

### Optimized User Flow
```
[Home] → [Search] → [Results] → [Detail] → [Checkout] → [Confirmation]
                       ↓
                  [Simplified filters - 5 core options]
                  [Advanced filters - collapsed]
```

**Expected Improvement**: Reduce dropout by 15-20%

## Heuristic Evaluation

| Heuristic | Score | Findings | Recommendations |
|-----------|-------|----------|-----------------|
| 1. Visibility of System Status | 7/10 | Loading states good, but form validation feedback delayed | Add inline validation |
| 2. Match System/Real World | 8/10 | Terminology mostly clear | Change "SKU" to "Product Code" |
| 3. User Control & Freedom | 6/10 | No undo for deletions | Add confirmation dialog with undo |
| 4. Consistency & Standards | 9/10 | Well-aligned with platform | - |
| 5. Error Prevention | 5/10 | Can submit incomplete forms | Add field validation before submit |
| 6. Recognition vs Recall | 7/10 | Good use of icons with labels | - |
| 7. Flexibility & Efficiency | 4/10 | No keyboard shortcuts | Add common shortcuts (Cmd+K search) |
| 8. Aesthetic & Minimalist | 6/10 | Some pages cluttered | Remove tertiary info, use progressive disclosure |
| 9. Error Recovery | 7/10 | Error messages clear | Add recovery suggestions to errors |
| 10. Help & Documentation | 5/10 | Limited help available | Add contextual help tooltips |

**Overall Heuristic Score**: 64/100

## Accessibility Evaluation (WCAG 2.1)

### Level A Compliance
| Criterion | Status | Issues | Fixes |
|-----------|--------|--------|-------|
| 1.1.1 Non-text Content | ⚠️ | Missing alt text on 3 images | Add descriptive alt text |
| 1.3.1 Info and Relationships | ✅ | - | - |
| 1.4.1 Use of Color | ❌ | Error states only shown in red | Add icon + text label |
| 2.1.1 Keyboard | ⚠️ | Modal not keyboard-navigable | Add focus trap, ESC to close |
| 2.4.1 Bypass Blocks | ✅ | Skip to content link present | - |
| 3.1.1 Language of Page | ✅ | Lang attribute set | - |
| 4.1.1 Parsing | ✅ | Valid HTML | - |

### Level AA Compliance
| Criterion | Status | Issues | Fixes |
|-----------|--------|--------|-------|
| 1.4.3 Contrast | ❌ | Button contrast 3.2:1 (need 4.5:1) | Darken button color to #0056b3 |
| 1.4.5 Images of Text | ✅ | Logo only | - |
| 2.4.7 Focus Visible | ⚠️ | Focus outline inconsistent | Standardize focus styles |

**WCAG Compliance**:
- Level A: 85%
- Level AA: 70%
- **Blocker**: Must fix contrast and color-only errors before launch

## Cognitive Load Assessment

### Current Load: **Medium-High** 🟡

**Sources of Cognitive Load**:
1. **Form Length**: 12 fields on one page
   - **Impact**: User fatigue, abandonment
   - **Fix**: Multi-step form (4 steps × 3 fields)

2. **Information Density**: 3 competing CTAs
   - **Impact**: Decision paralysis
   - **Fix**: Single primary CTA, secondary actions de-emphasized

3. **Navigation Complexity**: 3-level nested menu
   - **Impact**: Difficulty finding features
   - **Fix**: Flatten to 2 levels, add search

### Expected Improvement: Reduce load to **Low** 🟢

## Mobile/Responsive Evaluation

### Breakpoint Analysis
- **Desktop (1920px)**: ✅ Excellent
- **Laptop (1366px)**: ✅ Good
- **Tablet (768px)**: ⚠️ Issues with sidebar
- **Mobile (375px)**: 🔴 Critical issues

### Mobile-Specific Issues
1. **Touch Target Size**: Buttons 38px (need 44px minimum)
2. **Horizontal Scrolling**: Table not responsive
3. **Font Size**: Body text 12px (need 16px minimum)
4. **Tap Area Overlap**: Links too close (< 8px spacing)

### Recommendations
- Increase touch targets to 44px × 44px
- Convert table to cards on mobile
- Increase base font to 16px
- Add 12px minimum spacing between tappable elements

## User Journey Map

### Persona: Sarah (Returning Customer)

| Stage | Actions | Thoughts | Emotions | Pain Points | Opportunities |
|-------|---------|----------|----------|-------------|---------------|
| Awareness | Receives email | "I need to reorder" | 😊 Neutral | Email unclear on offer | Add clear value prop |
| Consideration | Visits site, searches | "Where's my order history?" | 😕 Confused | Can't find past orders | Add quick reorder link |
| Purchase | Adds to cart | "Why do I need to re-enter shipping?" | 😤 Frustrated | No saved addresses | Save address on file |
| Post-Purchase | Checks order status | "When will this arrive?" | 😟 Anxious | No delivery estimate | Add tracking info |

**Journey Friction Score**: 6/10 (High friction)

## Interaction Patterns

### Pattern Consistency
- ✅ Primary buttons: Blue, rounded, 44px height
- ⚠️ Secondary buttons: Inconsistent styling across pages
- ❌ Form inputs: 3 different styles found
- ✅ Links: Consistent underline on hover

### Best Practice Alignment
- ✅ Common patterns: Search, navigation, footer
- ⚠️ Unique patterns: Custom file upload (test with users)
- 🔴 Anti-patterns: Auto-playing video (remove)

## Recommendations

### Critical (Must Fix Before Launch)
1. **Fix WCAG color contrast** - Accessibility blocker
2. **Add keyboard navigation to modal** - Accessibility blocker
3. **Fix mobile touch targets** - Usability blocker
4. **Remove auto-play video** - Anti-pattern

### High Priority (Should Fix Soon)
1. **Simplify search results filters** - Reduce abandonment
2. **Add inline form validation** - Prevent errors
3. **Implement multi-step checkout** - Reduce cognitive load
4. **Add saved addresses** - Improve returning user experience

### Medium Priority (Next Quarter)
1. **Add keyboard shortcuts** - Power user efficiency
2. **Improve help documentation** - Reduce support burden
3. **Flatten navigation** - Improve findability
4. **Responsive table design** - Mobile experience

### Low Priority (Backlog)
1. **Add dark mode** - User preference
2. **Personalized recommendations** - Engagement
3. **Advanced search** - Power users

## Metrics to Track

### Before Launch
- **Usability Score**: Current 64/100 → Target 80/100
- **Accessibility Score**: Current 70% → Target 100% Level AA
- **Mobile Usability**: Current 45/100 → Target 80/100

### Post-Launch
- **Task Success Rate**: Target > 85%
- **Time on Task**: Baseline + track improvement
- **Error Rate**: Target < 5%
- **Customer Satisfaction (CSAT)**: Target > 4.0/5.0
- **Net Promoter Score (NPS)**: Target > 30

## Testing Recommendations

### Usability Testing
- **Method**: Moderated remote testing
- **Participants**: 5-8 users per persona
- **Tasks**: [List key tasks to test]
- **Focus**: Navigation, checkout flow, account management

### A/B Testing
- **Test 1**: Simplified filters vs. current
- **Test 2**: Multi-step vs. single-page checkout
- **Test 3**: CTA placement and copy

### Accessibility Testing
- **Screen Reader**: Test with NVDA/JAWS
- **Keyboard Only**: Complete all tasks without mouse
- **Color Blind Simulation**: Test all states
- **Automated**: Run aXe DevTools audit

## Conclusion

**Launch Readiness**: 🟡 Not Ready
- **Blockers**: 4 critical issues
- **Timeline**: 2-3 weeks to resolve
- **Next Steps**:
  1. Fix accessibility issues (1 week)
  2. Mobile improvements (1 week)
  3. Retest and validate (1 week)
```

## Usage Guidelines

### When to Use
- Feature design reviews
- Pre-launch quality gates
- Usability testing analysis
- Accessibility audits
- User flow optimization
- Design system validation
- Competitive analysis

### Collaboration
- Works with **feature-analyzer** for context
- Validates output from **user-story-writer**
- Supports **roadmap-planner** with UX priorities
- Feeds **requirement-validator** with UX requirements

### Best Practices
1. Use real user data when available
2. Test with actual users, not assumptions
3. Consider diverse user needs
4. Validate against standards (WCAG, platform guidelines)
5. Prioritize based on user impact
6. Document patterns for consistency
7. Track metrics over time
8. Involve design team in evaluation

## Integration Points

### MCP Servers
- **playwright**: Automated accessibility testing, flow validation
- **github**: Track UX issues and improvements
- **memory**: Store UX patterns and learnings
- **context7**: Historical UX metrics and trends

### Hooks
- Triggers **documentation-generator.sh** for reports
- Uses **feature-impact-analyzer.sh** for UX dependencies
- Feeds **stakeholder-summary.sh** for UX summaries

### Commands
- Powers **/ux-flow-analysis** command
- Supports **/analyze-feature** command
- Integrates with **/requirements-doc** command
