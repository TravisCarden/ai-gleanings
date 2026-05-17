# Skill Naming Convention

**Standard**: Use descriptive nouns that represent the capability, role, or tool type.

## Decision Rationale

**Adopted**: May 17, 2026  
**Context**: Analyzed existing patterns and decided to follow noun-based naming for consistency with successful tool ecosystems and better conceptual alignment.

### Why Nouns Work Better

1. **Conceptual fit**: Skills are persistent capabilities/specialists, not one-off actions
2. **Ecosystem consistency**: Matches patterns from successful tools (`docker`, `prettier`, `eslint`)
3. **Conciseness**: `content-optimizer` vs `optimize-content-skill`
4. **Flexibility**: Handles multi-purpose skills naturally
5. **Memorability**: Easier to remember "the optimizer" than "the optimize-thing"
6. **Claude Code alignment**: Follows the pattern of the platform itself

## Naming Guidelines

### Format
- Use descriptive compound nouns: `content-optimizer`, `skill-creator`
- Focus on **what/who**, not **what-it-does**: `analyzer` not `analyze-performance`
- Use hyphens for multi-word names
- Keep it concise but clear
- Avoid redundant `-skill` suffix (the directory structure makes this obvious)

### Examples

#### ✅ **Good Examples**
- `content-optimizer` - handles content optimization, auditing, consolidation
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
├── content-optimizer/        # Noun-based directory name
│   └── SKILL.md             # Frontmatter: name: content-optimizer
├── skill-creator/           # Already follows standard
└── skill-auditor/           # Renamed from audit-skill
```

### Frontmatter Consistency
The directory name and SKILL.md frontmatter `name` field must match exactly:

```yaml
---
name: content-optimizer  # Must match directory name
description: ...
---
```

### Installation/Symlinks
Installation scripts should create symlinks matching the skill name:
```bash
ln -sf "$SKILL_DIR" ~/.claude/skills/content-optimizer
```

## Historical Changes

- **May 17, 2026**: Renamed `audit-skill` → `skill-auditor` to follow new standard
- **May 17, 2026**: Established this naming convention document

## When Creating New Skills

1. **Choose a descriptive noun** that clearly indicates the skill's role or capability
2. **Check this document** for examples and anti-patterns
3. **Ensure consistency** between directory name and SKILL.md frontmatter
4. **Update installation scripts** to use the correct name
5. **Test the name** - does it feel natural to say "use the [name]" or "ask the [name]"?

---

**Next skill to be created**: `content-optimizer` (combining content auditing, optimization, and consolidation)