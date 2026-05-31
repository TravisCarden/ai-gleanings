# Global Configuration Templates

Placeholder for user-level AI tooling configuration templates.

## Status

Not yet populated. The intent is to host adaptable templates — agent settings, RTK configuration, shell hooks — showing patterns rather than copies of personal configurations.

## Intended layout

When templates land here:

- `agent-settings/` — agent user settings and keybindings
- `rtk/` — RTK (Rust Token Killer) configuration
- `shell-integration/` — shell hooks and functions

The usage pattern will be: copy and adapt for your setup. For example,

```bash
cp global-config/agent-settings/settings.json ~/.claude/settings.json
# then edit for your needs
```
