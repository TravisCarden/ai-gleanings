# User Experience Guidelines

Evaluation criteria for skill accessibility and usability.

## New User Experience
- [ ] Has clear entry point for beginners
- [ ] Avoids domain jargon without explanation
- [ ] Includes realistic examples (not placeholders)
- [ ] Error scenarios have recovery guidance

## Expert User Experience
- [ ] Advanced features clearly marked
- [ ] Expert shortcuts available
- [ ] Edge cases documented
- [ ] Integration patterns shown

## Skill Interaction Analysis

### Conflict Detection
Check if skill overlaps with existing skills:

```bash
# Find potential conflicts
grep -r "description.*keyword" ../*/SKILL.md
```

**Resolution strategies**:
- Merge overlapping skills
- Clarify different use cases
- Update descriptions to avoid conflicts

### Composition Opportunities
Skills that work well together:
- Complementary domains (testing + deployment)
- Sequential workflows (development + review)
- Hierarchical relationships (general + specific tools)

## Maintenance Indicators

### Staleness Signals
- [ ] Commands reference EOL software versions
- [ ] Links point to archived repositories
- [ ] Examples use deprecated APIs
- [ ] No updates in 6+ months for active domains

### Evolution Readiness
- [ ] Extensible structure for new features
- [ ] Clear boundaries for scope expansion
- [ ] Documented assumptions that might change
- [ ] Migration path for major updates
