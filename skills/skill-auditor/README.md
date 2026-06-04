# Skill Auditor

Audits agent skills against marketplace-quality heuristics. Runs automated structural checks (token footprint, routing integrity, frontmatter, evals) and surfaces a manual-review checklist (progressive disclosure, content quality, redundancy, description triggering). Produces severity-categorized findings with concrete fixes.

## What it does

- **Structure & token footprint.** Reports per-file word and token counts; flags `SKILL.md` over ~1000 tokens and reference files over ~800 tokens as split candidates.
- **Routing integrity.** Cross-references the `references/` directory against link targets in `SKILL.md` to find dangling links and orphan files.
- **Frontmatter validation.** Confirms a `description` exists and is long enough to trigger reliably (~15+ words).
- **Evals presence.** Detects `evals/evals.json` (current convention) or `evals.json` (legacy), validates JSON, counts test cases.
- **Manual-review checklist.** Surfaces the judgment-shaped checks that automation can't make: progressive disclosure, hallucination risk, agent ergonomics, description triggering, redundancy. See `SKILL.md` and `references/` for criteria.

## Quick Start

### Via agent

```
"Audit this skill"
"Review skill quality"
"Check skill structure"
"Validate skill for release"
```

### Direct

```bash
# Fast feedback during development
./scripts/validate-skill.sh <skill-path>

# Full review (structure + routing + frontmatter + evals)
./scripts/review-skill.sh <skill-path>
```

`<skill-path>` may be absolute or relative. Both scripts are read-only.

## When NOT to use this

- You want to audit instruction *docs* (`README.md`, `AGENTS.md`, `CLAUDE.md`, contributor guides) rather than agent skills — use [`docs-optimizer`](../docs-optimizer/) instead.
- You want to *create* a skill from scratch — use `skill-creator` for that; bring `skill-auditor` in for the pre-release pass.

## Install

Install via `npx skills add TravisCarden/ai-gleanings --skill skill-auditor` or `npx skills add TravisCarden/ai-gleanings` for all skills.

## Test

```bash
make test
```

Runs `validate-skill.sh` and `review-skill.sh` self-checks plus `tests/test-runner.sh` (script existence, self-validation, error handling, fixture-based positive and negative tests, evals schema validation, security checks).

## Structure

```
skill-auditor/
├── SKILL.md                          # Workflow the agent follows
├── README.md                         # This file
├── Makefile                          # `make test`
├── scripts/
│   ├── validate-skill.sh             # Fast development feedback
│   └── review-skill.sh               # Comprehensive review
├── references/                       # Progressive-disclosure modules
│   ├── review_criteria.md
│   ├── progressive_disclosure.md
│   ├── reporting_template.md
│   ├── advanced_checks.md
│   ├── usability_checks.md
│   └── quality_metrics.md
├── evals/
│   └── evals.json                    # Eval suite ({skill_name, evals[]})
└── tests/
    └── test-runner.sh                # Integration tests
```

## Example output

`./scripts/validate-skill.sh .` (fast feedback):

```
=== Quick Skill Validation ===
Path: /path/to/skills/skill-auditor

✓ SKILL.md exists
✓ Frontmatter description found
✓ SKILL.md size OK: ~625 tokens
✓ evals/evals.json found (8 test cases)
✓ All 6 references linked

✓ Basic validation passed
```

`./scripts/review-skill.sh .` (full review):

```
=== Skill Review: skill-auditor ===

## Structure (words × 1.4 ≈ tokens)

  File                                        Words  Tokens
  --------------------------------------------------------
  README.md                                     428    ~599
  references/
      advanced_checks.md                        176    ~246
      progressive_disclosure.md                 567    ~793
      quality_metrics.md                        263    ~368
      reporting_template.md                     333    ~466
      review_criteria.md                        504    ~705
      usability_checks.md                       220    ~308
  SKILL.md                                      447    ~625
  --------------------------------------------------------
  TOTAL                                        2938   ~4113

### Footprint Flags
✓ SKILL.md ~625 tokens
✓ Total ~4113 tokens

## Routing Integrity
✓ All references valid, no orphans

## Frontmatter
  Description: Audit agent skills using marketplace-quality heuristics...
✓ Description length OK (55 words)

## Evals
✓ evals/evals.json found (8 test cases)
```

On a skill with problems, the same sections surface dangling links, orphan reference files, oversized files, missing frontmatter, and missing or empty evals — each with a concrete pointer.

## Limitations

- **Heuristics, not rules.** Token budgets are guidance; flagged values aren't always actionable. The script reports them so a human can decide.
- **Read-only.** Scripts never modify the audited skill. Fixes are recommendations, not edits.
- **Schema-tolerant for evals.** Both `evals/evals.json` (current) and `evals.json` (legacy) are detected; both `{evals: [...]}` and `{testCases: [...]}` shapes are counted. New skills should follow the current convention.
