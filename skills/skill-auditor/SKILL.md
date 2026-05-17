---
name: skill-auditor
description: Audit agent skills using marketplace-quality heuristics. Performs automated structure analysis, token optimization, routing integrity checks, and content quality assessment. Generates detailed reports with severity-categorized findings and concrete fixes. Use when preparing skills for publication, conducting quality reviews, or when asked to "audit this skill", "review skill quality", "check skill structure", or "validate skill for release".
---

# Audit Skill

Audit skills against design principles with automated checks and manual audit. Report findings by severity with concrete fixes.

## Quick Start

Run automated checks first, then manual review:

```bash
./scripts/review-skill.sh <skill-path>
```

This covers structure, token footprint, routing integrity, and evals presence.

## Review Process

### Phase 1: Automated Checks

The script validates:
- File structure and SKILL.md existence
- Token footprint with heuristic flags
- Routing integrity (orphans and dangling links)
- Frontmatter completeness

### Phase 2: Manual Review

Focus on areas requiring human judgment:

| Check | Focus | Reference |
|-------|-------|-----------|
| Progressive disclosure | Query tracing, reference utilization | [Details](references/progressive_disclosure.md) |
| Content quality | Hallucination risk, agent ergonomics | [Criteria](references/review_criteria.md) |
| Description triggering | User language, trigger phrases | [Criteria](references/review_criteria.md) |
| Redundancy | Cross-file duplication patterns | [Detection methods](references/review_criteria.md) |
| Advanced checks | Lifecycle and performance | [Methods](references/advanced_checks.md) |
| User experience | Accessibility and usability | [Guidelines](references/usability_checks.md) |
| Quality metrics | Testing and measurement | [Approaches](references/quality_metrics.md) |

### Phase 3: Reporting

Structure findings by severity and provide concrete fixes. See [reporting template](references/reporting_template.md).

## Anti-Patterns

| Pattern | Problem | Solution |
|---------|---------|----------|
| Flagging style preferences | Not actionable for skill function | Focus on functional issues only |
| Vague concerns | No clear fix available | Cite specific files and line numbers |
| Token budget absolutism | Ignores skill scope reality | Use heuristics as guidance, not rules |
| Perfect-is-enemy-of-good | Blocks useful skills over minor issues | Prioritize by actual user impact |

## Output Artifacts

A complete review produces:

1. **Automated report** - Script output with measurements
2. **Manual findings** - Severity-categorized issues with specific fixes
3. **Progressive disclosure assessment** - Query tracing and routing analysis
4. **Fix recommendations** - Concrete actions with file/line references

## What Not to Flag

- Missing optional files unless maintainer requested them
- Token budgets as absolute limits (they're guidance)
- Style preferences unrelated to skill effectiveness
- Minor inconsistencies that don't impact functionality
