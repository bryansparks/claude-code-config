# How to Use Subagents

**Specialized expert consultants for Engineers and QA personnel**

## What Are Subagents?

**Subagents** are specialized Claude instances with deep expertise in specific domains. Think of them as "expert consultants" that Claude automatically invokes to provide highly specialized analysis and recommendations.

**Key characteristics:**
- **Visual Identity**: Each has a unique emoji and output format (e.g., `[CODE-REVIEWER] 🔍`)
- **Deep Expertise**: Focused knowledge in a specific area
- **Structured Output**: Consistent, formatted responses
- **Automatic Invocation**: Claude calls them based on your request
- **Collaboration**: Work together with other subagents when needed

**You don't need to explicitly call them** - just ask your question naturally, and Claude will invoke the right expert.

---

## Engineer Subagents (9 total)

### 1. 🔍 Code Reviewer
**Location**: `personas/engineer/subagents/code-reviewer.md`

**Expertise:**
- SOLID principles & design patterns
- Code smells & complexity analysis (cyclomatic, cognitive)
- Security review (SQL injection, XSS, authentication)
- Performance review (Big O analysis, N+1 queries, caching)
- Test coverage analysis

**Example prompts:**
- "Review this authentication code for security issues"
- "Can you review my user service implementation?"
- "Check this code for quality and best practices"
- "Is this code maintainable and well-structured?"

**Output format:**
```
[CODE-REVIEWER] 🔍 Code Review Results
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Critical Issues (P0):
• [File:Line] - Detailed description
• Impact: [What breaks]
• Fix: [Specific recommendation]

High Priority (P1):
• [Issues with specific locations]

Security Concerns:
• [Vulnerability identified]
• [Recommendation]

Performance Opportunities:
• [Bottleneck identified]
• [Optimization suggestion]

Positive Observations:
• [Well-implemented patterns]

Recommendations:
1. [Priority 1 action]
2. [Priority 2 action]
```

---

### 2. 🐛 Debugger
**Location**: `personas/engineer/subagents/debugger.md`

**Expertise:**
- Root cause analysis (5 Whys methodology)
- Stack trace interpretation
- Error pattern recognition
- Debugging strategies (binary search, rubber duck, divide and conquer)
- Production issue investigation
- Log analysis and correlation

**Example prompts:**
- "Help me debug this error in the payment processing"
- "Why is this function failing intermittently?"
- "App crashes when uploading large files, what's wrong?"
- "Explain this stack trace and how to fix it"

**When to use:** Any time you have a bug, error, or unexpected behavior that needs investigation.

---

### 3. ⚡ Performance Optimizer
**Location**: `personas/engineer/subagents/performance-optimizer.md`

**Expertise:**
- Profiling and benchmarking
- Algorithm optimization (time & space complexity)
- Database query optimization (indexes, query plans)
- Caching strategies (Redis, CDN, in-memory)
- Memory leak detection and resolution
- Load testing and scalability analysis

**Example prompts:**
- "This API endpoint is slow, help me optimize it"
- "Dashboard loads in 8 seconds, too slow - what can I improve?"
- "How can I make this search algorithm faster?"
- "This database query is taking 5 seconds, optimize it"

**When to use:** When code is working but too slow, or you need to scale for more users.

---

### 4. 🔧 Refactorer
**Location**: `personas/engineer/subagents/refactorer.md`

**Expertise:**
- Code restructuring without breaking functionality
- Identifying and eliminating code smells
- Extracting methods, classes, and modules
- Dependency injection and inversion of control
- Design pattern application
- Legacy code modernization

**Example prompts:**
- "This code needs refactoring, it's too complex"
- "How can I improve the structure of this class?"
- "Refactor this 300-line function into smaller pieces"
- "Make this code more maintainable and testable"

**When to use:** When code works but is hard to understand, modify, or test.

---

### 5. 🌐 Backend Engineer
**Location**: `personas/engineer/subagents/backend-engineer.md`

**Expertise:**
- RESTful API design and implementation
- Database schema design (relational and NoSQL)
- Authentication/authorization (JWT, OAuth, sessions)
- Microservices architecture
- Message queues and async processing (RabbitMQ, Kafka)
- API versioning and deprecation strategies

**Example prompts:**
- "Design a backend API for a blogging platform"
- "Review my database schema for an e-commerce system"
- "How should I implement authentication for this API?"
- "Design a microservices architecture for order processing"

**When to use:** Designing or reviewing backend systems, APIs, or database schemas.

---

### 6. 🎨 Frontend/UX Engineer
**Location**: `personas/engineer/subagents/frontend-ux-engineer.md`

