# Skill: Requirements Refiner - Precision Improvement

## Skill Metadata
- **Skill ID**: `requirements-refiner`
- **Version**: 1.0
- **Persona**: Product Manager
- **Auto-invocation**: Yes
- **Priority**: High

---

## Invocation Pattern

This skill automatically activates when Claude detects:

```yaml
triggers:
  - vague_language:
      - "fast", "slow", "quick", "easy", "simple", "intuitive"
      - "better", "improved", "enhanced", "optimized"
      - "more", "less", "few", "many"
      - "should", "could", "might"

  - incomplete_requirements:
      - Requirements without acceptance criteria
      - Missing edge cases
      - No non-functional requirements
      - Ambiguous success conditions

  - validation_request:
      - PM asks "is this complete?"
      - PM runs /validate-requirements
      - During PRD review
```

---

## Skill Purpose

Transform vague, ambiguous requirements into precise, testable specifications by:
1. Detecting imprecise language
2. Asking clarifying questions
3. Suggesting specific alternatives
4. Ensuring completeness

---

## Vague Language Detection

### Pattern Library

```python
VAGUE_PATTERNS = {
  "performance": {
    "vague": ["fast", "quick", "slow", "responsive", "snappy"],
    "questions": [
      "How fast? (milliseconds, seconds?)",
      "What's the acceptable threshold?",
      "How do we measure this?",
      "What's the p95 target?"
    ],
    "specific_alternatives": [
      "Page loads in < 500ms (p95)",
      "API responds in < 200ms (p95)",
      "Button feedback in < 50ms",
      "Search results appear in < 1s"
    ]
  },

  "usability": {
    "vague": ["easy", "simple", "intuitive", "user-friendly", "clean"],
    "questions": [
      "What makes it easy? (fewer steps? clearer labels?)",
      "How do we validate usability?",
      "What's the success rate target?",
      "What accessibility level?"
    ],
    "specific_alternatives": [
      "Users complete task in < 3 clicks",
      "90%+ users complete without help",
      "WCAG 2.1 AA compliant",
      "Task completion rate > 85%",
      "System Usability Scale (SUS) score > 80"
    ]
  },

  "quantity": {
    "vague": ["more", "less", "few", "many", "several", "some"],
    "questions": [
      "Exact number?",
      "Minimum/maximum?",
      "What's the range?"
    ],
    "specific_alternatives": [
      "Display exactly 10 results per page",
      "Support 1-100 items",
      "Maximum 5 active sessions",
      "At least 3 payment methods"
    ]
  },

  "quality": {
    "vague": ["high quality", "good", "better", "improved", "reliable"],
    "questions": [
      "What metric defines quality?",
      "What's the acceptable error rate?",
      "What's the uptime target?"
    ],
    "specific_alternatives": [
      "Error rate < 0.1%",
      "99.9% uptime SLA",
      "Zero data loss",
      "< 5 support tickets per week"
    ]
  },

  "frequency": {
    "vague": ["regularly", "often", "sometimes", "occasionally", "periodically"],
    "questions": [
      "How often exactly?",
      "What's the schedule?",
      "Triggered by what event?"
    ],
    "specific_alternatives": [
      "Every 24 hours at 2am UTC",
      "On each user action",
      "After 5 failed attempts",
      "Weekly on Mondays"
    ]
  },

  "scope": {
    "vague": ["should", "could", "might", "may", "preferably"],
    "questions": [
      "Is this required or optional?",
      "Must-have or nice-to-have?",
      "What's the priority (P0/P1/P2)?"
    ],
    "specific_alternatives": [
      "MUST: Required for launch",
      "SHOULD: High priority, defer if needed",
      "COULD: Nice-to-have, Phase 2",
      "WON'T: Out of scope"
    ]
  }
}
```

---

## Interactive Refinement Process

### Pattern 1: Detect and Question

