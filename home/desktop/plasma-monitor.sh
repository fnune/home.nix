#!/usr/bin/env sh

TEMP_DIR="/tmp/plasma-monitor"
PREVIOUS_DUMP="$TEMP_DIR/previous_dump"
CURRENT_DUMP="$TEMP_DIR/current_dump"
DIFF_FILE="$TEMP_DIR/diff_log"

mkdir -p "$TEMP_DIR"

if [ ! -f "$PREVIOUS_DUMP" ]; then
  nix run github:pjones/plasma-manager >"$PREVIOUS_DUMP"
  echo "Initial configuration captured in $TEMP_DIR."
fi

while true; do
  nix run github:pjones/plasma-manager >"$CURRENT_DUMP"

  DIFF_OUTPUT=$(diff -u "$PREVIOUS_DUMP" "$CURRENT_DUMP")

  if [ -n "$DIFF_OUTPUT" ]; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    {
      echo "[$TIMESTAMP] Plasma config changes detected:"
      echo "$DIFF_OUTPUT"
      echo "---"
    } >>"$DIFF_FILE"
  fi

  cp "$CURRENT_DUMP" "$PREVIOUS_DUMP"

  sleep 300
done
