#!/bin/bash

# Code Quality Format Script - MODIFIES FILES
# This script automatically fixes code style issues and runs quality checks.
# Use this when you want to clean up your code automatically.
#
# What it does:
# 1. Sorts import statements (modifies files)
# 2. Formats code style with Black (modifies files)
# 3. Runs flake8 linting (reports remaining issues)
# 4. Runs mypy type checking (reports type issues)
#
# Usage: ./scripts/format.sh
# Prerequisites: uv sync --group dev

set -e  # Exit on first error

# Change to project root directory
cd "$(dirname "$0")/.."

echo "Running code quality format script (will modify files)..."
echo ""

echo "Step 1/4: Sorting imports with isort..."
uv run isort backend/
echo "  Imports sorted successfully"
echo ""

echo "Step 2/4: Formatting code with Black..."
uv run black backend/
echo "  Code formatted successfully"
echo ""

echo "Step 3/4: Running flake8 linting..."
if uv run flake8 backend/; then
    echo "  No linting issues found"
else
    echo "  Linting issues reported above (fix manually)"
fi
echo ""

echo "Step 4/4: Running mypy type checking..."
if uv run mypy backend/ --ignore-missing-imports; then
    echo "  No type issues found"
else
    echo "  Type issues reported above (fix manually)"
fi
echo ""

echo "Code quality format completed!"
