# AI Gleanings - Domain Context

## Purpose

This repository captures and shares AI tooling, demonstrating patterns through working examples rather than tutorials.

## Core Principles

### Self-Demonstrating
The repository practices what it preaches - it uses its own principles and tooling to manage itself. The `.claude/` directory contains only skills this repository actually uses for self-management.

### Reference Implementation  
Each artifact represents common patterns that others can fork and adapt rather than build from scratch.

### Quality Gates
Archived artifacts must be:
- Well-designed and showing useful patterns
- Actually useful and regularly used
- Tested (evals for skills, functional tests for scripts, validation for configs, multi-dimensional testing for instructions)
- Documented for others to understand and use
- Solving real problems, not theoretical ones

### Testing Strategy
**Skills**: Eval suites with prompt arrays and expected outcomes
**Scripts**: Functional tests ensuring they work as documented
**Configs**: Schema validation and linting
**Instructions**: Token efficiency + design principles (progressive disclosure)

## Artifact Types

**Skills** - Custom agent skills with full eval suites
**Instructions** - Agent-agnostic instruction templates using hybrid approach (principles + concrete examples)
**Configurations** - Settings, keybindings, project configs
**Tooling** - Custom tools like RTK configurations
**Setup** - Brewfiles, devcontainers, dependency management

## Architecture Decisions

### Repository Structure
The repository organizes by deployment context rather than artifact type, with the repository itself serving as the primary example of project structure best practices.

### Skill Organization  
Skills live in `/skills/` as source of truth with minimal structure based on actual needs. The project's `.claude/skills/` symlinks only to skills used for repository self-management: skill-validation, documentation-generation, and quality-checks.

### Configuration Philosophy
Global configs are templates showing patterns, not copies of actual personal configurations. Templates show the principles without personal details.

### Documentation Strategy
All key patterns, strategies, and architectural decisions are documented for user learning, focusing on rationale over narrative. Documentation generation uses smart updates that preserve manual edits while keeping generated sections current.

README optimizes for discovery: understanding the philosophy and browsing available artifacts for later deep-dive or use. Five-minute success case is comprehending the approach and identifying relevant tools.

### Setup Philosophy
Selective adoption with clear dependency trees. Users primarily cherry-pick specific tools or learn patterns rather than adopting the complete system. Each artifact documents its own dependencies for standalone use.

### Evolution Strategy
Repository represents current thinking - artifacts are updated or removed when practices evolve. No deprecation folders or historical preservation.