#!/bin/bash
# Auto Test on Change Hook
# Automatically runs affected tests when code changes are detected

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 Detecting test framework...${NC}"

# Detect test framework
if [ -f "package.json" ]; then
  if grep -q "jest" package.json; then
    FRAMEWORK="jest"
  elif grep -q "vitest" package.json; then
    FRAMEWORK="vitest"
  elif grep -q "playwright" package.json; then
    FRAMEWORK="playwright"
  elif grep -q "@playwright/test" package.json; then
    FRAMEWORK="playwright"
  else
    FRAMEWORK="unknown"
  fi
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
  FRAMEWORK="pytest"
elif [ -f "Gemfile" ] && grep -q "rspec" Gemfile 2>/dev/null; then
  FRAMEWORK="rspec"
else
  FRAMEWORK="unknown"
fi

echo -e "${GREEN}✓ Detected framework: $FRAMEWORK${NC}"

# Get changed files from git
if git rev-parse --git-dir > /dev/null 2>&1; then
  CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

  if [ -z "$CHANGED_FILES" ]; then
    echo -e "${YELLOW}⚠ No staged changes detected${NC}"
    exit 0
  fi

  echo -e "${YELLOW}📝 Changed files:${NC}"
  echo "$CHANGED_FILES" | while read -r file; do
    echo "  - $file"
  done
else
  echo -e "${RED}✗ Not a git repository${NC}"
  exit 1
fi

# Function to find related test files
find_related_tests() {
  local source_file=$1
  local test_pattern=""

  case $FRAMEWORK in
    jest|vitest)
      # Look for .test.js, .spec.js, .test.ts, .spec.ts
      test_pattern="${source_file%.*}.{test,spec}.{js,ts,jsx,tsx}"
      find . -type f \( -name "$(basename "${source_file%.*}").test.*" -o -name "$(basename "${source_file%.*}").spec.*" \) 2>/dev/null
      ;;
    playwright)
      # Look for .spec.ts files
      find . -type f -name "$(basename "${source_file%.*}").spec.ts" 2>/dev/null
      ;;
    pytest)
      # Look for test_*.py or *_test.py
      find . -type f \( -name "test_$(basename "${source_file%.*}").py" -o -name "$(basename "${source_file%.*}")_test.py" \) 2>/dev/null
      ;;
    rspec)
      # Look for *_spec.rb
      find . -type f -name "$(basename "${source_file%.*}")_spec.rb" 2>/dev/null
      ;;
  esac
}

# Collect all related test files
TEST_FILES=""
while IFS= read -r file; do
  # Skip if file is already a test file
  if [[ $file =~ \.(test|spec)\. ]] || [[ $file =~ test_ ]] || [[ $file =~ _test\. ]] || [[ $file =~ _spec\. ]]; then
    TEST_FILES="$TEST_FILES $file"
    continue
  fi

  # Find related test files
  related_tests=$(find_related_tests "$file")
  if [ -n "$related_tests" ]; then
    TEST_FILES="$TEST_FILES $related_tests"
  fi
done <<< "$CHANGED_FILES"

# Remove duplicates and trim
TEST_FILES=$(echo "$TEST_FILES" | tr ' ' '\n' | sort -u | tr '\n' ' ' | xargs)

if [ -z "$TEST_FILES" ]; then
  echo -e "${YELLOW}⚠ No related tests found${NC}"
  echo -e "${YELLOW}💡 Consider adding tests for changed files${NC}"
  exit 0
fi

echo -e "\n${YELLOW}🧪 Running affected tests...${NC}"
echo "$TEST_FILES" | tr ' ' '\n' | while read -r file; do
  [ -n "$file" ] && echo "  - $file"
done

# Run tests based on framework
case $FRAMEWORK in
  jest)
    if command -v npm &> /dev/null; then
      echo -e "\n${YELLOW}Running Jest tests...${NC}"
      npm test -- $TEST_FILES --coverage --changedSince=HEAD || {
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
      }
    else
      echo -e "${RED}✗ npm not found${NC}"
      exit 1
    fi
    ;;

  vitest)
    if command -v npm &> /dev/null; then
      echo -e "\n${YELLOW}Running Vitest tests...${NC}"
      npm test -- --run $TEST_FILES --coverage || {
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
      }
    else
      echo -e "${RED}✗ npm not found${NC}"
      exit 1
    fi
    ;;

  playwright)
    if command -v npx &> /dev/null; then
      echo -e "\n${YELLOW}Running Playwright tests...${NC}"
      npx playwright test $TEST_FILES || {
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
      }
    else
      echo -e "${RED}✗ npx not found${NC}"
      exit 1
    fi
    ;;

  pytest)
    if command -v pytest &> /dev/null; then
      echo -e "\n${YELLOW}Running pytest tests...${NC}"
      pytest $TEST_FILES --cov --cov-report=term-missing || {
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
      }
    else
      echo -e "${RED}✗ pytest not found${NC}"
      exit 1
    fi
    ;;

  rspec)
    if command -v bundle &> /dev/null; then
      echo -e "\n${YELLOW}Running RSpec tests...${NC}"
      bundle exec rspec $TEST_FILES || {
        echo -e "${RED}✗ Tests failed${NC}"
        exit 1
      }
    else
      echo -e "${RED}✗ bundle not found${NC}"
      exit 1
    fi
    ;;

  *)
    echo -e "${RED}✗ Unknown test framework${NC}"
    echo -e "${YELLOW}💡 Supported: jest, vitest, playwright, pytest, rspec${NC}"
    exit 1
    ;;
esac

echo -e "\n${GREEN}✓ All affected tests passed!${NC}"

# Check if we should run full test suite
if [ "${RUN_FULL_SUITE:-false}" = "true" ]; then
  echo -e "\n${YELLOW}🧪 Running full test suite...${NC}"
  case $FRAMEWORK in
    jest|vitest)
      npm test -- --run --coverage
      ;;
    playwright)
      npx playwright test
      ;;
    pytest)
      pytest --cov
      ;;
    rspec)
      bundle exec rspec
      ;;
  esac
fi

exit 0