**Expertise:**
- React/Vue/Angular best practices
- Responsive design and mobile-first approach
- Component architecture and reusability
- State management (Redux, Context, Zustand)
- CSS optimization and methodology (BEM, CSS-in-JS)
- Web accessibility (a11y) and ARIA

**Example prompts:**
- "Build a React component for user profile editing"
- "Review my frontend component architecture"
- "Make this UI responsive for mobile devices"
- "How should I manage state in this React app?"

**When to use:** Building or reviewing frontend components, UI/UX, or client-side architecture.

---

### 7. 🔌 API Designer
**Location**: `personas/engineer/subagents/api-designer.md`

**Expertise:**
- RESTful API design principles and best practices
- GraphQL schema design and resolvers
- OpenAPI/Swagger specification writing
- API versioning strategies (URL, header, content negotiation)
- Error handling and HTTP status codes
- Rate limiting, pagination, and filtering

**Example prompts:**
- "Design a RESTful API for inventory management"
- "Review this API specification for best practices"
- "How should I version this API?"
- "Design the error responses for this API"

**When to use:** Designing new APIs or reviewing API specifications before implementation.

---

### 8. 🚀 DevOps
**Location**: `personas/engineer/subagents/devops.md`

**Expertise:**
- CI/CD pipeline design (GitHub Actions, GitLab CI, Jenkins)
- Docker containerization and optimization
- Kubernetes orchestration and deployment
- Infrastructure as Code (Terraform, CloudFormation)
- Monitoring and alerting (Prometheus, Grafana, DataDog)
- Deployment strategies (blue/green, canary, rolling)

**Example prompts:**
- "Set up CI/CD pipeline for this Node.js application"
- "Containerize this application with Docker"
- "Design Kubernetes deployment for high availability"
- "How should I monitor this microservices system?"

**When to use:** Setting up infrastructure, deployment pipelines, or DevOps workflows.

---

### 9. 🤖 AI/ML Engineer
**Location**: `personas/engineer/subagents/ai-ml-engineer.md`

**Expertise:**
- Machine learning model selection and architecture
- Data preprocessing and feature engineering
- Model training, evaluation, and hyperparameter tuning
- MLOps and model deployment
- Neural network architectures (CNNs, RNNs, Transformers)
- LLM integration and prompt engineering

**Example prompts:**
- "Implement a recommendation system for products"
- "Add sentiment analysis to this feedback system"
- "How should I structure this ML pipeline?"
- "Integrate an LLM for document summarization"

**When to use:** Adding AI/ML capabilities to your application or designing ML systems.

---

## QA Subagents (5 total)

### 1. 🤖 Test Automation Specialist
**Location**: `personas/qa/subagents/test-automation-specialist.md`

**Expertise:**
- Test framework selection (Jest, Vitest, Playwright, Cypress, pytest)
- Page Object Model (POM) pattern
- CI/CD test integration and optimization
- Test data management and fixtures
- Flaky test prevention and resolution
- Parallel test execution strategies

**Example prompts:**
- "Create test automation framework for this React app"
- "Generate E2E tests for the checkout flow"
- "How should I structure my test suite?"
- "Fix these flaky tests that fail intermittently"

**Output example:**
```yaml
Framework Recommendations:
  Unit Testing:
    Framework: Vitest
    Reason: Fast, native ESM support, Vite integration

  E2E Testing:
    Framework: Playwright
    Reason: Cross-browser, auto-wait, robust selectors

  API Testing:
    Framework: Supertest + Jest
    Reason: Express integration, familiar syntax

CI/CD Strategy:
  - Unit tests: Run on every commit (< 30s)
  - Integration tests: Run on PR (< 2min)
  - E2E tests: Run on PR + scheduled (< 10min)
  - Parallel execution: 4 workers minimum
```

**When to use:** Setting up test automation, creating test suites, or improving test infrastructure.

---

### 2. 🔍 Bug Analyst
**Location**: `personas/qa/subagents/bug-analyst.md`

**Expertise:**
- Root cause analysis using 5 Whys methodology
- Bug reproduction steps creation
- Severity and priority assessment
- Regression test creation
- Bug pattern identification
- Issue triage and categorization

**Example prompts:**
- "Analyze this bug in the login flow"
- "Users report intermittent payment failures, investigate why"
- "Help me create reproduction steps for this issue"
- "What's the root cause of this crash?"

