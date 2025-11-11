---
name: test-automation
description: Auto-generate comprehensive test cases from requirements, user stories, or code. Use when user requests test generation, asks to create tests, wants test coverage for a feature, or needs test scenarios for requirements.
---

# Test Automation Skill

Automatically generate comprehensive, high-quality test cases from requirements, user stories, code, or feature descriptions.

## When to Use This Skill

Automatically invoke when the user:
- Requests test case generation
- Asks "generate tests" or "create test cases"
- Wants test coverage for a new feature
- Provides requirements and asks for test scenarios
- Asks "what should I test" or "test plan needed"
- Requests E2E, integration, or unit test creation

## Test Generation Process

Follow this systematic approach:

### 1. Requirements Analysis

#### Gather Context
- **Feature description**: What is being built?
- **User stories**: Who is the user and what do they want?
- **Acceptance criteria**: When is it done?
- **Technical specifications**: How is it implemented?
- **Dependencies**: What does it rely on?

#### Identify Test Levels
- **Unit tests**: Individual functions/methods
- **Integration tests**: Component interactions, API endpoints
- **E2E tests**: Complete user journeys
- **Visual tests**: UI appearance and behavior
- **Performance tests**: Load, stress, response times
- **Accessibility tests**: WCAG compliance

### 2. Test Scenario Design

#### Happy Path Scenarios
- **Primary flow**: Expected user behavior
- **Core functionality**: Main features working correctly
- **Positive test cases**: Valid inputs, expected outputs

#### Edge Cases
- **Boundary values**: Min/max limits, empty/null
- **Special characters**: Unicode, emoji, SQL chars
- **Unexpected inputs**: Wrong types, invalid formats
- **Concurrent operations**: Race conditions, locks

#### Error Scenarios
- **Invalid input**: Malformed data, type mismatches
- **Authorization failures**: Insufficient permissions
- **Network errors**: Timeouts, connection failures
- **Dependency failures**: Database down, API unavailable

#### Security Test Cases
- **Authentication**: Login, logout, session management
- **Authorization**: Role-based access control
- **Input validation**: SQL injection, XSS prevention
- **Data protection**: PII handling, encryption

### 3. Test Case Structure

For each test case, define:

```
Test ID: TEST-001
Title: User can successfully log in with valid credentials
Type: E2E
Priority: P0 (Critical)

Preconditions:
- User account exists in database
- User email is verified
- Application is running and accessible

Test Steps:
1. Navigate to login page
2. Enter valid email: "test@example.com"
3. Enter valid password: "SecurePass123!"
4. Click "Log In" button

Expected Result:
- User is redirected to dashboard
- Welcome message displays user's name
- Session token is stored
- No error messages displayed

Actual Result: [To be filled during execution]

Pass/Fail: [To be determined]

Test Data:
- Email: test@example.com
- Password: SecurePass123!

Notes:
- Test with multiple browsers (Chrome, Firefox, Safari)
- Verify session persistence after page refresh
```

### 4. Coverage Analysis

Ensure coverage across:

#### Functional Coverage
- [ ] All acceptance criteria tested
- [ ] All user stories covered
- [ ] All API endpoints tested
- [ ] All UI components validated

#### Code Coverage
- [ ] All functions have unit tests
- [ ] All branches covered
- [ ] All error handlers tested
- [ ] All integration points verified

#### User Journey Coverage
- [ ] All critical paths tested E2E
- [ ] All user roles tested
- [ ] All device types tested (mobile, tablet, desktop)
- [ ] All browsers tested (Chrome, Firefox, Safari)

## Output Format

Provide structured test plan:

