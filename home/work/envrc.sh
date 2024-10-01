#!/usr/bin/env bash

if [ -z "$IN_NIX_SHELL" ]; then
  use flake ~/.home.nix/home/work/nix/shell
fi

export CELERY_WORKER_CONCURRENCY=3
export INVOKE_MEMFAULT_PROCFILE_RUNNER=overmind
export PYRIGHT_DAEMON_ENABLED=1
export STRUCTLOG_RENDERER=dev
export VOLTA_HOME="$MAMBA_ROOT_PREFIX/envs/memfault/.volta"
export WWW_LOGGING="root:warn,www.main.access_log:warn"

export PATH="$PATH:$VOLTA_HOME/bin"
