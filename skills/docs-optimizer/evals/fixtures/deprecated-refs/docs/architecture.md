# Architecture

## Components

The system has three components:

- **Ingester**: HTTP server that accepts events and validates them against a JSON schema. Runs on port 8080.
- **Classifier**: Rules engine that tags each event based on configurable rules.
- **Router**: Dispatches tagged events to the matching downstream queue.

## Data flow

Events arrive at the ingester, get validated, are passed to the classifier over an in-memory channel, then forwarded to the router which writes to one of the backing queues (Kafka or SQS).

## Backing queues

The router currently supports Kafka (default) and SQS. Adding a new queue type requires implementing the `QueueDriver` interface in `internal/router/driver.go`.
