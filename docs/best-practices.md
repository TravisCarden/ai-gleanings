# Best Practices

Architectural recommendations for building and maintaining AI agent
instructions, skills, and related tooling.

## Skill Design

### Use `disable-model-invocation: true` and `user-invocable: true` for skills
that don't run dynamically

Skills that should not be used by the agent automatically when it decides
they're relevant, but only when the user explicitly invokes them should set both
flags:

```markdown
---
name: my-skill
disable-model-invocation: true
user-invocable: true
---
```

**Why `disable-model-invocation: true`**: Prevents the harness from loading the
skill's full content into every conversation's context window. Without it, a
skill's instructions are injected whether or not the skill is active — inflating
token usage on every turn.

**Why `user-invocable: true`**: Makes the skill available via `/skill-name` in
the user's prompt, enabling manual invocation without automatic injection.

**When not to apply**: Skills that need to be auto-loaded every turn (e.g., a
global coding style enforcer) should omit `disable-model-invocation: true`.
Those are the exception; most skills are invoked on demand.
