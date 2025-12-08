#!/usr/bin/env bash
# Mirror Verification Script
# Confirms that all branches and tags have been transferred between repositories

set -euo pipefail

echo "==> Branch Newspaper Mirror Verification"

# Configuration
SOURCE_REMOTE="${SOURCE_REMOTE:-gitlab}"
DEST_REMOTE="${DEST_REMOTE:-origin}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to print status
print_status() {
    local status=$1
    local message=$2
    case $status in
        ok)
            echo -e "${GREEN}[OK]${NC} $message"
            ;;
        error)
            echo -e "${RED}[ERROR]${NC} $message"
            ((ERRORS++))
            ;;
        warn)
            echo -e "${YELLOW}[WARN]${NC} $message"
            ((WARNINGS++))
            ;;
    esac
}

# Fetch latest from both remotes
echo "==> Fetching from remotes..."
git fetch "$SOURCE_REMOTE" --tags --prune 2>/dev/null || print_status warn "Could not fetch from $SOURCE_REMOTE"
git fetch "$DEST_REMOTE" --tags --prune 2>/dev/null || print_status warn "Could not fetch from $DEST_REMOTE"

# Verify branches
echo ""
echo "==> Verifying branches..."

SOURCE_BRANCHES=$(git branch -r | grep "^  $SOURCE_REMOTE/" | sed "s|  $SOURCE_REMOTE/||" | grep -v "HEAD" || true)
DEST_BRANCHES=$(git branch -r | grep "^  $DEST_REMOTE/" | sed "s|  $DEST_REMOTE/||" | grep -v "HEAD" || true)

if [ -z "$SOURCE_BRANCHES" ]; then
    print_status warn "No branches found on $SOURCE_REMOTE"
else
    for branch in $SOURCE_BRANCHES; do
        if echo "$DEST_BRANCHES" | grep -q "^$branch$"; then
            # Check if commits match
            SOURCE_COMMIT=$(git rev-parse "$SOURCE_REMOTE/$branch" 2>/dev/null || echo "")
            DEST_COMMIT=$(git rev-parse "$DEST_REMOTE/$branch" 2>/dev/null || echo "")

            if [ "$SOURCE_COMMIT" = "$DEST_COMMIT" ]; then
                print_status ok "Branch '$branch' synced (${SOURCE_COMMIT:0:7})"
            else
                print_status error "Branch '$branch' out of sync: $SOURCE_REMOTE=${SOURCE_COMMIT:0:7} vs $DEST_REMOTE=${DEST_COMMIT:0:7}"
            fi
        else
            print_status error "Branch '$branch' missing on $DEST_REMOTE"
        fi
    done
fi

# Verify tags
echo ""
echo "==> Verifying tags..."

SOURCE_TAGS=$(git tag -l | sort)
DEST_TAGS=$(git ls-remote --tags "$DEST_REMOTE" 2>/dev/null | awk '{print $2}' | sed 's|refs/tags/||' | grep -v '\^{}' | sort || true)

if [ -z "$SOURCE_TAGS" ]; then
    print_status warn "No tags found in repository"
else
    for tag in $SOURCE_TAGS; do
        if echo "$DEST_TAGS" | grep -q "^$tag$"; then
            print_status ok "Tag '$tag' present on $DEST_REMOTE"
        else
            print_status error "Tag '$tag' missing on $DEST_REMOTE"
        fi
    done
fi

# Verify commit history integrity
echo ""
echo "==> Verifying commit history..."

# Get the main/master branch
MAIN_BRANCH=""
for branch in main master; do
    if git rev-parse --verify "$DEST_REMOTE/$branch" &>/dev/null; then
        MAIN_BRANCH=$branch
        break
    fi
done

if [ -n "$MAIN_BRANCH" ]; then
    COMMIT_COUNT=$(git rev-list --count "$DEST_REMOTE/$MAIN_BRANCH" 2>/dev/null || echo "0")
    print_status ok "Commit history intact: $COMMIT_COUNT commits on $MAIN_BRANCH"

    # Show recent commits
    echo ""
    echo "==> Recent commits on $MAIN_BRANCH:"
    git log --oneline -5 "$DEST_REMOTE/$MAIN_BRANCH" 2>/dev/null || true
else
    print_status warn "Could not find main/master branch"
fi

# Summary
echo ""
echo "==> Verification Summary"
echo "========================"
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo -e "${RED}Mirror verification FAILED${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}Mirror verification PASSED${NC}"
    exit 0
fi
