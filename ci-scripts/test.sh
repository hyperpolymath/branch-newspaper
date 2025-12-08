#!/usr/bin/env bash
# CI Test Script - Shared between GitHub Actions and GitLab CI
# This script runs all tests and generates coverage reports

set -euo pipefail

echo "==> Running Branch Newspaper Tests"

# Set environment
export MIX_ENV=test

# Parse arguments
COVERAGE="${COVERAGE:-false}"
FORMAT="${FORMAT:-default}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --coverage)
            COVERAGE=true
            shift
            ;;
        --format)
            FORMAT="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Ensure dependencies are compiled
echo "==> Ensuring test dependencies are compiled..."
mix deps.compile

# Run database migrations
echo "==> Running database migrations..."
mix ecto.create --quiet || true
mix ecto.migrate --quiet

# Run tests
echo "==> Running ExUnit tests..."

TEST_OPTS=""

if [ "$COVERAGE" = "true" ]; then
    echo "==> Coverage reporting enabled"
    # If using excoveralls
    if grep -q "excoveralls" mix.exs 2>/dev/null; then
        case $FORMAT in
            github)
                mix coveralls.github
                ;;
            html)
                mix coveralls.html
                ;;
            *)
                mix coveralls
                ;;
        esac
    else
        mix test --cover
    fi
else
    mix test $TEST_OPTS
fi

TEST_EXIT_CODE=$?

echo "==> Test run complete with exit code: $TEST_EXIT_CODE"
exit $TEST_EXIT_CODE
