#!/bin/sh
# Smoke tests for new-computer-install.sh
# Runs the script with --dry-run and validates expected output

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/new-computer-install.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

# Test helper: check if output contains expected string
assert_contains() {
  local output="$1"
  local expected="$2"
  local test_name="$3"

  if echo "$output" | grep -qF -- "$expected"; then
    echo "${GREEN}✓${NC} $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "${RED}✗${NC} $test_name"
    echo "  Expected to find: $expected"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Test helper: check if output does NOT contain string
assert_not_contains() {
  local output="$1"
  local unexpected="$2"
  local test_name="$3"

  if ! echo "$output" | grep -qF -- "$unexpected"; then
    echo "${GREEN}✓${NC} $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "${RED}✗${NC} $test_name"
    echo "  Did not expect to find: $unexpected"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

echo "Running install script smoke tests..."
echo ""

# Change to script directory for tests
cd "$SCRIPT_DIR"

#############################################################################
# Test 1: Help output
#############################################################################
echo "Test: --help flag"
output=$("$INSTALL_SCRIPT" --help 2>&1)
assert_contains "$output" "Usage:" "Shows usage information"
assert_contains "$output" "--dry-run" "Documents dry-run flag"
assert_contains "$output" "--update" "Documents update flag"
assert_contains "$output" "--verbose" "Documents verbose flag"

#############################################################################
# Test 2: Dry-run mode banner
#############################################################################
echo ""
echo "Test: --dry-run mode"
output=$("$INSTALL_SCRIPT" --dry-run --update 2>&1)
assert_contains "$output" "DRY RUN MODE" "Shows dry-run banner"
assert_contains "$output" "UPDATE MODE" "Shows update mode banner"

#############################################################################
# Test 3: Configuration copy functions run
#############################################################################
echo ""
echo "Test: Configuration functions execute"
assert_contains "$output" "Setting up zsh configuration" "Runs copy_zsh_config"
assert_contains "$output" "Copying dotfiles" "Runs copy_dotfiles"
assert_contains "$output" "Copying XDG config files" "Runs copy_xdg_config"
assert_contains "$output" "Copying Claude Code user settings" "Runs copy_claude_settings"

#############################################################################
# Test 4: Update mode skips installations
#############################################################################
echo ""
echo "Test: Update mode behavior"
assert_contains "$output" "Skipping shell environment setup" "Skips shell setup in update mode"
assert_contains "$output" "Skipping package installation" "Skips packages in update mode"

#############################################################################
# Test 5: Dry-run doesn't modify files
#############################################################################
echo ""
echo "Test: Dry-run safety"
assert_contains "$output" "[DRY RUN]" "Shows dry-run prefixes"
assert_not_contains "$output" "Error:" "No errors during dry-run"

#############################################################################
# Test 6: Completion message
#############################################################################
echo ""
echo "Test: Completion"
assert_contains "$output" "Configuration Update Complete" "Shows completion message"

#############################################################################
# Summary
#############################################################################
echo ""
echo "============================================================================="
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
if [ $TESTS_FAILED -eq 0 ]; then
  echo "${GREEN}All $TOTAL tests passed${NC}"
  exit 0
else
  echo "${RED}$TESTS_FAILED of $TOTAL tests failed${NC}"
  exit 1
fi
