# AI Gleanings

A collection of AI tooling and patterns with working examples for software engineers.

## Quick Start

Browse the directories to find tools you can use immediately:

- **`skills/`** - Custom agent skills with eval suites
- **`global-config/`** - Configuration templates for your `~/.claude/` setup
- **`instructions/`** - Agent-agnostic instruction patterns
- **`Brewfile`** - Install AI development dependencies: `brew bundle`

Each directory includes documentation and usage examples.

## Philosophy

- **Self-demonstrating** - Uses its own tools for organization
- **Standalone** - Each artifact works independently with clear dependencies
- **Quality-focused** - Tested, documented, and solves real problems
- **Current** - Updated as practices evolve, no deprecated artifacts

## What's Inside

### Skills (`/skills/`)
Custom agent skills with eval suites and bundled resources that solve real problems.

### Configuration (`/global-config/`)
Templates for user-level setup:
- **Agent settings** - Settings, keybindings, and permissions
- **RTK** - Token optimization configurations
- **Shell integration** - Hooks and productivity functions

### Instructions (`/instructions/`)
Agent-agnostic instruction templates with universal principles and concrete examples.

### Development Environment
Setup files for consistent development: dependencies and project configuration.

## Usage Patterns

### Cherry-Picking Tools

```bash
# Install all skills from this repo
npx skills add TravisCarden/ai-gleanings

# Install a specific skill (recommended)
npx skills add TravisCarden/ai-gleanings --skill docs-optimizer-creator

# Try configuration templates
cp global-config/agent-settings/settings.json ~/.claude/settings.json

# Apply instruction patterns
# Copy and adapt instructions/*.md for your agent setup
```

See [`skills/NAMING.md`](skills/NAMING.md) for the skill naming and install convention.

### Learning Patterns

- Study `CONTEXT.md` for architectural principles
- Read `docs/adr/` for key design decisions
- Examine skill structure in `/skills/README.md`
- Review the project's own `.claude/` configuration

### Setting Up Development Environment

```bash
# Install dependencies
brew bundle
```

## Quality Standards

All artifacts are well-designed, useful, tested, documented, and general purpose.

## Architecture

Minimal structure, agent-agnostic patterns, and intentional curation. See `CONTEXT.md` for details.

## Contributing

This is a personal collection of proven practices. New artifacts are added when they meet the quality standards and demonstrate useful patterns.

---

*This repository embodies its own principles - it uses AI tooling to maintain itself and demonstrates the patterns it teaches.*
