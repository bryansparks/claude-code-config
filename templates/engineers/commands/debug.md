**Purpose**: Systematic debugging assistance for code issues

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Debug [issue description] in $ARGUMENTS"

Provide systematic debugging assistance to identify and resolve code issues, errors, and unexpected behavior.

## Usage Examples
- `/debug --error "TypeError: Cannot read property 'map'" --file src/components/UserList.jsx`
- `/debug --issue "API returns 500 error intermittently" --reproduce`
- `/debug --performance "Page load is slow" --profile`
- `/debug --logs --filter "ERROR"`

## Command-Specific Flags
--error: "Debug specific error message or stack trace"
--issue: "Describe unexpected behavior to investigate"
--reproduce: "Help create minimal reproduction steps"
--performance: "Debug performance issues and bottlenecks"
--logs: "Analyze application logs for issues"
--filter: "Filter logs by level (ERROR, WARN, INFO)"
--profile: "Analyze performance profiling data"
--memory: "Investigate memory leaks or issues"
--network: "Debug API calls and network requests"
--trace: "Enable detailed stack trace analysis"

## Debugging Process

**1. Problem Understanding:**
- What is the expected behavior?
- What is actually happening?
- When did it start?
- Can it be reproduced consistently?

**2. Information Gathering:**
- Collect error messages and stack traces
- Review recent code changes
- Check relevant logs
- Identify affected environment

**3. Systematic Investigation:**
- Form hypotheses about root cause
- Test each hypothesis methodically
- Use debugger to inspect state
- Add strategic logging

**4. Root Cause Analysis:**
- Identify exact failure point
- Understand why it fails
- Assess impact scope
- Document findings

**5. Solution Development:**
- Implement fix
- Write regression test
- Verify across environments
- Update documentation

## Output Format

The debug command provides:
1. **Problem Analysis**: Clear description of the issue
2. **Root Cause**: Identified source of the problem
3. **Investigation Steps**: What was checked and why
4. **Recommended Fix**: Specific code changes needed
5. **Test Case**: Regression test to prevent recurrence
6. **Prevention**: How to avoid similar issues

## Debugging Strategies

**Stack Trace Analysis:**
- Read from bottom to top
- Identify first occurrence in your code
- Check function parameters and state
- Look for null/undefined values

**Binary Search Debugging:**
- Divide problem space in half
- Test each half
- Narrow down to specific line
- Identify exact condition

**Rubber Duck Method:**
- Explain code line by line
- Verbalize assumptions
- Question each step
- Often reveals the issue

**Logging Strategy:**
- Log inputs at function entry
- Log outputs before return
- Log intermediate calculations
- Use structured logging

## Common Debug Scenarios

**Frontend Issues:**
- Component not rendering
- State not updating
- Props not passing
- Event handlers not firing
- API calls failing
- Memory leaks in React

**Backend Issues:**
- API endpoint errors
- Database query failures
- Authentication problems
- Race conditions
- Memory leaks
- Performance bottlenecks

**Integration Issues:**
- API contract mismatches
- CORS errors
- Timeout issues
- Data format problems
- Version incompatibilities
