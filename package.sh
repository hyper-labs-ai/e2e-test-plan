#!/usr/bin/env bash
# Package the e2e-test-plan skill into a distributable .skill file
# Usage: ./package.sh [output-directory]
#   Default output: ./dist/e2e-test-plan.skill
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_NAME="e2e-test-plan"
OUTPUT_DIR="${1:-"$SKILL_DIR/dist"}"
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT

# Stage skill files
mkdir -p "$STAGING/$SKILL_NAME/references" "$STAGING/$SKILL_NAME/evals"
cp "$SKILL_DIR/SKILL.md" "$STAGING/$SKILL_NAME/SKILL.md"
cp "$SKILL_DIR/references/plan-template.md" "$STAGING/$SKILL_NAME/references/plan-template.md"
cp "$SKILL_DIR/references/plan-formats.md" "$STAGING/$SKILL_NAME/references/plan-formats.md"
cp "$SKILL_DIR/evals/evals.json" "$STAGING/$SKILL_NAME/evals/evals.json"

# Create output directory
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/$SKILL_NAME.skill"

# Package as zip with .skill extension
cd "$STAGING"
zip -r "$OUTPUT_FILE" "$SKILL_NAME/" > /dev/null
cd - > /dev/null

echo "✓ Packaged: $OUTPUT_FILE ($(wc -c < "$OUTPUT_FILE") bytes)"
echo ""
echo "To install:"
echo "  unzip -o \"$OUTPUT_FILE\" -d ~/.agents/skills/"
echo ""
echo "Contents:"
unzip -l "$OUTPUT_FILE"
