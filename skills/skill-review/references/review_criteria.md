# Review Criteria

Detailed criteria for skill evaluation.

## Token Footprint Heuristics

| Component | Target | Flag if exceeds |
|-----------|---------|-----------------|
| SKILL.md | 500-700 tokens | 1000 tokens |
| Single reference | 600 tokens | 800 tokens |
| Total skill | 4000 tokens | 6000 tokens |

**Calculation**: `words × 1.3 ≈ tokens`

```bash
wc -w <skill>/SKILL.md <skill>/references/**/*.md
```

## Content Quality Checklist

### Hallucination Risk Assessment

- [ ] Commands exist in the product (`--help` verification)
- [ ] Flags and options are accurate
- [ ] API endpoints are current
- [ ] File paths and URLs are valid
- [ ] Version-specific features are noted

### Agent Ergonomics

- [ ] Tables over prose for listings
- [ ] Copy-pasteable examples with realistic values
- [ ] No placeholder values (`xxx`, `YOUR_API_KEY`)
- [ ] Explicit flags and options shown
- [ ] Error handling guidance provided

### Graceful Failure

- [ ] Points to `--help` when uncertain
- [ ] Includes debug flags or troubleshooting
- [ ] Mentions support channels or docs
- [ ] Handles edge cases explicitly

## Progressive Disclosure Evaluation

### Routing Table Assessment

Good routing patterns:
```markdown
- Basic usage: Stay in SKILL.md
- Advanced config: See [config.md](references/config.md)  
- Troubleshooting: See [debugging.md](references/debugging.md)
```

Bad routing patterns:
```markdown
- Everything: See [everything.md](references/everything.md)
- Multiple references for same query
- Circular references between files
```

### Reference File Sizing

| Lines | Status | Action |
|-------|--------|---------|
| < 50 | Too small | Consider merging into SKILL.md |
| 50-80 | Good size | Keep separate |
| 80-120 | Large | Consider splitting by topic |
| > 120 | Too large | Split required |

### Query Resolution Test

Pick 5 representative user queries and trace:

1. What loads automatically (SKILL.md)
2. What additional references are needed
3. Total token cost for resolution

Healthy pattern: SKILL.md + 1 reference resolves 80% of queries.

## Description Triggering Analysis

### Strong Triggers

- Product/tool names: "Acquia CLI", "Docker Compose"
- Specific commands: "acli", "docker-compose up"
- Error messages: "permission denied", "connection refused"
- User intent phrases: "deploy to staging", "run tests"

### Weak Triggers

- Generic terms: "helps with", "manages"
- Vague domains: "development", "operations" 
- Internal jargon: "the platform", "our system"

### Triggering Test Questions

1. Would a new user recognize when to use this?
2. Does it avoid false triggers on unrelated work?
3. Is it "pushy" enough to trigger when relevant?
4. Does it include error messages users might encounter?

## Redundancy Detection

### Common Redundancy Patterns

| Pattern | Problem | Detection |
|---------|---------|-----------|
| Command repetition | Same examples in multiple files | `grep -r "command-name"` |
| Procedure duplication | Setup steps repeated | Search for numbered lists |
| Troubleshooting overlap | Same solutions multiple places | Look for error messages |

### Redundancy Severity

- **Critical**: Exact duplication (copy-paste detected)
- **Important**: Conceptual overlap with different examples  
- **Minor**: Similar phrasing but different context