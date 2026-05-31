# Tailored docs-optimizer template

A reference for what the creator should produce when generating a per-repo
`docs-optimizer`. This is **not** a fill-in-the-blanks form — copy the
structure, fill in repo-specific content discovered during the audit. If
a section doesn't apply, omit it. Don't include empty placeholders.

The output goes to whatever skills location the target repo already uses.
Detect the convention; ask the user if no convention exists. Don't bias
toward a specific agent harness.

---

## Required frontmatter

```yaml
---
name: <repo-name>-docs-optimizer
description: Audit, consolidate, and clean up instruction docs for <repo description>. Catches drift specific to this repo's <whatever the audit found>: <2–3 specific drift patterns from the audit>. Use when cleaning up docs, after a refactor, or before a release.
---
```

The description must name **specific drift patterns this repo suffers
from**, not generic categories. "Catches `AGENTS.md` vs `CLAUDE.md`
drift" is too generic; "Catches drift between `AGENTS.md`'s command
surface and the project's wrapper script flag definitions" is
calibrated. Replace the wrapper-script reference with whatever the
target repo actually uses.

---

## Body structure

```markdown
# <Repo Name> Docs Optimizer

<One sentence: what this skill earns its keep on. Specific to this repo.>

## Scope

The instruction surface that matters in this repo:
- <list the specific files, e.g. `AGENTS.md`, `CLAUDE.md`, `docs/*.md`>
- <plus any non-obvious validation harness, e.g. `tests/InstructionConsistencyTest.php`>

## Canonical sources

When two docs disagree, these are authoritative (in order):
1. <Code or config — the actual scripts, `composer.json`, Makefile, `package.json`, `flake.nix`, etc.>
2. <The doc-of-record per repo convention, e.g. `AGENTS.md`>
3. <Other docs and READMEs>

This ordering is what a contradiction-resolution pass should defer to.

## What drifts in this repo

These are the patterns that have actually shown up in audits, in priority order:

1. **<Pattern name>** — <description, with a real example from the audit>
2. **<Pattern name>** — <description>
3. **<Pattern name>** — <description>

Don't list generic patterns. List what's actually broken or fragile here.

## How to verify

Mechanical checks first (cheap, deterministic):

```bash
<command to run the verifier — see drift-check-patterns.md for examples>
```

Then read across the docs to compare claims against code. The patterns above
guide what to look for.

## Resolving conflicts

<Repo-specific guidance for picking the canonical version. Examples of the
shape (replace with this repo's actuals):
- "For wrapper-command flag definitions, the wrapper metadata file is ground
  truth; doc must match its declared flags."
- "For build-system outputs, the build manifest (`composer.json` / Makefile /
  `package.json`) is ground truth; `ARCHITECTURE.md` must match.">

## Update checklist

When a contract or convention changes, these files all need to ripple in one PR:

- <list: this is the cross-file synchronization the user has burned time on>

## Output format

Use this structure for any audit report (audit-only mode or full pass):

```
## Audit Report

### Conflicts
- [`file_a`] vs [`file_b`]: <what disagrees>; canonical = <X> per <ground-truth check>

### Drift
- [`file:line`]: references <thing> that doesn't exist | has moved to <Y>

### Redundancy
- <topic>: covered in [`file_a`], [`file_b`]; recommend single source: [`file_a`]; unique to merge: <X>

### Recommendations
- ...
```

Use these exact section headings (`### Conflicts`, `### Drift`,
`### Redundancy`, `### Recommendations`).

## Validation after edits

```bash
<the repo's own drift-detection command — see drift-check-patterns.md>
```

If validation fails and the fix isn't obvious, revert and report as deferred.
```

---

## What NOT to put in the tailored skill

- Generic doc-cleanup advice that any LLM already follows (consolidate
  duplicates, preserve unique content). The slim parent skill covers that;
  the tailored version is for what the parent skill **can't** know.
- Anti-patterns and quality metrics. They don't change behavior.
- Section dividers and ceremony. Aim for under ~120 lines, but if the
  repo's cross-file synchronization rules genuinely warrant a longer
  Update Checklist table, take the lines — that table is high-leverage
  and is the kind of content the slim parent skill explicitly cannot
  carry.
- Speculative "what if" patterns. Only what the audit actually found.

## Quality bar

A tailored skill is good if:
1. Reading it tells you something specific about this repo you couldn't have
   guessed from the generic `docs-optimizer`.
2. The "what drifts" section names patterns that have real-world examples
   from the audit.
3. The "canonical sources" ordering would resolve a real contradiction in
   this repo correctly.
4. The validation command actually exists and works (or the creator also
   produced it — see `drift-check-patterns.md`).

If the creator can't meet (1), don't write a tailored skill — report that
the repo's drift patterns are generic and `docs-optimizer` is enough.
