#!/usr/bin/env bash

function t() {
  local repos="$HOME/go/src/github.com/pulumi"
  local service_repo="$repos/pulumi-service"
  local pulumi_repo="$repos/pulumi"

  cd "$service_repo" || exit

  if ! tmux list-sessions | grep -q "^pulumi-service:"; then
    tmux new-session -c "$service_repo" -d -s pulumi-service -n auxiliary

    tmux split-window -c "$service_repo" -h
    tmux send-keys "awsso" C-m

    # Local database
    tmux split-window -c "$service_repo" -v
    tmux send-keys "make ensure && ./scripts/local-mysql.sh up" C-m

    # HMR + tunneled backend setup
    tmux split-window -c "$service_repo" -h
    tmux send-keys "esc run pulumi/default/review-stacks -- kubectl port-forward svc/pulumi-api 8080:8080 -n \$PULUMI_STACK_NAME_OVERRIDE" C-m
    tmux split-window -c "$service_repo" -v
    tmux send-keys "PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 ./scripts/dev/run-console.sh backend" C-m
    tmux split-window -c "$service_repo/cmd/console2" -h
    tmux send-keys "PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 yarn run start:hmr" C-m

    tmux select-pane -t 0

    tmux new-window -c "$service_repo" -n editor
    tmux send-keys -t pulumi-service:editor "$EDITOR" C-m
  fi

  if ! tmux list-sessions | grep -q "^pulumi OSS:"; then
    tmux new-session -c "$pulumi_repo" -d -s "pulumi OSS" -n main
    tmux send-keys -t "pulumi OSS:main" "$EDITOR" C-m
  fi

  tmux attach-session -t pulumi-service
}
