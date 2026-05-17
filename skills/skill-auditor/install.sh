#!/usr/bin/env bash
# Simple global installation script for skill-auditor

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing skill-auditor..."

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
if [[ -e ~/.claude/skills/skill-auditor && ! -L ~/.claude/skills/skill-auditor ]]; then
    echo "Error: ~/.claude/skills/skill-auditor exists and is not a symlink" >&2
    echo "Remove it manually and re-run this script." >&2
    exit 1
fi

ln -sf "$SKILL_DIR" ~/.claude/skills/skill-auditor
echo "✓ Installed to ~/.claude/skills/skill-auditor"

echo "Installation complete!"
echo ""
echo "The skill will be available as 'skill-auditor' in your agent."
