# Agent

The agent processes incoming tasks from the broker queue.

## How to run

```bash
python -m agent --config config/agent.yaml
```

## How it works

The agent connects to the broker (port 5672), pulls tasks, and dispatches each to a handler.
