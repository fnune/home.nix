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

    # Split right pane into 3
    tmux split-window -c "$service_repo" -v
    tmux split-window -c "$service_repo" -v

    # Frontend
    tmux send-keys -t 1 "cd $service_repo/cmd/console2 && PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 yarn run start:hmr" C-m

    # Console backend
    tmux send-keys -t 2 "PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 ./scripts/dev/run-console.sh backend" C-m

    # Tunnels and database
    tmux send-keys -t 3 "$HOME/.home.nix/home/work/services.sh" C-m

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
