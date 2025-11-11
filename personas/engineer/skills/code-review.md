---
name: code-review
description: Perform comprehensive code review analyzing quality, security, performance, and best practices. Use when user requests code review, asks to review changes, wants feedback on pull requests, or needs quality assessment of their code.
---

# Code Review Skill

Provide comprehensive code review analyzing quality, security, performance, and adherence to best practices.

## When to Use This Skill

Automatically invoke when the user:
- Requests code review explicitly
- Asks "review my code" or "can you review this"
- Wants feedback on pull requests or changes
- Needs quality assessment before committing
- Asks about code improvements or best practices

## Review Process

Follow this systematic approach:

### 1. Initial Scan
- **File structure**: Logical organization, separation of concerns
- **Naming conventions**: Descriptive, consistent, follows language standards
- **Code formatting**: Consistent style, proper indentation
- **Obvious issues**: Clear bugs, anti-patterns, code smells

### 2. Deep Analysis

#### Logic & Correctness
- Algorithm correctness for all inputs
- Edge case handling (null, empty, boundary values)
- Error condition management
- Data validation completeness

#### Security Assessment
- **Input validation**: SQL injection, XSS, command injection prevention
- **Authentication/Authorization**: Proper JWT/OAuth, session management
- **Data protection**: Encryption, PII handling, sensitive data exposure
- **Dependencies**: Known vulnerabilities, outdated packages
- **API security**: Rate limiting, CORS, CSRF protection

#### Performance Review
- **Algorithm efficiency**: Big O complexity analysis
- **Database queries**: N+1 problems, missing indexes, query optimization
- **Caching strategy**: Appropriate use, invalidation patterns
- **Memory usage**: Potential leaks, excessive allocations
- **Network calls**: Batching opportunities, parallel requests

#### Code Quality
- **SOLID principles**: Single responsibility, open/closed, etc.
- **Design patterns**: Appropriate pattern usage
- **Code smells**: Long methods, duplicate code, large classes
- **Complexity**: Cyclomatic complexity, cognitive load
- **Maintainability**: Readability, modularity, testability

### 3. Testing Analysis
- **Test coverage**: Adequacy for critical paths
- **Test quality**: Meaningful assertions, proper mocking
- **Edge cases**: Covered in tests
- **Integration points**: Tested appropriately

## Output Format

Provide structured feedback:

```
🔍 CODE REVIEW RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⛔ Critical Issues (P0) - Must Fix
• [File:Line] - Detailed description
  Impact: [What breaks or security risk]
  Fix: [Specific code recommendation]

⚠️  High Priority (P1) - Should Fix
• [Issue with location and recommendation]

📊 Code Quality Assessment
• Complexity: [Metrics and assessment]
• Maintainability: [Rating and specific concerns]
• Test Coverage: [Percentage and gaps identified]

🔐 Security Concerns
• [Specific vulnerability or weakness]
  Recommendation: [How to address it]

⚡ Performance Opportunities
• [Bottleneck identified with location]
  Optimization: [Specific improvement suggestion]

✅ Positive Observations
• [Well-implemented patterns or good practices]

📋 Recommendations (Prioritized)
1. [Priority 1 action with file location]
2. [Priority 2 action with file location]
3. [Priority 3 action with file location]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Language-Specific Guidelines

### JavaScript/TypeScript
- ESLint compliance, TypeScript strict mode
- Proper async/await usage, promise handling
- React best practices (hooks, memo, keys)
- Modern ES6+ features usage

### Python
- PEP 8 compliance
- Type hints for functions
- List comprehensions vs loops
- Context managers for resources

### Java
- Google Java Style Guide
- Spring Boot best practices
- Exception handling patterns
- Stream API usage

### Go
- Effective Go guidelines
- Error handling patterns
- Goroutine and channel usage
- Interface design

## Review Checklist

Complete assessment of:
- [ ] Logic correctness for all code paths
- [ ] Edge cases and error handling
- [ ] Input validation and sanitization
- [ ] Security best practices followed
- [ ] Performance considerations addressed
- [ ] Code is readable and maintainable
- [ ] Functions are focused and well-named
- [ ] Documentation is adequate
- [ ] Tests cover critical functionality
- [ ] No obvious code smells

## Best Practices

1. **Be Constructive**: Focus on improvement, not criticism
2. **Be Specific**: Point to exact lines and provide examples
3. **Prioritize**: Rank issues by severity and impact
4. **Educate**: Explain why something is an issue
5. **Acknowledge Good Code**: Highlight positive patterns
6. **Context Aware**: Respect the developer's intent and constraints
