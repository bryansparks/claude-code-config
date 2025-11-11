---
name: unit-test-generator
description: Automatic unit test generation with TDD workflow support, test coverage analysis, and real-time test running. Auto-triggers when new code is written. Generates complete test suites with mocks, fixtures, and edge cases for JavaScript, TypeScript, Python, Java, and Go.
---

# Unit Test Generator Skill

Automatically generate comprehensive unit tests with TDD workflow support, coverage analysis, and quality assessment. Proactively triggers when new functions or classes are created.

## When to Use This Skill

**Automatically invoke when:**
- User writes new function or class (PROACTIVE)
- User modifies existing function (suggest test updates)
- User requests "write tests" or "generate tests"
- File is saved and lacks corresponding test file
- Test coverage drops below 80%
- User mentions TDD, "red-green-refactor", or unit testing

## Test-Driven Development (TDD) Workflow

### Red-Green-Refactor Cycle

```
1. RED   → Write failing test first
2. GREEN → Write minimal code to pass
3. REFACTOR → Improve code while keeping tests green
```

**TDD Support:**
```typescript
// Step 1: RED - Write test first (fails because function doesn't exist)
describe('calculateDiscount', () => {
  it('should apply 10% discount to orders over $100', () => {
    expect(calculateDiscount(150)).toBe(135);
  });
});

// Step 2: GREEN - Write minimal implementation
function calculateDiscount(amount: number): number {
  return amount > 100 ? amount * 0.9 : amount;
}

// Step 3: REFACTOR - Improve code quality
function calculateDiscount(amount: number, threshold = 100, rate = 0.1): number {
  if (amount <= 0) throw new Error('Amount must be positive');
  return amount > threshold ? amount * (1 - rate) : amount;
}

// Update tests for refactored code
describe('calculateDiscount', () => {
  it('should apply 10% discount to orders over $100', () => {
    expect(calculateDiscount(150)).toBe(135);
  });

  it('should not apply discount to orders under $100', () => {
    expect(calculateDiscount(50)).toBe(50);
  });

  it('should throw error for negative amounts', () => {
    expect(() => calculateDiscount(-10)).toThrow('Amount must be positive');
  });

  it('should support custom discount rates', () => {
    expect(calculateDiscount(200, 100, 0.2)).toBe(160);
  });
});
```

## Automatic Test Generation

### TypeScript/JavaScript (Jest/Vitest)

