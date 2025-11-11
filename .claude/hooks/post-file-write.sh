#!/usr/bin/env bash

# post-file-write.sh
# Automatically triggered after a file is written by Claude Code
# Triggers unit-test-generator skill for source files without corresponding tests

# Arguments:
#   $1 - File path that was written
#   $2 - File action (created, modified, deleted)

FILE_PATH="$1"
FILE_ACTION="$2"

# Only process source files (not test files)
if [[ "$FILE_PATH" =~ \.(test|spec)\.(ts|js|py|java|go)$ ]]; then
  exit 0  # Skip test files
fi

# Check if it's a source file
if [[ "$FILE_PATH" =~ \.(ts|js|tsx|jsx|py|java|go)$ ]]; then

  # Determine test file path based on project structure
  get_test_path() {
    local src_file="$1"
    local test_file=""

    # TypeScript/JavaScript (Jest/Vitest conventions)
    if [[ "$src_file" =~ \.(ts|js|tsx|jsx)$ ]]; then
      # Pattern 1: src/foo.ts → tests/foo.test.ts
      if [[ "$src_file" =~ ^src/ ]]; then
        test_file="${src_file/src\//tests/}"
        test_file="${test_file%.*}.test.${src_file##*.}"
      # Pattern 2: lib/foo.ts → __tests__/foo.test.ts
      elif [[ "$src_file" =~ ^lib/ ]]; then
        dir=$(dirname "$src_file")
        file=$(basename "$src_file" .${src_file##*.})
        test_file="$dir/__tests__/$file.test.${src_file##*.}"
      # Pattern 3: src/components/Foo.tsx → src/components/Foo.test.tsx
      else
        test_file="${src_file%.*}.test.${src_file##*.}"
      fi

    # Python (pytest conventions)
    elif [[ "$src_file" =~ \.py$ ]]; then
      # Pattern: src/foo.py → tests/test_foo.py
      if [[ "$src_file" =~ ^src/ ]]; then
        test_file="${src_file/src\//tests/}"
        file=$(basename "$test_file" .py)
        dir=$(dirname "$test_file")
        test_file="$dir/test_$file.py"
      fi

    # Java (JUnit conventions)
    elif [[ "$src_file" =~ \.java$ ]]; then
      # Pattern: src/main/java/Foo.java → src/test/java/FooTest.java
      test_file="${src_file/src\/main\/java/src/test/java}"
      test_file="${test_file%.java}Test.java"

    # Go (testing conventions)
    elif [[ "$src_file" =~ \.go$ ]] && [[ ! "$src_file" =~ _test\.go$ ]]; then
      # Pattern: foo.go → foo_test.go
      test_file="${src_file%.go}_test.go"
    fi

    echo "$test_file"
  }

  TEST_FILE=$(get_test_path "$FILE_PATH")

  # Check if test file exists
  if [ -n "$TEST_FILE" ] && [ ! -f "$TEST_FILE" ]; then
    echo "🧪 Source file modified without corresponding test: $FILE_PATH"
    echo "📝 Suggested test file: $TEST_FILE"
    echo ""
    echo "💡 Tip: Ask Claude to generate tests for this file"
    echo "   Example: 'Generate unit tests for $FILE_PATH'"
    echo ""

    # Optional: Auto-prompt Claude (if in interactive mode)
    # This would require Claude Code API integration
    # For now, just notify the user
  fi
fi

exit 0
