# AI Gleanings

A collection of AI tooling and patterns with working examples for software engineers.

## What's Inside

- **[`skills/`](skills/)** — Custom agent skills with eval suites
- **[`global-config/`](global-config/)** — Configuration templates for `~/.claude/`
- **[`Brewfile`](Brewfile)** — AI development dependencies: `brew bundle`

## Install

```bash
# One skill (recommended)
npx skills add TravisCarden/ai-gleanings --skill docs-optimizer-creator

# All skills
npx skills add TravisCarden/ai-gleanings

# Config template
cp global-config/agent-settings/settings.json ~/.claude/settings.json

# Dependencies
brew bundle
```

See [`skills/NAMING.md`](skills/NAMING.md) for naming and install conventions. See [`CONTEXT.md`](CONTEXT.md) for architecture and design principles.
