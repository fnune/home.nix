#!/usr/bin/env bash

function t() {
  local repos="$HOME/Development/pulumi"
  local service_repo="$repos/pulumi-service"
  local pulumi_repo="$repos/pulumi"
  local esc_repo="$repos/esc"
  local docs_repo="$repos/docs"
  local registry_repo="$repos/registry"

  local session_service="☁️ pulumi/pulumi-service"
  local session_pulumi="🔧 pulumi/pulumi"
  local session_esc="🔐 pulumi/esc"
  local session_docs="📚 pulumi/docs"
  local session_registry="📦 pulumi/registry"

  local theme_light_blue="#5694ca"
  local theme_green="#00703c"
  local theme_dark_red="#6a3532"
  local theme_purple="#4c2c92"
  local theme_turquoise="#28a197"

  cd "$service_repo" || exit

  env_entries="$(esc open pulumi/default/review-stacks --format json | jq -r '.environmentVariables | to_entries[]')"
  env_script="$(echo "$env_entries" | jq -r '"tmux set-environment -t \"'"$session_service"'\" \(.key) \(.value | @sh)"')"

  if ! tmux list-sessions | grep -q "^$session_service:"; then
    tmux new-session -c "$service_repo" -d -s "$session_service" -n git
    eval "$env_script"
    set_tmux_session_theme "$session_service" "$theme_light_blue"
    tmux send-keys -t "$session_service:git" "lazygit" C-m

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
    tmux select-window -t "$session_service:git"
  fi

  if ! tmux list-sessions | grep -q "^$session_pulumi:"; then
    create_simple_session "$session_pulumi" "$pulumi_repo" "$theme_green"
  fi

  if ! tmux list-sessions | grep -q "^$session_esc:"; then
    create_simple_session "$session_esc" "$esc_repo" "$theme_dark_red"
  fi

  if ! tmux list-sessions | grep -q "^$session_docs:"; then
    create_simple_session "$session_docs" "$docs_repo" "$theme_purple"
  fi

  if ! tmux list-sessions | grep -q "^$session_registry:"; then
    create_simple_session "$session_registry" "$registry_repo" "$theme_turquoise"
  fi
  tmux attach-session -t "$session_service"
}
