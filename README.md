# AI Gleanings

A curated collection of battle-tested AI tooling, demonstrating best practices through working examples for software engineers.

## Quick Start

Browse the directories to find tools you can use immediately:

- **`skills/`** - Custom Claude Code skills with eval suites
- **`global-config/`** - Configuration templates for your `~/.claude/` setup  
- **`instructions/`** - Agent-agnostic instruction patterns
- **`Brewfile`** - Install AI development dependencies: `brew bundle`

Each directory includes documentation and usage examples.

## Philosophy

This repository practices what it preaches - it's a **reference implementation** that:

- **Self-demonstrates** - Uses its own principles for organization and tooling
- **Cherry-pickable** - Each artifact works standalone with clear dependencies  
- **Quality-gated** - Everything is tested, documented, and solves real problems
- **Current best thinking** - Continuously updated, no deprecated artifacts

## What's Inside

### Skills (`/skills/`)
Custom Claude Code skills demonstrating:
- Progressive disclosure and bundled resources
- Comprehensive eval suites with quantitative metrics
- Real problem-solving over theoretical examples

### Configuration (`/global-config/`)
Templates for user-level setup:
- **Claude Code** - Settings, keybindings, and permissions
- **RTK** - Token optimization configurations
- **Shell integration** - Hooks and productivity functions

### Instructions (`/instructions/`)
Agent-agnostic instruction templates using hybrid approach:
- Universal principles that work across AI platforms
- Concrete examples illustrating the principles
- Token-efficient with progressive disclosure

### Development Environment
- **`.devcontainer/`** - Consistent development environment setup
- **`Brewfile`** - Dependency management for AI tooling
- **`.claude/`** - Project configuration demonstrating best practices

## Usage Patterns

### Cherry-Picking Tools

```bash
# Use a specific skill
ln -s /path/to/ai-gleanings/skills/skill-name ~/.claude/skills/

# Try configuration templates  
cp global-config/claude-code/settings.json ~/.claude/settings.json

# Apply instruction patterns
# Copy and adapt instructions/*.md for your agent setup
```

### Learning Patterns

- Study `CONTEXT.md` for architectural principles
- Read `docs/adr/` for key design decisions
- Examine skill structure in `/skills/README.md`
- Review the project's own `.claude/` configuration

### Setting Up Development Environment

```bash
# Install dependencies
brew bundle

# Optional: Use the devcontainer for consistent environment
# (Requires VS Code or GitHub Codespaces)
```

## Quality Standards

Artifacts included here meet these criteria:

- **Well-designed** - Demonstrates best practices worth imitating
- **Actually useful** - Solves real problems, used regularly  
- **Properly tested** - Evals for skills, validation for configs
- **Documented** - Clear usage instructions and design rationale
- **80% use case** - Works for most people, adaptable for edge cases

## Architecture

This repository demonstrates:

- **Minimal structure based on actual needs** - No over-engineering
- **Smart documentation updates** - Generated sections preserve manual edits  
- **Intentional skill curation** - Project uses only skills it needs
- **Agent-agnostic patterns** - Works across AI platforms where possible

See `CONTEXT.md` for detailed architectural decisions and `docs/adr/` for specific design choices.

## Contributing

This is a personal collection of proven practices. New artifacts are added when they meet the quality standards and demonstrate valuable patterns others should emulate.

---

*This repository embodies its own principles - it uses AI tooling to maintain itself and demonstrates the patterns it teaches.*