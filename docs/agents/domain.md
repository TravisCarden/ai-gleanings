# Domain Documentation

This repository uses a **single-context** layout for domain documentation.

## Layout

- `CONTEXT.md` — domain language and project context (repo root)

## Consumer Rules

### CONTEXT.md

Skills like `improve-codebase-architecture`, `diagnose`, and `tdd` read `CONTEXT.md` to understand:
- Domain terminology and concepts
- Business rules and constraints
- System boundaries and key abstractions
- Current architectural patterns

**Location:** `/CONTEXT.md` (repo root)

### Additional Context

For projects that need architectural decision records (ADRs), the [`grill-with-docs`](https://www.skills.sh/mattpocock/skills/grill-with-docs) skill can create and maintain a `docs/adr/` directory structure. This project keeps all architectural context in `CONTEXT.md` for simplicity.

## Usage

When skills need domain context:
1. They read `CONTEXT.md` for current domain language and architectural principles
2. They apply this context to their analysis and recommendations

## Setup

Create a `CONTEXT.md` file that describes your project's purpose, key concepts, and architectural principles.
