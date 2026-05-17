#!/usr/bin/env bash
# Test Runner for audit-skill
#
# Runs validation tests based on evals.json and additional integration tests
# SAFETY: This script only tests read-only operations, never modifies files

set -euo pipefail

# Colors
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# Helper functions
pass() { echo -e "${GREEN}✓ $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}" >&2; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Test directory setup
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$TEST_DIR/.." && pwd)"
TEMP_DIR=$(mktemp -d -t audit-skill-tests.XXXXXX)
trap 'rm -rf "$TEMP_DIR"' EXIT

cd "$SKILL_DIR"

# Test counter
tests_run=0
tests_passed=0

run_test() {
  local test_name="$1"
  local test_command="$2"
  local expected_exit_code="${3:-0}"

  tests_run=$((tests_run + 1))
  info "Running: $test_name"

  local actual_exit_code=0
  eval "$test_command" >/dev/null 2>&1 || actual_exit_code=$?

  if [[ $actual_exit_code -eq $expected_exit_code ]]; then
    pass "$test_name"
    tests_passed=$((tests_passed + 1))
  else
    fail "$test_name (exit code: expected $expected_exit_code, got $actual_exit_code)"
  fi
}

echo "=== Skill Audit Test Suite ==="
echo "Skill: $(basename "$SKILL_DIR")"
echo "Test directory: $TEMP_DIR"
echo

# Test 1: Basic script existence and permissions
echo "## Basic Script Tests"
run_test "validate-skill.sh exists and executable" '[[ -x scripts/validate-skill.sh ]]'
run_test "review-skill.sh exists and executable" '[[ -x scripts/review-skill.sh ]]'

# Test 2: Self-validation tests
echo
echo "## Self-Validation Tests"
run_test "Self-validation passes" './scripts/validate-skill.sh .'
run_test "Self-review passes" './scripts/review-skill.sh .'

# Test 3: Error handling tests
echo
echo "## Error Handling Tests"
run_test "Validate nonexistent directory fails" './scripts/validate-skill.sh /nonexistent/path' 1
run_test "Review nonexistent directory fails" './scripts/review-skill.sh /nonexistent/path' 1

# Test 4: Create test skill for validation
echo
echo "## Test Skill Creation"
TEST_SKILL_DIR="$TEMP_DIR/test-skill"
mkdir -p "$TEST_SKILL_DIR/references"

# Good test skill
cat > "$TEST_SKILL_DIR/SKILL.md" << 'EOF'
---
name: test-skill
description: A test skill for validation with sufficient description length to avoid triggering warnings about short descriptions.
---

# Test Skill

This is a test skill for validation.

## Usage

Basic usage information.

## References

For advanced topics, see [advanced topics](references/advanced.md).
EOF

cat > "$TEST_SKILL_DIR/references/advanced.md" << 'EOF'
# Advanced Topics

This file contains advanced topics for the test skill.
EOF

cat > "$TEST_SKILL_DIR/evals.json" << 'EOF'
{
  "name": "test-skill",
  "testCases": [
    {
      "name": "basic_test",
      "prompt": "test prompt",
      "expectedContent": ["test"]
    }
  ]
}
EOF

run_test "Test skill validation passes" "./scripts/validate-skill.sh \"$TEST_SKILL_DIR\""
run_test "Test skill review passes" "./scripts/review-skill.sh \"$TEST_SKILL_DIR\""

# Test 5: Bad test skill
echo
echo "## Negative Tests"
BAD_SKILL_DIR="$TEMP_DIR/bad-skill"
mkdir -p "$BAD_SKILL_DIR"

# Missing SKILL.md
run_test "Missing SKILL.md fails validation" "./scripts/validate-skill.sh \"$BAD_SKILL_DIR\"" 1

# Create minimal SKILL.md without frontmatter
echo "# Bad Skill" > "$BAD_SKILL_DIR/SKILL.md"
run_test "Missing frontmatter fails validation" "./scripts/validate-skill.sh \"$BAD_SKILL_DIR\"" 1

# Test 6: evals.json validation
echo
echo "## evals.json Validation"
if [[ -f evals.json ]]; then
  if jq empty evals.json >/dev/null 2>&1; then
    pass "evals.json is valid JSON"
    tests_passed=$((tests_passed + 1))
  else
    fail "evals.json contains invalid JSON"
  fi
  tests_run=$((tests_run + 1))

  eval_count=$(jq -r '.testCases | length' evals.json 2>/dev/null || echo "0")
  if [[ $eval_count -gt 0 ]]; then
    pass "evals.json contains $eval_count test cases"
    tests_passed=$((tests_passed + 1))
  else
    fail "evals.json contains no test cases"
  fi
  tests_run=$((tests_run + 1))
fi

# Test 7: Security tests
echo
echo "## Security Tests"
run_test "Path traversal attack rejected" './scripts/validate-skill.sh ../../../etc' 1
run_test "Absolute path to system directory rejected" './scripts/validate-skill.sh /etc' 1

# Test summary
echo
echo "=== Test Summary ==="
echo "Tests run: $tests_run"
echo "Tests passed: $tests_passed"
echo "Tests failed: $((tests_run - tests_passed))"

if [[ $tests_passed -eq $tests_run ]]; then
  pass "All tests passed!"
  exit 0
else
  fail "$((tests_run - tests_passed)) test(s) failed"
  exit 1
fi