```
PM writes: "The form should load fast"

Claude (requirements-refiner activates):
"I notice 'fast' is vague. Let's make this specific:

CURRENT: 'The form should load fast'

QUESTIONS:
1. What aspect needs to be fast?
   - Initial page load?
   - Form field rendering?
   - Validation feedback?
   - Submit/save response?

2. How fast is 'fast'?
   - < 100ms (instant)?
   - < 500ms (very fast)?
   - < 1s (fast)?
   - < 2s (acceptable)?

3. Measured how?
   - Lighthouse performance score?
   - Real User Monitoring (RUM)?
   - Synthetic monitoring?
   - PostHog performance tracking?

4. For which users?
   - All users globally?
   - 90th percentile (p90)?
   - 95th percentile (p95)?

SUGGESTED SPECIFIC REQUIREMENTS:

Option A (High Performance):
'Form renders all fields in < 300ms (p95), measured via Lighthouse,
with skeleton loaders shown during load for perceived performance'

Option B (Balanced):
'Initial form paint in < 500ms (p95), with progressive enhancement
for complex fields, measured via Real User Monitoring in PostHog'

Option C (Minimum Viable):
'Form fully interactive in < 2s (p95) on 3G connection,
measured via synthetic monitoring'

Which performance level is appropriate for this feature?"
```

### Pattern 2: Suggest Missing Requirements

```
PM writes:
"User can upload profile photo"

Claude (requirements-refiner activates):
"This functional requirement needs additional details:

CURRENT REQUIREMENT:
'User can upload profile photo'

MISSING DETAILS:

1. File Requirements:
   - Supported formats? (JPG, PNG, WebP, HEIC?)
   - File size limits? (e.g., max 10MB)
   - Image dimensions? (min/max resolution)
   - Aspect ratio? (square, 4:3, any?)

2. Validation:
   - What if file too large?
   - What if wrong format?
   - What if image is corrupted?
   - Content moderation needed?

3. Processing:
   - Automatic resizing/cropping?
   - Generate thumbnails?
   - Image optimization?
   - CDN upload?

4. Performance:
   - Upload progress indicator?
   - Maximum upload time?
   - Retry logic if failed?

5. Security:
   - Malware scanning?
   - File type verification (not just extension)?
   - Storage location/permissions?

6. Accessibility:
   - Alt text required?
   - Keyboard/screen reader support?

SUGGESTED COMPLETE REQUIREMENT:

FR-12: Profile Photo Upload

DESCRIPTION:
Users can upload a profile photo to personalize their account.

ACCEPTANCE CRITERIA:
1. Given user clicks 'Upload Photo'
   When file picker opens
   Then accept JPG, PNG, WebP, HEIC formats only

2. Given user selects valid image file
   When file size ≤ 10MB and dimensions ≥ 200x200px
   Then upload starts with progress indicator

3. Given upload in progress
   When upload exceeds 30 seconds
   Then show timeout error and retry option

4. Given upload succeeds
   When image is processed
   Then auto-crop to 1:1 aspect ratio and generate 3 sizes:
        - Thumbnail: 64x64px
        - Profile: 256x256px
        - Full: 1024x1024px

5. Given uploaded image
   When displaying to user
   Then serve from CDN with alt text 'Profile photo of [name]'

EDGE CASES:
- File > 10MB: Show error 'File too large (max 10MB)'
- Invalid format: Show error 'Please upload JPG or PNG'
- Upload fails: Retry up to 3 times, then show 'Upload failed, try again'
- No internet: Queue for upload when connection restored

NON-FUNCTIONAL REQUIREMENTS:
- Security: Virus scan all uploads, strip EXIF data
- Performance: Process upload in < 10s for 10MB file
- Storage: S3 with 30-day lifecycle policy for abandoned uploads
- Accessibility: WCAG 2.1 AA - keyboard accessible, screen reader support

Would you like me to add this detailed version to the PRD?"
```

### Pattern 3: Identify Missing Edge Cases

```
PM writes acceptance criteria without edge cases:

"Given user submits form
When all fields valid
Then save data and show success message"

Claude (requirements-refiner activates):
"I see basic happy path covered, but missing edge cases:

CURRENT: Only happy path defined

MISSING EDGE CASES:

1. Network/Server Issues:
   - What if API times out?
   - What if server returns 500 error?
   - What if user loses connection mid-submit?
   - What if server is in maintenance mode?

2. Data Issues:
   - What if duplicate submission?
   - What if data changed by another user?
   - What if user submits while form is processing?
   - What if required field becomes empty before submit?

3. User Behavior:
   - What if user hits Back button during save?
   - What if user refreshes page during save?
   - What if user closes browser during save?
   - What if user submits same form in multiple tabs?

4. Validation Edge Cases:
   - What if field passes client-side but fails server-side?
   - What if validation rules changed since page load?
   - What if special characters break validation?

SUGGESTED ADDITIONAL ACCEPTANCE CRITERIA:

Edge Case Handling:

6. Given API timeout (> 30s)
   When submit request pending
   Then show 'Taking longer than usual...' message
   And retry up to 3 times

7. Given server error (500/503)
   When submit fails
   Then preserve form data locally
   And show 'Something went wrong, try again' with retry button

8. Given duplicate submission detection
   When user clicks submit twice within 2 seconds
   Then ignore second click and show 'Submitting...' state

9. Given user navigation during submit
   When user hits Back/Refresh
   Then show 'Changes are being saved' confirmation dialog

10. Given connection loss during submit
    When network drops
    Then queue submission for retry
    And show offline indicator

Would you like me to add these edge cases?"
```

