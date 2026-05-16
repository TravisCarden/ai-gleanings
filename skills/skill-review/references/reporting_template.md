# Reporting Template

Standardized format for skill review findings.

## Severity Categories

### Critical (🔴 Blocks Release)
- Broken routing (dangling links, orphaned files)
- Hallucinated commands or APIs
- Description won't trigger on relevant queries
- Missing required frontmatter

### Important (🟡 Fix Before Release)  
- Significant redundancy (>20% duplicate content)
- Bloated SKILL.md (>1000 tokens)
- Weak triggering patterns
- Unverified content (commands not tested)
- Poor progressive disclosure (everything in SKILL.md)

### Nice-to-have (🟢 Polish)
- Minor duplication (<10% overlap)
- Inconsistent table formatting
- Missing examples where helpful
- Style inconsistencies

## Findings Report Template

```markdown
# Skill Review: [skill-name]

## Summary
- **Status**: [Critical Issues / Ready with Changes / Ready]
- **Total findings**: [X critical, Y important, Z minor]
- **Token footprint**: [Current tokens] ([% over/under target])

## Critical Issues
1. **[Issue title]** (`file.md:line`)
   - **Problem**: [Specific issue]
   - **Fix**: [Concrete action needed]
   - **Impact**: [Why this blocks release]

## Important Issues  
[Same format as above]

## Minor Issues
[Same format as above]

## Progressive Disclosure Analysis
- **Query resolution**: [% queries needing 2+ references]
- **Routing effectiveness**: [Clear/Confusing/Broken]
- **Reference utilization**: [List unused/overused files]
```

## Fix Recommendation Format

For each finding:
```markdown
**[Issue Title]** (`filename.md:lines`)
- **Current**: [What exists now]
- **Problem**: [Why it's an issue]  
- **Fix**: [Specific action to take]
- **Files affected**: [List all files to change]
```

## Output Artifacts Checklist

After completing review, deliver:

- [ ] **Automated report** - Script output with measurements
- [ ] **Manual findings** - Using severity template above  
- [ ] **Fix recommendations** - Specific actions with file references
- [ ] **Progressive disclosure assessment** - Query tracing results
- [ ] **Token optimization suggestions** - Specific content to move/merge/delete

## Review Quality Standards

Your review should be:
- **Actionable**: Every finding has a specific fix
- **Specific**: Cite file paths and line numbers
- **Prioritized**: Clear severity with rationale
- **Complete**: Cover all review dimensions
- **Balanced**: Flag problems AND acknowledge good patterns