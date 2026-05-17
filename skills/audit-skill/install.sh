#!/usr/bin/env bash
# Simple global installation script for audit-skill

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing audit-skill..."

# Check dependencies
if ! command -v jq >/dev/null 2>&1; then
    echo "Warning: jq is required. Install with: brew install jq"
fi

# Run self-tests first
echo "Running self-tests..."
"$SKILL_DIR/scripts/validate-skill.sh" "$SKILL_DIR" || {
    echo "Error: Self-validation failed. Fix issues before installing." >&2
    exit 1
}

# Install to common locations
mkdir -p ~/.claude/skills

# Safe installation with conflict detection
if [[ -e ~/.claude/skills/audit-skill && ! -L ~/.claude/skills/audit-skill ]]; then
    echo "Error: ~/.claude/skills/audit-skill exists and is not a symlink" >&2
    echo "Remove it manually and re-run this script." >&2
    exit 1
fi

ln -sf "$SKILL_DIR" ~/.claude/skills/audit-skill
echo "✓ Installed to ~/.claude/skills/audit-skill"

echo "Installation complete!"
echo ""
echo "The skill will be available as 'audit-skill' in your agent."