---

## Completeness Checklist

### Requirement Completeness

For each functional requirement, validate:

```
✅ Functional Requirement Checklist

- [ ] Clear description (what it does)
- [ ] Priority defined (P0/P1/P2 or MoSCoW)
- [ ] User value explained (why we're building this)
- [ ] Acceptance criteria (2+ scenarios)
- [ ] Edge cases documented (3+ scenarios)
- [ ] Error handling specified
- [ ] Success/failure states defined
- [ ] No vague language (all terms specific)

✅ Acceptance Criteria Quality

Each AC must have:
- [ ] Given/When/Then format
- [ ] Specific values (not "fast", "many", "some")
- [ ] Observable outcome (testable)
- [ ] Clear pass/fail criteria

✅ Non-Functional Requirements

Must include:
- [ ] Performance requirements (load time, response time)
- [ ] Security requirements (authentication, authorization, encryption)
- [ ] Accessibility requirements (WCAG level, keyboard, screen reader)
- [ ] Browser/device support (which versions?)
- [ ] Scalability requirements (concurrent users, data volume)
- [ ] Reliability requirements (uptime, error rate)
```

---

## Non-Functional Requirements Templates

### Performance

```markdown
## Performance Requirements

### Page Performance
- **Initial Load**: LCP < 2.5s (p75), measured via Lighthouse
- **Interactivity**: FID < 100ms (p75)
- **Visual Stability**: CLS < 0.1
- **Time to Interactive**: < 3.5s on 4G connection

### API Performance
- **Response Time**:
  - p50: < 100ms
  - p95: < 500ms
  - p99: < 1000ms
- **Throughput**: Support 1000 requests/second
- **Timeout**: 30 seconds max, with retry logic

### Database Performance
- **Query Time**: < 50ms for 95% of queries
- **Connection Pool**: Min 10, Max 100 connections
- **Index Coverage**: 100% of queries use indexes

### Front-End Performance
- **Bundle Size**: Total JS < 500KB (gzipped)
- **Image Optimization**: WebP format, lazy loading
- **Caching**: 1-year cache for static assets
```

### Security

```markdown
## Security Requirements

### Authentication
- **Method**: OAuth 2.0 with JWT tokens
- **Token Expiry**: Access token 15 min, Refresh token 7 days
- **MFA**: Required for admin roles, optional for users
- **Password Policy**: Min 12 chars, 1 uppercase, 1 number, 1 special

### Authorization
- **Model**: Role-Based Access Control (RBAC)
- **Principle**: Least privilege
- **Session**: Server-side session management
- **Timeout**: 30 minutes inactivity

### Data Protection
- **In Transit**: TLS 1.3, HTTPS only
- **At Rest**: AES-256 encryption for PII
- **PII Handling**: GDPR compliant, data minimization
- **Secrets**: Stored in AWS Secrets Manager, rotated every 90 days

### Security Testing
- **OWASP Top 10**: All vulnerabilities addressed
- **Dependency Scanning**: Snyk scan in CI/CD
- **Penetration Testing**: Annual third-party audit
```

### Accessibility

