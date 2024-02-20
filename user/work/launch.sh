#!/usr/bin/env bash

function t() {
  export MEMFAULT_LAUNCH_COMMAND="source $HOME/.zsh/includes/t; tl"
  cd "$HOME/Development/memfault" || exit
  export MEMFAULT_LAUNCH_COMMAND=""
}

# Use a special instance so that I can launch tmux in other windows without
# that environment becoming isolated by the FHS env of Memfault.
alias tm="tmux -Lmemfault"
alias tk="tm kill-server"

function tl() {
  memfault_path="$HOME/Development/memfault"

  if ! tm list-sessions | grep -q "memfault"; then
    tm new-session -c "$memfault_path" -d -s memfault -n auxiliary

    tm split-window -c "$memfault_path" -h
    tm send-keys "invoke dc.svc --log-sql" C-m
    tm split-window -c "$memfault_path" -v
    tm send-keys "rm -f .overmind.sock && invoke dev" C-m
    tm split-window -c "$memfault_path" -v
    tm send-keys ".lint/pyright.sh && invoke dc.test-svc --log-sql" C-m

    tm select-pane -t 0
    tm select-layout main-vertical

    tm new-window -c "$memfault_path" -n editor
    tm send-keys -t memfault:editor "$EDITOR" C-m

    tm attach-session -t memfault
  fi
}
