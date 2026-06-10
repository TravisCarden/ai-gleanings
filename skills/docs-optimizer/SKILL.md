---
name: docs-optimizer
description: Audit, consolidate, and clean up instruction docs (`README.md`, `AGENTS.md`, `CLAUDE.md`, contributor guides, `docs/` trees) — finds drift, conflicts, redundancy, and broken references across files, then optionally applies fixes. Use when cleaning up docs, after a refactor has left docs behind, when consolidating overlapping files, or when asked to audit, review, clean up, consolidate, optimize, or fix documentation.
disable-model-invocation: true
user-invocable: true
---

# Docs Optimizer

Audit instruction docs for drift, conflicts, and redundancy across files,
then resolve them. The skill earns its keep on **cross-file** problems —
the kind a single-file read can't catch — and stays out of the way for
generic doc cleanup that any LLM already handles.

## Workflow

Before doing anything else, check whether the target repo already has a
tailored `docs-optimizer` calibrated to its conventions.

### Step 0: Defer if a tailored optimizer exists

A tailored optimizer knows repo-specific things this generic skill cannot
match — custom validation harnesses, forbidden patterns, integration
seams, and the project's own canonical-source ordering. Don't run a
parallel audit; defer.

```bash
REPO="<absolute path to target repo>"

# Look in common agent-skill / agent-rule locations. The list isn't
# exhaustive; check whatever the target repo actually uses.
find "$REPO" \
  -path "$REPO/.git" -prune -o \
  -type f \( -name "SKILL.md" -o -name "*.mdc" \) -print 2>/dev/null \
  | xargs grep -l -iE "audit|drift|consist|governance|optimi[sz]e" 2>/dev/null
```

If a match is found, **read its frontmatter and first section** to extract
2–3 specific things it covers (validation commands, forbidden patterns,
integration seams). Then output:

```
This repo already has a tailored docs-optimizer at <path>.
That skill is calibrated to this repo's conventions and includes:
  - <specific coverage note 1, e.g. validation via the repo's own test wrapper>
  - <specific coverage note 2, e.g. knowledge of <forbidden pattern>>
  - <specific coverage note 3, e.g. awareness of <integration seam> drift>

I'm deferring to it. Consult that skill's instructions instead of running
a generic audit here.
```

Then exit. Don't try to "supplement" — that produces conflicting
recommendations.

If no tailored optimizer exists, continue to Step 1.

### Step 1: Mechanical drift (cheap, deterministic)

Run the bundled verifier:

```bash
python3 <skill-path>/scripts/verify_refs.py "$REPO"
```

It catches: broken markdown link targets, inline-code paths that don't
exist, `make foo` targets missing from the Makefile, `npm run foo`
scripts missing from `package.json`. False-positive limitations are
documented in the script — runtime-generated paths and references
describing *external* repos can't be distinguished from real drift
mechanically; let the semantic step in the next phase triage.

### Step 2: Semantic drift (LLM judgment)

Read every instruction doc in the repo. Then look for these patterns
explicitly — drift only shows up in the cross-file view:

1. **Cross-file conflicts** — two docs disagree on a fact (install
   command, API endpoint, run command, config path). The reader can't
   tell which is right.
2. **Architectural drift** — docs describing a different architecture
   than the code. Sometimes the verifier catches it (when the refactor
   renamed paths), but the dangerous case is when paths are stable and
   only the surrounding narrative is wrong. Read multiple docs side by
   side and ask: do they tell the same story about what this repo is
   and how it's structured? If two docs disagree on identity, that's
   architectural drift even if every link still resolves.
3. **Stale meta-docs** — `STATUS.md` / `PLAN.md` / `COMPLETION_CHECKLIST.md`
   that captured a moment in time and no longer match reality. Check
   the git log for "Last Updated" stamps or last commit dates.
4. **Redundant content** — same procedure documented in multiple files.
5. **Scattered authority** — one topic split across many files with no
   canonical source.

Architectural drift is the highest-judgment, most-LLM-shaped check. The
verifier can't catch it — only cross-doc reading can.

### Step 3: Resolve via ground truth

When two docs disagree, check the code, not the other docs:

- Commands and scripts: verify with `ls`, `grep` the Makefile, `grep`
  `composer.json`, `grep` `package.json`. The doc that matches reality
  wins.
- API endpoints, ports, paths: code is ground truth.
- Procedures: prefer the version referenced from the most-trafficked
  file unless the code disagrees.

State the rationale briefly. Don't silently overwrite — the user needs
to be able to challenge the call.

### Step 4: Output and apply

Always produce a structured audit report. If the user asked for a
cleanup pass (the common case — the skill description triggers on
"clean up", "consolidate", "optimize", "fix", as well as "audit"),
list each edit before making it, then apply. If audit-only was
requested, stop after the report.

```
## Audit Report

### Conflicts
- [`file_a`] vs [`file_b`]: <what disagrees>; canonical = <X> per <ground-truth check>

### Drift
- [`file:line`]: references <thing> that doesn't exist | has moved to <Y>

### Redundancy
- <topic>: covered in [`file_a`], [`file_b`]; recommend single source: [`file_a`]; unique to merge: <X from `file_b`>

### Recommendations
- ...
```

Use these exact section headings (`### Conflicts`, `### Drift`,
`### Redundancy`, `### Recommendations`) — no numbering, no extra
qualifiers. Predictable structure makes the reports easy to grep,
diff, and post-process.

## What to preserve

Before deleting anything labeled "redundant", check for unique value:

- Is anything mentioned only in this file?
- Different audience? (Agent-instruction files like `AGENTS.md` or
  `CLAUDE.md` are for agents; `README.md` is for humans — these are
  not duplicates.)
- Cross-references that would break?

If yes to any: merge the unique content into the kept file rather than
dropping the source whole.

## Style: respect the repo's conventions

If the repo or agent uses a `caveman` skill or any other brevity /
compression convention, match that style — produce terser reports
without losing technical accuracy. Don't introduce a verbose style
into a repo whose other agent instructions are terse. Conversely,
don't over-compress in a repo whose docs are deliberately
narrative-heavy.

## When the audit returns nothing

Sometimes the answer is "no drift found." Say that. Don't invent
problems. A 5-line report saying "audit clean" is more valuable than a
fabricated finding.

## When this skill isn't enough

If the audit reveals a substantial doc set (>8 files, active doc churn)
and no governance infrastructure exists, suggest the user invoke
`docs-optimizer-creator` afterward to scaffold a tailored optimizer
and drift-check harness for this repo. That's a separate, opt-in step —
this skill stops at the cleanup of currently-detected drift.

Any tailored `docs-optimizer` skill produced this way must include
`disable-model-invocation: true` and `user-invocable: true` in its
frontmatter so it doesn't inflate the context window of every
conversation in the repo.
