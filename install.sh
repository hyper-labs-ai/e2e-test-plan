#!/usr/bin/env bash
# Install e2e-test-plan skill for OpenCode / Claude Code
# Usage: ./install.sh [target-dir]
#   or:  curl -fsSL https://raw.githubusercontent.com/hyper-labs-ai/e2e-test-plan/main/install.sh | bash
set -euo pipefail

REPO="hyper-labs-ai/e2e-test-plan"
BRANCH="main"
TARGET="${1:-"$HOME/.agents/skills/e2e-test-plan"}"
TMPDIR=""

cleanup() {
  [[ -n "$TMPDIR" ]] && rm -rf "$TMPDIR"
}
trap cleanup EXIT

# macOS-compatible mktemp
mktempdir() {
  mktemp -d 2>/dev/null || mktemp -d /tmp/e2e-test-plan.XXXXXX
}

# Detect if running from a local clone
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd 2>/dev/null || true)"

if [[ -f "$SCRIPT_DIR/SKILL.md" && -d "$SCRIPT_DIR/references" ]]; then
  echo "Installing from local clone..."
  mkdir -p "$TARGET/references" "$TARGET/evals"
  cp "$SCRIPT_DIR/SKILL.md" "$TARGET/SKILL.md"
  cp "$SCRIPT_DIR/references/plan-template.md" "$TARGET/references/plan-template.md"
  [[ -f "$SCRIPT_DIR/evals/evals.json" ]] && cp "$SCRIPT_DIR/evals/evals.json" "$TARGET/evals/evals.json"
else
  echo "Downloading from GitHub ($REPO)..."
  TMPDIR="$(mktempdir)"
  TARBALL="$TMPDIR/skill.tar.gz"
  curl -fsSL "https://api.github.com/repos/$REPO/tarball/$BRANCH" -o "$TARBALL"
  # Extract (handles both GNU tar and BSD tar on macOS)
  tar -xzf "$TARBALL" -C "$TMPDIR"
  # Find the extracted repo directory (GitHub tarballs have a unique prefix dir)
  EXTRACTED_DIR=""
  for _f in "$TMPDIR"/*/; do
    EXTRACTED_DIR="$_f"
    break
  done
  mkdir -p "$TARGET/references" "$TARGET/evals"
  cp "$EXTRACTED_DIR/SKILL.md" "$TARGET/SKILL.md"
  cp "$EXTRACTED_DIR/references/plan-template.md" "$TARGET/references/plan-template.md"
  [[ -f "$EXTRACTED_DIR/evals/evals.json" ]] && cp "$EXTRACTED_DIR/evals/evals.json" "$TARGET/evals/evals.json"
fi

echo "✓ Installed to $TARGET"
echo ""
echo "To verify:"
echo "  ls -la $TARGET/"