```typescript
// Source: src/services/userService.ts
export class UserService {
  constructor(private db: Database) {}

  async createUser(userData: CreateUserDTO): Promise<User> {
    // Validate email
    if (!this.isValidEmail(userData.email)) {
      throw new ValidationError('Invalid email format');
    }

    // Check for existing user
    const existing = await this.db.users.findByEmail(userData.email);
    if (existing) {
      throw new ConflictError('Email already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(userData.password, 10);

    // Create user
    const user = await this.db.users.create({
      ...userData,
      password: hashedPassword
    });

    return user;
  }

  private isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}

// AUTO-GENERATED: tests/services/userService.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { UserService } from '@/services/userService';
import { Database } from '@/database';
import * as bcrypt from 'bcrypt';

// Mock dependencies
vi.mock('bcrypt');

describe('UserService', () => {
  let userService: UserService;
  let mockDb: jest.Mocked<Database>;

  beforeEach(() => {
    // Setup mocks
    mockDb = {
      users: {
        findByEmail: vi.fn(),
        create: vi.fn()
      }
    } as any;

    userService = new UserService(mockDb);
  });

  describe('createUser', () => {
    const validUserData = {
      email: 'test@example.com',
      password: 'SecurePass123!',
      name: 'Test User'
    };

    it('should create user with valid data', async () => {
      // Arrange
      const hashedPassword = 'hashed_password_here';
      const createdUser = { id: '123', ...validUserData, password: hashedPassword };

      mockDb.users.findByEmail.mockResolvedValue(null);
      (bcrypt.hash as jest.Mock).mockResolvedValue(hashedPassword);
      mockDb.users.create.mockResolvedValue(createdUser);

      // Act
      const result = await userService.createUser(validUserData);

      // Assert
      expect(result).toEqual(createdUser);
      expect(mockDb.users.findByEmail).toHaveBeenCalledWith(validUserData.email);
      expect(bcrypt.hash).toHaveBeenCalledWith(validUserData.password, 10);
      expect(mockDb.users.create).toHaveBeenCalledWith({
        ...validUserData,
        password: hashedPassword
      });
    });

    it('should throw ValidationError for invalid email', async () => {
      // Arrange
      const invalidData = { ...validUserData, email: 'invalid-email' };

      // Act & Assert
      await expect(userService.createUser(invalidData))
        .rejects
        .toThrow('Invalid email format');

      expect(mockDb.users.findByEmail).not.toHaveBeenCalled();
    });

    it('should throw ConflictError when email already exists', async () => {
      // Arrange
      mockDb.users.findByEmail.mockResolvedValue({ id: 'existing-user' } as any);

      // Act & Assert
      await expect(userService.createUser(validUserData))
        .rejects
        .toThrow('Email already exists');

      expect(mockDb.users.create).not.toHaveBeenCalled();
    });

    it('should hash password before storing', async () => {
      // Arrange
      const hashedPassword = 'hashed_password';
      mockDb.users.findByEmail.mockResolvedValue(null);
      (bcrypt.hash as jest.Mock).mockResolvedValue(hashedPassword);
      mockDb.users.create.mockResolvedValue({} as any);

      // Act
      await userService.createUser(validUserData);

      // Assert
      expect(bcrypt.hash).toHaveBeenCalledWith(validUserData.password, 10);
      expect(mockDb.users.create).toHaveBeenCalledWith(
        expect.objectContaining({ password: hashedPassword })
      );
    });

    // Edge Cases
    it('should handle database errors gracefully', async () => {
      // Arrange
      mockDb.users.findByEmail.mockRejectedValue(new Error('Database connection failed'));

      // Act & Assert
      await expect(userService.createUser(validUserData))
        .rejects
        .toThrow('Database connection failed');
    });

    it('should handle bcrypt errors gracefully', async () => {
      // Arrange
      mockDb.users.findByEmail.mockResolvedValue(null);
      (bcrypt.hash as jest.Mock).mockRejectedValue(new Error('Hashing failed'));

      // Act & Assert
      await expect(userService.createUser(validUserData))
        .rejects
        .toThrow('Hashing failed');
    });
  });

  describe('isValidEmail', () => {
    it('should return true for valid email addresses', () => {
      const validEmails = [
        'test@example.com',
        'user.name@example.co.uk',
        'user+tag@example.com',
        'user_123@sub.example.com'
      ];

      validEmails.forEach(email => {
        expect((userService as any).isValidEmail(email)).toBe(true);
      });
    });

    it('should return false for invalid email addresses', () => {
      const invalidEmails = [
        'invalid',
        '@example.com',
        'user@',
        'user name@example.com',
        'user@.com'
      ];

      invalidEmails.forEach(email => {
        expect((userService as any).isValidEmail(email)).toBe(false);
      });
    });
  });
});

// Coverage Report
// Statements   : 100% ( 15/15 )
// Branches     : 100% ( 8/8 )
// Functions    : 100% ( 3/3 )
// Lines        : 100% ( 14/14 )
```

### Python (pytest)

