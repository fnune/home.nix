#!/usr/bin/env bash

function set_tmux_session_theme() {
  local session="$1"
  local bg_color="$2"
  local fg_color="#ffffff"

  tmux set -t "$session" status-style "bg=$bg_color,fg=$fg_color"
  tmux set -t "$session" status-left " #S "
  tmux set -t "$session" status-right ""
}

function t() {
  local repos="$HOME/Development/pulumi"
  local service_repo="$repos/pulumi-service"
  local pulumi_repo="$repos/pulumi"

  local theme_light_blue="#5694ca"
  local theme_dark_blue="#003078"
  local theme_green="#00703c"
  local theme_dark_green="#1d2d13"
  local theme_yellow="#ffdd00"
  local theme_white="#ffffff"

  cd "$service_repo" || exit

  env_entries="$(esc open pulumi/default/review-stacks --format json | jq -r '.environmentVariables | to_entries[]')"
  env_script="$(echo "$env_entries" | jq -r '"tmux set-environment -t pulumi-service \(.key) \(.value | @sh)"')"

  if ! tmux list-sessions | grep -q "^pulumi-service:"; then
    tmux new-session -c "$service_repo" -d -s pulumi-service -n authorization
    eval "$env_script"
    set_tmux_session_theme pulumi-service "$theme_light_blue"

    tmux new-window -c "$service_repo" -n auxiliary

    # Create right pane
    tmux split-window -c "$service_repo" -h

    # Split right pane into 3
    tmux split-window -c "$service_repo" -v
    tmux split-window -c "$service_repo" -v

    # Frontend
    tmux send-keys -t 1 "cd $service_repo/cmd/console2 && yarn && PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 yarn run start:hmr" C-m

    # Console backend & Go deps
    tmux send-keys -t 2 "make ensure && make install_gotools && PULUMI_CONSOLE_DOMAIN=localhost:4200 PULUMI_API=http://localhost:8080 ./scripts/dev/run-console.sh backend" C-m

    # Tunnels and database
    tmux send-keys -t 3 "$HOME/.home.nix/home/work/services.sh" C-m

    # Select the left empty pane
    tmux select-pane -t 0
    tmux new-window -c "$service_repo" -n git
    tmux send-keys -t pulumi-service:git "lazygit" C-m
    tmux kill-window -t authorization
  fi

  if ! tmux list-sessions | grep -q "^pulumi/pulumi:"; then
    tmux new-session -c "$pulumi_repo" -d -s "pulumi/pulumi" -n main
    set_tmux_session_theme "pulumi/pulumi" "$theme_green"
    tmux send-keys -t "pulumi/pulumi:main" "lazygit" C-m
  fi
  tmux attach-session -t pulumi-service
}
