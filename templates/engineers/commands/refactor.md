**Purpose**: Code refactoring and quality improvement

---

## Command Execution
Execute: immediate. --plan→show plan first
Purpose: "Refactor [target] in $ARGUMENTS"

Improve code quality through refactoring while maintaining functionality. Focus on readability, maintainability, and reducing technical debt.

## Usage Examples
- `/refactor --file src/utils/helpers.js --extract-functions`
- `/refactor --directory src/components --dry-pattern`
- `/refactor --class UserService --solid-principles`
- `/refactor --smell "long-method" --complexity-threshold 10`

## Command-Specific Flags
--file: "Refactor specific file"
--directory: "Refactor all files in directory"
--class: "Refactor specific class or module"
--function: "Refactor specific function"
--smell: "Target specific code smell (long-method, large-class, etc)"
--extract-functions: "Break down long functions"
--extract-class: "Split large classes"
--dry-pattern: "Remove code duplication (Don't Repeat Yourself)"
--solid-principles: "Apply SOLID principles"
--design-patterns: "Suggest applicable design patterns"
--complexity-threshold: "Target functions above complexity threshold"
--rename: "Improve naming consistency"
--simplify: "Simplify complex logic"

## Refactoring Techniques

**Extract Method:**
```javascript
// Before: Long function
function processUserData(user) {
    // 50 lines of code...
}

// After: Focused functions
function processUserData(user) {
    const validated = validateUser(user);
    const enriched = enrichUserData(validated);
    return saveUser(enriched);
}
```

**Extract Class:**
```javascript
// Before: God class
class UserManager {
    // User CRUD
    // Authentication
    // Email notifications
    // Audit logging
}

// After: Separated concerns
class UserRepository { /* CRUD */ }
class AuthService { /* Authentication */ }
class NotificationService { /* Emails */ }
class AuditLogger { /* Logging */ }
```

**Replace Conditional with Polymorphism:**
```javascript
// Before: Switch statements
if (type === 'admin') { /* admin logic */ }
else if (type === 'user') { /* user logic */ }

// After: Polymorphism
class Admin extends User { /* admin logic */ }
class RegularUser extends User { /* user logic */ }
```

**Introduce Parameter Object:**
```javascript
// Before: Long parameter list
function createUser(name, email, age, address, phone) {}

// After: Parameter object
function createUser(userData) {}
```

## Code Smells Detected

**Long Method:**
- Symptom: Function over 30 lines
- Fix: Extract smaller functions
- Benefit: Easier to understand and test

**Large Class:**
- Symptom: Class with many responsibilities
- Fix: Split into focused classes
- Benefit: Single Responsibility Principle

**Duplicated Code:**
- Symptom: Similar code in multiple places
- Fix: Extract to shared function/utility
- Benefit: DRY principle, easier maintenance

**Long Parameter List:**
- Symptom: Function with 5+ parameters
- Fix: Parameter object or builder pattern
- Benefit: Easier to call, extend

**Data Clumps:**
- Symptom: Same group of data items together
- Fix: Create a class or type
- Benefit: Cohesion, type safety

**Feature Envy:**
- Symptom: Method uses another class's data more than its own
- Fix: Move method to appropriate class
- Benefit: Better encapsulation

## Refactoring Process

**1. Ensure Test Coverage:**
- Write tests if missing
- Verify current behavior
- Establish safety net

**2. Plan Refactoring:**
- Identify code smells
- Prioritize by impact
- Plan incremental steps

**3. Refactor in Small Steps:**
- One change at a time
- Run tests after each step
- Commit working state

**4. Verify Improvements:**
- All tests still passing
- Complexity metrics improved
- Code more readable

## Output Format

The refactor command provides:
1. **Code Smell Analysis**: What issues exist
2. **Complexity Metrics**: Current vs target metrics
3. **Refactoring Plan**: Step-by-step approach
4. **Code Examples**: Before and after comparisons
5. **Testing Strategy**: How to verify safety
6. **Benefit Analysis**: Expected improvements

## Safety Principles

**Always:**
- Have test coverage before refactoring
- Make small, incremental changes
- Run tests after each change
- Commit working states frequently

**Never:**
- Mix refactoring with feature additions
- Refactor without tests
- Make large changes at once
- Change external behavior

## Metrics Tracking

**Before Refactoring:**
- Cyclomatic Complexity
- Lines of Code
- Number of Parameters
- Class/Function Count
- Duplication Percentage

**After Refactoring:**
- Complexity reduced by X%
- Code more modular
- Better test coverage
- Improved maintainability score
