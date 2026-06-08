# AI Gleanings - Domain Context

## Purpose

This repository captures and shares AI tooling, demonstrating patterns through working examples rather than tutorials.

## Core Principles

- **Self-demonstrating** — Uses its own skills and tooling for self-management. Skills authored here are invoked by direct path mention against this repo's own artifacts (e.g. `skill-auditor` against `skills/skill-auditor`).
- **Reference implementation** — Each artifact represents common patterns others can fork and adapt.
- **Quality gates** — Artifacts must be well-designed, useful, tested, documented, and solve real problems.
- **Current** — Artifacts are updated or removed as practices evolve. No deprecation folders or historical preservation.

## Artifact Types

- **Skills** ([`skills/`](skills/)) — Custom agent skills with eval suites. Current set: [`skill-auditor`](skills/skill-auditor/), [`docs-optimizer`](skills/docs-optimizer/), [`docs-optimizer-creator`](skills/docs-optimizer-creator/).
- **Configurations** ([`global-config/`](global-config/)) — User-level configuration templates for `~/.claude/`.
- **Setup** ([`Brewfile`](Brewfile)) — Development environment dependencies.

## Architecture Decisions

### Repository Structure
Organized by deployment context rather than artifact type. The repo itself serves as the primary example of project structure best practices.

### Skill Organization
Skills live in [`/skills/`](skills/) as source of truth. For self-management, the repo maintains [`.agents/skills/`](.agents/skills/) symlinks to the skills it uses on itself ([`skill-auditor`](skills/skill-auditor/), [`docs-optimizer`](skills/docs-optimizer/)), with [`.claude/skills/`](.claude/skills/) pointing to `.agents/skills/` for Claude Code discovery. End users install via `npx skills add TravisCarden/ai-gleanings`.

### Configuration Philosophy
Templates show patterns without personal details — the 80% use case, production-ready, forkable.

### Documentation Strategy
Key patterns and decisions documented here. [`README.md`](README.md) optimizes for discovery; success = understanding the philosophy and identifying relevant tools in under 5 minutes.

### Setup Philosophy
Selective adoption with clear dependencies. Each artifact documents its own dependencies. No all-or-nothing approach.

## Testing Strategy

- **Skills** — Eval suites with prompt arrays and expected outcomes
- **Scripts** — Functional tests
- **Configs** — Schema validation and linting
- **Instructions** — Token efficiency and design principles
