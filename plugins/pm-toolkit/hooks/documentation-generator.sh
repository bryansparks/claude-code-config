#!/bin/bash

# Documentation Generator Hook
# Auto-generates product documentation from user stories and requirements
# Triggered: Post-feature completion, during release prep

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Generate user guide
generate_user_guide() {
    local source_file=$1
    local output_file=$2

    log_info "Generating user guide from: $(basename "$source_file")"

    # Extract user-facing information
    local feature_name=$(grep -m1 "^#\|^## " "$source_file" | sed 's/^#\+\s*//' || echo "Feature")
    local user_role=$(grep -o "As a[n]\? \+[^,]*" "$source_file" | head -1 | sed 's/As a[n]\? //' || echo "User")
    local user_goal=$(grep -o "I want[^S]*" "$source_file" | head -1 | sed 's/I want //' | sed 's/$//' || echo "Goal")
    local user_value=$(grep -o "So that[^#]*" "$source_file" | head -1 | sed 's/So that //' || echo "Value")

    cat > "$output_file" <<EOF
# User Guide: $feature_name

## Overview

This feature allows **$user_role** to **$user_goal** so that **$user_value**.

## How to Use

### Getting Started

1. Navigate to [Feature Location]
2. [First step to access feature]
3. [Follow the steps below]

### Step-by-Step Instructions

EOF

    # Extract and convert acceptance criteria to user steps
    local in_ac=false
    while IFS= read -r line; do
        if [[ $line =~ [Aa]cceptance[[:space:]][Cc]riteria ]]; then
            in_ac=true
            continue
        fi
        if $in_ac; then
            if [[ $line =~ ^(##|###|\*\*[A-Z]) ]]; then
                break
            fi
            # Convert Given/When/Then to user steps
            if [[ $line =~ When.*[Cc]lick ]]; then
                echo "$(echo "$line" | sed 's/.*When/1./' | sed 's/\*\*//g')" >> "$output_file"
            elif [[ $line =~ When.*[Ee]nter ]]; then
                echo "$(echo "$line" | sed 's/.*When/2./' | sed 's/\*\*//g')" >> "$output_file"
            fi
        fi
    done < "$source_file"

    cat >> "$output_file" <<EOF

### Expected Results

When you complete the steps above, you should see:

- [Expected outcome 1]
- [Expected outcome 2]

## Frequently Asked Questions

**Q: What if I encounter an error?**
A: [Error guidance based on error handling criteria]

**Q: Can I [common user question]?**
A: [Answer based on feature scope]

## Related Features

- [Related Feature 1]
- [Related Feature 2]

## Need Help?

If you need assistance with this feature:
- Contact support at [support email]
- Visit our help center at [help URL]
- Check the troubleshooting guide at [guide URL]

---
*Last updated: $(date +%Y-%m-%d)*
EOF

    log_success "User guide generated: $output_file"
}

# Generate technical documentation
generate_technical_doc() {
    local source_file=$1
    local output_file=$2

    log_info "Generating technical documentation from: $(basename "$source_file")"

    local feature_name=$(grep -m1 "^#\|^## " "$source_file" | sed 's/^#\+\s*//' || echo "Feature")

    cat > "$output_file" <<EOF
# Technical Documentation: $feature_name

## Overview

$(grep -A 3 "Context:\|Background:" "$source_file" | tail -n +2 || echo "[Feature context]")

## Architecture

### Components Affected

$(grep -A 10 "Technical Notes:\|Implementation:" "$source_file" | grep -E "^\s*[-*]" || echo "- [Component 1]
- [Component 2]")

### Data Model

\`\`\`
[Data structures/schema]
\`\`\`

### API Endpoints

$(grep -i "API\|endpoint" "$source_file" || echo "#### [Endpoint Name]

- **Method**: GET/POST/PUT/DELETE
- **URL**: \`/api/[endpoint]\`
- **Request**:
  \`\`\`json
  {}
  \`\`\`
- **Response**:
  \`\`\`json
  {}
  \`\`\`")

## Implementation Details

### Key Files

- \`[file1.ts]\` - [Description]
- \`[file2.ts]\` - [Description]

### Dependencies

$(grep -A 5 "Dependencies:" "$source_file" | tail -n +2 || echo "- [Dependency 1]
- [Dependency 2]")

## Testing

### Test Coverage

- Unit tests: \`[test-file.test.ts]\`
- Integration tests: \`[integration.test.ts]\`
- E2E tests: \`[e2e.test.ts]\`

### Test Scenarios

$(grep -A 20 "Acceptance Criteria" "$source_file" | grep -E "Given.*When.*Then" | sed 's/^/- /' || echo "- [Test scenario 1]
- [Test scenario 2]")

## Configuration

### Environment Variables

\`\`\`bash
FEATURE_ENABLED=true
[OTHER_CONFIG]=value
\`\`\`

### Feature Flags

- \`${feature_name}_enabled\` - Enable/disable this feature

## Security Considerations

$(grep -A 5 "Security:\|Non-Functional" "$source_file" | grep -i security || echo "- Authentication: [Method]
- Authorization: [Rules]
- Data encryption: [Details]")

## Performance

$(grep -A 5 "Performance:\|Non-Functional" "$source_file" | grep -i performance || echo "- Expected load: [Metrics]
- Response time: [Target]
- Caching strategy: [Details]")

## Monitoring & Alerts

### Metrics to Track

- [Metric 1]
- [Metric 2]

### Alerts

- [Alert condition 1]
- [Alert condition 2]

## Deployment

### Prerequisites

- [Prerequisite 1]
- [Prerequisite 2]

### Deployment Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

### Rollback Plan

[Rollback procedure]

## Troubleshooting

### Common Issues

**Issue**: [Problem description]
**Solution**: [Resolution steps]

---
*Last updated: $(date +%Y-%m-%d)*
EOF

    log_success "Technical documentation generated: $output_file"
}

# Generate release notes
generate_release_notes() {
    local source_dir=$1
    local version=$2
    local output_file=$3

    log_info "Generating release notes for version $version"

    cat > "$output_file" <<EOF
# Release Notes - Version $version

**Release Date**: $(date +%Y-%m-%d)

## New Features

EOF

    # Find all user story files and extract features
    if [ -d "$source_dir" ]; then
        find "$source_dir" -type f -name "*.md" | while read -r file; do
            local feature=$(grep -m1 "^#\|^## " "$file" | sed 's/^#\+\s*//' || echo "Feature")
            local value=$(grep -o "So that[^#]*" "$file" | head -1 | sed 's/So that //' || echo "")

            echo "### $feature" >> "$output_file"
            echo "" >> "$output_file"
            echo "$value" >> "$output_file"
            echo "" >> "$output_file"
        done
    fi

    cat >> "$output_file" <<EOF

## Improvements

- [Improvement 1]
- [Improvement 2]

## Bug Fixes

- [Bug fix 1]
- [Bug fix 2]

## Breaking Changes

⚠️ **None** / [Description of breaking changes]

## Migration Guide

[Steps to migrate from previous version, if needed]

## Known Issues

- [Known issue 1]
- [Known issue 2]

## Deprecations

- [Deprecated feature 1] - Will be removed in version [X.X.X]

## Upgrade Instructions

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Contributors

- [Contributor 1]
- [Contributor 2]

---

For detailed technical changes, see the [Technical Documentation](./TECHNICAL.md)
EOF

    log_success "Release notes generated: $output_file"
}

# Generate API documentation
generate_api_doc() {
    local source_file=$1
    local output_file=$2

    log_info "Generating API documentation from: $(basename "$source_file")"

    cat > "$output_file" <<EOF
# API Documentation

## Overview

[API description based on feature]

## Authentication

All API requests require authentication using:

\`\`\`
Authorization: Bearer {token}
\`\`\`

## Endpoints

### [Endpoint Name]

**URL**: \`/api/[endpoint]\`

**Method**: \`GET\` | \`POST\` | \`PUT\` | \`DELETE\`

**Description**: [What this endpoint does]

#### Request

**Headers**:
\`\`\`
Content-Type: application/json
Authorization: Bearer {token}
\`\`\`

**Parameters**:

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| param1 | string | Yes | [Description] |
| param2 | number | No | [Description] |

**Body** (if POST/PUT):
\`\`\`json
{
  "field1": "value1",
  "field2": "value2"
}
\`\`\`

#### Response

**Success Response** (200 OK):
\`\`\`json
{
  "success": true,
  "data": {
    "id": "123",
    "field1": "value1"
  }
}
\`\`\`

**Error Responses**:

- **400 Bad Request**: Invalid input
  \`\`\`json
  {
    "success": false,
    "error": "Invalid parameter: param1"
  }
  \`\`\`

- **401 Unauthorized**: Authentication failed
  \`\`\`json
  {
    "success": false,
    "error": "Invalid or expired token"
  }
  \`\`\`

- **404 Not Found**: Resource not found
  \`\`\`json
  {
    "success": false,
    "error": "Resource not found"
  }
  \`\`\`

- **500 Internal Server Error**: Server error
  \`\`\`json
  {
    "success": false,
    "error": "Internal server error"
  }
  \`\`\`

#### Example

**Request**:
\`\`\`bash
curl -X GET \\
  https://api.example.com/api/[endpoint] \\
  -H 'Authorization: Bearer {token}' \\
  -H 'Content-Type: application/json'
\`\`\`

**Response**:
\`\`\`json
{
  "success": true,
  "data": { ... }
}
\`\`\`

## Rate Limiting

- Rate limit: 100 requests per minute
- Rate limit header: \`X-RateLimit-Remaining\`

## Webhooks

[Webhook documentation if applicable]

---
*Last updated: $(date +%Y-%m-%d)*
EOF

    log_success "API documentation generated: $output_file"
}

# Main function
main() {
    local doc_type=${1:-"user-guide"}
    local source=$2
    local output=${3:-""}

    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║      Documentation Generator                       ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""

    if [ -z "$source" ]; then
        log_error "Source file/directory not specified"
        echo ""
        echo "Usage:"
        echo "  $0 user-guide <source-file.md> [output-file.md]"
        echo "  $0 technical <source-file.md> [output-file.md]"
        echo "  $0 release-notes <source-dir> <version> [output-file.md]"
        echo "  $0 api <source-file.md> [output-file.md]"
        exit 1
    fi

    case "$doc_type" in
        user-guide|user)
            output=${output:-"user-guide.md"}
            generate_user_guide "$source" "$output"
            ;;
        technical|tech)
            output=${output:-"technical-doc.md"}
            generate_technical_doc "$source" "$output"
            ;;
        release-notes|release)
            local version=$output
            output=${4:-"RELEASE-NOTES.md"}
            generate_release_notes "$source" "$version" "$output"
            ;;
        api)
            output=${output:-"api-doc.md"}
            generate_api_doc "$source" "$output"
            ;;
        *)
            log_error "Unknown documentation type: $doc_type"
            exit 1
            ;;
    esac

    echo ""
    log_success "Documentation generation complete!"
    echo "Output: $output"
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
