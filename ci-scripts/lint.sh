#!/usr/bin/env bash
# CI Lint Script - Shared between GitHub Actions and GitLab CI
# This script runs code quality checks

set -euo pipefail

echo "==> Running Branch Newspaper Linting & Code Quality Checks"

EXIT_CODE=0

# Check formatting
echo "==> Checking code formatting..."
if ! mix format --check-formatted; then
    echo "ERROR: Code is not properly formatted. Run 'mix format' to fix."
    EXIT_CODE=1
fi

# Check for unused dependencies
echo "==> Checking for unused dependencies..."
if mix deps.unlock --check-unused 2>/dev/null; then
    echo "OK: No unused dependencies found."
else
    echo "WARNING: Unused dependencies detected."
    # Don't fail on unused deps, just warn
fi

# Compile with warnings as errors
echo "==> Compiling with warnings as errors..."
if ! mix compile --warnings-as-errors --force; then
    echo "ERROR: Compilation warnings found."
    EXIT_CODE=1
fi

# Run Credo for static code analysis (if available)
if grep -q "credo" mix.exs 2>/dev/null; then
    echo "==> Running Credo static analysis..."
    if ! mix credo --strict; then
        echo "WARNING: Credo found issues."
        # Make Credo failures advisory for now
    fi
fi

# Run Dialyzer for type checking (if PLT exists or --dialyzer flag passed)
if [ "${RUN_DIALYZER:-false}" = "true" ]; then
    echo "==> Running Dialyzer type analysis..."
    if grep -q "dialyxir" mix.exs 2>/dev/null; then
        mix dialyzer --format github || echo "WARNING: Dialyzer found issues."
    else
        echo "SKIP: Dialyxir not configured."
    fi
fi

# Check for security vulnerabilities in dependencies
if grep -q "sobelow" mix.exs 2>/dev/null; then
    echo "==> Running Sobelow security scan..."
    mix sobelow --config || echo "WARNING: Sobelow found potential issues."
fi

# Check for outdated dependencies
echo "==> Checking for outdated dependencies..."
mix hex.outdated || true

echo "==> Lint checks complete with exit code: $EXIT_CODE"
exit $EXIT_CODE
