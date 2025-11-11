# How to Use Skills

**Auto-invoked workflow assistance that activates based on what you're doing**

## What Are Skills?

**Skills** are intelligent workflow templates that automatically activate when you're performing specific development tasks. Think of them as "smart assistants" that recognize what you're trying to do and provide structured guidance to help you do it well.

**Key characteristics:**
- **Auto-Invoked**: Activate automatically based on your requests (you don't call them)
- **Workflow Guidance**: Provide step-by-step processes and checklists
- **Structured Output**: Consistent, formatted responses with clear next steps
- **Proactive**: Some skills activate when you write code (before you even ask)
- **Context-Aware**: Understand your intent and adapt to your specific situation

**You don't need to memorize trigger words** - just work naturally, and skills activate when relevant.

---

## How Skills Work

### Automatic Activation

Skills activate automatically based on:
1. **What you say**: Keywords and intent in your messages
2. **What you're doing**: Code you write or files you modify
3. **What's missing**: When tests or documentation are needed

**Example Flow:**
```
You: "Review my authentication code"

Behind the scenes:
→ Claude recognizes: code review request
→ Activates: code-review skill
→ Provides: Structured review with security analysis, best practices, recommendations

You see:
🔍 CODE REVIEW RESULTS with specific findings
```

### Proactive Activation

Some skills are **proactive** - they activate before you ask:

```
You: *Writes a new function*
function processPayment(amount, card) { ... }

Behind the scenes:
→ Claude detects: new function without tests
→ Activates: unit-test-generator skill (PROACTIVE)
→ Suggests: "I notice you wrote processPayment without tests. Should I generate tests?"

You see:
🧪 TEST GENERATION SUGGESTION
```

---

## Engineer Skills (8 total)

### 1. 🔍 Code Review
**File**: `personas/engineer/skills/code-review.md`

**What it does:**
Performs comprehensive code review analyzing quality, security, performance, and best practices.

**Auto-activates when you:**
- Say "review my code" or "can you review this"
- Ask for feedback on pull requests or changes
- Request quality assessment before committing
- Ask about code improvements or best practices

**Example prompts:**
- "Review my authentication implementation"
- "Can you review this API endpoint for security?"
- "Check this code before I commit"
- "Give me feedback on these changes"

**What you get:**
```
🔍 CODE REVIEW RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⛔ Critical Issues (P0) - Must Fix
• [File:Line] SQL injection vulnerability
  Impact: Database could be compromised
  Fix: Use parameterized queries instead of string interpolation

⚠️  High Priority (P1) - Should Fix
• [File:Line] Missing input validation
• [File:Line] Password stored in plain text

📊 Code Quality Assessment
• Complexity: High (cyclomatic 15, recommend <10)
• Maintainability: Good (clear naming, good structure)
• Test Coverage: 65% (recommend 80%+)

🔐 Security Concerns
• User input not sanitized (XSS risk)
  Recommendation: Use DOMPurify or equivalent

⚡ Performance Opportunities
• N+1 query detected in user fetch loop
  Optimization: Use eager loading with .include()

✅ Positive Observations
• Excellent error handling with specific messages
• Good use of async/await patterns

📋 Recommendations (Prioritized)
1. Fix SQL injection in auth.ts:45 (CRITICAL)
2. Add input validation to all endpoints
3. Improve test coverage to 80%+
```

**Best for:**
- Before submitting pull requests
- After implementing new features
- When refactoring existing code
- Learning best practices in a new codebase

---

### 2. 🐛 Debug Analysis
**File**: `personas/engineer/skills/debug-analysis.md`

**What it does:**
Systematic root cause analysis using 5 Whys methodology with specific fix recommendations.

**Auto-activates when you:**
- Report bugs or errors
- Say "help me debug" or "why is this failing"
- Share error messages or stack traces
- Ask "what's wrong with this code"
- Describe unexpected behavior

**Example prompts:**
- "Help me debug this 500 error"
- "Why does this crash when uploading files?"
- "This function returns undefined, what's wrong?"
- "App freezes after 5 minutes, investigate why"

**What you get:**
```
🐛 DEBUG ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Problem: App crashes when uploading files >5MB

🔍 5 Whys Root Cause Analysis:
Why? → Memory limit exceeded
Why? → File loaded entirely into memory
Why? → Using Buffer to read complete file
Why? → No streaming implementation
Why? → Initial implementation assumed small files

🎯 Root Cause:
No streaming for large file uploads, entire file buffered in memory

✅ Immediate Fix:
// Before (causes crash)
const buffer = await file.arrayBuffer();
await processFile(buffer);

// After (streams data)
const stream = file.stream();
await processFileStream(stream);

🚀 Long-term Solutions:
1. Implement chunked upload (1MB chunks)
2. Add file size validation on frontend
3. Set appropriate memory limits (50MB)
4. Add progress indicators for user feedback

🧪 Regression Test:
test('handles large file uploads without crash', async () => {
  const largeFile = createMockFile(10_000_000); // 10MB
  await expect(uploadFile(largeFile)).resolves.not.toThrow();
});

📊 Related Areas to Check:
• Server memory configuration (Node.js --max-old-space-size)
• Frontend file size limits (validate before upload)
• Network timeout settings (increase for large uploads)
```

**Best for:**
- Investigating bugs and crashes
- Understanding error messages
- Finding root causes (not just symptoms)
- Preventing issues from recurring

---

### 3. ⚡ Performance Optimization
**File**: `personas/engineer/skills/performance-optimization.md`

**What it does:**
Identifies performance bottlenecks and provides specific optimization strategies with measurable improvements.

**Auto-activates when you:**
- Mention "slow", "performance", or "optimization"
- Say "this is taking too long"
- Ask how to make code faster
- Request profiling or benchmarking help

**Example prompts:**
- "This API call takes 5 seconds, optimize it"
- "Dashboard loads too slowly, what can I improve?"
- "How can I make this algorithm faster?"
- "Profile this code and find bottlenecks"

**What you get:**
```
⚡ PERFORMANCE OPTIMIZATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Performance: Dashboard loads in 8.2s
Target: <2s (75% improvement needed)

🐌 Bottlenecks Identified:

[1] N+1 Database Queries (4.2s)
Location: src/api/dashboard.ts:34
Problem: Loading users in loop (87 separate queries)

Fix:
// Before (slow)
for (const order of orders) {
  order.user = await db.users.findById(order.userId);
}

// After (fast)
const orders = await db.orders.findAll({
  include: [{ model: db.users }]
});

Expected Improvement: 4.2s → 0.3s (93% faster)

[2] Large JavaScript Bundle (2.1s)
Size: 2.3MB uncompressed
Problem: Loading all components upfront

Fix:
// Code splitting with React.lazy()
const Dashboard = lazy(() => import('./Dashboard'));
const Reports = lazy(() => import('./Reports'));

Expected Improvement: 2.1s → 0.4s (81% faster)

[3] Unoptimized Images (1.5s)
Problem: Loading high-res images (5MB each)

Fix:
• Use next-gen formats (WebP, AVIF)
• Lazy load images below fold
• Implement responsive images (<picture>)

Expected Improvement: 1.5s → 0.2s (87% faster)

[4] No Caching (0.4s repeated)
Problem: Same API calls on every page load

Fix:
// Add Redis cache with 5min TTL
const cached = await redis.get(`dashboard:${userId}`);
if (cached) return JSON.parse(cached);

Expected Improvement: Eliminates 0.4s on repeated loads

📊 Total Expected Improvement:
8.2s → 1.2s (85% faster) ✅ Exceeds target

🎯 Quick Wins (Do First):
1. Fix N+1 queries (4.2s → 0.3s) - 1 hour effort
2. Add Redis caching (saves 0.4s) - 2 hour effort

⏰ Longer Term:
3. Implement code splitting - 1 day effort
4. Optimize images - 1 day effort
```

**Best for:**
- When users complain about slowness
- Before launching to production
- Scaling to more users
- Meeting performance SLAs

---

### 4. 🔐 Security Analysis
**File**: `personas/engineer/skills/security-analysis.md`

**What it does:**
OWASP Top 10 security scanning, vulnerability detection, and remediation guidance.

**Auto-activates when you:**
- Mention "security", "vulnerability", or "OWASP"
- Ask "is this secure?"
- Request security audit or review
- Implement authentication/authorization

**Example prompts:**
- "Check this code for security vulnerabilities"
- "Is this login implementation secure?"
- "Audit this API for OWASP Top 10 issues"
- "How can I prevent SQL injection here?"

**What you get:**
```
🔐 SECURITY ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Security Score: 65/100 (Needs Improvement)

🔴 CRITICAL Vulnerabilities (Fix Immediately):

[1] SQL Injection (OWASP A03)
Location: src/api/users/search.ts:23
Severity: Critical (CVSS 9.8)

Vulnerable Code:
const query = `SELECT * FROM users WHERE name LIKE '%${searchTerm}%'`;
const results = await db.raw(query);

Impact: Attacker could:
• Read entire database
• Modify/delete data
• Execute arbitrary SQL

Fix (Parameterized Query):
const query = 'SELECT * FROM users WHERE name LIKE ?';
const results = await db.raw(query, [`%${searchTerm}%`]);

[2] Plaintext Password Storage (OWASP A02)
Location: src/auth/register.ts:45
Severity: Critical (CVSS 9.1)

Problem:
await db.users.create({
  email,
  password: password  // Stored in plaintext!
});

Fix:
const hashedPassword = await bcrypt.hash(password, 10);
await db.users.create({ email, password: hashedPassword });

🟠 HIGH Severity Issues:

[3] Missing Rate Limiting (OWASP A07)
Location: src/api/auth/login.ts
Risk: Brute force attacks on login endpoint

Fix: Add express-rate-limit
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5 // 5 attempts per window
});
app.post('/api/login', limiter, loginHandler);

🟡 MEDIUM Severity Issues:

[4] Weak CORS Configuration
Current: CORS set to '*' (allows any origin)
Fix: Specify allowed origins explicitly

📋 Remediation Priority:
1. Fix SQL injection (CRITICAL - 30 min)
2. Hash passwords (CRITICAL - 1 hour)
3. Add rate limiting (HIGH - 2 hours)
4. Fix CORS (MEDIUM - 30 min)

Estimated total effort: 4 hours
```

**Best for:**
- Before deploying to production
- After implementing authentication
- Regular security audits
- Compliance requirements (SOC2, HIPAA)

---

### 5. 🔌 API Design Review
**File**: `personas/engineer/skills/api-design-review.md`

**What it does:**
RESTful API design validation, OpenAPI compliance, versioning strategy review.

**Auto-activates when you:**
- Say "design an API" or "review this API"
- Ask about REST best practices
- Request OpenAPI/Swagger help
- Mention API versioning or endpoints

**Example prompts:**
- "Design a RESTful API for user management"
- "Review my API endpoints for best practices"
- "How should I version this API?"
- "Is this API design RESTful?"

**What you get:**
```
🔌 API DESIGN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Score: 78/100 (Good, Needs Improvement)

❌ CRITICAL Issues:

[1] Non-RESTful URL Structure
Current:  POST /api/createUser
Problem:  Verb in URL (not RESTful)

Fix:
POST /api/v1/users
Response: 201 Created
{
  "id": "123",
  "email": "user@example.com",
  "created_at": "2025-11-11T10:00:00Z"
}

[2] Missing Pagination
Endpoint: GET /api/users
Problem: Returns all users (could be millions)

Fix:
GET /api/v1/users?page=1&limit=20
Response:
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1234,
    "total_pages": 62
  },
  "links": {
    "first": "/api/v1/users?page=1&limit=20",
    "next": "/api/v1/users?page=2&limit=20",
    "last": "/api/v1/users?page=62&limit=20"
  }
}

⚠️  HIGH Priority:

[3] Inconsistent Error Responses
Current errors vary in format:
• {"error": "Not found"}
• {"message": "Invalid input"}
• "Server error"

Fix (Consistent Format):
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "User with ID 123 not found",
    "details": {
      "resource": "user",
      "id": "123"
    },
    "timestamp": "2025-11-11T10:00:00Z"
  }
}

✅ WELL DESIGNED:

• Proper HTTP status codes (200, 201, 404, 500)
• API versioning in URL (/api/v1/)
• JSON content type specified
• Authentication with JWT

📋 Recommended API Structure:

Users Resource:
GET    /api/v1/users           # List users (paginated)
POST   /api/v1/users           # Create user
GET    /api/v1/users/:id       # Get user by ID
PATCH  /api/v1/users/:id       # Update user (partial)
DELETE /api/v1/users/:id       # Delete user

Response Status Codes:
200 OK          - Successful GET, PATCH, DELETE
201 Created     - Successful POST
204 No Content  - Successful DELETE (no body)
400 Bad Request - Invalid input
401 Unauthorized - Missing/invalid auth
403 Forbidden   - Insufficient permissions
404 Not Found   - Resource doesn't exist
500 Server Error - Unexpected error

🎯 Next Steps:
1. Fix non-RESTful URLs (1 hour)
2. Add pagination to all list endpoints (2 hours)
3. Standardize error responses (1 hour)
4. Generate OpenAPI spec (use Swagger) (1 hour)
```

**Best for:**
- Designing new APIs
- Reviewing API specifications
- Ensuring consistency across endpoints
- Preparing for API documentation

---

### 6. ♿ Accessibility Development
**File**: `personas/engineer/skills/accessibility-development.md`

**What it does:**
WCAG 2.1/2.2 compliant code generation with accessible React/Vue/Angular components.

**Auto-activates when you:**
- Build UI components (forms, modals, navigation)
- Mention "accessibility", "a11y", or "WCAG"
- Ask "is this accessible?"
- Request keyboard navigation help

**Example prompts:**
- "Create an accessible modal dialog"
- "Make this form WCAG compliant"
- "Build an accessible dropdown menu"
- "How do I make this keyboard navigable?"

**What you get:**
```typescript
♿ ACCESSIBLE MODAL COMPONENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ WCAG 2.1 AA Compliant Modal Dialog

import { useEffect, useRef } from 'react';
import { createPortal } from 'react-dom';

export const AccessibleModal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children
}) => {
  const modalRef = useRef<HTMLDivElement>(null);
  const previousActiveElement = useRef<HTMLElement | null>(null);

  useEffect(() => {
    if (isOpen) {
      // 1. Store previously focused element
      previousActiveElement.current = document.activeElement as HTMLElement;

      // 2. Focus first focusable element in modal
      const firstFocusable = modalRef.current?.querySelector<HTMLElement>(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      firstFocusable?.focus();

      // 3. Trap focus within modal
      const handleTab = (e: KeyboardEvent) => {
        if (e.key !== 'Tab') return;

        const focusableElements = modalRef.current?.querySelectorAll<HTMLElement>(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );

        if (!focusableElements || focusableElements.length === 0) return;

        const first = focusableElements[0];
        const last = focusableElements[focusableElements.length - 1];

        if (e.shiftKey) {
          // Shift+Tab on first element -> focus last
          if (document.activeElement === first) {
            e.preventDefault();
            last.focus();
          }
        } else {
          // Tab on last element -> focus first
          if (document.activeElement === last) {
            e.preventDefault();
            first.focus();
          }
        }
      };

      // 4. Close on Escape key
      const handleEscape = (e: KeyboardEvent) => {
        if (e.key === 'Escape') onClose();
      };

      document.addEventListener('keydown', handleTab);
      document.addEventListener('keydown', handleEscape);

      // 5. Mark background as inert
      document.body.style.overflow = 'hidden';

      return () => {
        document.removeEventListener('keydown', handleTab);
        document.removeEventListener('keydown', handleEscape);
        document.body.style.overflow = '';

        // 6. Restore focus to previously focused element
        previousActiveElement.current?.focus();
      };
    }
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return createPortal(
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/50"
        onClick={onClose}
        aria-hidden="true"
      />

      {/* Modal */}
      <div
        ref={modalRef}
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-title"
        aria-describedby="modal-description"
        className="fixed inset-0 flex items-center justify-center p-4"
      >
        <div className="bg-white rounded-lg shadow-xl max-w-md w-full">
          {/* Header */}
          <div className="flex items-center justify-between p-6 border-b">
            <h2 id="modal-title" className="text-xl font-semibold">
              {title}
            </h2>
            <button
              onClick={onClose}
              aria-label="Close dialog"
              className="text-gray-500 hover:text-gray-700"
            >
              ×
            </button>
          </div>

          {/* Content */}
          <div id="modal-description" className="p-6">
            {children}
          </div>
        </div>
      </div>
    </>,
    document.body
  );
};

✅ ACCESSIBILITY FEATURES:
• role="dialog" and aria-modal="true" (announces as modal)
• aria-labelledby points to title (screen reader announces title)
• aria-describedby points to content (provides context)
• Focus trap (Tab/Shift+Tab cycles within modal)
• Escape key closes modal (keyboard users can exit)
• Focus management (restores focus when closed)
• Backdrop click closes modal (mouse users can exit)
• Background inert (can't interact with content behind)
• Close button has aria-label (screen readers know its purpose)

🎯 WCAG Success Criteria Met:
• 2.1.1 Keyboard (A) - All functions keyboard accessible
• 2.1.2 No Keyboard Trap (A) - Can escape with keyboard
• 2.4.3 Focus Order (A) - Logical focus sequence
• 2.4.7 Focus Visible (AA) - Focus indicators visible
• 4.1.2 Name, Role, Value (A) - Proper ARIA attributes
```

**Best for:**
- Building new UI components
- Making existing UIs accessible
- Ensuring keyboard navigation works
- Meeting WCAG compliance requirements

---

### 7. 📊 ISO Standards Compliance
**File**: `personas/engineer/skills/iso-standards-compliance.md`

**What it does:**
ISO/IEC 25010 quality model assessment with 0-100 scoring across 8 characteristics.

**Auto-activates when you:**
- Mention "ISO", "quality standards", or "quality assessment"
- Ask "how is the code quality?"
- Request quality metrics or scoring
- Prepare for audits or certification

**Example prompts:**
- "Assess code quality using ISO standards"
- "Rate this codebase for ISO compliance"
- "What's the quality score of this project?"
- "Prepare quality report for certification"

**What you get:**
```
📊 ISO/IEC 25010 QUALITY ASSESSMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overall Quality Score: 84/100 (GOOD)

Quality Characteristics:

1. Functional Suitability  ████████████████████  92/100 ✅
   • Functional completeness: Excellent
   • Functional correctness: Very good
   • Functional appropriateness: Good

   Strengths:
   • All user stories implemented
   • Requirements traceable to code
   • Edge cases handled

   Improvements:
   • Add validation for negative amounts

2. Performance Efficiency  ████████████████░░░░  82/100 ✅
   • Time behavior: Good (API p95: 387ms)
   • Resource utilization: Good (CPU: 45%, Mem: 62%)
   • Capacity: Acceptable (handles 500 concurrent users)

   Improvements:
   • Optimize database queries (N+1 detected)
   • Implement caching (reduce API calls 40%)

3. Compatibility  ████████████████░░░░  82/100 ✅
   • Co-existence: Excellent (no port conflicts)
   • Interoperability: Good (REST API, OpenAPI spec)

   Strengths:
   • Works with all major browsers
   • Mobile responsive

4. Usability  ████████████████░░░░  81/100 ✅
   • User error protection: Good
   • Aesthetics: Very good
   • Accessibility: Good (WCAG AA: 93%)

   Improvements:
   • Add loading indicators
   • Improve error messages (be specific)

5. Reliability  █████████████████░░░  87/100 ✅
   • Maturity: Good (low defect rate: 0.4/KLOC)
   • Availability: Excellent (uptime: 99.7%)
   • Fault tolerance: Good (graceful degradation)
   • Recoverability: Very good (auto-retry, fallbacks)

6. Security  █████████████████░░░  85/100 ✅
   • Confidentiality: Excellent (encryption at rest/transit)
   • Integrity: Good (input validation, checksums)
   • Authentication: Very good (JWT, MFA available)

   Concerns:
   • Rate limiting not implemented (add it)
   • Some API endpoints lack authorization checks

7. Maintainability  ███████████████░░░░░  76/100 ⚠️
   • Modularity: Good (clear separation)
   • Reusability: Fair (some duplication)
   • Testability: Good (test coverage: 87%)
   • Modifiability: Fair (high coupling in places)

   Issues:
   • Technical debt: 280 hours (reduce to <150h)
   • Code complexity: 8 functions >15 cyclomatic
   • Duplication: 4.2% (target: <3%)

8. Portability  ████████████████░░░░  79/100 ✅
   • Adaptability: Good (config-driven)
   • Installability: Excellent (Docker, one-command)
   • Replaceability: Good (standard interfaces)

🎯 TOP 5 IMPROVEMENT PRIORITIES:

1. Reduce Technical Debt (280h → 150h)
   Impact: HIGH
   Effort: 6 weeks
   • Refactor auth module (80h debt)
   • Remove unused code (40h)
   • Update deprecated dependencies (60h)

2. Improve Accessibility (93% → 98% WCAG)
   Impact: HIGH
   Effort: 3 weeks
   • Fix keyboard navigation gaps
   • Add ARIA labels to custom components
   • Improve color contrast (3 violations)

3. Add Rate Limiting
   Impact: HIGH (security risk)
   Effort: 2 days
   • Implement express-rate-limit
   • Set limits: 100 req/15min per IP

4. Optimize Database Queries
   Impact: MEDIUM (performance)
   Effort: 2 weeks
   • Fix N+1 queries (12 locations)
   • Add missing indexes (5 tables)
   • Implement query caching

5. Reduce Code Duplication
   Impact: MEDIUM (maintainability)
   Effort: 1 week
   • Extract common patterns (5 modules)
   • Create shared utilities

📈 PROJECTED IMPROVEMENT:
After implementing top 3 priorities: 84 → 89/100
```

**Best for:**
- Quality audits and reviews
- Certification preparation
- Measuring improvement over time
- Identifying quality gaps

---

### 8. 🧪 Unit Test Generator
**File**: `personas/engineer/skills/unit-test-generator.md`

**What it does:**
Automatic test generation with TDD workflow, coverage analysis, and test quality scoring.

**Auto-activates when you:**
- Write new functions or classes (PROACTIVE)
- Say "write tests" or "generate tests"
- File saved without corresponding test
- Test coverage drops below 80%
- Mention TDD or "red-green-refactor"

**Example prompts:**
- "Generate tests for this user service"
- "Write unit tests with TDD approach"
- "Create tests that cover all edge cases"
- "I wrote this function, create tests for it"

**What you get:**
```typescript
🧪 UNIT TEST GENERATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Source: src/services/userService.ts
Test File: tests/services/userService.test.ts

Generated Test Suite (45 tests, 100% coverage):

import { UserService } from '@/services/userService';
import { Database } from '@/database';
import * as bcrypt from 'bcrypt';

// Mock dependencies
jest.mock('@/database');
jest.mock('bcrypt');

describe('UserService', () => {
  let userService: UserService;
  let mockDb: jest.Mocked<Database>;

  beforeEach(() => {
    mockDb = {
      users: {
        findByEmail: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
        delete: jest.fn()
      }
    } as any;

    userService = new UserService(mockDb);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ========================================
  // HAPPY PATH TESTS
  // ========================================

  describe('createUser', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = {
        email: 'test@example.com',
        password: 'SecurePass123!',
        name: 'Test User'
      };

      mockDb.users.findByEmail.mockResolvedValue(null);
      (bcrypt.hash as jest.Mock).mockResolvedValue('hashed_password');
      mockDb.users.create.mockResolvedValue({
        id: '123',
        email: userData.email,
        name: userData.name,
        password: 'hashed_password'
      });

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result).toEqual({
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        password: 'hashed_password'
      });
      expect(mockDb.users.findByEmail).toHaveBeenCalledWith('test@example.com');
      expect(bcrypt.hash).toHaveBeenCalledWith('SecurePass123!', 10);
      expect(mockDb.users.create).toHaveBeenCalled();
    });
  });

  // ========================================
  // VALIDATION TESTS
  // ========================================

  describe('input validation', () => {
    it('should throw ValidationError for invalid email', async () => {
      const invalidData = { email: 'invalid-email', password: 'Pass123!' };

      await expect(userService.createUser(invalidData))
        .rejects.toThrow('Invalid email format');
    });

    it('should throw ValidationError for weak password', async () => {
      const weakPasswordData = { email: 'test@example.com', password: '123' };

      await expect(userService.createUser(weakPasswordData))
        .rejects.toThrow('Password must be at least 8 characters');
    });

    it('should throw ValidationError for missing name', async () => {
      const missingNameData = { email: 'test@example.com', password: 'Pass123!' };

      await expect(userService.createUser(missingNameData))
        .rejects.toThrow('Name is required');
    });
  });

  // ========================================
  // EDGE CASES
  // ========================================

  describe('edge cases', () => {
    it('should handle email with special characters', async () => {
      const specialEmail = 'user+tag@example.co.uk';
      mockDb.users.findByEmail.mockResolvedValue(null);

      await expect(userService.createUser({
        email: specialEmail,
        password: 'Pass123!',
        name: 'User'
      })).resolves.not.toThrow();
    });

    it('should handle very long names (255 chars)', async () => {
      const longName = 'A'.repeat(255);
      mockDb.users.findByEmail.mockResolvedValue(null);

      const result = await userService.createUser({
        email: 'test@example.com',
        password: 'Pass123!',
        name: longName
      });

      expect(result.name).toBe(longName);
    });

    it('should reject names longer than 255 chars', async () => {
      const tooLongName = 'A'.repeat(256);

      await expect(userService.createUser({
        email: 'test@example.com',
        password: 'Pass123!',
        name: tooLongName
      })).rejects.toThrow('Name must be less than 255 characters');
    });
  });

  // ========================================
  // ERROR HANDLING
  // ========================================

  describe('error handling', () => {
    it('should throw ConflictError if email already exists', async () => {
      mockDb.users.findByEmail.mockResolvedValue({ id: '456', email: 'test@example.com' });

      await expect(userService.createUser({
        email: 'test@example.com',
        password: 'Pass123!',
        name: 'User'
      })).rejects.toThrow('Email already exists');
    });

    it('should handle database errors gracefully', async () => {
      mockDb.users.create.mockRejectedValue(new Error('Database connection lost'));

      await expect(userService.createUser({
        email: 'test@example.com',
        password: 'Pass123!',
        name: 'User'
      })).rejects.toThrow('Failed to create user');
    });
  });

  // ... 35 more tests covering all scenarios ...
});

📊 TEST COVERAGE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Statements   : 100% (45/45)
Branches     : 100% (12/12)
Functions    : 100% (8/8)
Lines        : 100% (42/42)

✅ All paths covered
✅ All edge cases tested
✅ All error conditions tested

🎯 TEST QUALITY SCORE: 95/100
• Proper AAA pattern (Arrange-Act-Assert)
• Meaningful test descriptions
• Good use of mocks
• Edge cases covered
• Error handling tested

Improvement: Add integration tests for database interaction
```

**Best for:**
- After writing new code
- TDD development (write tests first)
- Improving test coverage
- Preventing regressions

---

## QA Skills (4 total)

### 1. 🤖 Test Automation
**File**: `personas/qa/skills/test-automation.md`

**What it does:**
Auto-generates comprehensive test cases from requirements, user stories, or code.

**Auto-activates when you:**
- Say "generate tests" or "create test cases"
- Ask "what should I test?"
- Provide requirements and need test scenarios
- Request E2E, integration, or unit test plans

**Example prompts:**
- "Generate test cases for user login"
- "Create E2E tests for the checkout flow"
- "What test scenarios do I need for this feature?"
- "Generate a test plan for this API"

**What you get:**
```
🤖 AUTOMATED TEST PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Feature: User Login System
📝 Description: Allow users to authenticate with email/password

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 P0 TESTS (Critical - Must Pass):

TEST-001: User can login with valid credentials
Type: E2E
Priority: P0

Preconditions:
• User account exists in database
• Email is verified
• Application is accessible

Steps:
1. Navigate to /login
2. Enter valid email: "user@example.com"
3. Enter valid password: "SecurePass123!"
4. Click "Login" button

Expected Result:
• Redirected to /dashboard
• Session token stored in cookies
• User profile displayed
• Welcome message shown

TEST-002: Login fails with incorrect password
Type: E2E
Priority: P0

Steps:
1. Navigate to /login
2. Enter valid email: "user@example.com"
3. Enter wrong password: "WrongPass456!"
4. Click "Login" button

Expected Result:
• Remain on /login page
• Error message: "Invalid email or password"
• Password field cleared
• Email field retained
• No session token created

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 P1 TESTS (High Priority):

TEST-003: Login prevents brute force attempts
TEST-004: Login redirects to original destination
TEST-005: Remember me checkbox works
TEST-006: Forgot password link navigates correctly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧪 EDGE CASES:

TEST-007: Login with email containing + symbol
TEST-008: Login with very long password (256 chars)
TEST-009: Login with Unicode characters in password
TEST-010: Login with whitespace in email (should trim)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔐 SECURITY TESTS:

TEST-011: Login rejects SQL injection attempts
TEST-012: Login prevents XSS in error messages
TEST-013: Rate limiting after 5 failed attempts
TEST-014: Session token has proper expiration

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 COVERAGE SUMMARY:
• Unit Tests: 15 tests (auth service, validation)
• Integration Tests: 8 tests (API endpoints, database)
• E2E Tests: 12 tests (full user journeys)
• Security Tests: 6 tests (OWASP checks)
• Performance Tests: 3 tests (response time, load)

Total: 44 tests

🎯 Estimated Execution Time:
• Unit: 30 seconds
• Integration: 2 minutes
• E2E: 8 minutes
• Total: ~11 minutes
```

**Best for:**
- Creating comprehensive test plans
- Ensuring full feature coverage
- Identifying edge cases
- Security test scenarios

---

### 2. ♿ Accessibility Audit
**File**: `personas/qa/skills/accessibility-audit.md`

**What it does:**
WCAG 2.1/2.2 compliance analysis with automated and manual testing guidance.

**Auto-activates when you:**
- Say "accessibility audit" or "check accessibility"
- Mention "WCAG", "a11y", or "screen reader"
- Ask "is this accessible?"
- Request keyboard navigation testing

**Example prompts:**
- "Audit this page for accessibility"
- "Check WCAG 2.1 AA compliance"
- "Is this form accessible to screen readers?"
- "Test keyboard navigation of this component"

**What you get:**
```
♿ ACCESSIBILITY AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Page: User Profile Form
Date: 2025-11-11
Standard: WCAG 2.1 Level AA

📊 OVERALL SCORE: 87/100 (Good)
🎯 COMPLIANCE: Partially Compliant

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 CRITICAL VIOLATIONS (Level A) - Must Fix:

[1] Missing Form Labels
Impact: Screen reader users cannot identify input fields
Location: <input type="email"> at line 45
Affected Users: Blind users using NVDA, JAWS, VoiceOver

Current Code:
<input type="email" placeholder="Enter email" />

Fix:
<label for="email">Email Address</label>
<input type="email" id="email" placeholder="Enter email" />

[2] Missing Alternative Text
Impact: Images have no description for screen readers
Location: Profile avatar at line 67
Affected Users: Blind users

Fix:
<img src="avatar.jpg" alt="User profile photo of John Doe" />

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟠 SERIOUS VIOLATIONS (Level AA) - Should Fix:

[3] Insufficient Color Contrast
Element: "Save" button
Current: #777 on #999 (2.1:1)
Required: 4.5:1 minimum (Level AA)
Affected Users: Users with low vision, color blindness

Fix: Change text to #000 (black) for 4.6:1 contrast
button { color: #000; background: #999; }

[4] Missing Focus Indicators
Impact: Keyboard users cannot see which element is focused
Location: All custom dropdown menus

Fix: Add visible focus styles
.dropdown:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟡 MODERATE ISSUES:

[5] Form Error Messages Not Associated
Fix: Use aria-describedby to link errors to inputs

[6] Page Landmark Structure Missing
Fix: Add <main>, <nav>, <header> semantic HTML

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ PASSING CRITERIA:

• Semantic HTML structure (h1, h2, p, etc.)
• Keyboard navigation works (Tab, Enter, Escape)
• Skip to main content link present
• Language attribute set (<html lang="en">)
• Page title is descriptive
• Headings in logical order (no skipped levels)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧪 MANUAL TESTING CHECKLIST:

Keyboard Navigation:
[ ] Tab key moves through all interactive elements
[ ] Shift+Tab moves backwards
[ ] Enter/Space activates buttons and links
[ ] Escape closes modals and dropdowns
[ ] Arrow keys navigate within components

Screen Reader Testing:
[ ] Test with NVDA (Windows)
[ ] Test with JAWS (Windows)
[ ] Test with VoiceOver (Mac/iOS)
[ ] All content is announced
[ ] Form labels are read correctly
[ ] Error messages are announced

Visual Testing:
[ ] 200% zoom still usable
[ ] High contrast mode works
[ ] No content disappears when CSS disabled

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 REMEDIATION PRIORITY:

1. Add form labels (CRITICAL - 30 min)
2. Add alt text to images (CRITICAL - 15 min)
3. Fix color contrast (SERIOUS - 1 hour)
4. Add focus indicators (SERIOUS - 1 hour)
5. Associate error messages (MODERATE - 30 min)

Total Effort: ~3.5 hours

📈 PROJECTED IMPROVEMENT: 87% → 98% compliance
```

**Best for:**
- Pre-launch accessibility checks
- WCAG compliance audits
- Improving user experience for disabled users
- Meeting legal requirements (ADA, Section 508)

---

### 3. 🔍 Bug Analysis
**File**: `personas/qa/skills/bug-analysis.md`

**What it does:**
Root cause analysis using 5 Whys with reproduction steps and regression tests.

**Auto-activates when you:**
- Report bugs or issues
- Say "investigate this bug" or "analyze this issue"
- Ask "why is this happening?"
- Request reproduction steps

**Example prompts:**
- "Analyze this login bug"
- "Users report payment failures, investigate"
- "Why does this crash intermittently?"
- "Create reproduction steps for this issue"

**What you get:**
```
🔍 BUG ANALYSIS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Bug ID: BUG-456
Title: Users cannot log in after password reset
Severity: HIGH (affects all users)
Priority: P0 (fix immediately)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 5 WHYS ROOT CAUSE ANALYSIS:

Problem: Users cannot log in after resetting password

Why? → New password is not accepted by login
Why? → Password hash doesn't match database
Why? → Password reset transaction not committing
Why? → Missing .commit() call in handler
Why? → Recent refactoring removed explicit commit

🎯 ROOT CAUSE:
Missing database commit in password reset handler
Location: src/auth/resetPassword.ts:67

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 REPRODUCTION STEPS:

Preconditions:
• User account exists with email: test@example.com
• User has access to email for reset link

Steps to Reproduce:
1. Navigate to /forgot-password
2. Enter email: test@example.com
3. Click "Reset Password"
4. Check email, click reset link
5. Enter new password: "NewPass123!"
6. Click "Update Password"
7. Navigate to /login
8. Enter email: test@example.com
9. Enter password: "NewPass123!"
10. Click "Login"

Expected Result:
• Successfully logged in
• Redirected to dashboard

Actual Result:
• Login fails with "Invalid password" error
• User cannot access account

Frequency: 100% reproducible

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ FIX:

Location: src/auth/resetPassword.ts:67

Before (Broken):
async function resetPassword(token: string, newPassword: string) {
  const user = await verifyResetToken(token);
  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await db.users.update(user.id, {
    password: hashedPassword
  });
  // Missing commit! Transaction not saved
}

After (Fixed):
async function resetPassword(token: string, newPassword: string) {
  const user = await verifyResetToken(token);
  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await db.users.update(user.id, {
    password: hashedPassword
  });
  await db.commit(); // ← Add this line
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧪 REGRESSION TEST:

// tests/auth/resetPassword.test.ts
describe('Password Reset', () => {
  it('should allow login with new password after reset', async () => {
    // Arrange
    const user = await createTestUser({
      email: 'test@example.com',
      password: 'OldPass123!'
    });
    const resetToken = await generateResetToken(user.email);

    // Act - Reset password
    await resetPassword(resetToken, 'NewPass123!');

    // Assert - Can login with new password
    const loginResult = await login('test@example.com', 'NewPass123!');
    expect(loginResult.success).toBe(true);

    // Assert - Cannot login with old password
    await expect(login('test@example.com', 'OldPass123!'))
      .rejects.toThrow('Invalid password');
  });

  it('should persist password change across sessions', async () => {
    const user = await createTestUser();
    const resetToken = await generateResetToken(user.email);

    await resetPassword(resetToken, 'NewPass123!');

    // Simulate server restart (clear cache)
    await clearCache();

    // Should still work after restart
    const loginResult = await login(user.email, 'NewPass123!');
    expect(loginResult.success).toBe(true);
  });
});

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 RELATED AREAS TO CHECK:

• All other transaction handlers (check for missing commits)
• Password change endpoint (verify commits properly)
• User deletion flow (ensure cascading deletes work)
• Email verification flow (check transaction handling)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 ACTION ITEMS:

1. Apply fix (add db.commit()) - 5 minutes
2. Write regression test - 30 minutes
3. Test fix in staging - 15 minutes
4. Deploy to production - 10 minutes
5. Monitor error logs for 24 hours
6. Audit other transaction handlers - 2 hours

Total Time to Resolution: ~3 hours
```

**Best for:**
- Understanding why bugs happen
- Creating clear reproduction steps
- Preventing similar bugs
- Documenting issues for team

---

### 4. 👁️ Visual Regression
**File**: `personas/qa/skills/visual-regression.md`

**What it does:**
UI change detection through screenshot comparison across browsers and devices.

**Auto-activates when you:**
- Say "visual regression" or "screenshot comparison"
- Ask "did the UI change?"
- Mention CSS changes or refactoring
- Request cross-browser visual testing

**Example prompts:**
- "Check for unintended UI changes"
- "Visual regression test after CSS update"
- "Compare screenshots before and after"
- "Test UI across different browsers"

**What you get:**
```typescript
👁️ VISUAL REGRESSION TEST SUITE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// tests/visual/homepage.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Homepage Visual Regression', () => {

  // Desktop viewport
  test('homepage matches baseline - desktop', async ({ page }) => {
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Mask dynamic content (timestamps, ads, random content)
    await page.addStyleTag({
      content: `
        [data-testid="timestamp"],
        [data-testid="advertisement"],
        .random-quote {
          visibility: hidden !important;
        }
      `
    });

    // Take screenshot and compare
    await expect(page).toHaveScreenshot('homepage-desktop.png', {
      maxDiffPixels: 100,      // Allow up to 100 pixels difference
      threshold: 0.2,           // 20% pixel difference threshold
      animations: 'disabled'    // Disable animations for consistency
    });
  });

  // Tablet viewport
  test('homepage matches baseline - tablet', async ({ page }) => {
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await expect(page).toHaveScreenshot('homepage-tablet.png');
  });

  // Mobile viewport
  test('homepage matches baseline - mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await expect(page).toHaveScreenshot('homepage-mobile.png');
  });
});

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 VISUAL REGRESSION RESULTS:

Test Run: 2025-11-11 10:00 UTC
Baseline: production-2025-11-01
Changes: CSS refactor in header component

✅ PASSED (No visual changes):
• Homepage - Desktop (0 pixel diff)
• About Page - Desktop (12 pixel diff - within threshold)
• Contact Page - Mobile (0 pixel diff)

⚠️  REVIEW NEEDED (Changes detected):
• Product Page - Desktop (234 pixel diff)
  Location: Header navigation
  Diff: Button spacing increased 5px
  Impact: Minor - intentional change from CSS refactor

❌ FAILED (Significant changes):
• Checkout Page - Desktop (5,847 pixel diff)
  Location: Payment form
  Diff: Form completely broken
  Impact: CRITICAL - payment form not rendering

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 DETAILED DIFF ANALYSIS:

Checkout Page Issues:
• Payment form CSS classes missing
• Submit button invisible (z-index issue)
• Input fields have no borders
• Error messages overlapping inputs

Root Cause: CSS refactor removed .payment-form styles

Fix Required:
// Add back missing styles in payment.css
.payment-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.payment-form input {
  border: 1px solid #ddd;
  padding: 0.5rem;
}

.payment-form button {
  z-index: 1;
  background: #0066cc;
  color: white;
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 NEXT STEPS:

1. Fix checkout page CSS (CRITICAL)
2. Re-run visual tests
3. Update baseline if intentional changes
4. Deploy to staging for manual review

🖼️  VIEW DIFFS:
• Checkout diff: tests/visual/__screenshots__/checkout-diff.png
• Interactive comparison: http://visual-diff-viewer.local/checkout
```

**Best for:**
- Catching unintended CSS changes
- Cross-browser compatibility testing
- Responsive design validation
- Preventing UI regressions

---

## Skills vs Subagents - When to Use What

| Situation | Use Skill | Use Subagent |
|-----------|-----------|--------------|
| **"Review my code"** | ✅ code-review skill | ✅ Code Reviewer subagent |
| **"Why is this broken?"** | ✅ debug-analysis skill | ✅ Debugger subagent |
| **"Generate tests"** | ✅ unit-test-generator skill | ✅ Test Automation Specialist |
| **"Build accessible modal"** | ✅ accessibility-development skill | ✅ Frontend/UX Engineer |
| **"Design an API"** | ✅ api-design-review skill | ✅ API Designer subagent |

**The difference:**
- **Skills** = Workflow guidance (checklists, processes, structured output)
- **Subagents** = Expert analysis (deep knowledge, specialized review)

**They work together:**
Both activate simultaneously to provide comprehensive assistance!

---

## Best Practices for Using Skills

### 1. Let Skills Activate Naturally

**Don't:**
```
"Invoke the code-review skill to review this code"
```

**Do:**
```
"Review this authentication code"
```

Skills activate automatically based on intent.

### 2. Provide Context

**Good:**
```
"Review this payment processing code for:
- PCI compliance
- Security vulnerabilities
- Error handling
- Test coverage"
```

**Better than:**
```
"Review this code"
```

### 3. Use Proactive Skills

Some skills are proactive (like unit-test-generator):
```
You: *Writes new function*

Claude: "I notice you wrote processPayment without tests.
Should I generate comprehensive unit tests?"
```

Trust these suggestions - they help catch issues early.

### 4. Iterate Based on Feedback

Skills provide actionable recommendations:
```
Skill: "Fix SQL injection at line 45"
You: "Apply that fix"
Skill: *Generates secure code*
```

### 5. Combine Multiple Skills

For complex tasks, multiple skills activate:
```
You: "Build and test a new user registration feature"

Activates:
1. accessibility-development (build accessible form)
2. security-analysis (check for vulnerabilities)
3. unit-test-generator (create tests)
4. code-review (final quality check)
```

---

## Summary

**You have 12 intelligent skills that activate automatically:**

### Engineer Skills (8):
1. **Code Review** - Quality, security, performance analysis
2. **Debug Analysis** - Root cause investigation with 5 Whys
3. **Performance Optimization** - Bottleneck identification and fixes
4. **Security Analysis** - OWASP Top 10 vulnerability scanning
5. **API Design Review** - RESTful design validation
6. **Accessibility Development** - WCAG-compliant component creation
7. **ISO Standards Compliance** - Quality assessment and scoring
8. **Unit Test Generator** - Automatic test creation with TDD

### QA Skills (4):
1. **Test Automation** - Comprehensive test case generation
2. **Accessibility Audit** - WCAG compliance checking
3. **Bug Analysis** - Root cause and reproduction steps
4. **Visual Regression** - UI change detection

**Key Benefits:**
- ✅ Auto-activate based on what you're doing
- ✅ Provide structured, actionable guidance
- ✅ Include checklists and templates
- ✅ Work together for complex tasks
- ✅ Proactively suggest improvements

**Remember:** Just work naturally - skills activate automatically when relevant. You don't need to memorize triggers or invoke them explicitly.

---

**Related Documentation:**
- [How to Use Subagents](HOW_TO_USE_SUBAGENTS.md) - Expert consultants for specialized analysis
- [Engineer Skills Training](ENGINEER_SKILLS_TRAINING.md) - Comprehensive training guide
- [Workflow Examples](WORKFLOW_EXAMPLES.md) - Skills in action with real scenarios
- [Skills System](../SKILLS.md) - Technical overview of the skills system
