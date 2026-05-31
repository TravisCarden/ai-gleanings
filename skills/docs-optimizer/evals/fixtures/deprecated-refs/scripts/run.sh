#!/usr/bin/env bash
# Single canonical entry point: build, test, and deploy
set -euo pipefail

case "${1:-}" in
  build) make build ;;
  test)  make test ;;
  deploy) make deploy ;;
  *) echo "usage: run.sh {build|test|deploy}"; exit 1 ;;
esac
