---
name: docs-optimizer-creator
description: Generate a tailored `docs-optimizer` skill plus a drift-check harness for a target repo, calibrated to its conventions, validation infrastructure, and actual drift patterns. Use when setting up docs governance for a repo that doesn't have it, or when asked to "set up drift detection", "scaffold docs governance", or "create a docs-optimizer for this repo".
---

# Docs Optimizer Creator

Scaffold the docs-governance infrastructure a repo needs to catch drift
itself, going forward. The deliverable is two artifacts in the target
repo: a tailored `docs-optimizer` skill calibrated to the repo's drift
patterns, and a drift-check harness wired into its existing test
framework.

This skill is not for one-shot cleanups — `docs-optimizer` covers that.
It's for converting a one-shot audit + cleanup into durable infrastructure.

## When to create one (and when not to)

| Repo state | Action |
|---|---|
| Has a tailored `docs-optimizer` already | Defer (point at the existing one and exit) |
| Small / short-lived doc set (<8 files, low churn) | **Don't create one.** Suggest using `docs-optimizer` for occasional audits + cleanup. Heavy infrastructure for a light doc set is a net loss. |
| In flux — architecture / conventions changing weekly | **Don't create one yet.** The output will be stale by the time it's installed. Recommend revisiting after the architecture settles. |
| Substantial doc set (>8 files), active doc churn (>15 commits / 90 days), conventions stable | **Create one.** |

If unclear, ask the user once before producing artifacts.

## Workflow

### Step 1: Audit the target repo

The tailored skill can't be calibrated without knowing the repo's actual
drift patterns. Run the same workflow `docs-optimizer` runs: mechanical
verification + cross-file semantic comparison. Identify the conflicts,
drift, redundancies, and scattered authority. The patterns you find are
the input to the tailored skill — without real examples, the tailored
skill will be generic and unhelpful.

The bundled `scripts/verify_refs.py` is a copy of the one in
`docs-optimizer`. Run it the same way:

```bash
python3 <skill-path>/scripts/verify_refs.py "$REPO"
```

### Step 2: Identify repo-specific governance shape

While reading the docs and code, capture:

- **Canonical-source ordering**: when docs disagree, what should win?
  `composer.json`? The Makefile? `package.json`? `flake.nix`? `AGENTS.md`?
  Look for explicit precedence rules in existing docs; if none, infer
  from how the repo actually operates.
- **Validation infrastructure**: does the repo use PHPUnit, Bats, pytest,
  plain shell tests, GitHub Actions, a custom test runner? The drift
  check will fit there, not introduce a new framework.
- **Cross-file synchronization patterns**: are there contracts that must
  ripple across multiple files (a flag change touching script + wrapper
  + doc + test)? These are gold for the tailored skill — document them
  as an Update Checklist.
- **Repo-specific conventions**: forbidden patterns, naming rules,
  ownership boundaries. The generic optimizer doesn't know these.
- **Existing skills location**: where does the repo already keep
  agent-instruction artifacts? If a convention exists in the repo
  (a skills directory, a rules directory, an `AGENTS.md` section),
  match it. If the repo has none, ask the user before defaulting.
  Do not bias toward any specific agent harness.
- **Brevity / style preferences**: does the repo use a `caveman` skill
  or any other compression / brevity convention? If so, the tailored
  skill's prose should follow that convention. Don't introduce a verbose
  style into a repo whose other agent instructions are terse.

### Step 3: Draft the tailored docs-optimizer

Use `references/tailored-optimizer-template.md` as the structural
reference. Fill in repo-specific content from the audit.

The quality bar: a tailored optimizer is good only if reading it tells
you something specific about this repo you couldn't have guessed from
the generic `docs-optimizer`. If everything in the draft is generic,
**don't write the tailored optimizer** — degrade to "no creator output
needed, keep using `docs-optimizer`." Report that finding instead of
installing ceremony.

The tailored skill's frontmatter `name` should follow the repo's
existing naming convention. Common patterns: `<repo>-docs-optimizer`,
`<repo>-docs`, or just `docs-optimizer` if the repo's skill location
is already namespaced.

### Step 4: Draft the drift-check harness

Use `references/drift-check-patterns.md` for shapes that fit common
test infrastructures (PHPUnit, Bats, pytest, plain shell). Pick the
one that matches the repo's existing CI and test framework. Always
wire in the `verify_refs.py` invocation — mechanical checks come free.

If the repo has no test framework at all, propose the plain-shell
pattern and a CI hook. Don't introduce a test framework just to host
the drift check; that's disproportionate.

### Step 5: Verifier placement

The creator copies `scripts/verify_refs.py` from this skill into the
tailored skill's directory. Both the tailored skill and the drift-check
harness reference the in-repo path so the target repo is self-contained
— invocation does not depend on this generic skill remaining at any
particular path.

**IMPORTANT**: Skills must follow the standard directory structure:
`<skills-location>/<skill-name>/SKILL.md`, not `<skills-location>/<skill-name>.md`.
For example: `.claude/skills/docs-optimizer/SKILL.md`, not `.claude/skills/docs-optimizer.md`.

The destination directory follows the repo's existing skill convention
(detected in Step 2). If no convention exists, ask the user.

### Step 6: Present to the user

```
## Creator proposal for <repo-name>

### Audit findings (from this run)
<bulleted list of real drift found — these are the patterns the tailored
optimizer is calibrated against>

### Proposed tailored docs-optimizer
Path: `<chosen path matching the repo's skill convention>/<skill-name>/SKILL.md`
<full content as a fenced code block>

Plus a copy of `verify_refs.py` at `<chosen path>/<skill-name>/verify_refs.py`.

### Proposed drift-check
Path: <chosen path, matching the repo's test framework, e.g.
`tests/InstructionConsistencyTest.php` for PHPUnit or
`tests/instruction-consistency.bats` for Bats>
<full content as a fenced code block>
Wiring: <how it integrates with existing CI / test command>

### What to do next
Approve the drafts and I'll apply them. Or push back on specifics —
each section is grounded in audit findings, so if a finding looks wrong,
the corresponding skill section is wrong too.
```

Apply only after explicit approval. The artifacts change the target
repo durably; user consent matters.

## What NOT to create one for

- Repos with active governance — defer.
- Repos with <8 docs — `docs-optimizer` suffices.
- Repos in flux — the output goes stale before it ships.
- Monorepos where each subproject has its own conventions — produce
  per subproject, not at the root.

## Quality bar

Before presenting:

- The tailored skill names patterns from the audit, not generic ones.
- The canonical-source ordering would resolve a real conflict in this
  repo correctly (test it mentally against one of the audit findings).
- The drift-check harness fits the repo's existing test infrastructure
  — no new framework introduced.
- Every section has a concrete repo example, not a placeholder.
- The destination paths match the repo's existing conventions, not a
  hardcoded default biased toward a specific agent harness.

If any of these fail, fix the draft before presenting. Half-calibrated
artifacts are worse than no artifacts because they look done.