```python
# Source: src/services/user_service.py
from typing import Optional
import bcrypt
from src.models import User
from src.database import Database
from src.exceptions import ValidationError, ConflictError

class UserService:
    def __init__(self, db: Database):
        self.db = db

    def create_user(self, email: str, password: str, name: str) -> User:
        """Create a new user with hashed password."""
        # Validate email
        if not self._is_valid_email(email):
            raise ValidationError("Invalid email format")

        # Check for existing user
        existing = self.db.users.find_by_email(email)
        if existing:
            raise ConflictError("Email already exists")

        # Hash password
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

        # Create user
        user = self.db.users.create(email=email, password=hashed, name=name)
        return user

    @staticmethod
    def _is_valid_email(email: str) -> bool:
        import re
        pattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$'
        return re.match(pattern, email) is not None

# AUTO-GENERATED: tests/services/test_user_service.py
import pytest
from unittest.mock import Mock, patch
from src.services.user_service import UserService
from src.models import User
from src.exceptions import ValidationError, ConflictError

@pytest.fixture
def mock_db():
    """Create mock database."""
    db = Mock()
    db.users = Mock()
    return db

@pytest.fixture
def user_service(mock_db):
    """Create UserService instance with mock database."""
    return UserService(mock_db)

class TestUserService:
    def test_create_user_with_valid_data(self, user_service, mock_db):
        """Should create user with valid data."""
        # Arrange
        user_data = {
            'email': 'test@example.com',
            'password': 'SecurePass123!',
            'name': 'Test User'
        }
        created_user = User(id=1, email=user_data['email'], name=user_data['name'])

        mock_db.users.find_by_email.return_value = None
        mock_db.users.create.return_value = created_user

        # Act
        with patch('bcrypt.hashpw', return_value=b'hashed_password'):
            result = user_service.create_user(**user_data)

        # Assert
        assert result == created_user
        mock_db.users.find_by_email.assert_called_once_with(user_data['email'])
        mock_db.users.create.assert_called_once()

    def test_create_user_raises_validation_error_for_invalid_email(
        self, user_service, mock_db
    ):
        """Should raise ValidationError for invalid email."""
        with pytest.raises(ValidationError, match="Invalid email format"):
            user_service.create_user('invalid-email', 'password', 'Name')

        mock_db.users.find_by_email.assert_not_called()

    def test_create_user_raises_conflict_error_when_email_exists(
        self, user_service, mock_db
    ):
        """Should raise ConflictError when email already exists."""
        mock_db.users.find_by_email.return_value = User(id=1, email='test@example.com')

        with pytest.raises(ConflictError, match="Email already exists"):
            user_service.create_user('test@example.com', 'password', 'Name')

        mock_db.users.create.assert_not_called()

    def test_create_user_hashes_password(self, user_service, mock_db):
        """Should hash password before storing."""
        mock_db.users.find_by_email.return_value = None
        mock_db.users.create.return_value = User(id=1, email='test@example.com')

        with patch('bcrypt.hashpw') as mock_hash:
            mock_hash.return_value = b'hashed_password'
            user_service.create_user('test@example.com', 'MyPassword', 'Name')

            mock_hash.assert_called_once()
            assert mock_hash.call_args[0][0] == b'MyPassword'

    @pytest.mark.parametrize('email', [
        'test@example.com',
        'user.name@example.co.uk',
        'user+tag@example.com'
    ])
    def test_is_valid_email_returns_true_for_valid_emails(self, user_service, email):
        """Should return True for valid email addresses."""
        assert user_service._is_valid_email(email) is True

    @pytest.mark.parametrize('email', [
        'invalid',
        '@example.com',
        'user@',
        'user name@example.com'
    ])
    def test_is_valid_email_returns_false_for_invalid_emails(
        self, user_service, email
    ):
        """Should return False for invalid email addresses."""
        assert user_service._is_valid_email(email) is False

# Coverage Report
# Name                              Stmts   Miss  Cover
# -----------------------------------------------------
# src/services/user_service.py        15      0   100%
```

### Java (JUnit 5 + Mockito)

