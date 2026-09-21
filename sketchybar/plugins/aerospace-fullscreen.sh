#!/usr/bin/env bash

set -euo pipefail

state_dir="${TMPDIR:-/tmp}/aerospace-fullscreen-bars"
lock_dir="${state_dir}.lock"

mkdir -p "$state_dir"
until mkdir "$lock_dir" 2>/dev/null; do
  sleep 0.02
done
trap 'rmdir "$lock_dir"' EXIT

if [ "${1:-sync}" = "toggle" ]; then
  aerospace fullscreen --no-outer-gaps
fi

if [ "${SENDER:-}" = "aerospace_item_init" ]; then
  rm -f "$state_dir"/*.hidden
fi

monitor=$(aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}')
state_file="$state_dir/$monitor.hidden"
fullscreen=$(aerospace list-windows --focused --format '%{window-is-fullscreen}' 2>/dev/null || true)

if [ "$fullscreen" = true ]; then
  if [ ! -f "$state_file" ]; then
    sketchybar --bar hidden=current && : >"$state_file"
  fi
elif [ -f "$state_file" ]; then
  sketchybar --bar hidden=current && rm -f "$state_file"
fi
