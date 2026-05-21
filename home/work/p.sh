#!/bin/sh
set -eu

case "${1:-}" in
  prod/*)
    name="${1#prod/}"
    url=https://api.pulumi.com
    ref="op://Employee/Pulumi-Prod-${name}/credential"
    ;;
  review/*)
    name="${1#review/}"
    url="https://api-${name}.review-stacks.pulumi-dev.io"
    ref="op://Employee/Pulumi-Review-${name}/credential"
    ;;
  local) url=http://localhost:8080 ref=op://Employee/Pulumi-Local/credential ;;
  ""|-h|--help)
    echo "usage: p <target> <pulumi args...>" >&2
    echo "targets: prod/<account>, review/<name>, local" >&2
    exit 1 ;;
  *)
    echo "p: unknown target '$1'" >&2
    exit 1 ;;
esac

shift
token="$(op read "$ref")" || exit 1

# https://github.com/pulumi/pulumi/issues/20602
# bwrap cannot bind through a read-only symlink, so swap the nix-store
# symlink for a regular file during the call and restore it on exit.

creds_path="$HOME/.pulumi/credentials.json"
tmpfs_creds="$(mktemp --tmpdir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" pulumi-creds.XXXXXX)"
symlink_target=""
[ -L "$creds_path" ] && symlink_target="$(readlink "$creds_path")"

restore_symlink() {
  rm -f "$tmpfs_creds"
  if [ -n "$symlink_target" ]; then
    rm -f "$creds_path"
    ln -sfn "$symlink_target" "$creds_path"
  fi
}
trap restore_symlink EXIT INT TERM

printf '{"accounts":{},"current":""}' > "$tmpfs_creds"
chmod 600 "$tmpfs_creds"

mkdir -p "$HOME/.pulumi"
rm -f "$creds_path"
: > "$creds_path"

export PULUMI_BACKEND_URL="$url"
export PULUMI_ACCESS_TOKEN="$token"
bwrap --dev-bind / / \
  --bind "$tmpfs_creds" "$creds_path" \
  -- pulumi "$@"
