#!/usr/bin/env bash

set -euxo pipefail

paths_txt=$(mktemp)
for path in "$@"; do
  echo "$path" >> "$paths_txt"
done

inv test.mypy --daemon=check --paths-txt "${paths_txt}"
