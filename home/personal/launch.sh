#!/usr/bin/env bash

function n() {
  local notes_dir="$HOME/Documents/Fausto"
  local dotfiles_dir="$HOME/.home.nix"

  local session="📝 personal"
  local theme_purple="#912b88"

  if ! tmux list-sessions | grep -q "^$session:"; then
    tmux new-session -c "$notes_dir" -d -s "$session" -n notes
    set_tmux_session_theme "$session" "$theme_purple"
    tmux send-keys -t "$session:notes" "$EDITOR -c 'NvimTreeToggle'" C-m

    tmux new-window -c "$dotfiles_dir" -n dotfiles
    tmux send-keys -t "$session:dotfiles" "lazygit" C-m
    tmux split-window -c "$dotfiles_dir" -h
    tmux send-keys -t "$session:dotfiles" "$EDITOR" C-m

    tmux select-window -t "$session:notes"
  fi

  tmux attach-session -t "$session"
}
