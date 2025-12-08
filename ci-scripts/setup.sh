#!/usr/bin/env bash
# CI Setup Script - Shared between GitHub Actions and GitLab CI
# This script installs dependencies and prepares the environment

set -euo pipefail

echo "==> Setting up Branch Newspaper CI environment"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
esac

echo "==> Detected OS: $OS, Architecture: $ARCH"

# Install Elixir dependencies
echo "==> Installing Mix dependencies..."
mix local.hex --force
mix local.rebar --force
mix deps.get

# Compile in the appropriate environment
MIX_ENV="${MIX_ENV:-test}"
echo "==> Compiling in $MIX_ENV environment..."
mix compile --warnings-as-errors

# Setup database
echo "==> Setting up database..."
mix ecto.create || true
mix ecto.migrate

# Install Node.js dependencies for assets (if needed)
if [ -f "assets/package.json" ]; then
    echo "==> Installing Node.js dependencies..."
    cd assets && npm ci && cd ..
fi

# Setup Kubo/IPFS if needed for tests
if [ -d "kubo" ] && [ "${SETUP_IPFS:-false}" = "true" ]; then
    echo "==> Setting up IPFS (Kubo)..."
    if [ ! -f "kubo/ipfs" ]; then
        KUBO_VERSION="${KUBO_VERSION:-v0.24.0}"
        KUBO_TARBALL="kubo_${KUBO_VERSION}_${OS}-${ARCH}.tar.gz"

        if [ -f "$KUBO_TARBALL" ]; then
            tar -xzf "$KUBO_TARBALL" -C kubo --strip-components=1
        else
            echo "Warning: Kubo tarball not found, skipping IPFS setup"
        fi
    fi
fi

echo "==> Setup complete!"