```java
// Source: src/main/java/com/example/services/UserService.java
@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User createUser(CreateUserDTO dto) throws ValidationException, ConflictException {
        // Validate email
        if (!isValidEmail(dto.getEmail())) {
            throw new ValidationException("Invalid email format");
        }

        // Check for existing user
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new ConflictException("Email already exists");
        }

        // Hash password
        String hashedPassword = passwordEncoder.encode(dto.getPassword());

        // Create user
        User user = new User();
        user.setEmail(dto.getEmail());
        user.setPassword(hashedPassword);
        user.setName(dto.getName());

        return userRepository.save(user);
    }

    private boolean isValidEmail(String email) {
        String regex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        return email != null && email.matches(regex);
    }
}

// AUTO-GENERATED: src/test/java/com/example/services/UserServiceTest.java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    private CreateUserDTO validUserDTO;

    @BeforeEach
    void setUp() {
        validUserDTO = new CreateUserDTO(
            "test@example.com",
            "SecurePass123!",
            "Test User"
        );
    }

    @Test
    @DisplayName("Should create user with valid data")
    void shouldCreateUserWithValidData() throws Exception {
        // Arrange
        String hashedPassword = "hashed_password";
        User expectedUser = new User(1L, validUserDTO.getEmail(),
            hashedPassword, validUserDTO.getName());

        when(userRepository.existsByEmail(validUserDTO.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(validUserDTO.getPassword())).thenReturn(hashedPassword);
        when(userRepository.save(any(User.class))).thenReturn(expectedUser);

        // Act
        User result = userService.createUser(validUserDTO);

        // Assert
        assertNotNull(result);
        assertEquals(expectedUser.getEmail(), result.getEmail());
        verify(userRepository).existsByEmail(validUserDTO.getEmail());
        verify(passwordEncoder).encode(validUserDTO.getPassword());
        verify(userRepository).save(any(User.class));
    }

    @Test
    @DisplayName("Should throw ValidationException for invalid email")
    void shouldThrowValidationExceptionForInvalidEmail() {
        // Arrange
        CreateUserDTO invalidDTO = new CreateUserDTO("invalid-email", "password", "Name");

        // Act & Assert
        ValidationException exception = assertThrows(
            ValidationException.class,
            () -> userService.createUser(invalidDTO)
        );

        assertEquals("Invalid email format", exception.getMessage());
        verify(userRepository, never()).existsByEmail(anyString());
    }

    @Test
    @DisplayName("Should throw ConflictException when email exists")
    void shouldThrowConflictExceptionWhenEmailExists() {
        // Arrange
        when(userRepository.existsByEmail(validUserDTO.getEmail())).thenReturn(true);

        // Act & Assert
        ConflictException exception = assertThrows(
            ConflictException.class,
            () -> userService.createUser(validUserDTO)
        );

        assertEquals("Email already exists", exception.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    @DisplayName("Should hash password before storing")
    void shouldHashPasswordBeforeStoring() throws Exception {
        // Arrange
        String hashedPassword = "hashed_password";
        when(userRepository.existsByEmail(any())).thenReturn(false);
        when(passwordEncoder.encode(validUserDTO.getPassword())).thenReturn(hashedPassword);
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        // Act
        userService.createUser(validUserDTO);

        // Assert
        verify(passwordEncoder).encode(validUserDTO.getPassword());
        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userRepository).save(userCaptor.capture());
        assertEquals(hashedPassword, userCaptor.getValue().getPassword());
    }

    @ParameterizedTest
    @ValueSource(strings = {
        "test@example.com",
        "user.name@example.co.uk",
        "user+tag@example.com"
    })
    @DisplayName("Should validate correct email formats")
    void shouldValidateCorrectEmailFormats(String email) {
        CreateUserDTO dto = new CreateUserDTO(email, "password", "Name");
        when(userRepository.existsByEmail(email)).thenReturn(false);
        when(passwordEncoder.encode(any())).thenReturn("hashed");
        when(userRepository.save(any())).thenReturn(new User());

        assertDoesNotThrow(() -> userService.createUser(dto));
    }

    @ParameterizedTest
    @ValueSource(strings = {"invalid", "@example.com", "user@", "user name@example.com"})
    @DisplayName("Should reject invalid email formats")
    void shouldRejectInvalidEmailFormats(String email) {
        CreateUserDTO dto = new CreateUserDTO(email, "password", "Name");

        assertThrows(ValidationException.class, () -> userService.createUser(dto));
    }
}

// Coverage: 100% (15/15 lines, 8/8 branches)
```

## Test Coverage Analysis

