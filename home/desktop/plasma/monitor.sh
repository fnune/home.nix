#!/usr/bin/env bash

set -euxo pipefail

TEMP_DIR="/tmp/plasma-monitor"
PREVIOUS="$TEMP_DIR/previous"
CURRENT="$TEMP_DIR/current"
DIFF_FILE="$TEMP_DIR/diff_log"

mkdir -p "$TEMP_DIR"

capture() { nix run github:pjones/plasma-manager; }

if [ ! -f "$PREVIOUS" ]; then
  capture >"$PREVIOUS" && echo "Wrote initial configuration in $PREVIOUS."
else
  echo "Found existing configuration in $PREVIOUS."
fi

while true; do
  if capture >"$CURRENT"; then
    DIFF_OUTPUT=$(diff -u "$PREVIOUS" "$CURRENT" || true)
    [ -n "$DIFF_OUTPUT" ] && {
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      {
        echo "[$TIMESTAMP] Changes:"
        echo "$DIFF_OUTPUT"
        echo "---"
      } >>"$DIFF_FILE"
    }
    cp "$CURRENT" "$PREVIOUS"
  fi
  sleep 300
done
