#!/usr/bin/env bash

set -euo pipefail

spec="${1:?usage: apply-workspace <spec.json> [--rebuild]}"

rebuild=false
for arg in "${@:2}"; do
  case "$arg" in
    --rebuild) rebuild=true ;;
    *)
      echo "unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

function server_running() {
  herdr status server 2>/dev/null | grep -q '^status: running' # exits 0 even when down
}

function workspace_exists() {
  [ -n "$(workspace_id_for_label "$1")" ]
}

function inside_herdr() {
  [ -n "${HERDR_ENV:-}" ]
}

# Bare `herdr` later attaches to this same server rather than spawning its own.
function ensure_server() {
  if server_running; then
    return
  fi

  nohup herdr server >/dev/null 2>&1 &
  disown

  for _ in $(seq 1 50); do
    if server_running; then
      return
    fi
    sleep 0.1
  done

  echo "herdr server did not come up" >&2
  exit 1
}

function workspace_id_for_label() {
  herdr workspace list |
    jq -r --arg label "$1" \
      '.result.workspaces[] | select(.label == $label) | .workspace_id'
}

function apply_layout() {
  local params="$1"
  jq -n --argjson params "$params" \
    '{id: "apply-workspace", method: "layout.apply", params: $params}' |
    herdr-rpc >/dev/null
}

function build_workspace() {
  local workspace_spec="$1"
  local label
  label="$(jq -r '.label' <<<"$workspace_spec")"

  local existing
  existing="$(workspace_id_for_label "$label")"
  if [ -n "$existing" ]; then
    herdr workspace close "$existing" >/dev/null
  fi

  local created workspace first_tab
  created="$(herdr workspace create --label "$label" --no-focus)"
  workspace="$(jq -r '.result.workspace.workspace_id' <<<"$created")"
  first_tab="$(jq -r '.result.tab.tab_id' <<<"$created")"

  local tab_count
  tab_count="$(jq '.tabs | length' <<<"$workspace_spec")"
  for index in $(seq 0 $((tab_count - 1))); do
    local tab target
    tab="$(jq --argjson index "$index" '.tabs[$index]' <<<"$workspace_spec")"

    # The workspace is created with an empty tab already in place, so the first
    # layout replaces it by id and the rest are appended to the workspace.
    if [ "$index" -eq 0 ]; then
      target="$(jq -n --arg tab_id "$first_tab" '{tab_id: $tab_id}')"
    else
      target="$(jq -n --arg workspace_id "$workspace" '{workspace_id: $workspace_id}')"
    fi

    apply_layout "$(jq -n \
      --argjson target "$target" \
      --argjson tab "$tab" \
      '$target + {tab_label: $tab.label, root: $tab.root}')"
  done

  local focus_tab tab_id
  focus_tab="$(jq -r '.focus_tab // empty' <<<"$workspace_spec")"
  if [ -n "$focus_tab" ]; then
    tab_id="$(herdr tab list --workspace "$workspace" |
      jq -r --arg label "$focus_tab" \
        '.result.tabs[] | select(.label == $label) | .tab_id')"
    [ -n "$tab_id" ] && herdr tab focus "$tab_id" >/dev/null
  fi

  echo "built $label"
}

ensure_server

workspace_count="$(jq '.workspaces | length' "$spec")"
for workspace_index in $(seq 0 $((workspace_count - 1))); do
  workspace_spec="$(jq --argjson index "$workspace_index" '.workspaces[$index]' "$spec")"
  label="$(jq -r '.label' <<<"$workspace_spec")"

  if workspace_exists "$label" && [ "$rebuild" = false ]; then
    continue
  fi

  build_workspace "$workspace_spec"
done

focus="$(jq -r '.focus // empty' "$spec")"
if [ -n "$focus" ]; then
  focus_id="$(workspace_id_for_label "$focus")"
  [ -n "$focus_id" ] && herdr workspace focus "$focus_id" >/dev/null
fi

if ! inside_herdr; then
  exec herdr
fi
