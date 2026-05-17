# AI Gleanings - Domain Context

## Purpose

This repository captures and shares AI tooling, demonstrating patterns through working examples rather than tutorials.

## Core Principles

### Self-Demonstrating
The repository practices what it preaches - it uses its own principles and tooling to manage itself. The `.claude/` directory contains only skills this repository actually uses for self-management.

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

- **Skills** - Custom agent skills with eval suites
- **Instructions** - Agent-agnostic templates with principles and examples
- **Configurations** - Settings, keybindings, project configs
- **Tooling** - Custom tools and configurations
- **Setup** - Development environment and dependencies

## Architecture Decisions

### Repository Structure
The repository organizes by deployment context rather than artifact type, with the repository itself serving as the primary example of project structure best practices.

### Skill Organization
Skills live in `/skills/` as source of truth with minimal structure based on actual needs. The project's `.claude/skills/` symlinks only to skills used for repository self-management: skill-validation, documentation-generation, and quality-checks.

### Configuration Philosophy
Global configs are templates showing patterns, not copies of actual personal configurations. Templates show the principles without personal details.

### Documentation Strategy
Key patterns and decisions are documented focusing on rationale over narrative. Documentation generation preserves manual edits while keeping generated sections current.

README optimizes for discovery: understanding the philosophy and browsing artifacts. Success case is comprehending the approach and identifying relevant tools.

### Setup Philosophy
Selective adoption with clear dependencies. Users cherry-pick specific tools or learn patterns rather than adopting everything. Each artifact documents its own dependencies.

### Evolution Strategy
Repository represents current thinking - artifacts are updated or removed when practices evolve. No deprecation folders or historical preservation.
