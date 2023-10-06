if [ -z "$IN_NIX_SHELL" ]; then
  use flake ~/.home.nix/user/work/nix/miniforge
fi

export PYTEST_REUSE_CONTAINERS=1
export CELERY_WORKER_CONCURRENCY=10
export CYPRESS_INSTALL_BINARY=0
export CYPRESS_RUN_BINARY=~/.nix-profile/bin/Cypress
