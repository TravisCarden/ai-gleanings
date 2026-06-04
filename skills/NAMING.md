# Skill Naming Convention

**Standard**: Use descriptive nouns that represent the capability, role, or tool type.

## Decision Rationale

**Adopted**: May 17, 2026  
**Context**: Analyzed existing patterns and decided to follow noun-based naming for consistency with successful tool ecosystems and better conceptual alignment.

### Why Nouns Work Better

1. **Conceptual fit**: Skills are persistent capabilities/specialists, not one-off actions
2. **Ecosystem consistency**: Matches patterns from successful tools (`docker`, `prettier`, `eslint`)
3. **Conciseness**: `docs-optimizer` vs `optimize-docs-skill`
4. **Flexibility**: Handles multi-purpose skills naturally
5. **Memorability**: Easier to remember "the optimizer" than "the optimize-thing"
6. **Claude Code alignment**: Follows the pattern of the platform itself

## Naming Guidelines

### Format
- Use descriptive compound nouns: `docs-optimizer`, `skill-creator`
- Focus on **what/who**, not **what-it-does**: `analyzer` not `analyze-performance`
- Use hyphens for multi-word names
- Keep it concise but clear
- Avoid redundant `-skill` suffix (the directory structure makes this obvious)

### Examples

#### ✅ **Good Examples**
- `docs-optimizer` - handles docs auditing, consolidation, and cleanup
- `skill-creator` - creates and improves skills
- `skill-auditor` - audits skills for quality (renamed from `audit-skill`)
- `performance-analyzer` - analyzes performance
- `security-reviewer` - reviews security
- `code-formatter` - formats code

#### ❌ **Bad Examples**
- `optimize-content` - verb-based action
- `audit-skill` - ambiguous (auditing skills vs skill that audits)
- `create-skill-tool` - verbose and action-oriented
- `skill-optimizer-skill` - redundant suffix
- `optimizer` - too generic without context

## Implementation Notes

### Directory Structure
```
skills/
├── NAMING.md                 # This file
├── README.md                 # Skills overview
├── docs-optimizer/           # Audits + cleans up docs
│   └── SKILL.md             # Frontmatter: name: docs-optimizer
├── docs-optimizer-creator/   # Creates a tailored docs-optimizer for a repo
│   └── SKILL.md             # Frontmatter: name: docs-optimizer-creator
└── skill-auditor/            # Audits skills
    └── SKILL.md             # Frontmatter: name: skill-auditor
```

### Frontmatter Consistency
The directory name and SKILL.md frontmatter `name` field must match exactly:

```yaml
---
name: docs-optimizer  # Must match directory name
description: ...
---
```

### Installation
Skills are installed via `npx skills add TravisCarden/ai-gleanings` (all skills) or `npx skills add TravisCarden/ai-gleanings --skill <name>` (specific skill). Individual install scripts are not part of the skill's responsibility; the skill directory is consumed by the installer.

## Historical Changes

- **May 31, 2026**: Added `docs-optimizer` (audit + consolidate + clean up instruction docs) and `docs-optimizer-creator` (creates a tailored `docs-optimizer` calibrated to a target repo, plus a drift-check harness). Same shape as the `skill-creator` / `skill-auditor` pair, scoped to docs.
- **May 17, 2026**: Renamed `audit-skill` → `skill-auditor` to follow new standard.
- **May 17, 2026**: Established this naming convention document.

## When Creating New Skills

1. **Choose a descriptive noun** that clearly indicates the skill's role or capability
2. **Check this document** for examples and anti-patterns
3. **Ensure consistency** between directory name and SKILL.md frontmatter
4. **Update installation scripts** to use the correct name
5. **Test the name** - does it feel natural to say "use the [name]" or "ask the [name]"?
6. **Pair convention** — when a skill has a paired skill that creates instances of it (e.g. `skill-creator` creates skills; `docs-optimizer-creator` creates docs-optimizers), name the paired skill `<thing>-creator`.
