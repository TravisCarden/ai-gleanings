# ADR-0001: Project Skills Directory Symlinks Only to Self-Management Skills

**Status**: Accepted
**Date**: 2026-05-16
**Context**: Repository design for AI tooling reference implementation

## Decision

The project's `.claude/skills/` directory symlinks only to skills that the repository itself uses for self-management (skill-validation, documentation-generation, quality-checks), not to all available skills in the `/skills/` directory.

## Rationale

**Problem**: Users might expect `.claude/skills/` to contain all skills for easy access, but this would make the project configuration heavy and unfocused.

**Solution**: Curated demonstration - the project's skill configuration becomes a living example of thoughtful skill selection rather than a convenience dump.

## Consequences

**Positive:**
- Project configuration demonstrates intentional skill curation
- Faster project startup (fewer skills loaded)
- Clear separation between "skills this project uses" vs "skills this project provides"
- Living example of project-specific skill selection

**Negative:**
- Users must symlink individual skills manually if they want them active
- Less convenient for browsing/trying skills immediately

## Implementation

- `/skills/` contains source of truth for all skills
- `.claude/skills/` contains symlinks only to: skill-validation, documentation-generation, quality-checks
- Documentation explains this pattern as a best practice for project-specific skill curation