**Output example:**
```
Problem: Users cannot log in after password reset

🔍 5 Whys Analysis:
Why? → New password not being accepted
Why? → Password hash doesn't match database
Why? → Password reset transaction not committing
Why? → Missing .commit() call in handler
Why? → Recent refactoring removed explicit commit

🎯 Root Cause: Missing database commit in password reset handler

✅ Fix: Add await db.commit() after password update

🧪 Regression Test: Create test that verifies password reset workflow
```

**When to use:** Investigating bugs, creating reproduction steps, or performing root cause analysis.

---

### 3. ♿ Accessibility Auditor
**Location**: `personas/qa/subagents/accessibility-auditor.md`

**Expertise:**
- WCAG 2.1/2.2 Level AA compliance
- Screen reader testing (NVDA, JAWS, VoiceOver)
- Keyboard navigation and focus management
- Color contrast analysis (4.5:1 for text, 3:1 for UI)
- ARIA attributes and semantic HTML
- Automated accessibility testing (axe-core, Lighthouse)

**Example prompts:**
- "Check accessibility of this modal dialog"
- "Make this form WCAG 2.1 AA compliant"
- "Audit this page for accessibility issues"
- "Is this component keyboard accessible?"

**Output example:**
```
♿ ACCESSIBILITY AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 WCAG Level: AA
🎯 Compliance: 92%

🔴 CRITICAL (Level A) - Must Fix:
[1] Missing alt text on product images
    Impact: Screen reader users cannot understand content
    Location: src/components/ProductCard.tsx:45
    Fix: Add alt="Product name and description" to <img>

🟠 SERIOUS (Level AA) - Should Fix:
[2] Color contrast insufficient on CTA button
    Element: "Buy Now" button
    Current: #777 on #999 (2.1:1 contrast)
    Required: 4.5:1 minimum
    Fix: Change text to #000 for 4.6:1 contrast

🟡 MODERATE:
[3] Missing focus indicators on custom dropdowns
    Fix: Add :focus styles with 2px outline

✅ PASSING:
• Semantic HTML structure
• Keyboard navigation works
• Screen reader labels present
```

**When to use:** Ensuring your application is accessible to users with disabilities.

---

### 4. ⚡ Performance Tester
**Location**: `personas/qa/subagents/performance-tester.md`

**Expertise:**
- Load testing (JMeter, k6, Artillery, Gatling)
- Stress testing to find breaking points
- Response time analysis and optimization
- Throughput and concurrency measurement
- Bottleneck identification
- Scalability testing and capacity planning

**Example prompts:**
- "Performance test this API under high load"
- "How many concurrent users can this system handle?"
- "Load test the checkout endpoint"
- "Find performance bottlenecks in this application"

**When to use:** Validating system performance under load or planning for scale.

---

### 5. 👁️ Visual Regression Tester
**Location**: `personas/qa/subagents/visual-regression-tester.md`

**Expertise:**
- Screenshot comparison and pixel-diff analysis
- Baseline management and update strategies
- Cross-browser visual testing
- Responsive design verification across devices
- Visual testing tools (Percy, Chromatic, BackstopJS)
- CSS regression detection

**Example prompts:**
- "Check for visual changes after this CSS update"
- "Set up visual regression testing for components"
- "Compare screenshots across browsers"
- "Detect unintended UI changes from this refactor"

**When to use:** Ensuring UI changes are intentional and don't break existing designs.

---

## How Subagents Work

### Automatic Invocation

You **don't need to explicitly call subagents** - Claude automatically invokes the right expert based on your request.

**Example 1:**
```
You: "Review this authentication code for security issues"

Behind the scenes:
→ Claude recognizes: code review + security focus
→ Invokes: Code Reviewer subagent
→ Output: Structured security review with findings
```

**Example 2:**
```
You: "This API is slow, help me optimize it"

Behind the scenes:
→ Claude recognizes: performance issue
→ Invokes: Performance Optimizer subagent
→ Output: Profiling analysis with specific optimizations
```

**Example 3:**
```
You: "Generate tests for this user service"

Behind the scenes:
→ Claude recognizes: test creation request
→ Invokes: Test Automation Specialist subagent
→ Output: Complete test suite with Page Objects
```

### Subagent Collaboration

Multiple subagents can work together on complex tasks:

```
You: "Build and test a new payment processing API"

Workflow:
Step 1: API Designer creates the API specification
Step 2: Backend Engineer implements the code
Step 3: Code Reviewer checks quality and security
Step 4: Test Automation Specialist generates tests
Step 5: Performance Tester validates scalability
```

### Visual Identity

Each subagent identifies itself with a unique prefix:

