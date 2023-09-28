complete() { :; } # The shell hook uses complete, which direnv does not provide
eval "$(conda shell.zsh hook)"
conda activate memfault

export PYTEST_REUSE_CONTAINERS=1
export CELERY_WORKER_CONCURRENCY=10
