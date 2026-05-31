# Custom Skills

Skills demonstrating patterns in skill design, testing, and documentation.

## Quality Standards

Skills are well-designed, useful, tested, documented, and solve real problems.

## Structure

```
skill-name/
├── SKILL.md          # Skill definition
├── evals/           # Evaluation test cases
├── scripts/         # Bundled automation
└── references/      # Documentation and examples
```

See [NAMING.md](NAMING.md) for skill naming conventions (noun-based: `docs-optimizer`, `skill-creator`).

## Testing

Skills with measurable outputs include eval suites testing trigger conditions, expected outcomes, and token efficiency.

## Usage

Skills are installed via `npx skills`. They can also be invoked directly by reading a skill's `SKILL.md` from this repo.
