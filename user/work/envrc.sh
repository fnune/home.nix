if [ -z "$IN_NIX_SHELL" ]; then
  use flake ~/.home.nix/user/work/nix/miniforge
fi

export CELERY_WORKER_CONCURRENCY=10
export INVOKE_MEMFAULT_PROCFILE_RUNNER=overmind
export PYRIGHT_DAEMON_ENABLED=1
export PYTEST_REUSE_CONTAINERS=1
