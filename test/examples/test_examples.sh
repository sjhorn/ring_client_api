#!/bin/bash
#
# Ring Client API - Example Test Runner
#
# Runs all example tests including Playwright browser tests.
#
# Usage:
#   ./test_examples.sh              # Run all tests
#   ./test_examples.sh --no-browser # Skip browser tests
#   ./test_examples.sh --browser    # Run only browser tests
#   ./test_examples.sh record       # Run specific example test
#
# Environment:
#   RING_REFRESH_TOKEN - Required for all tests
#

set -e

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for refresh token - try .env file if not set
if [ -z "$RING_REFRESH_TOKEN" ]; then
    if [ -f "$PROJECT_ROOT/.env" ]; then
        echo -e "${YELLOW}Loading token from .env file...${NC}"
        # Handle both refreshToken= and RING_REFRESH_TOKEN= formats
        if grep -q "^RING_REFRESH_TOKEN=" "$PROJECT_ROOT/.env"; then
            RING_REFRESH_TOKEN="$(grep "^RING_REFRESH_TOKEN=" "$PROJECT_ROOT/.env" | sed 's/^RING_REFRESH_TOKEN=//')"
        elif grep -q "^refreshToken=" "$PROJECT_ROOT/.env"; then
            RING_REFRESH_TOKEN="$(grep "^refreshToken=" "$PROJECT_ROOT/.env" | sed 's/^refreshToken=//')"
        fi
        export RING_REFRESH_TOKEN
    fi
fi

if [ -z "$RING_REFRESH_TOKEN" ]; then
    echo -e "${RED}Error: RING_REFRESH_TOKEN environment variable is required${NC}"
    echo ""
    echo "Usage:"
    echo "  export RING_REFRESH_TOKEN=\"your_token\""
    echo "  ./test/examples/test_examples.sh"
    echo ""
    echo "Or create a .env file with:"
    echo "  RING_REFRESH_TOKEN=your_token"
    exit 1
fi

# Parse arguments
RUN_BROWSER=true
RUN_EXAMPLES=true
EXAMPLE_FILTER=""

for arg in "$@"; do
    case $arg in
        --no-browser)
            RUN_BROWSER=false
            ;;
        --browser)
            RUN_EXAMPLES=false
            ;;
        *)
            EXAMPLE_FILTER="$arg"
            ;;
    esac
done

echo "========================================"
echo "Ring Client API - Example Tests"
echo "========================================"
echo ""

# Install Playwright if needed
if [ "$RUN_BROWSER" = true ]; then
    if [ ! -d "$SCRIPT_DIR/node_modules" ]; then
        echo -e "${YELLOW}Installing Playwright dependencies...${NC}"
        (cd "$SCRIPT_DIR" && npm install && npx playwright install chromium)
        echo ""
    fi
fi

# Track results
PASSED=0
FAILED=0

# Run Dart example tests (from project root)
if [ "$RUN_EXAMPLES" = true ]; then
    echo -e "${YELLOW}Running Dart example tests...${NC}"
    echo ""

    cd "$PROJECT_ROOT"
    if [ -n "$EXAMPLE_FILTER" ]; then
        if dart run test/examples/run_example_tests.dart "$EXAMPLE_FILTER"; then
            PASSED=$((PASSED + 1))
        else
            FAILED=$((FAILED + 1))
        fi
    else
        if dart run test/examples/run_example_tests.dart; then
            PASSED=$((PASSED + 1))
        else
            FAILED=$((FAILED + 1))
        fi
    fi

    echo ""
fi

# Run Playwright browser tests
if [ "$RUN_BROWSER" = true ]; then
    echo -e "${YELLOW}Running Playwright browser tests...${NC}"
    echo ""

    # Create test-results directory in project root
    mkdir -p "$PROJECT_ROOT/test-results"

    if (cd "$SCRIPT_DIR" && npx playwright test); then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi

    echo ""
fi

# Summary
echo "========================================"
echo "Test Summary"
echo "========================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All test suites passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed${NC}"
    echo "Passed: $PASSED"
    echo "Failed: $FAILED"
    exit 1
fi
