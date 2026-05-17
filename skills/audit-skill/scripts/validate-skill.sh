#!/usr/bin/env bash
# Skill Validation - Quick validation for development
#
# Usage: validate-skill.sh [skill-path]
# Defaults to current directory if no path provided
#
# SAFETY: This script only reads files, never modifies them.
# It will not access files outside the specified skill directory.

set -euo pipefail

# Colors for output (disabled in non-interactive mode)
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED='' YELLOW='' GREEN='' BLUE='' NC=''
fi

# Helper functions (consistent with review-skill.sh)
error() { echo -e "${RED}❌ $1${NC}" >&2; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Dependency check
check_dependencies() {
  local missing=()
  command -v jq >/dev/null 2>&1 || missing+=("jq")
  if [[ ${#missing[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing[*]}"
    echo "Install with: brew install ${missing[*]}" >&2
    exit 1
  fi
}

# Input validation
validate_path() {
  local path="$1"

  # Security: Prevent obvious path traversal attacks, but allow reasonable temp paths
  if [[ "$path" == *"../../"* ]] || [[ "$path" == "/etc"* ]] || [[ "$path" == "/usr"* ]] || [[ "$path" == "/bin"* ]]; then
    error "Invalid path: $path (security restriction)"
    exit 1
  fi

  # Resolve and validate
  if [[ ! -d "$path" ]]; then
    error "Directory does not exist: $path"
    exit 1
  fi

  if [[ ! -r "$path" ]]; then
    error "Cannot read directory: $path (permission denied)"
    exit 1
  fi
}

# Main execution
main() {
  local skill_path="${1:-.}"
  skill_path="${skill_path%/}"

  # Validate inputs
  validate_path "$skill_path"
  check_dependencies

  # Convert to absolute path for consistent reporting
  skill_path="$(cd "$skill_path" && pwd)"

  echo "=== Quick Skill Validation ==="
  echo "Path: $skill_path"
  echo

  local exit_code=0

  # 1. Required files
  if [[ ! -f "$skill_path/SKILL.md" ]]; then
    error "SKILL.md missing"
    exit_code=1
  else
    success "SKILL.md exists"
  fi

  # 2. Frontmatter check
  if [[ -f "$skill_path/SKILL.md" ]]; then
    if head -1 "$skill_path/SKILL.md" | grep -q '^---$'; then
      local desc
      desc=$(sed -n '/^---$/,/^---$/p' "$skill_path/SKILL.md" | grep -E '^description:' | sed 's/^description: *//' || echo "")
      if [[ -n "$desc" ]]; then
        success "Frontmatter description found"
      else
        error "No description in frontmatter"
        exit_code=1
      fi
    else
      error "No frontmatter found"
      exit_code=1
    fi
  fi

  # 3. Token count check (using more accurate estimation)
  if [[ -f "$skill_path/SKILL.md" ]]; then
    local skill_words skill_tokens
    skill_words=$(wc -w < "$skill_path/SKILL.md" | tr -d ' ')
    # More accurate token estimation: 1.3x for general text, but account for markdown
    skill_tokens=$((skill_words * 14 / 10))
    if [[ $skill_tokens -gt 1000 ]]; then
      warn "SKILL.md large: ~$skill_tokens tokens"
    else
      success "SKILL.md size OK: ~$skill_tokens tokens"
    fi
  fi

  # 4. Evals check (with error handling)
  if [[ -f "$skill_path/evals.json" ]]; then
    if ! jq empty "$skill_path/evals.json" >/dev/null 2>&1; then
      warn "evals.json found but contains invalid JSON"
    elif jq -e '.testCases | length > 0' "$skill_path/evals.json" >/dev/null 2>&1; then
      local eval_count
      eval_count=$(jq '.testCases | length' "$skill_path/evals.json")
      success "evals.json found ($eval_count test cases)"
    else
      warn "evals.json found but no test cases"
    fi
  else
    warn "No evals.json found"
  fi

  # 5. Basic routing check (more robust)
  if [[ -f "$skill_path/SKILL.md" && -d "$skill_path/references" ]]; then
    local ref_count unique_links
    ref_count=$(find "$skill_path/references" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
    unique_links=$(grep -oE '\]\(references/[^)]+\.md\)|`references/[^`]+\.md`|references/[^[:space:])>\]]+\.md' "$skill_path/SKILL.md" 2>/dev/null \
      | sed 's/.*(\(references\/[^)]*\.md\)).*/\1/; s/^`//; s/`$//' \
      | sort -u | wc -l | tr -d ' ' || echo "0")

    if [[ $ref_count -eq $unique_links ]]; then
      success "All $ref_count references linked"
    elif [[ $unique_links -eq 0 ]]; then
      warn "No reference links found ($ref_count reference files exist)"
    else
      info "References: $ref_count files, $unique_links unique links"
    fi
  fi

  echo
  if [[ $exit_code -eq 0 ]]; then
    success "Basic validation passed"
    echo "Run './scripts/review-skill.sh $(basename "$skill_path")' for full review"
  else
    error "Validation failed - fix critical issues before proceeding"
  fi

  return $exit_code
}

# Run main function if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi