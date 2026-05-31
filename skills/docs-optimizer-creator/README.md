# Docs Optimizer Creator

Generates a tailored `docs-optimizer` skill plus a drift-check harness for a target repo, calibrated to its conventions, validation infrastructure, and actual drift patterns.

## What it does

- **Audits the target repo.** Same workflow as [`docs-optimizer`](../docs-optimizer/) — runs the bundled verifier and reads docs side by side to find real drift patterns.
- **Identifies repo conventions.** Looks at the canonical-source ordering, validation infrastructure (PHPUnit / Bats / pytest / shell / GitHub Actions), cross-file synchronization patterns, and existing skills location.
- **Drafts a tailored optimizer.** Calibrated to the repo's actual drift patterns — not a paste-job. Uses `references/tailored-optimizer-template.md` as the structural reference.
- **Drafts a drift-check harness.** Fits the repo's existing test framework — never introduces a new one. Uses `references/drift-check-patterns.md` for shapes that fit PHPUnit / Bats / pytest / plain shell.
- **Presents drafts for approval.** The artifacts change the target repo durably; nothing is applied without consent.

## Quick Start

### Via agent

```
"Set up drift detection for this repo"
"Scaffold docs governance for this project"
"Create a docs-optimizer for this repo"
```

## When NOT to use this

- For one-shot docs cleanup — use [`docs-optimizer`](../docs-optimizer/) instead.
- When the repo already has tailored governance — defer.
- When the repo has fewer than ~8 docs or low doc churn — heavy infrastructure for a light doc set is a net loss.
- When the repo is mid-architectural-change — the output will be stale before it ships.

## Install

Skills are installed via `npx skills`. See the project root for installation tooling.

## Test

```bash
make test
```

Runs `tests/test_verify_refs.py` — regression tests for the bundled drift detector, plus a sync check confirming this skill's `verify_refs.py` matches the optimizer's copy.

```bash
make sync
```

Pulls the canonical `verify_refs.py` and `test_verify_refs.py` from `docs-optimizer`. Run this if `make test` reports a sync drift.

## Structure

```
docs-optimizer-creator/
├── SKILL.md                              # Workflow the agent follows
├── README.md                             # This file
├── Makefile                              # `make test` / `make sync`
├── scripts/
│   └── verify_refs.py                    # Mechanical drift detector (kept in sync with docs-optimizer)
├── references/
│   ├── tailored-optimizer-template.md    # Structural shape for the produced skill
│   └── drift-check-patterns.md           # Shapes for the produced harness
├── evals/
│   └── evals.json                        # Eval-gap notes (validation is qualitative)
└── tests/
    └── test_verify_refs.py               # Verifier regression + sync tests
```

## Output artifacts (written to the target repo)

After approval, the creator produces:

1. **A tailored `docs-optimizer` skill** at the repo's existing skills location. The destination matches whatever convention the repo already uses; if no convention exists, the creator asks rather than guessing.
2. **A copy of `verify_refs.py`** in that skill's `scripts/` directory so the skill is self-contained.
3. **A drift-check harness** in the repo's existing test framework, wired into the existing test runner where possible.
