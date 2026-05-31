# AI Gleanings - Domain Context

## Purpose

This repository captures and shares AI tooling, demonstrating patterns through working examples rather than tutorials.

## Core Principles

### Self-Demonstrating
The repository practices what it preaches — it uses its own principles and tooling to manage itself. Skills authored here are invoked by direct path mention against this repo's own artifacts (e.g. running `skill-auditor` against `skills/skill-auditor`).

### Reference Implementation
Each artifact represents common patterns that others can fork and adapt rather than build from scratch.

### Quality Gates
Archived artifacts must be well-designed, useful, tested, documented, and solve real problems.

### Testing Strategy
- **Skills**: Eval suites with prompt arrays and expected outcomes
- **Scripts**: Functional tests
- **Configs**: Schema validation and linting
- **Instructions**: Token efficiency and design principles

## Artifact Types

- **Skills** (`skills/`) — Custom agent skills with eval suites. The currently-built set is `skill-auditor`, `docs-optimizer`, and `docs-optimizer-creator`.
- **Instructions** (`instructions/`) — Placeholder for agent-agnostic instruction templates; not yet populated.
- **Configurations** (`global-config/`) — Placeholder for user-level configuration templates; not yet populated.
- **Setup** (`Brewfile`) — Development environment dependencies.

## Architecture Decisions

### Repository Structure
The repository organizes by deployment context rather than artifact type, with the repository itself serving as the primary example of project structure best practices.

### Skill Organization
Skills live in `/skills/` as the source of truth. They are invoked by direct path mention against this repo, or installed user-level via `npx skills`. The project does not maintain a `.claude/skills/` symlink set — see [`docs/adr/0001-skills-invocation-strategy.md`](docs/adr/0001-skills-invocation-strategy.md) for the rationale.

### Configuration Philosophy
Global configs are templates showing patterns, not copies of actual personal configurations. Templates show the principles without personal details.

### Documentation Strategy
Key patterns and decisions are documented focusing on rationale over narrative. Documentation generation preserves manual edits while keeping generated sections current.

README optimizes for discovery: understanding the philosophy and browsing artifacts. Success case is comprehending the approach and identifying relevant tools.

### Setup Philosophy
Selective adoption with clear dependencies. Users cherry-pick specific tools or learn patterns rather than adopting everything. Each artifact documents its own dependencies.

### Evolution Strategy
Repository represents current thinking - artifacts are updated or removed when practices evolve. No deprecation folders or historical preservation.
