#!/usr/bin/env bash
# Skill Review - Comprehensive Analysis
#
# Usage: review-skill.sh <skill-path>
#
# <skill-path> can be:
#   - Absolute path: /path/to/skill
#   - Relative path: ./myskill or ../skills/myskill (resolved from current directory)
#
# The skill directory must contain a SKILL.md file.
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

# Helper functions (consistent naming)
error() { echo -e "${RED}Error: $1${NC}" >&2; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Input validation function
validate_skill_path() {
  local path="$1"

  # Security: Prevent obvious path traversal attacks, but allow reasonable temp paths
  if [[ "$path" == *"../../"* ]] || [[ "$path" == "/etc"* ]] || [[ "$path" == "/usr"* ]] || [[ "$path" == "/bin"* ]]; then
    error "Potentially unsafe path: $path"
    exit 1
  fi

  if [[ ! -d "$path" ]]; then
    error "'$path' is not a directory or does not exist"
    exit 1
  fi

  if [[ ! -r "$path" ]]; then
    error "Cannot read '$path' (permission denied)"
    exit 1
  fi
}

main() {
  local skill_path="${1:-}"

  if [[ -z "$skill_path" ]]; then
    error "Missing required argument"
    echo "Usage: review-skill.sh <skill-path>" >&2
    echo "  <skill-path>  Absolute or relative path to skill directory" >&2
    exit 1
  fi

  # Normalize: remove trailing slash, validate path
  skill_path="${skill_path%/}"
  validate_skill_path "$skill_path"

  # Resolve to absolute path for consistent reporting
  skill_path="$(cd "$skill_path" && pwd)"

  # Extract skill name for display
  local skill_name="${skill_path##*/}"

  if [[ ! -f "$skill_path/SKILL.md" ]]; then
    error "'$skill_path/SKILL.md' not found"
    echo "This doesn't appear to be a valid skill directory." >&2
    exit 1
  fi

  # Verify we can read files
  if [[ ! -r "$skill_path/SKILL.md" ]]; then
    error "Cannot read '$skill_path/SKILL.md' (permission denied)"
    exit 1
  fi

  echo "=== Skill Review: $skill_name ==="
  echo "Path: $skill_path"
  echo

  # 1. Structure & Token Footprint (merged tree display)
  echo "## Structure (words × 1.4 ≈ tokens)"
  echo

  local total_words=0

  # Collect files (more robust)
  local files=()
  mapfile -t files < <(find "$skill_path" -name '*.md' -type f -print 2>/dev/null | sort)

  if [[ ${#files[@]} -eq 0 ]]; then
    warn "No .md files found in skill directory"
    return 1
  fi

  # Build data
  local data=()
  for file in "${files[@]}"; do
    local rel="${file#$skill_path/}"
    local words tokens
    words=$(wc -w < "$file" 2>/dev/null | tr -d ' ')
    tokens=$((words * 14 / 10))  # More accurate token estimation
    total_words=$((total_words + words))
    data+=("$rel|$words|$tokens")
  done
  local total_tokens=$((total_words * 14 / 10))

  local count=${#data[@]}
  local printed_dirs=""

  # Header
  printf "  %-42s %6s %7s\n" "File" "Words" "Tokens"
  printf "  %s\n" "--------------------------------------------------------"

  for ((i=0; i<count; i++)); do
    IFS='|' read -r rel words tokens <<< "${data[$i]}"
    local dir filename
    dir=$(dirname "$rel")
    filename=$(basename "$rel")

    if [[ "$dir" == "." ]]; then
      # Root level file
      printf "  %-42s %6d %7s\n" "$filename" "$words" "~$tokens"
    else
      # Print directory headers if new
      IFS='/' read -ra parts <<< "$dir"
      local depth=${#parts[@]}

      for ((d=0; d<depth; d++)); do
        local partial
        partial=$(IFS='/'; echo "${parts[*]:0:$((d+1))}")
        if [[ ! "$printed_dirs" == *"|$partial|"* ]]; then
          printed_dirs+="|$partial|"
          local indent=""
          for ((p=0; p<d; p++)); do indent+="    "; done
          printf "  %s%s/\n" "$indent" "${parts[$d]}"
        fi
      done

      # Print file with indent
      local indent=""
      for ((p=0; p<depth; p++)); do indent+="    "; done
      printf "  %-42s %6d %7s\n" "$indent$filename" "$words" "~$tokens"
    fi
  done

  printf "  %s\n" "--------------------------------------------------------"
  printf "  %-42s %6d %7s\n" "TOTAL" "$total_words" "~$total_tokens"
  echo

  # Flag concerns
  local skill_md_words skill_md_tokens
  skill_md_words=$(wc -w < "$skill_path/SKILL.md" 2>/dev/null | tr -d ' ')
  skill_md_tokens=$((skill_md_words * 14 / 10))

  echo "### Footprint Flags"
  if [[ $skill_md_tokens -gt 1000 ]]; then
    warn "SKILL.md ~$skill_md_tokens tokens (target: 500-700)"
  else
    success "SKILL.md ~$skill_md_tokens tokens"
  fi

  if [[ $total_tokens -gt 6000 ]]; then
    warn "Total ~$total_tokens tokens (consider trimming)"
  else
    success "Total ~$total_tokens tokens"
  fi

  # Check individual references
  if [[ -d "$skill_path/references" ]]; then
    while IFS= read -r -d '' ref; do
      local ref_words ref_tokens
      ref_words=$(wc -w < "$ref" 2>/dev/null | tr -d ' ')
      ref_tokens=$((ref_words * 14 / 10))
      if [[ $ref_tokens -gt 800 ]]; then
        warn "${ref#$skill_path/} ~$ref_tokens tokens (split candidate)"
      fi
    done < <(find "$skill_path/references" -name '*.md' -type f -print0 2>/dev/null || true)
  fi
  echo

  # 2. Routing Integrity
  echo "## Routing Integrity"

  # Extract reference paths from SKILL.md
  # Matches: [text](references/...), `references/...`, (references/...), references/...
  # Captures paths in markdown links, backticks, parens, or bare references ending in .md
  local referenced
  referenced=$(grep -oE '\]\(references/[^)]+\.md\)|`references/[^`]+\.md`|references/[^[:space:])>\]]+\.md' "$skill_path/SKILL.md" 2>/dev/null \
    | sed 's/.*(\(references\/[^)]*\.md\)).*/\1/; s/^`//; s/`$//' \
    | sort -u || true)

  # Files that exist
  local existing=""
  if [[ -d "$skill_path/references" ]]; then
    existing=$(find "$skill_path/references" -name '*.md' -type f -print 2>/dev/null | sed "s|^$skill_path/||" | sort)
  fi

  # Compare
  local orphans="" dangling=""

  if [[ -n "$existing" ]]; then
    while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      if ! echo "$referenced" | grep -qxF "$file"; then
        orphans="$orphans$file"$'\n'
      fi
    done <<< "$existing"
  fi

  if [[ -n "$referenced" ]]; then
    while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      if [[ ! -f "$skill_path/$file" ]]; then
        dangling="$dangling$file"$'\n'
      fi
    done <<< "$referenced"
  fi

  if [[ -z "$orphans" && -z "$dangling" ]]; then
    success "All references valid, no orphans"
  else
    if [[ -n "$dangling" ]]; then
      fail "Dangling Links (referenced but missing):"
      echo "$dangling" | grep -v '^$' | sed 's/^/     /'
    fi
    if [[ -n "$orphans" ]]; then
      warn "Orphan Files (exist but unreferenced):"
      echo "$orphans" | grep -v '^$' | sed 's/^/     /'
    fi
  fi
  echo

  # 3. Frontmatter Description
  echo "## Frontmatter"
  if head -1 "$skill_path/SKILL.md" | grep -q '^---$'; then
    local desc
    desc=$(sed -n '/^---$/,/^---$/p' "$skill_path/SKILL.md" | grep -E '^description:' | sed 's/^description: *//' || echo "")
    if [[ -n "$desc" ]]; then
      local desc_words
      desc_words=$(echo "$desc" | wc -w | tr -d ' ')
      echo "  Description: $desc"
      echo
      if [[ $desc_words -lt 15 ]]; then
        warn "Description is short ($desc_words words) — may undertrigger"
      else
        success "Description length OK ($desc_words words)"
      fi
    else
      fail "No description in frontmatter"
    fi
  else
    fail "No frontmatter found"
  fi
  echo

  # 4. evals.json
  # Prefer evals/evals.json (current convention); fall back to evals.json (legacy).
  echo "## Evals"
  local evals_file=""
  if [[ -f "$skill_path/evals/evals.json" ]]; then
    evals_file="$skill_path/evals/evals.json"
  elif [[ -f "$skill_path/evals.json" ]]; then
    evals_file="$skill_path/evals.json"
  fi

  if [[ -n "$evals_file" ]]; then
    local rel_evals="${evals_file#$skill_path/}"
    if ! command -v jq >/dev/null 2>&1; then
      warn "$rel_evals found but jq unavailable for parsing"
    elif ! jq empty "$evals_file" >/dev/null 2>&1; then
      warn "$rel_evals found but contains invalid JSON"
    else
      # Support both schemas: {evals: [...]} (current) and {testCases: [...]} (legacy).
      local eval_count
      eval_count=$(jq '(.evals // .testCases // []) | length' "$evals_file")
      if [[ $eval_count -eq 0 ]]; then
        warn "$rel_evals found but no test cases detected"
      else
        success "$rel_evals found ($eval_count test cases)"
      fi
    fi
  else
    warn "No evals.json found"
  fi
  echo

  echo "=== End Review ==="
}

# Run main function if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi