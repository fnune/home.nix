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

confirm() {
  # Prompt with a default of yes. Non-interactive callers take the default.
  local prompt="$1" reply
  if [[ ! -r /dev/tty ]]; then
    return 0
  fi
  read -r -p "$prompt [Y/n] " reply </dev/tty || return 0
  [[ -z $reply || $reply =~ ^[Yy] ]]
}

launch_1password() {
  if pgrep -x 1password >/dev/null 2>&1; then
    return 0
  fi
  if [[ ${OSTYPE:-} == darwin* ]]; then
    open -a "1Password"
  else
    1password >/dev/null 2>&1 &
  fi
}

read_secret() {
  local ref="$1" out
  if out="$(op read "$ref" 2>/dev/null)"; then
    printf '%s' "$out"
    return 0
  fi

  echo "p: 1Password is locked or not running." >&2
  if ! confirm "Open 1Password to unlock?"; then
    echo "p: cannot read $ref without 1Password." >&2
    return 1
  fi

  launch_1password
  echo "p: waiting for 1Password (unlock when prompted)..." >&2
  for _ in $(seq 1 30); do
    if out="$(op read "$ref" 2>/dev/null)"; then
      printf '%s' "$out"
      return 0
    fi
    sleep 2
  done

  echo "p: timed out reading $ref from 1Password." >&2
  return 1
}

ensure_aws_sso() {
  # Stack operations against the dev/review/prod AWS accounts need a live SSO
  # session for $AWS_PROFILE (set by the repo's .envrc). Refresh it up front
  # instead of letting pulumi fail mid-run.
  local profile="${AWS_PROFILE:-}"
  [[ -n $profile ]] || return 0
  command -v aws >/dev/null 2>&1 || return 0

  if aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then
    return 0
  fi

  echo "p: AWS SSO session for profile '$profile' is expired or missing." >&2
  if confirm "Run 'aws sso login --profile $profile'?"; then
    aws sso login --profile "$profile"
  fi
}

subcommand=""
for arg in "$@"; do
  if [[ $arg != -* ]]; then
    subcommand="$arg"
    break
  fi
done

case "$subcommand" in
up | preview | destroy | refresh | import | watch)
  ensure_aws_sso
  ;;
esac

if ! token="$(read_secret "$ref")"; then
  exit 1
fi

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
