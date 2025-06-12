#!/usr/bin/env bash

function t() {
  local service_repo="$HOME/go/src/github.com/pulumi/pulumi-service"

  cd "$service_repo" || exit

  if ! tmux list-sessions | grep -q pulumi-service; then
    tmux new-session -c "$service_repo" -d -s pulumi-service -n auxiliary

    tmux split-window -c "$service_repo" -h
    tmux send-keys "awsso" C-m

    tmux split-window -c "$service_repo" -v
    tmux send-keys "make ensure && ./scripts/local-mysql.sh up" C-m

    tmux select-pane -t 0

    tmux new-window -c "$service_repo" -n editor
    tmux send-keys -t pulumi-service:editor "$EDITOR" C-m

    tmux attach-session -t pulumi-service
  else
    tmux attach-session -t pulumi-service
  fi
}