```
📊 TEST COVERAGE REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Coverage: 84% (Target: ≥80%) ✓

By Category:
  • Statements:  856/1000  (85.6%) ✓
  • Branches:    142/180   (78.9%) ⚠️
  • Functions:   98/110    (89.1%) ✓
  • Lines:       842/995   (84.6%) ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 UNCOVERED CODE (Prioritized)

[1] src/services/paymentService.ts
    Coverage: 45% (High Priority - handles money)
    Missing Tests:
      • Line 23-28: Refund logic
      • Line 45-50: Fraud detection
      • Line 78-82: Error handling

[2] src/utils/validators.ts
    Coverage: 68% (Medium Priority)
    Missing Tests:
      • Line 15-18: Credit card validation
      • Line 34-36: Phone number formats

[3] src/api/webhooks.ts
    Coverage: 72% (Medium Priority)
    Missing Tests:
      • Line 56-60: Signature verification
      • Line 89-92: Retry logic

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ WELL-TESTED MODULES

  • src/services/userService.ts: 100%
  • src/services/authService.ts: 98%
  • src/utils/email.ts: 95%
  • src/api/users.ts: 92%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 COVERAGE GOALS

  Current → Target:
    • Statements: 85.6% → 90%
    • Branches:   78.9% → 85%
    • Functions:  89.1% → 95%

  Estimated Effort: Add 25 test cases (8 hours)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Automatic Test Running

### Watch Mode Configuration

```json
// package.json
{
  "scripts": {
    "test": "vitest",
    "test:watch": "vitest --watch",
    "test:coverage": "vitest --coverage",
    "test:ui": "vitest --ui"
  }
}

// vitest.config.ts
export default defineConfig({
  test: {
    watch: true,  // Auto-run tests on file changes
    coverage: {
      reporter: ['text', 'json', 'html'],
      lines: 80,
      functions: 80,
      branches: 80,
      statements: 80
    }
  }
});
```

### Pre-commit Hook Integration

```bash
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

echo "🧪 Running tests before commit..."

# Run tests
npm test -- --run --reporter=verbose

# Check if tests passed
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Commit aborted."
  exit 1
fi

echo "✅ All tests passed!"
```

## Test Quality Assessment

```
🏆 TEST QUALITY SCORE: 88/100 (Excellent)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Test Coverage:        95/100
  • Statement Coverage: 95%
  • Branch Coverage: 88%
  • Function Coverage: 98%

✓ Test Reliability:     90/100
  • Flaky Tests: 2/450 (0.4%)
  • Test Execution Time: 8.2s (Target: <10s)
  • Consistent Pass Rate: 99.5%

✓ Test Maintainability: 85/100
  • Test Code Duplication: 3.2%
  • Avg Test Length: 28 LOC (Good)
  • Proper Use of Mocks: 92%

⚠️ Test Comprehensiveness: 78/100
  • Edge Cases Covered: 75%
  • Error Scenarios: 85%
  • Integration Points: 70%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommendations:
1. Add 15 edge case tests
2. Increase integration test coverage
3. Fix 2 flaky tests (identify and stabilize)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Output Format

```
🧪 UNIT TEST GENERATION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Test File Created:
   tests/services/userService.test.ts

✓ Tests Generated: 12
✓ Coverage: 100% (15/15 statements, 8/8 branches)
✓ Execution Time: 145ms
✓ All Tests Passing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 GENERATED TEST CASES

Happy Path (3 tests):
  ✓ should create user with valid data
  ✓ should hash password before storing
  ✓ should return created user object

Error Cases (5 tests):
  ✓ should throw ValidationError for invalid email
  ✓ should throw ConflictError when email exists
  ✓ should handle database errors gracefully
  ✓ should handle bcrypt errors gracefully
  ✓ should validate all required fields

Edge Cases (4 tests):
  ✓ should handle Unicode characters in name
  ✓ should trim whitespace from email
  ✓ should reject email with only spaces
  ✓ should handle very long names (>255 chars)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 TDD WORKFLOW READY

Next Steps:
  1. Review generated tests
  2. Run: npm test -- userService
  3. Modify implementation if tests fail
  4. Refactor while keeping tests green

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Best Practices

1. **Arrange-Act-Assert**: Clear test structure
2. **One Assertion Per Test**: Focused tests
3. **Descriptive Names**: Test name explains what's tested
4. **Independent Tests**: No test dependencies
5. **Mock External Dependencies**: Isolate unit under test
6. **Test Edge Cases**: Not just happy path
7. **Fast Tests**: <100ms per unit test
8. **Clean Up**: Reset mocks, clear data after tests

---

**Remember**: Good tests are your safety net - they give you confidence to refactor and prevent regressions. Write tests first (TDD) or immediately after writing code.
