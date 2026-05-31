# Components

## Ingester

HTTP server that accepts events. Validates each event against a JSON schema. Listens on port 8080.

## Classifier

Rules engine that tags each event. Rules live in `config/rules.yaml`.

## Router

Dispatches tagged events to a downstream queue. Supports Kafka and SQS. Adding a new queue requires implementing the `QueueDriver` interface.
