#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
prod/*)
  name="${1#prod/}"
  url="https://api.pulumi.com"
  ref="op://Employee/Pulumi-Prod-${name}/credential"
  ;;
review/*)
  name="${1#review/}"
  url="https://api-${name}.review-stacks.pulumi-dev.io"
  ref="op://Employee/Pulumi-Review-${name}/credential"
  ;;
local)
  url="http://localhost:8080"
  ref="op://Employee/Pulumi-Local/credential"
  ;;
"" | -h | --help)
  echo "usage: p <target> <pulumi args...>" >&2
  echo "targets: prod/<account>, review/<name>, local" >&2
  exit 1
  ;;
*)
  echo "p: unknown target '$1'" >&2
  exit 1
  ;;
esac

shift
token="$(op read "$ref")"

# https://github.com/pulumi/pulumi/issues/20602
# bwrap cannot bind through a read-only symlink, so for each credentials
# file we swap the nix-store symlink for a regular file during the call
# and restore it on exit. The list of files grows by adding swap_creds
# calls below.

cred_paths=()
tmpfs_paths=()
orig_links=()

swap_creds() {
  local path="$1" content="$2"
  local tmpfs link=""

  tmpfs="$(mktemp --tmpdir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" pulumi-creds.XXXXXX)"
  printf '%s' "$content" >"$tmpfs"

  if [[ -L $path ]]; then
    link="$(readlink "$path")"
  fi

  cred_paths+=("$path")
  tmpfs_paths+=("$tmpfs")
  orig_links+=("$link")

  mkdir -p "$(dirname "$path")"
  rm -f "$path"
  : >"$path"
}

restore_creds() {
  set +e
  local i
  for i in "${!cred_paths[@]}"; do
    rm -f "${tmpfs_paths[$i]}"
    if [[ -n ${orig_links[$i]} ]]; then
      rm -f "${cred_paths[$i]}"
      ln -sfn "${orig_links[$i]}" "${cred_paths[$i]}"
    fi
  done
}
trap restore_creds EXIT INT TERM

pulumi_creds_json="$(jq -nc \
  --arg url "$url" --arg token "$token" \
  '{accounts: {($url): {accessToken: $token}}, current: $url}')"

swap_creds "$HOME/.pulumi/credentials.json" "$pulumi_creds_json"
swap_creds "$HOME/.pulumi/.esc/credentials.json" "{}"

bwrap_binds=()
for i in "${!cred_paths[@]}"; do
  bwrap_binds+=(--bind "${tmpfs_paths[$i]}" "${cred_paths[$i]}")
done

export PULUMI_BACKEND_URL="$url"
export PULUMI_ACCESS_TOKEN="$token"
bwrap --dev-bind / / "${bwrap_binds[@]}" -- pulumi "$@"