**Engineer Subagents:**
- `[CODE-REVIEWER] 🔍`
- `[DEBUGGER] 🐛`
- `[PERFORMANCE-OPTIMIZER] ⚡`
- `[REFACTORER] 🔧`
- `[BACKEND-ENGINEER] 🌐`
- `[FRONTEND-UX-ENGINEER] 🎨`
- `[API-DESIGNER] 🔌`
- `[DEVOPS] 🚀`
- `[AI-ML-ENGINEER] 🤖`

**QA Subagents:**
- `[TEST-AUTOMATION] 🤖`
- `[BUG-ANALYST] 🔍`
- `[ACCESSIBILITY-AUDITOR] ♿`
- `[PERFORMANCE-TESTER] ⚡`
- `[VISUAL-REGRESSION] 👁️`

This helps you know which expert is responding.

---

## Subagents vs Skills

| Feature | Subagents | Skills |
|---------|-----------|--------|
| **What they are** | Specialized Claude personas | Workflow templates |
| **How they work** | Invoked by Claude automatically | Auto-invoked based on triggers |
| **Output** | Structured expert analysis | Actionable checklists & guides |
| **Example** | Code Reviewer analyzes code | Code review skill provides process |
| **Location** | `personas/*/subagents/` | `personas/*/skills/` |
| **Count (Engineer)** | 9 subagents | 8 skills |
| **Count (QA)** | 5 subagents | 4 skills |
| **Purpose** | Deep expertise | Workflow guidance |

**They work together:**
- **Skill** defines the *what* and *when* (e.g., "do code review when asked")
- **Subagent** provides the *how* and *expertise* (e.g., "here's my expert analysis")

**Example:**
```
You: "Review my authentication implementation"

1. code-review Skill activates (workflow)
   ✓ Provides code review checklist
   ✓ Defines review categories

2. Code Reviewer Subagent executes (expertise)
   ✓ Analyzes security vulnerabilities
   ✓ Checks best practices
   ✓ Provides specific recommendations
```

---

## Practical Usage Examples

### For Engineers

#### Code Review
```
You: "Review my user authentication implementation"

Code Reviewer subagent analyzes:
✓ Security
  • Password hashing (bcrypt with salt)
  • Session management (JWT expiration)
  • SQL injection prevention (parameterized queries)

✓ Best practices
  • Error handling (specific error messages)
  • Logging (no sensitive data logged)
  • Input validation (email format, password strength)

✓ Performance
  • Database queries (optimized with indexes)
  • Caching strategy (session caching)

✓ Testing
  • Test coverage (80% unit, 60% integration)
  • Edge cases (invalid credentials, expired sessions)
```

#### Debugging
```
You: "App crashes when uploading files larger than 5MB"

Debugger subagent provides:
🔍 Root Cause Analysis:
  → Memory limit exceeded in file buffer
  → Default limit: 5MB
  → Large files load entirely into memory

💡 Immediate Fix:
  • Increase memory limit to 50MB
  • Add file size validation on frontend

🚀 Long-term Solution:
  • Implement chunked file upload
  • Stream files directly to S3
  • Add progress indicators
```

#### Performance Optimization
```
You: "Dashboard loads in 8 seconds, too slow"

Performance Optimizer analyzes:
🐌 Bottlenecks Identified:
  1. N+1 database queries (87 queries!)
     Fix: Use eager loading with .include()

  2. Large JavaScript bundle (2.3MB)
     Fix: Code splitting with React.lazy()

  3. Unoptimized API calls (12 sequential requests)
     Fix: Batch requests or use GraphQL

  4. No caching (repeated identical queries)
     Fix: Add Redis cache with 5min TTL

⚡ Expected Improvement: 8s → 1.2s (85% faster)
```

### For QA

#### Test Automation
```
You: "Create E2E tests for the checkout flow"

Test Automation Specialist generates:

📁 Test Structure:
tests/e2e/checkout/
├── page-objects/
│   ├── CartPage.ts
│   ├── CheckoutPage.ts
│   └── PaymentPage.ts
├── fixtures/
│   └── test-products.json
└── checkout.spec.ts

🧪 Test Scenarios:
✓ Happy path (full checkout with valid card)
✓ Invalid card (error handling)
✓ Empty cart (validation)
✓ Guest checkout (no account)
✓ Applied discount code
✓ Multiple items in cart
✓ Stock validation

📊 CI/CD Integration:
• Run on every PR
• Parallel execution (4 workers)
• Screenshot on failure
• Retry failed tests (2x)
```

