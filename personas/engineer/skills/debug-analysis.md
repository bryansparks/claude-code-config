---
name: debug-analysis
description: Systematic debugging assistance for code issues, errors, and unexpected behavior. Use when user reports bugs, errors, crashes, or asks for help debugging problems in their code.
---

# Debug Analysis Skill

Provide systematic debugging assistance to identify root causes and resolve code issues, errors, and unexpected behavior.

## When to Use This Skill

Automatically invoke when the user:
- Reports an error message or stack trace
- Describes unexpected behavior or bugs
- Asks "why isn't this working" or "help debug"
- Mentions crashes, failures, or issues
- Needs help troubleshooting code problems
- Requests investigation of intermittent issues

## Debugging Process

Follow this systematic approach to identify and resolve issues:

### 1. Problem Definition

Understand the issue clearly:
- **Expected behavior**: What should happen?
- **Actual behavior**: What is happening instead?
- **Onset**: When did it start? After what change?
- **Reproducibility**: Consistent, intermittent, or specific conditions?

### 2. Information Gathering

Collect diagnostic data:
- Error messages and complete stack traces
- Recent code changes (git diff, commits)
- Relevant application logs
- Affected environment (dev, staging, production)
- Browser/Node version, OS, dependencies

### 3. Hypothesis Formation

Develop possible explanations:
- List potential root causes
- Prioritize by likelihood and evidence
- Identify verification methods for each
- Plan systematic investigation approach

### 4. Systematic Investigation

Use debugging strategies:

#### Binary Search Debugging
- Divide problem space in half
- Test each half to isolate issue
- Narrow down to specific lines
- Identify exact failing condition

#### Stack Trace Analysis
- Read from bottom to top
- Find first occurrence in your code (not libraries)
- Check function parameters and state at that point
- Look for null/undefined values

#### Strategic Logging
- Log function inputs at entry
- Log outputs before return
- Log intermediate calculations
- Use structured logging with context

#### Debugger Usage
- Set breakpoints at suspected locations
- Inspect variable state
- Step through execution
- Watch expressions and call stack

### 5. Root Cause Identification

Pinpoint the exact issue:
- Identify specific line/condition causing failure
- Understand WHY it fails (not just where)
- Assess impact scope (how widespread?)
- Document findings clearly

### 6. Fix & Verification

Resolve and prevent:
- Implement targeted fix
- Write regression test
- Verify across environments
- Update documentation
- Add preventive safeguards

## Common Bug Categories

### Logic Errors
- Incorrect algorithms
- Off-by-one errors
- Wrong conditional logic
- Missing edge case handling

### Runtime Errors
- Null/undefined references
- Type mismatches
- Array index out of bounds
- Division by zero

### Concurrency Issues
- Race conditions
- Deadlocks
- Thread safety violations
- Async/await misuse

### Memory Issues
- Memory leaks
- Excessive allocations
- Closure memory retention
- Event listener leaks

### Integration Errors
- API endpoint failures
- Data format mismatches
- Timeout issues
- CORS errors
- Authentication failures

### Configuration Errors
- Wrong environment variables
- Missing dependencies
- Incorrect settings
- Path resolution issues

## Output Format

Provide structured debugging analysis:

```
🐛 DEBUG ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Problem Summary
Expected: [What should happen]
Actual: [What is happening]
Frequency: [Always | Intermittent | Specific conditions]
Environment: [Where it occurs]

🔍 Error Analysis
Stack Trace Key Lines:
  [File:Line] - [Error message]
  [File:Line] - [Relevant frame]

Error Type: [Category - e.g., TypeError, NullPointer]
Location: [Primary file:line where error originates]

🎯 Root Cause
Issue: [Specific problem identified]
Why it happens: [Clear explanation of the mechanism]
Trigger conditions: [What causes it to occur]

🔬 Investigation Steps Taken
1. [What was checked and result]
2. [What was tested and finding]
3. [What was analyzed and conclusion]

✅ Recommended Fix

[File:Line]
```language
// Clear code example showing the fix
// Before (problematic code)
const result = data.map(item => item.value);

// After (fixed code with null check)
const result = data?.map(item => item?.value) ?? [];
```

Explanation: [Why this fixes the issue]

📝 Verification Plan
- [ ] Add unit test for this bug scenario
- [ ] Add integration test if needed
- [ ] Manual verification steps: [Specific actions]
- [ ] Regression prevention: [Safeguards added]

⚠️  Related Issues
Similar patterns found:
  • [File:Line] - [Similar issue to check]

Potential related bugs:
  • [Concern to investigate]

🛡️ Prevention
To avoid similar issues in the future:
• [Specific practice or pattern to adopt]
• [Tool or check to implement]
• [Code review checkpoint]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Debugging Strategies by Issue Type

### Frontend Issues
- **Component not rendering**: Check props, state updates, keys
- **State not updating**: Verify setState/dispatch calls, async timing
- **Props not passing**: Inspect component tree, prop types
- **Event handlers not firing**: Check event binding, delegation
- **API calls failing**: Inspect network tab, CORS, auth headers

### Backend Issues
- **API endpoint errors**: Check routing, middleware, request validation
- **Database query failures**: Examine query syntax, connections, indexes
- **Authentication problems**: Verify tokens, sessions, middleware order
- **Race conditions**: Analyze async operations, locks
- **Performance bottlenecks**: Profile code, check N+1 queries

### Integration Issues
- **API contract mismatches**: Compare request/response schemas
- **CORS errors**: Check headers, preflight requests
- **Timeout issues**: Analyze request duration, adjust limits
- **Data format problems**: Validate serialization/deserialization
- **Version incompatibilities**: Check dependency versions, changelogs

## Language-Specific Tools

### JavaScript/TypeScript
- **Chrome DevTools**: Console, debugger, network, performance
- **VS Code Debugger**: Breakpoints, watches, launch configs
- **Node Inspector**: `node --inspect-brk`, Chrome DevTools
- **Source Maps**: Enable for TypeScript/bundled code

### Python
- **pdb/ipdb**: Interactive debugger, `import pdb; pdb.set_trace()`
- **VS Code Debugger**: Launch configurations
- **Logging**: `logging` module with proper levels
- **pytest**: `pytest --pdb` for test debugging

### Java
- **IntelliJ Debugger**: Breakpoints, watches, evaluate expression
- **JDB**: Command-line debugger
- **Logging**: slf4j, log4j with appropriate levels

### Go
- **Delve**: Full-featured debugger `dlv debug`
- **Race Detector**: `go run -race` for concurrency issues
- **Printf Debugging**: Strategic fmt.Printf statements

## Debugging Checklist

- [ ] Can reproduce the bug consistently
- [ ] Have complete error messages/stack traces
- [ ] Reviewed recent code changes
- [ ] Examined relevant logs
- [ ] Inspected variable state at failure point
- [ ] Identified root cause
- [ ] Understand why it fails
- [ ] Assessed impact scope
- [ ] Implemented fix
- [ ] Added regression test
- [ ] Verified in all environments
- [ ] Documented findings

## Best Practices

1. **Reproduce First**: Ensure you can consistently trigger the bug
2. **Simplify**: Create minimal reproduction case
3. **One Change at a Time**: Test each fix individually
4. **Document**: Record findings and solutions
5. **Test**: Always add regression tests
6. **Prevent**: Identify root cause to prevent similar bugs
7. **Communicate**: Clearly explain findings to team
