# Triage Label Mapping

This repository uses the default triage vocabulary for issue status tracking.

## Label Mapping

| Canonical Role | Label String | Description |
|----------------|--------------|-------------|
| Needs Triage | `needs-triage` | Issue needs initial evaluation by maintainer |
| Needs Info | `needs-info` | Waiting on reporter for more information |
| Ready for Agent | `ready-for-agent` | Fully specified, can be picked up by AFK agent |
| Ready for Human | `ready-for-human` | Needs human implementation |
| Won't Fix | `wontfix` | Issue will not be actioned |

## Usage

Skills like `triage` will update the **Status** field in `.scratch/<feature>/issue.md` files using these exact strings.

Example:
```markdown
**Status:** ready-for-agent
```

## Customization

To use different label names, update the "Label String" column above. Skills will read from this mapping when applying triage decisions.