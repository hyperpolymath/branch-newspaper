#!/usr/bin/env bash
# Mirror Push Script - Pushes changes from GitHub to GitLab
# This is triggered by GitHub Actions on push events (event-driven, not polling)

set -euo pipefail

echo "==> Pushing to GitLab Mirror"

# Configuration from environment
GITLAB_URL="${GITLAB_URL:-git@gitlab.com:maa-framework/3-applications/branch-newspaper.git}"
GITLAB_REMOTE_NAME="gitlab-mirror"

# Setup GitLab remote if not exists
if ! git remote get-url "$GITLAB_REMOTE_NAME" &>/dev/null; then
    echo "==> Adding GitLab mirror remote..."
    git remote add "$GITLAB_REMOTE_NAME" "$GITLAB_URL"
fi

# Get current branch/ref
CURRENT_REF="${GITHUB_REF:-$(git symbolic-ref HEAD 2>/dev/null || git rev-parse HEAD)}"
CURRENT_BRANCH="${CURRENT_REF#refs/heads/}"

echo "==> Current ref: $CURRENT_REF"
echo "==> Current branch: $CURRENT_BRANCH"

# Push with retry logic
MAX_RETRIES=4
RETRY_DELAY=2

push_with_retry() {
    local target=$1
    local retries=0

    while [ $retries -lt $MAX_RETRIES ]; do
        echo "==> Pushing $target to GitLab (attempt $((retries + 1))/$MAX_RETRIES)..."

        if git push "$GITLAB_REMOTE_NAME" "$target" --force-with-lease 2>&1; then
            echo "==> Successfully pushed $target"
            return 0
        fi

        retries=$((retries + 1))
        if [ $retries -lt $MAX_RETRIES ]; then
            echo "==> Push failed, retrying in ${RETRY_DELAY}s..."
            sleep $RETRY_DELAY
            RETRY_DELAY=$((RETRY_DELAY * 2))
        fi
    done

    echo "==> Failed to push $target after $MAX_RETRIES attempts"
    return 1
}

# Push branches
echo "==> Pushing branches..."
push_with_retry "$CURRENT_BRANCH"

# Push tags if this is a tag push
if [[ "$CURRENT_REF" == refs/tags/* ]]; then
    TAG_NAME="${CURRENT_REF#refs/tags/}"
    echo "==> Pushing tag: $TAG_NAME"
    push_with_retry "refs/tags/$TAG_NAME"
fi

# Optionally push all tags
if [ "${PUSH_ALL_TAGS:-false}" = "true" ]; then
    echo "==> Pushing all tags..."
    git push "$GITLAB_REMOTE_NAME" --tags --force-with-lease || true
fi

echo "==> Mirror push complete!"
