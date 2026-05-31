# Docs Optimizer

Audits and cleans up instruction documentation in a repo. Finds drift, conflicts, redundancy, and broken references across files; resolves them via ground-truth comparison with the code; produces a structured report and (with consent) applies fixes. Defers to a tailored `docs-optimizer` in the target repo if one exists.

## What it does

- **Detects existing governance.** If the target repo has its own tailored `docs-optimizer`, defers to it rather than running a parallel audit with conflicting recommendations.
- **Mechanical drift.** Runs `scripts/verify_refs.py` to catch broken markdown links, missing inline-code paths, missing Make targets, missing `npm` scripts.
- **Semantic drift.** Reads docs cross-file to find conflicts, architectural drift, stale meta-docs, redundancy, and scattered authority that mechanical checks miss.
- **Resolves via ground truth.** When two docs disagree, checks the code (`composer.json`, Makefile, `package.json`, source files) rather than averaging the docs.
- **Cleans up.** Removes deprecated refs, consolidates redundant content, deletes stub files, merges scattered authority — listing each edit before applying.
- **Produces a structured report.** Always outputs Conflicts / Drift / Redundancy / Recommendations sections, even on a fix pass.

## Quick Start

### Via agent

```
"Audit the docs in this repo"
"Clean up the documentation"
"Consolidate the AGENTS.md and CLAUDE.md"
"Find and fix any drift in the docs"
```

### Direct

```bash
# Mechanical-only check
python3 scripts/verify_refs.py /path/to/repo
```

The semantic step is LLM-driven and only meaningful through the agent.

## When NOT to use this

- The repo has its own tailored `docs-optimizer` — use that instead.
- You want to set up *durable* docs governance for a repo that doesn't have it — use [`docs-optimizer-creator`](../docs-optimizer-creator/) instead. This skill handles one-shot audits and cleanup; the creator handles infrastructure setup.

## Install

Skills are installed via `npx skills`. See the project root for installation tooling.

## Test

```bash
make test
```

Runs `tests/test_verify_refs.py` — regression tests for the bundled drift detector, plus a sync check confirming this skill's `verify_refs.py` matches the creator's copy.

## Structure

```
docs-optimizer/
├── SKILL.md                      # Workflow the agent follows
├── README.md                     # This file
├── Makefile                      # `make test`
├── scripts/
│   └── verify_refs.py            # Mechanical drift detector
├── evals/
│   ├── evals.json                # Fixture-based eval suite
│   └── fixtures/                 # Synthetic broken-doc test cases
│       ├── conflicting-installs/
│       ├── deprecated-refs/
│       └── scattered-runbooks/
└── tests/
    └── test_verify_refs.py       # Verifier regression + sync tests
```

## Verifier limitations

`verify_refs.py` is a heuristics-based mechanical checker, not an exhaustive linter. Documented limitations in the script header:

- Cannot tell that a path mentioned in the docs is describing an *external* repo's expected structure (false positive on those).
- Cannot tell a generic file-type mention (`composer.json` in prose) from a path reference — we require a slash to flag.
- Cannot detect references that lack any path-shaped marker. Catching those needs cross-doc reading — that's the LLM-side audit's job.