```markdown
## Accessibility Requirements

### Compliance Level
- **Standard**: WCAG 2.1 Level AA (minimum)
- **Target**: WCAG 2.2 Level AA
- **Critical Paths**: Level AAA for checkout and auth

### Keyboard Navigation
- **All Interactive Elements**: Keyboard accessible (Tab, Enter, Space)
- **Focus Indicators**: Visible 3:1 contrast ratio
- **Skip Links**: "Skip to main content" at page top
- **No Keyboard Traps**: User can navigate in and out

### Screen Reader Support
- **Semantic HTML**: Proper heading hierarchy (h1-h6)
- **ARIA Labels**: All interactive elements labeled
- **Live Regions**: Dynamic content announced
- **Form Validation**: Errors announced in context
- **Testing**: NVDA (Windows), VoiceOver (Mac/iOS)

### Visual Accessibility
- **Color Contrast**:
  - Normal text: 4.5:1 minimum
  - Large text: 3:1 minimum
  - UI components: 3:1 minimum
- **No Color-Only Info**: Use icons + text + patterns
- **Text Resize**: Support up to 200% zoom
- **Focus Visible**: Always show focus indicator

### Testing Requirements
- **Automated**: axe-core in CI/CD (via A11y MCP)
- **Manual**: Keyboard and screen reader testing
- **Target Score**: Lighthouse accessibility score ≥ 95
```

### Browser/Device Support

```markdown
## Browser & Device Support

### Desktop Browsers
- **Chrome**: Last 2 versions (93% market share)
- **Safari**: Last 2 versions
- **Firefox**: Last 2 versions
- **Edge**: Last 2 versions
- **NOT SUPPORTED**: Internet Explorer

### Mobile Browsers
- **iOS Safari**: iOS 14+
- **Chrome Mobile**: Android 10+
- **Samsung Internet**: Last 2 versions

### Responsive Breakpoints
- **Mobile**: 375px - 767px (iPhone SE minimum)
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px - 1920px
- **Large Desktop**: 1921px+

### Device Testing
- **Required Physical Devices**:
  - iPhone 13 (iOS 16)
  - Samsung Galaxy S22 (Android 13)
  - iPad Air (iPadOS 16)
- **Browser Stack**: Cross-browser testing for all other combinations

### Progressive Enhancement
- **Core Features**: Work without JavaScript
- **Enhanced Features**: Add with JavaScript
- **Fallbacks**: Provide alternatives for:
  - WebP images → JPG fallback
  - CSS Grid → Flexbox fallback
  - Modern JS → Babel transpilation
```

---

## Common Requirement Smells

### Smell 1: Modal Verbs

```
❌ BAD:
"The system should validate email"
"Users could receive notifications"
"Form might show errors"

✅ GOOD:
"The system MUST validate email format (RFC 5322)"
"Users WILL receive notification within 5 seconds of action"
"Form MUST show inline errors on field blur"

Use RFC 2119 keywords:
- MUST: Absolute requirement
- SHOULD: Recommended but not required
- MAY: Truly optional
```

### Smell 2: Implementation Details in Requirements

```
❌ BAD:
"Use Redux for state management"
"Store data in PostgreSQL with JSONB column"
"Use React.memo for optimization"

✅ GOOD:
"Maintain form state across page refreshes"
"Support complex nested data structures"
"Render list of 1000 items without lag"

(Let engineering choose implementation)
```

### Smell 3: Assuming Context

```
❌ BAD:
"Update the user"
"Send the email"
"Show the error"

✅ GOOD:
"Update user's profile name in database and UI"
"Send password reset email to user's registered address"
"Show validation error inline below the field"

(Be explicit, assume no context)
```

---

## Output Format

When refining requirements, use this structure:

```markdown
## Refined Requirement: [Name]

### Original (Vague)
[What PM wrote]

### Issues Identified
1. [Vague term or missing detail]
2. [Another issue]

### Clarifying Questions
1. [Question to resolve ambiguity]
2. [Another question]

### Refined Requirement

**FR-XX: [Clear Name]**

**Priority**: P0 | P1 | P2 (Must | Should | Could | Won't)

**Description**:
[Clear, specific description]

**User Value**:
[Why this matters to users]

**Acceptance Criteria**:

1. **Given** [specific initial state]
   **When** [specific action with values]
   **Then** [specific observable outcome]

2. **Given** [next scenario]
   **When** [action]
   **Then** [outcome]

**Edge Cases**:

1. [Specific edge case scenario + expected behavior]
2. [Another edge case]

**Error Handling**:
- [Error type]: [User-visible message] + [System behavior]

**Non-Functional Requirements**:
- **Performance**: [Specific metric with threshold]
- **Security**: [Specific requirement]
- **Accessibility**: [Specific requirement]

**Dependencies**:
- [Prerequisite 1]
- [Prerequisite 2]

**Out of Scope**:
- [Explicitly excluded 1]
- [Explicitly excluded 2]
```

