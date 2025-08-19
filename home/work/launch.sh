#!/usr/bin/env bash

function t() {
  local repos="$HOME/go/src/github.com/pulumi"
  local service_repo="$repos/pulumi-service"
  local pulumi_repo="$repos/pulumi"

  cd "$service_repo" || exit

  env_entries="$(esc open pulumi/default/review-stacks --format json | jq -r '.environmentVariables | to_entries[]')"
  env_script="$(echo "$env_entries" | jq -r '"tmux set-environment -t pulumi-service \(.key) \(.value | @sh)"')"

  if ! tmux list-sessions | grep -q "^pulumi-service:"; then
    tmux new-session -c "$service_repo" -d -s pulumi-service -n authorization
    eval "$env_script"

    tmux new-window -c "$service_repo" -n auxiliary

    # Create right pane
    tmux split-window -c "$service_repo" -h

    # Split right pane into 5 vertical sections
    tmux split-window -c "$service_repo" -v
    tmux split-window -c "$service_repo" -v
    tmux split-window -c "$service_repo" -v
    tmux split-window -c "$service_repo" -v

    # Local database (pane 1 on right side)
    tmux send-keys -t 1 "make ensure && ./scripts/local-mysql.sh up" C-m

    # Remote database tunnel (pane 2 on right side)
    tmux send-keys -t 2 "esc run pulumi/default/review-stacks -- kubectl port-forward pod/mysql-0 3308:3306 -n \$PULUMI_STACK_NAME_OVERRIDE" C-m

    # Backend API tunnel (pane 3 on right side)
    tmux send-keys -t 3 "esc run pulumi/default/review-stacks -- kubectl port-forward svc/pulumi-api 8080:8080 -n \$PULUMI_STACK_NAME_OVERRIDE" C-m

    # Console backend (pane 4 on right side)
    tmux send-keys -t 4 "PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 ./scripts/dev/run-console.sh backend" C-m

    # Add HMR frontend (pane 5 on right side)
    tmux send-keys -t 5 "cd $service_repo/cmd/console2 && PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 yarn run start:hmr" C-m

    # Select the left empty pane
    tmux select-pane -t 0

    tmux new-window -c "$service_repo" -n editor
    tmux send-keys -t pulumi-service:editor "$EDITOR" C-m

    tmux kill-window -t authorization
  fi

  if ! tmux list-sessions | grep -q "^pulumi OSS:"; then
    tmux new-session -c "$pulumi_repo" -d -s "pulumi OSS" -n main
    tmux send-keys -t "pulumi OSS:main" "$EDITOR" C-m
  fi

  tmux attach-session -t pulumi-service
}
