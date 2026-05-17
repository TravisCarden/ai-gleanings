# Progressive Disclosure Assessment

How to evaluate if a skill properly uses progressive disclosure.

## Core Principle

Skills should reveal complexity gradually:
- **SKILL.md**: Core workflows, quick wins, routing decisions
- **References**: Deep details, edge cases, advanced features

## Evaluation Method

### 1. Query Tracing

Pick 5 representative user queries and trace information needs:

| Query | SKILL.md loads | References needed | Total tokens |
|-------|----------------|-------------------|--------------|
| "How do I start?" | ✓ Sufficient | None | ~200 |
| "Configure advanced settings" | ✓ Routing | config.md | ~500 |
| "Debug connection errors" | ✓ Routing | troubleshooting.md | ~400 |

**Healthy pattern**: 80% of queries resolve with SKILL.md + 0-1 reference

### 2. Content Distribution Analysis

```bash
# Check if SKILL.md is doing too much
wc -l skill/SKILL.md skill/references/*.md

# Look for routing density
grep -c "See \[" skill/SKILL.md
```

| SKILL.md lines | Assessment | Action |
|----------------|------------|---------|
| < 80 | Good | Maintain current structure |
| 80-120 | Monitor | Consider splitting if growing |
| > 120 | Too dense | Move advanced content to references |

### 3. Reference Utilization

Track which references get used for common queries:

```bash
# Find routing patterns
grep -oE 'See \[[^]]+\]\([^)]+\)' SKILL.md
```

**Red flags**:
- One reference handles 50%+ of queries → merge into SKILL.md
- References never used → delete or integrate
- Every query needs multiple references → poor organization

## Routing Quality Patterns

### ✅ Good Routing
```markdown
## Quick Start
[Basic steps here]

## Advanced Configuration
For complex setups, see [config.md](references/config.md)

## Troubleshooting
For connection issues, see [debugging.md](references/debugging.md)
```

### ❌ Poor Routing
```markdown
## Everything
See [all-the-things.md](references/all-the-things.md) for complete information.

## Getting Started
See [setup.md](references/setup.md), [config.md](references/config.md),
and [troubleshooting.md](references/troubleshooting.md)
```

## Reference File Organization

### Single Responsibility
Each reference should have a clear, narrow scope:

**Good examples**:
- `api_reference.md` - Just API endpoints and parameters
- `troubleshooting.md` - Just error scenarios and fixes
- `advanced_config.md` - Just complex configuration options

**Bad examples**:
- `everything_else.md` - Catch-all for random content
- `more_info.md` - Vague scope, unclear when to use

### Reference Size Guidelines

| Size | Assessment | Typical Content |
|------|------------|-----------------|
| 20-40 lines | Good | Focused topic (API endpoints) |
| 40-80 lines | Acceptable | Moderate complexity (config options) |
| 80+ lines | Consider splitting | Multiple related topics |

## Progressive Disclosure Anti-Patterns

### The Mega-SKILL
**Problem**: Everything crammed into SKILL.md
**Symptoms**: 150+ lines, multiple unrelated sections
**Fix**: Extract advanced topics to focused references

### The Reference Dump
**Problem**: SKILL.md just routes to references
**Symptoms**: No useful content in main file, everything requires clicking
**Fix**: Include essential workflows directly in SKILL.md

### The Circular Reference
**Problem**: References that reference other references
**Symptoms**: Deep navigation chains, confused routing
**Fix**: Flatten hierarchy, ensure 1-hop max from SKILL.md

### The Orphan Reference
**Problem**: Reference files that aren't routed from SKILL.md
**Symptoms**: Files exist but unreachable via normal workflow
**Fix**: Add routing or delete unused references

## Testing Progressive Disclosure

### User Journey Test
1. Give skill to someone unfamiliar with the domain
2. Ask them to complete 3 common tasks
3. Track where they get stuck or confused
4. Note how many files they need to complete each task

### Token Efficiency Test
1. Calculate tokens for common query resolutions
2. Compare against monolithic approach
3. Aim for 30-50% token savings on routine queries
