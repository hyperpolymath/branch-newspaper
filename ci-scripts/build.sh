#!/usr/bin/env bash
# CI Build Script - Shared between GitHub Actions and GitLab CI
# This script builds the application for deployment

set -euo pipefail

echo "==> Building Branch Newspaper"

# Set environment
export MIX_ENV="${MIX_ENV:-prod}"

echo "==> Building in $MIX_ENV environment"

# Get dependencies
echo "==> Getting dependencies..."
mix deps.get --only $MIX_ENV

# Compile
echo "==> Compiling..."
mix compile

# Build assets
echo "==> Building assets..."
if [ -f "assets/package.json" ]; then
    cd assets
    npm ci
    cd ..
fi

# Deploy assets (esbuild + tailwind)
mix assets.deploy

# Create release
if grep -q "releases:" mix.exs 2>/dev/null; then
    echo "==> Creating release..."
    mix release --overwrite

    # Show release info
    echo ""
    echo "==> Release created successfully!"
    ls -la _build/$MIX_ENV/rel/branch_newspaper/ 2>/dev/null || true
else
    echo "==> Skipping release (not configured in mix.exs)"
fi

echo "==> Build complete!"
