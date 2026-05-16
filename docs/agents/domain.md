# Domain Documentation

This repository uses a **single-context** layout for domain documentation.

## Layout

- `CONTEXT.md` — domain language and project context (repo root)
- `docs/adr/` — architectural decision records (ADRs)

## Consumer Rules

### CONTEXT.md

Skills like `improve-codebase-architecture`, `diagnose`, and `tdd` read `CONTEXT.md` to understand:
- Domain terminology and concepts
- Business rules and constraints  
- System boundaries and key abstractions
- Current architectural patterns

**Location:** `/CONTEXT.md` (repo root)

### Architectural Decision Records

ADRs document significant architectural decisions and their rationale.

**Location:** `docs/adr/` 
**Format:** `NNNN-title.md` (e.g., `0001-use-local-markdown-for-issues.md`)

Skills read ADRs to understand:
- Past architectural decisions and context
- Technical constraints and trade-offs
- Patterns to follow or avoid
- Migration paths and technical debt

## Usage

When skills need domain context:
1. They first read `CONTEXT.md` for current domain language
2. They scan `docs/adr/` for relevant past decisions
3. They apply this context to their analysis and recommendations

## Setup

Create these files as needed:
```bash
touch CONTEXT.md
mkdir -p docs/adr
```

Start with a basic `CONTEXT.md` that describes your project's purpose and key concepts.