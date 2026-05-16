# Custom Skills

Battle-tested skills demonstrating best practices in skill design, testing, and documentation.

## Quality Standards

Skills in this directory meet these criteria:
- Well-designed and demonstrating best practices
- Actually useful and regularly used  
- Properly tested with eval suites
- Sufficiently documented for others to understand and use
- Solving real problems, not theoretical ones

## Structure

Skills use minimal structure based on actual needs:

```
skill-name/
├── SKILL.md          # Required: skill definition
├── evals/           # Optional: evaluation test cases
├── scripts/         # Optional: bundled automation
└── references/      # Optional: documentation and examples
```

## Testing

Skills with objective outputs include eval suites with:
- Prompt arrays testing trigger conditions
- Expected outcome verification  
- Token efficiency measurements (where relevant)

## Usage

These skills can be installed using standard skill management tools or by symlinking to your agent's skills directory.