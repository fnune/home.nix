#!/usr/bin/env bash

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$repo"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cp flake.lock "$work/old.lock"
nix flake update

if cmp -s "$work/old.lock" flake.lock; then
  echo "No input changed."
  exit 0
fi

if ! nh home switch .; then
  echo >&2
  echo 'Switch failed. Discard the update with `jj restore flake.lock`.' >&2
  exit 1
fi

attr=".#homeConfigurations.$USER"
apply=$(cat "$repo/lib/versions.nix")

echo "Evaluating package versions..."
nix eval --json --apply "$apply" --no-write-lock-file --reference-lock-file "$work/old.lock" "$attr" >"$work/old.json"
nix eval --json --apply "$apply" "$attr" >"$work/new.json"

report=$(jq -r -s -f "$repo/lib/report.jq" "$work/old.json" "$work/new.json")

echo
echo "$report"
echo

jj commit --message "$(printf 'Upgrade packages\n\n%s\n' "$report")" flake.lock
jj bookmark move --from 'heads(::@- & bookmarks())' --to '@-'
