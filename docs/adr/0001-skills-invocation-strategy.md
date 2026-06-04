# ADR-0001: Skills are invoked by path; no project-level skills directory

**Status**: Accepted (revised 2026-05-31)
**Date**: 2026-05-16 (original); 2026-05-31 (revised)
**Context**: Repository design for AI tooling reference implementation

## Decision

This repository does not maintain a `.claude/skills/` directory. Skills authored here are invoked by direct path mention (e.g. `./skills/skill-auditor/scripts/review-skill.sh`) or installed user-level via `npx skills add TravisCarden/ai-gleanings` (all skills) or `npx skills add TravisCarden/ai-gleanings --skill <name>` (specific skill).

## Rationale

**Earlier decision (2026-05-16):** `.claude/skills/` would symlink only to skills the repo uses for self-management ("intentional curation, not a convenience dump"). The intended set was `skill-validation`, `documentation-generation`, `quality-checks`.

**What changed:** None of those skills were ever built. The actually-built skills (`skill-auditor`, `docs-optimizer`, `docs-optimizer-creator`) are themselves authored here, so the auto-discovery payoff that motivated the symlink approach is small — when a contributor wants to use one against this repo, they can read its `SKILL.md` directly. The single symlink that did exist pointed outside the repo and was broken.

**Current decision:** Skills are invoked by path. The `npx skills add TravisCarden/ai-gleanings` installer is the supported user-level install path; nothing repo-local is needed. Per `CONTEXT.md`'s "no historical preservation" stance, this ADR is revised in place rather than superseded.

## Consequences

**Positive:**
- One less moving part — no symlink maintenance, no drift between curated list and reality.
- Honest about what exists: contributors run a skill by reading its `SKILL.md` and following the workflow, the same way the agent does.
- `npx skills add TravisCarden/ai-gleanings` is the documented install path for users who want auto-discovery in their own setup.

**Negative:**
- No automatic relevance routing inside this repo. When a contributor asks the agent a relevant question, it may not surface a skill unless explicitly named or installed user-level.
- If the repo grows past ~5 skills with frequent self-management use, revisit — adding `.claude/skills/` symlinks back is cheap.

## Implementation

- `/skills/` is the source of truth for all skills.
- No `.claude/skills/` directory.
- Skill READMEs document `npx skills add TravisCarden/ai-gleanings` as the install path; direct script invocation is shown for development.