```
🧪 AUTOMATED TEST PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Feature: [Feature Name]
📝 Description: [Brief description]
👤 User Story: [As a X, I want Y, so that Z]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 P0 Tests (Critical - Must Pass)
───────────────────────────────────

TEST-001: [Test Title]
Type: E2E
Steps:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
Expected: [Expected behavior]
Test Data: [Data needed]

TEST-002: [Test Title]
Type: Integration
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  P1 Tests (High Priority)
───────────────────────────────────

TEST-005: [Test Title]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 P2 Tests (Medium Priority)
───────────────────────────────────

TEST-010: [Test Title]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Coverage Summary
───────────────────────────────────

Functional Coverage:
  ✓ All acceptance criteria covered (5/5)
  ✓ All user stories covered (3/3)
  ✓ All API endpoints tested (8/8)

Test Types:
  • Unit Tests: 45 tests
  • Integration Tests: 12 tests
  • E2E Tests: 8 tests
  • Visual Tests: 5 tests
  • Accessibility Tests: 3 tests

Browser Coverage:
  • Chrome ✓
  • Firefox ✓
  • Safari ✓
  • Edge ✓

Device Coverage:
  • Desktop (1920x1080) ✓
  • Tablet (768x1024) ✓
  • Mobile (375x667) ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 Implementation Code Samples
───────────────────────────────────

[Provide actual test code in Playwright, Jest, pytest, etc.]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 Test Data Requirements
───────────────────────────────────

Users:
  - test.user@example.com (valid user)
  - admin@example.com (admin user)
  - invalid@example.com (non-existent user)

Database Fixtures:
  - Products table: 10 sample products
  - Orders table: 5 sample orders
  - Users table: 3 test users

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Test Framework Selection

### JavaScript/TypeScript

#### Playwright (E2E Tests)
```typescript
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test('should login successfully with valid credentials', async ({ page }) => {
    // Arrange
    await page.goto('/login');

    // Act
    await page.fill('[data-testid="email-input"]', 'test@example.com');
    await page.fill('[data-testid="password-input"]', 'SecurePass123!');
    await page.click('[data-testid="login-button"]');

    // Assert
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome-message"]')).toContainText('Welcome');
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', 'test@example.com');
    await page.fill('[data-testid="password-input"]', 'WrongPassword');
    await page.click('[data-testid="login-button"]');

    await expect(page.locator('[data-testid="error-message"]'))
      .toContainText('Invalid credentials');
  });
});
```

#### Jest (Unit/Integration Tests)
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = {
        email: 'newuser@example.com',
        password: 'SecurePass123!',
        name: 'Test User'
      };

      // Act
      const user = await userService.createUser(userData);

      // Assert
      expect(user).toBeDefined();
      expect(user.email).toBe(userData.email);
      expect(user.password).not.toBe(userData.password); // Should be hashed
      expect(user.id).toBeDefined();
    });

    it('should throw error for duplicate email', async () => {
      const userData = { email: 'existing@example.com', password: 'Pass123!' };

      await expect(userService.createUser(userData))
        .rejects
        .toThrow('Email already exists');
    });
  });
});
```

### Python

#### Pytest (Unit/Integration Tests)
```python
import pytest
from myapp.services import UserService

class TestUserService:
    def test_create_user_with_valid_data(self, db_session):
        # Arrange
        user_service = UserService(db_session)
        user_data = {
            'email': 'test@example.com',
            'password': 'SecurePass123!',
            'name': 'Test User'
        }

        # Act
        user = user_service.create_user(user_data)

        # Assert
        assert user is not None
        assert user.email == user_data['email']
        assert user.password != user_data['password']  # Should be hashed
        assert user.id is not None

    def test_create_user_with_duplicate_email_raises_error(self, db_session):
        user_service = UserService(db_session)
        user_data = {'email': 'existing@example.com', 'password': 'Pass123!'}

        with pytest.raises(ValueError, match='Email already exists'):
            user_service.create_user(user_data)
```

### Java

