#!/usr/bin/env bash

function t() {
  export MEMFAULT_LAUNCH_COMMAND="source $HOME/.zsh/includes/t; tl $1"
  cd "$HOME/Development/memfault" || exit
  export MEMFAULT_LAUNCH_COMMAND=""
}

# Use a special instance so that I can launch tmux in other windows without
# that environment becoming isolated by the FHS env of Memfault.
alias tm="tmux -Lmemfault"
alias tk="tm kill-server"

function tl() {
  memfault_path="$HOME/Development/memfault"
  quick=false

  if [[ $1 == "--quick" ]]; then
    quick=true
  fi

  if ! tm list-sessions | grep -q "memfault"; then
    tm new-session -c "$memfault_path" -d -s memfault -n auxiliary

    tm split-window -c "$memfault_path" -h
    if [[ $quick == false ]]; then
      tm send-keys "invoke dc.svc" C-m
    else
      tm send-keys "invoke dc.svc"
    fi

    tm split-window -c "$memfault_path" -v
    if [[ $quick == false ]]; then
      tm send-keys "invoke dev" C-m
    else
      tm send-keys "invoke dev"
    fi

    tm split-window -c "$memfault_path" -v
    if [[ $quick == false ]]; then
      tm send-keys ".lint/pyright.sh" C-m
    else
      tm send-keys ".lint/pyright.sh"
    fi

    tm select-pane -t 0
    tm select-layout main-vertical

    tm new-window -c "$memfault_path" -n editor
    tm send-keys -t memfault:editor "$EDITOR" C-m

    tm attach-session -t memfault
  fi
}
