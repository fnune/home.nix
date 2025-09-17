#!/usr/bin/env bash

set -euo pipefail

run_and_log() {
  local service_name="$1"
  shift
  "$@" > >(sed "s/^/[${service_name}] /") 2> >(sed "s/^/[${service_name} (?)] /" >&2)
}

cleanup() {
  echo "Stopping all processes..."
  kill "$(jobs -p)" 2>/dev/null
  wait
  exit 0
}

trap cleanup SIGINT SIGTERM

run_and_log "pulumi-api-pf" echo "Starting API port-forwards..."
run_and_log "pulumi-api-pf" esc run pulumi/default/review-stacks -- kubectl port-forward svc/pulumi-api 8080:8080 -n "$PULUMI_STACK_NAME_OVERRIDE" &
run_and_log "mysql-pf" echo "Starting MySQL port-forwards..."
run_and_log "mysql-pf" esc run pulumi/default/review-stacks -- kubectl port-forward pod/mysql-0 3308:3306 -n "$PULUMI_STACK_NAME_OVERRIDE" &

echo "Starting local database..."
run_and_log "local-db" bash -c "make ensure && make install_gotools && ./scripts/local-mysql.sh up" &

wait
