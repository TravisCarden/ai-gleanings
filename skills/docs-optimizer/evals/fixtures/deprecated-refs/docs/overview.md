# Project Quark Overview

Project Quark is a distributed event router. It accepts JSON events on an HTTP endpoint, classifies them, and forwards each to one of several downstream queues.

The system has three components: the ingester (HTTP), the classifier (rules engine), and the router (queue dispatcher). They communicate over an in-memory channel.

The ingester is a small Go service running on port 8080. It validates incoming events against a JSON schema before passing them to the classifier.
