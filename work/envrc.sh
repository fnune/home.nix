if [ -z "$IN_NIX_SHELL" ]; then
  use flake ~/.home.nix/work/nix/miniforge
fi

export PYTEST_REUSE_CONTAINERS=1
export CELERY_WORKER_CONCURRENCY=10
