#!/bin/bash

# Code Quality Lint Script - READ-ONLY CHECKS
# This script verifies code quality without making any changes to files.
# Perfect for CI/CD pipelines, pre-commit hooks, and code review.
#
# What it does:
# 1. Checks code formatting with Black (shows diff)
# 2. Checks import sorting with isort (shows diff)
# 3. Runs flake8 linting (style violations, complexity)
# 4. Runs mypy type checking (advisory - doesn't fail the script)
#
# Usage: ./scripts/lint.sh
# Prerequisites: uv sync --group dev
# Exit codes: 0 = all required checks pass, non-zero = issues found

# Change to project root directory
cd "$(dirname "$0")/.."

FAILED=0

echo "Running code quality lint script (read-only checks)..."
echo ""

echo "Step 1/4: Checking code formatting with Black..."
if uv run black --check --diff backend/; then
    echo "  Black formatting check passed"
else
    echo "  Black formatting check failed - run ./scripts/format.sh to fix"
    FAILED=1
fi
echo ""

echo "Step 2/4: Checking import sorting with isort..."
if uv run isort --check-only --diff backend/; then
    echo "  Import sorting check passed"
else
    echo "  Import sorting check failed - run ./scripts/format.sh to fix"
    FAILED=1
fi
echo ""

echo "Step 3/4: Running flake8 linting..."
if uv run flake8 backend/; then
    echo "  Flake8 linting passed"
else
    echo "  Flake8 linting failed - fix issues above"
    FAILED=1
fi
echo ""

echo "Step 4/4: Running mypy type checking (advisory)..."
if uv run mypy backend/ --ignore-missing-imports; then
    echo "  Mypy type checking passed"
else
    echo "  Mypy found type issues above (advisory - does not fail lint)"
fi
echo ""

if [ $FAILED -eq 0 ]; then
    echo "All code quality checks passed!"
    exit 0
else
    echo "Some code quality checks failed. Please fix the issues above."
    exit 1
fi
