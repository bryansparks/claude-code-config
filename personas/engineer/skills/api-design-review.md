---
name: api-design-review
description: RESTful API design review, OpenAPI validation, versioning strategies, and best practices assessment. Use when user requests API review, asks about REST design, wants API documentation review, or mentions API endpoints.
---

# API Design Review Skill

Comprehensive RESTful API design review covering resource modeling, HTTP methods, status codes, versioning, documentation, and industry best practices.

## When to Use This Skill

Automatically invoke when the user:
- Requests API design review
- Asks about RESTful API best practices
- Wants to design new API endpoints
- Mentions API documentation or OpenAPI/Swagger
- Asks about API versioning strategies
- Requests feedback on API architecture

## REST API Review Checklist

### 1. Resource Modeling

**Principles:**
- URLs represent resources (nouns), not actions (verbs)
- Use plural nouns for collections
- Use nested resources for relationships
- Keep URLs simple and intuitive

```
✅ GOOD:
GET    /api/users                 # Get all users
GET    /api/users/123             # Get specific user
GET    /api/users/123/orders      # Get user's orders
POST   /api/orders                # Create order

❌ BAD:
GET    /api/getUsers              # Verb in URL
GET    /api/user/123              # Singular noun
GET    /api/getAllOrdersForUser/123  # Too verbose
POST   /api/createOrder           # Verb in URL
```

### 2. HTTP Methods (Verbs)

**Standard Methods:**
- `GET`: Retrieve resources (idempotent, safe)
- `POST`: Create new resources
- `PUT`: Update entire resource (idempotent)
- `PATCH`: Partial update (not idempotent)
- `DELETE`: Remove resource (idempotent)

### 3. HTTP Status Codes

**Use appropriate codes:**
- **2xx Success**: 200 OK, 201 Created, 204 No Content
- **3xx Redirection**: 301 Moved Permanently, 304 Not Modified
- **4xx Client Error**: 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found
- **5xx Server Error**: 500 Internal Server Error, 503 Service Unavailable

### 4. Versioning Strategy

**Options:**
```
1. URL Versioning (Recommended):
   /api/v1/users
   /api/v2/users

2. Header Versioning:
   Accept: application/vnd.myapi.v1+json

3. Query Parameter:
   /api/users?version=1
```

## Output Format

```
🔌 API DESIGN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Overall Score: 75/100 (Good, Needs Improvement)

✓ Strengths: 8
⚠ Warnings: 12
❌ Issues: 5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ CRITICAL ISSUES

[1] Inconsistent Resource Naming
  Endpoint: POST /api/createUser
  Issue: Verb in URL violates REST principles

  Current:
  POST /api/createUser
  {
    "name": "John Doe",
    "email": "john@example.com"
  }

  Recommended:
  POST /api/users
  {
    "name": "John Doe",
    "email": "john@example.com"
  }

  Returns: 201 Created
  Location: /api/users/123

[2] Incorrect HTTP Status Code
  Endpoint: POST /api/users (when email exists)
  Current: Returns 400 Bad Request
  Issue: Should return 409 Conflict for duplicate resource

  Current Response:
  400 Bad Request
  { "error": "Email already exists" }

  Recommended:
  409 Conflict
  {
    "error": "DUPLICATE_EMAIL",
    "message": "A user with this email already exists",
    "details": {
      "field": "email",
      "value": "john@example.com"
    }
  }

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠ WARNINGS & IMPROVEMENTS

[3] Missing API Versioning
  Risk: Breaking changes affect all clients

  Recommendation:
  Implement URL versioning:
  - /api/v1/users (current stable)
  - /api/v2/users (new version)

  Version Strategy:
  - Maintain backward compatibility for 6 months
  - Deprecation warnings in headers:
    Sunset: Wed, 31 Dec 2025 23:59:59 GMT

[4] Inconsistent Error Response Format
  Issue: Different endpoints return different error formats

  Current (mixed formats):
  { "error": "Not found" }
  { "message": "Invalid input" }
  { "errors": ["Field required"] }

  Recommended (consistent):
  {
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Invalid input provided",
      "details": [
        {
          "field": "email",
          "message": "Email format is invalid"
        }
      ]
    }
  }

[5] Missing Pagination on Collection Endpoints
  Endpoint: GET /api/users
  Risk: Performance issues with large datasets

  Current:
  GET /api/users
  Returns: All users (potentially thousands)

  Recommended:
  GET /api/users?page=1&limit=20

  Response:
  {
    "data": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 1543,
      "totalPages": 78,
      "hasNext": true,
      "hasPrev": false
    },
    "links": {
      "self": "/api/users?page=1&limit=20",
      "next": "/api/users?page=2&limit=20",
      "last": "/api/users?page=78&limit=20"
    }
  }

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ STRENGTHS

• RESTful resource structure mostly correct
• Authentication using JWT (Bearer tokens)
• HTTPS enforced for all endpoints
• Rate limiting implemented (100 req/min)
• Comprehensive OpenAPI documentation
• CORS configured properly
• Request/response logging
• Input validation with detailed errors

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 RECOMMENDED API STRUCTURE

Users Resource:
────────────────

GET    /api/v1/users
       Query: ?page=1&limit=20&sort=createdAt:desc&filter[role]=admin
       Response: 200 OK, List of users with pagination

POST   /api/v1/users
       Body: User creation data
       Response: 201 Created, Location header with new resource URL

GET    /api/v1/users/:id
       Response: 200 OK, Single user or 404 Not Found

PUT    /api/v1/users/:id
       Body: Complete user object
       Response: 200 OK or 404 Not Found

PATCH  /api/v1/users/:id
       Body: Partial user update
       Response: 200 OK or 404 Not Found

DELETE /api/v1/users/:id
       Response: 204 No Content or 404 Not Found

Nested Resources:
─────────────────

GET    /api/v1/users/:id/orders
       Response: 200 OK, User's orders with pagination

POST   /api/v1/users/:id/orders
       Response: 201 Created

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 OPENAPI 3.0 DOCUMENTATION

openapi: 3.0.0
info:
  title: MyApp API
  version: 1.0.0
  description: Comprehensive API for MyApp platform

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'

components:
  schemas:
    User:
      type: object
      required:
        - email
        - name
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - bearerAuth: []

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔐 SECURITY RECOMMENDATIONS

• Add rate limiting per endpoint (currently global only)
• Implement API key rotation mechanism
• Add request signing for sensitive operations
• Enable CORS only for trusted origins
• Sanitize all input to prevent injection attacks
• Validate Content-Type headers
• Add security headers (CSP, HSTS)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡ PERFORMANCE RECOMMENDATIONS

• Implement ETags for caching
• Add compression (gzip/brotli)
• Use HTTP/2 for multiplexing
• Implement field filtering (?fields=id,name,email)
• Add database query optimization
• Consider GraphQL for complex data fetching needs

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Best Practices

1. **Consistency**: Use same patterns across all endpoints
2. **Documentation**: Comprehensive OpenAPI/Swagger docs
3. **Versioning**: Plan for API evolution
4. **Errors**: Clear, actionable error messages
5. **Security**: Authentication, rate limiting, input validation
6. **Performance**: Pagination, caching, compression
7. **Testing**: Comprehensive API integration tests

---

**Remember**: Well-designed APIs are intuitive, consistent, and maintainable - they become the foundation of your product's ecosystem.
