# Local Markdown Issue Tracker

Issues are tracked as Markdown files under `.scratch/<feature>/` in this repository.

## Workflow

### Creating Issues

Issues are stored as individual Markdown files:
```
.scratch/
  feature-name/
    issue.md
    notes.md
    ...
```

### Issue File Format

Each `issue.md` follows this structure:

```markdown
# Issue Title

**Status:** [needs-triage|needs-info|ready-for-agent|ready-for-human|wontfix]
**Type:** [bug|feature|enhancement|task]
**Priority:** [high|medium|low]

## Description

Brief description of the issue or feature request.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Notes

Additional context, links, or implementation notes.
```

### Directory Structure

- `.scratch/feature-name/issue.md` — main issue description
- `.scratch/feature-name/notes.md` — working notes and updates
- `.scratch/feature-name/implementation/` — implementation artifacts

### Triage Process

Issues move through these statuses:
1. `needs-triage` — needs initial evaluation
2. `needs-info` — waiting for more information
3. `ready-for-agent` — ready for autonomous implementation
4. `ready-for-human` — needs human implementation
5. `wontfix` — closed, won't be implemented

### Tools

Skills that create or modify issues will:
- Create `.scratch/<feature>/issue.md` for new issues
- Update the Status field for triage operations
- Add notes to the Notes section for progress updates
