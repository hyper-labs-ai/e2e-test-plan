#!/usr/bin/env bash
# Deploy the e2e-test-plan skill from dev location to ~/.agents/skills/
set -euo pipefail

SKILL_DEV="$(cd "$(dirname "$0")" && pwd)"
SKILL_NAME="$(basename "$SKILL_DEV")"
TARGET="$HOME/.agents/skills/$SKILL_NAME"

echo "Deploying '$SKILL_NAME' from $SKILL_DEV to $TARGET"

# Remove existing installation
if [ -e "$TARGET" ]; then
    rm -rf "$TARGET"
fi

# Copy skill files (exclude workspace)
mkdir -p "$TARGET/references" "$TARGET/evals"
cp "$SKILL_DEV/SKILL.md" "$TARGET/SKILL.md"
cp "$SKILL_DEV/references/plan-template.md" "$TARGET/references/plan-template.md"
cp "$SKILL_DEV/references/plan-formats.md" "$TARGET/references/plan-formats.md"
cp "$SKILL_DEV/evals/evals.json" "$TARGET/evals/evals.json"

echo "✓ Deployed to $TARGET"
echo ""
echo "To verify:"
echo "  ls -la $TARGET/"
