#!/usr/bin/env bash

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$repo"

host=$(uname -n)

# System first: Firefox and Thunderbird read their policies from /etc.
if [[ $(nix eval --raw .#systemConfigs --apply "configs: if configs ? \"$host\" then \"yes\" else \"no\"") == yes ]]; then
  nix run .#system-manager -- switch --flake ".#$host" --sudo
else
  echo "No system configuration for $host, skipping system-manager."
fi

nh home switch .
