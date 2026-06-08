# Custom Skills

Skills demonstrating patterns in skill design, testing, and documentation.

## Skills

| Skill | Description |
|-------|-------------|
| [`docs-optimizer`](docs-optimizer/) | Audit, consolidate, and clean up instruction docs — finds drift, conflicts, redundancy, and broken references across files, then optionally applies fixes. |
| [`docs-optimizer-creator`](docs-optimizer-creator/) | Generate a tailored `docs-optimizer` skill plus a drift-check harness for a target repo, calibrated to its conventions and actual drift patterns. |
| [`skill-auditor`](skill-auditor/) | Audit agent skills against marketplace-quality heuristics — structure, token footprint, routing integrity, evals presence, and content quality. |

## Install

```bash
npx skills add TravisCarden/ai-gleanings --skill <name>
npx skills add TravisCarden/ai-gleanings  # all skills
```

## Structure

```
skill-name/
├── SKILL.md         # Skill definition (loaded by the agent)
├── evals/           # Evaluation test cases
├── scripts/         # Bundled automation
└── references/      # Progressive-disclosure modules
```

See [NAMING.md](NAMING.md) for naming conventions. Each skill's README has usage details, test instructions, and limitations.
