# Worker

The worker executes long-running tasks dispatched by the agent.

## How to run

```bash
python -m worker --config config/worker.yaml
```

## Concurrency

The worker spawns one process per CPU core by default. Override with `--workers N`.
