# Project Quark

Project Quark is a distributed event router. It accepts JSON events on an HTTP endpoint, classifies them, and forwards each to one of several downstream queues.

The system has three components: the ingester (HTTP), the classifier (rules engine), and the router (queue dispatcher). They communicate over an in-memory channel.

For deeper architecture see [docs/architecture.md](docs/architecture.md).
