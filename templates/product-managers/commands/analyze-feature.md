# Command: Analyze Feature

## Purpose
Comprehensive feature analysis covering business value, user impact, technical complexity, dependencies, and risks.

## Usage
```bash
/analyze-feature [feature-name or file-path]
```

## What This Command Does

1. **Loads Feature Context**
   - If file path provided: Reads existing feature doc
   - If feature name: Analyzes from description/requirements

2. **Activates Subagents**
   - **feature-analyzer**: Primary analysis
   - **requirement-validator**: Validates completeness
   - **ux-evaluator**: UX/usability considerations
   - **feature-impact-analyzer** (hook): Dependency and impact scoring

3. **Performs Multi-Dimensional Analysis**
   - Business value and ROI
   - User impact and personas
   - Technical complexity
   - Dependencies and blockers
   - Risk assessment
   - RICE prioritization score

4. **Generates Output**
   - Detailed analysis report
   - Executive summary
   - Prioritization recommendation
   - Risk mitigation plan

## Output Format

```markdown
# Feature Analysis: [Feature Name]

## Executive Summary
[2-3 sentence overview with recommendation]

## Business Impact (Score: X/100)
- **Revenue Impact**: [High/Medium/Low]
- **Strategic Value**: [Details]
- **Market Opportunity**: [Details]
- **Expected ROI**: [Estimate]

## User Impact (Score: X/100)
- **Target Users**: [Segments and count]
- **Pain Points Addressed**: [List]
- **Expected Adoption**: [Rate]
- **User Value**: [Description]

## Technical Analysis (Complexity: X/100)
- **Complexity Level**: [High/Medium/Low]
- **Components Affected**: [List]
- **Integration Requirements**: [Details]
- **Performance Considerations**: [Details]
- **Security/Compliance**: [Requirements]

## Dependencies (Count: X)
- **Prerequisites**: [List]
- **Blockers**: [List]
- **External Dependencies**: [List]
- **Risk Level**: [High/Medium/Low]

## RICE Prioritization
- **Reach**: [Number of users per time period]
- **Impact**: [Score: 0.25-3]
- **Confidence**: [Percentage]
- **Effort**: [Person-months or story points]
- **RICE Score**: [Calculated score]

## Risk Assessment (Level: High/Medium/Low)
| Risk | Severity | Probability | Mitigation |
|------|----------|-------------|------------|
| [Risk] | [H/M/L] | [H/M/L] | [Plan] |

## Effort Estimation
- **Development**: [Time/points]
- **Design**: [Time/points]
- **Testing**: [Time/points]
- **Total**: [Time/points]

## Recommendation
[✅ HIGH PRIORITY / ⚠️ MEDIUM PRIORITY / ❌ LOW PRIORITY]

**Rationale**: [Why this priority]

**Next Steps**:
1. [Action item]
2. [Action item]
3. [Action item]
```

## Examples

### Example 1: Analyze from existing file
```bash
/analyze-feature ~/features/guest-checkout.md
```

### Example 2: Analyze from description
```bash
/analyze-feature

Feature: Guest Checkout
Allow users to complete purchases without creating an account to reduce cart abandonment.
Target: 30% of current users (estimated 50k users/month)
```

### Example 3: Quick analysis
```bash
/analyze-feature --quick "Add dark mode to settings"
```

## Options

- `--quick`: Fast analysis with basic metrics only
- `--detailed`: Full comprehensive analysis (default)
- `--focus=[business|technical|user]`: Focus on specific dimension
- `--output=<file>`: Save report to file
- `--format=[markdown|json|html]`: Output format

## Integration

### Subagents Used
- `feature-analyzer.md` (primary)
- `requirement-validator.md` (validation)
- `ux-evaluator.md` (UX assessment)

### Hooks Triggered
- `feature-impact-analyzer.sh` (impact scoring)
- `documentation-generator.sh` (report formatting)

### MCP Servers
- **github**: Pull similar feature data, user feedback
- **context7**: Historical feature performance
- **memory**: Store analysis patterns

## Success Criteria

Analysis is complete when:
- [ ] All impact dimensions scored
- [ ] RICE score calculated
- [ ] Dependencies identified
- [ ] Risks assessed with mitigation
- [ ] Clear recommendation provided
- [ ] Effort estimated
- [ ] Executive summary generated

## Follow-Up Commands

After analysis, commonly used commands:
- `/write-user-story` - Create user stories
- `/estimate-feature` - Detailed effort estimation
- `/roadmap-planning` - Add to roadmap
- `/stakeholder-update` - Share with stakeholders

## Tips

1. **Provide Context**: More context = better analysis
2. **Include Data**: User counts, metrics, benchmarks
3. **Link Related Features**: Mention dependencies
4. **Specify Constraints**: Timeline, resource, technical
5. **Add Competitive Info**: How competitors solve this

## Common Use Cases

- **Feature Prioritization**: Deciding what to build next
- **Stakeholder Presentations**: Making the case for a feature
- **Resource Planning**: Understanding effort and team needs
- **Risk Management**: Identifying and mitigating risks
- **Roadmap Planning**: Sequencing features logically
