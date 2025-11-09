#!/usr/bin/env bash

function set_tmux_session_theme() {
  local session="$1"
  local bg_color="$2"
  local fg_color="#ffffff"

  tmux set -t "$session" status-style "bg=$bg_color,fg=$fg_color"
  tmux set -t "$session" status-left " #[bold]#S#[nobold] "
  tmux set -t "$session" status-right ""
}

function create_simple_session() {
  local session="$1"
  local repo_path="$2"
  local color="$3"

  tmux new-session -c "$repo_path" -d -s "$session" -n git
  set_tmux_session_theme "$session" "$color"
  tmux send-keys -t "$session:git" "lazygit" C-m
  tmux new-window -c "$repo_path" -n main
  tmux select-window -t "$session:git"
}
