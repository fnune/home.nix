#!/usr/bin/env bash

set -euo pipefail

cleanup() {
  echo "Stopping all processes..."
  kill "$(jobs -p)" 2>/dev/null
  wait
  exit 0
}

trap cleanup SIGINT SIGTERM

echo "Starting port-forwards..."
esc run pulumi/default/review-stacks -- kubectl port-forward svc/pulumi-api 8080:8080 -n "$PULUMI_STACK_NAME_OVERRIDE" &
esc run pulumi/default/review-stacks -- kubectl port-forward pod/mysql-0 3308:3306 -n "$PULUMI_STACK_NAME_OVERRIDE" &

echo "Starting local database..."
make ensure && ./scripts/local-mysql.sh up &

wait
