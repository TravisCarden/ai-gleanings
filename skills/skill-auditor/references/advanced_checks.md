# Advanced Review Checks

Additional evaluation dimensions for comprehensive skill audit.

## Skill Lifecycle Considerations

### Version Consistency
- [ ] Skill name matches directory name
- [ ] Referenced tools/APIs are current versions
- [ ] Deprecated commands flagged with alternatives
- [ ] Breaking changes documented since last review

### Dependency Analysis
```bash
# Check for external tool dependencies
grep -r "npm install\|pip install\|brew install" <skill>/
grep -r "requires.*version" <skill>/
```

Flag skills that:
- Require specific tool versions without mentioning it
- Reference tools not commonly available
- Have undocumented system requirements

## Performance Considerations

### Token Efficiency Analysis
```bash
# Measure content density
total_tokens=$(wc -w <skill>/**/*.md | tail -1 | awk '{print $1 * 1.3}')
unique_concepts=$(grep -h "^## " <skill>/**/*.md | sort -u | wc -l)
echo "Tokens per concept: $(($total_tokens / $unique_concepts))"
```

**Benchmarks**:
- < 50 tokens/concept: Efficient
- 50-100 tokens/concept: Acceptable
- \> 100 tokens/concept: Review for redundancy

For additional checks, see:
- [User Experience Guidelines](usability_checks.md) - Accessibility and UX evaluation
- [Quality Metrics](quality_metrics.md) - Testing and measurement approaches
