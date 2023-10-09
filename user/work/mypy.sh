#!/usr/bin/env bash

set -euo pipefail

paths=("$@")

dmypy run -- "${paths[@]}"
