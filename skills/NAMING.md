# Skill Naming Convention

**Standard:** Descriptive compound nouns. `docs-optimizer`, not `optimize-docs`.

## Guidelines

- **What/who, not what-it-does:** `analyzer` not `analyze-performance`
- **Hyphens** for multi-word names
- **No `-skill` suffix** — the directory structure makes this obvious
- **Paired skills:** when a skill creates instances of another, name it `<thing>-creator` (e.g. `docs-optimizer-creator` creates `docs-optimizer`s)

### Examples

| Good | Bad |
|------|-----|
| `docs-optimizer` | `optimize-content` |
| `skill-auditor` | `audit-skill` |
| `skill-creator` | `create-skill-tool` |

## Consistency

Directory name and `SKILL.md` frontmatter `name` field must match exactly:

```yaml
---
name: docs-optimizer  # Must match directory name
---
```

## Current Skills

```
skills/
├── docs-optimizer/           # Audits + cleans up docs
├── docs-optimizer-creator/   # Creates a tailored docs-optimizer for a repo
└── skill-auditor/            # Audits skills
```