#### JUnit 5 + Mockito
```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    @DisplayName("Should create user with valid data")
    void shouldCreateUserWithValidData() {
        // Arrange
        UserDTO userData = new UserDTO("test@example.com", "SecurePass123!", "Test User");
        User mockUser = new User(1L, userData.getEmail(), "hashedPassword", userData.getName());
        when(userRepository.save(any(User.class))).thenReturn(mockUser);

        // Act
        User result = userService.createUser(userData);

        // Assert
        assertNotNull(result);
        assertEquals(userData.getEmail(), result.getEmail());
        assertNotEquals(userData.getPassword(), result.getPassword()); // Should be hashed
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    @DisplayName("Should throw exception for duplicate email")
    void shouldThrowExceptionForDuplicateEmail() {
        UserDTO userData = new UserDTO("existing@example.com", "Pass123!", "Test");
        when(userRepository.existsByEmail(userData.getEmail())).thenReturn(true);

        assertThrows(DuplicateEmailException.class,
            () -> userService.createUser(userData));
    }
}
```

## Test Data Management

### Factory Pattern
```typescript
// test/factories/user.factory.ts
export class UserFactory {
  static create(overrides?: Partial<User>): User {
    return {
      id: faker.string.uuid(),
      email: faker.internet.email(),
      name: faker.person.fullName(),
      password: 'SecurePass123!',
      createdAt: new Date(),
      ...overrides
    };
  }

  static createMany(count: number): User[] {
    return Array.from({ length: count }, () => this.create());
  }
}

// Usage in tests
const user = UserFactory.create({ email: 'specific@example.com' });
const users = UserFactory.createMany(10);
```

### Fixtures (Pytest)
```python
# conftest.py
@pytest.fixture
def test_user(db_session):
    user = User(
        email='test@example.com',
        password='hashed_password',
        name='Test User'
    )
    db_session.add(user)
    db_session.commit()
    yield user
    db_session.delete(user)
    db_session.commit()

@pytest.fixture
def test_users(db_session):
    users = [
        User(email=f'user{i}@example.com', password='hashed', name=f'User {i}')
        for i in range(10)
    ]
    db_session.add_all(users)
    db_session.commit()
    yield users
    for user in users:
        db_session.delete(user)
    db_session.commit()
```

## Best Practices

### Test Organization
- **One assertion per test** (guideline, not strict rule)
- **Arrange-Act-Assert pattern** for clarity
- **Descriptive test names** (should_doX_when_Y)
- **Independent tests** (no order dependencies)
- **Fast tests** (<100ms for unit tests)

### Test Data
- **Use factories** for test data generation
- **Minimal test data** (only what's needed)
- **Clean up after tests** (transaction rollback preferred)
- **Realistic data volumes** for performance tests

### Maintainability
- **DRY principle** (extract common setup to fixtures/helpers)
- **Page Object Model** for E2E tests
- **Test utilities** for repetitive operations
- **Clear error messages** for failures

### CI/CD Integration
- **Run on every PR** (unit + integration tests)
- **Run on merge** (E2E + visual tests)
- **Fail fast** (stop on first failure in CI)
- **Parallel execution** for speed

## Coverage Goals

- **Unit Tests**: ≥80% code coverage
- **Integration Tests**: ≥60% for critical paths
- **E2E Tests**: All critical user journeys
- **Visual Tests**: All UI components + critical pages
- **Accessibility Tests**: 100% of user-facing pages
- **Performance Tests**: All API endpoints

## Anti-Patterns to Avoid

- **Testing implementation details** (test behavior, not internals)
- **Flaky tests** (non-deterministic, time-dependent)
- **Slow tests** (use mocks, avoid real network/DB calls)
- **Brittle tests** (break on every refactor)
- **Testing frameworks** (don't test libraries, trust them)
- **Too many mocks** (prefer integration tests over heavy mocking)

## Continuous Improvement

After test execution:
- **Track flaky tests** and fix root causes
- **Monitor test duration** and optimize slow tests
- **Review coverage reports** and add missing tests
- **Refactor tests** alongside production code
- **Update tests** when requirements change
- **Learn from failures** and prevent regressions

---

**Remember**: Good tests are readable, maintainable, and provide confidence that the system works correctly.