---

## Skill Behavior

### Activation Timing

```
Continuous Monitoring:
├─ Scan each sentence as PM writes
├─ Detect vague patterns in real-time
├─ Activate immediately when detected
└─ Don't wait for PM to ask

Interrupt Appropriately:
├─ High priority vague terms → interrupt immediately
├─ Minor issues → batch and suggest at end of section
├─ During flow state → queue suggestions, present at pause
└─ Explicit validation request → comprehensive review
```

### Tone & Approach

- **Collaborative**: "Let's make this more specific"
- **Curious**: Ask questions, don't dictate
- **Options-based**: Offer 2-3 alternatives
- **Educational**: Explain why precision matters

---

## Integration with Other Skills

Works with:
- **prd-guide**: Refines requirements during PRD creation
- **success-criteria-builder**: Ensures metrics are specific
- **ai-solution-ideation**: Refines problem statement before ideation

---

## Success Metrics for This Skill

- **Precision Score**: Vague language reduced by 80%
- **Completeness**: Requirements missing edge cases reduced from 70% to <10%
- **Engineering Feedback**: "Clarification needed" requests down 75%
- **Time Saved**: Reduces requirement revision cycles from 3 → 1

---

## Example: Full Refinement

```
PM writes:
"Users should be able to search products quickly and easily,
with good results that match what they're looking for."

Claude (requirements-refiner):
"I see several vague terms here. Let's refine:

VAGUE TERMS DETECTED:
1. 'quickly' → How fast?
2. 'easily' → What makes it easy?
3. 'good results' → What defines good?
4. 'match what they're looking for' → How do we measure relevance?

Let me check PostHog for current search performance...

CURRENT STATE (PostHog data):
- Search response time: 2.3s average
- Click-through rate: 35%
- Zero results rate: 22%
- Search refinement rate: 58% (users search again)

REFINED REQUIREMENT:

FR-08: Product Search

Priority: P1 (Must Have)

Description:
Users can search the product catalog by entering text query,
with results appearing in real-time as they type.

User Value:
Reduces time to find products, increasing likelihood of purchase.
Target: Reduce 'search to purchase' time by 40%.

Acceptance Criteria:

1. Given user types in search box
   When user types 3+ characters
   Then display search results within 500ms
   And show loading spinner if > 200ms

2. Given search query 'red dress'
   When results displayed
   Then show products ranked by:
        - Exact match (title contains both words): 100 points
        - Partial match (title contains one word): 50 points
        - Category match: 25 points
        - Tag match: 10 points
   And display at least 10 results if available

3. Given search query returns 0 results
   When no exact matches found
   Then suggest similar searches
   And display 'Try: [suggestion]' with 3 alternatives

4. Given user clicks result
   When navigating to product page
   Then log click for relevance scoring

Edge Cases:

1. Query with special characters (!@#$%): Sanitize but preserve intent
2. Query > 100 characters: Truncate and show warning
3. API timeout (> 5s): Show cached results + 'Using cached data' notice
4. Typos: Use fuzzy matching (Levenshtein distance ≤ 2)
5. Empty query: Show popular products

Error Handling:
- Search API down: Fallback to cached index, show 'Limited results' banner
- Network loss: Queue query, execute when reconnected
- Malformed query: Log error, show 'Please try different search'

Non-Functional Requirements:
- Performance:
  - Response time: p95 < 500ms
  - Debounce typing: 300ms
  - Cache results: 5 minutes
- Security:
  - Sanitize all queries (prevent SQL injection)
  - Rate limit: 60 queries/minute per user
- Accessibility:
  - Screen reader announces result count
  - Keyboard navigable (arrow keys, enter)
  - ARIA live region for results

Success Metrics:
- Click-through rate: 35% → 55%
- Zero results rate: 22% → < 10%
- Search refinement rate: 58% → < 35%
- Time to first click: 8s → 4s

Dependencies:
- Elasticsearch cluster setup (Infra team, ETA: Week 2)
- Product catalog API v2 (Backend team, Available now)

Out of Scope:
- Voice search
- Image search
- Filters/facets (Phase 2)

Does this capture the intent accurately?"
```

---

**This skill ensures every requirement is precise, complete, and testable.**