#### Accessibility Audit
```
You: "Check accessibility of the new modal dialog"

Accessibility Auditor audits:

✅ PASSING:
• Keyboard navigation (Tab, Escape, Enter)
• Focus trap (focus stays within modal)
• Focus restoration (returns to trigger)
• ARIA role="dialog"
• ARIA aria-modal="true"

⚠️ NEEDS FIXING:
• Missing aria-labelledby (add title reference)
• Missing aria-describedby (add description)
• Background not inert (add aria-hidden to content)

🔴 CRITICAL:
• No Escape key handler
  Fix: Add onKeyDown handler to close on Escape

Code Example:
const handleKeyDown = (e: KeyboardEvent) => {
  if (e.key === 'Escape') {
    onClose();
  }
};
```

#### Bug Analysis
```
You: "Users report intermittent login failures"

Bug Analyst investigates:

🔍 5 Whys Analysis:
Why? → Login succeeds but session immediately expires
Why? → Session cookie not being set properly
Why? → Cookie domain mismatch (*.example.com vs example.com)
Why? → Recent change to cookie configuration
Why? → Security update modified domain attribute

🎯 Root Cause: Cookie domain misconfiguration

✅ Fix:
// Before (broken)
res.cookie('session', token, { domain: '*.example.com' });

// After (fixed)
res.cookie('session', token, { domain: '.example.com' });

🧪 Regression Test:
test('login sets session cookie correctly', async () => {
  const response = await request(app)
    .post('/login')
    .send({ email, password });

  expect(response.headers['set-cookie'][0])
    .toContain('domain=.example.com');
});

📊 Related Logs to Check:
• Authentication service logs (session creation)
• Browser console (cookie inspection)
• Network tab (Set-Cookie headers)
```

---

## Best Practices

### 1. Ask Specific Questions

**Good:**
- "Review this authentication code for SQL injection vulnerabilities"
- "Optimize this database query that's taking 5 seconds"
- "Create unit tests for the user service with 90% coverage"

**Too Vague:**
- "Review this code"
- "Make it faster"
- "Add tests"

### 2. Provide Context

**Include:**
- What you're trying to accomplish
- What's not working or could be better
- Any constraints (performance targets, browser support)
- Relevant code or error messages

**Example:**
```
"Review this payment processing code for security issues.
We need to:
- Handle credit card data securely
- Prevent fraud attempts
- Comply with PCI-DSS
- Support 1000 transactions/minute"
```

### 3. Combine Subagents for Complex Tasks

**Example workflow:**
```
1. "Design an API for order management"
   → API Designer creates specification

2. "Implement this API design"
   → Backend Engineer writes code

3. "Review this implementation for security and performance"
   → Code Reviewer + Performance Optimizer analyze

4. "Create comprehensive tests"
   → Test Automation Specialist generates test suite

5. "Set up CI/CD for this service"
   → DevOps creates pipeline
```

### 4. Use Natural Language

You don't need special syntax - just ask naturally:
- "Can you help me debug this?"
- "What's wrong with this code?"
- "How can I make this faster?"
- "Is this accessible?"

### 5. Iterate Based on Feedback

Subagents provide detailed recommendations - follow up with:
- "Implement fix #1 you suggested"
- "Show me how to refactor this using the pattern you mentioned"
- "Create the test you described"

---

## Summary

**You have access to 14 specialized experts:**

**For Engineers (9):**
1. Code Reviewer - Quality, security, performance analysis
2. Debugger - Root cause analysis and fixes
3. Performance Optimizer - Speed and efficiency improvements
4. Refactorer - Code restructuring and modernization
5. Backend Engineer - API and database design
6. Frontend/UX Engineer - React/Vue components and UX
7. API Designer - RESTful/GraphQL API specification
8. DevOps - CI/CD, Docker, Kubernetes, infrastructure
9. AI/ML Engineer - Machine learning and LLM integration

**For QA (5):**
1. Test Automation Specialist - Framework setup and test generation
2. Bug Analyst - Root cause analysis and triage
3. Accessibility Auditor - WCAG compliance and a11y testing
4. Performance Tester - Load testing and scalability
5. Visual Regression Tester - UI change detection

**Key Benefits:**
- ✅ Automatic invocation - just ask naturally
- ✅ Specialized expertise - deep knowledge in each domain
- ✅ Structured output - consistent, actionable responses
- ✅ Collaboration - multiple experts work together
- ✅ Visual identity - know which expert is helping

**Remember:** You don't need to memorize which subagent does what. Just ask your question naturally, and Claude will invoke the right expert automatically.

---

**Related Documentation:**
- [Skills Guide](../SKILLS.md) - Auto-invoked workflow assistance
- [MCP Servers](MCP_SERVERS.md) - Tool integrations
- [Engineer Persona](../personas/engineer/) - Full persona configuration
- [QA Persona](../personas/qa/) - Full persona configuration
