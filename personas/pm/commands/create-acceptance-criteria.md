# Command: Create Acceptance Criteria

## Purpose
Generates comprehensive, testable acceptance criteria for user stories or features.

## Usage
```bash
/create-acceptance-criteria [story-file or feature-description]
```

## What This Command Does

1. Analyzes feature/story context
2. Generates Given/When/Then criteria
3. Includes happy path, error cases, edge cases
4. Validates quality with **acceptance-criteria-checker.sh**
5. Ensures testability and completeness

## Output Format

```markdown
**Acceptance Criteria**:

1. **Given** I am a logged-in user on the checkout page
   **When** I enter valid payment information and click "Submit"
   **Then** I see a success message "Order placed successfully"
   **And** I receive an order confirmation email within 1 minute

2. **Given** I am on the checkout page with an empty cart
   **When** I attempt to place an order
   **Then** I see an error "Your cart is empty"
   **And** the order is not submitted

3. **Given** I enter invalid payment information
   **When** I click "Submit"
   **Then** I see an error highlighting the invalid field
   **And** I remain on the checkout page

**Edge Cases**:
- Payment gateway timeout → Show retry option
- Duplicate submission → Prevent with loading state
- Session expires during checkout → Save cart, prompt re-login
```

## Quality Standards

Each criterion must:
- Use Given/When/Then format
- Be testable and measurable
- Have clear pass/fail conditions
- Include UI feedback expectations
- Specify system state changes

## Validation Checks

- ✅ Minimum 2 criteria
- ✅ Happy path covered
- ✅ Error scenarios included
- ✅ Edge cases identified
- ✅ Testable verbs used
- ✅ No vague terms ("properly", "correctly")
- ✅ Specific values/data included

## Examples

```bash
# Generate from user story
/create-acceptance-criteria ~/stories/guest-checkout.md

# Generate from description
/create-acceptance-criteria "Password reset functionality"

# Detailed mode with edge cases
/create-acceptance-criteria --detailed ~/stories/feature.md
```

## Options
- `--format=[gwt|checklist]`: Output format
- `--detailed`: Include comprehensive edge cases
- `--testable-only`: Focus on automated test scenarios
