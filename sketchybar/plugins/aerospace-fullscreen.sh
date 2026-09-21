#!/usr/bin/env bash

set -euo pipefail

state_dir="${TMPDIR:-/tmp}/aerospace-fullscreen-bars"
lock_dir="${state_dir}.lock"

mkdir -p "$state_dir"
until mkdir "$lock_dir" 2>/dev/null; do
  sleep 0.02
done
trap 'rmdir "$lock_dir"' EXIT

mode=${1:-sync}
window=$(aerospace list-windows --focused --format '%{window-id}|%{window-is-fullscreen}' 2>/dev/null || true)
window_id=${window%%|*}
fullscreen=${window#*|}
edge_file="$state_dir/$window_id.edge"

case "$mode" in
  fullscreen|maximized)
    [ -n "$window_id" ] || exit 0
    if [ "$fullscreen" = true ]; then
      aerospace fullscreen off
      current_workspace=$(aerospace list-workspaces --focused)
      aerospace workspace aerospace-refresh
      aerospace workspace "$current_workspace"
      if { [ "$mode" = fullscreen ] && [ -f "$edge_file" ]; } ||
        { [ "$mode" = maximized ] && [ ! -f "$edge_file" ]; }; then
        rm -f "$edge_file"
        fullscreen=false
        mode=sync
      fi
    fi
    if [ "$mode" != sync ]; then
      if [ "$mode" = fullscreen ]; then
        aerospace fullscreen on --no-outer-gaps
        : >"$edge_file"
      else
        aerospace fullscreen on
        rm -f "$edge_file"
      fi
      fullscreen=true
    fi
    ;;
  sync) ;;
  *) exit 2 ;;
esac

if [ "${SENDER:-}" = aerospace_item_init ] || [ "${SENDER:-}" = display_change ]; then
  rm -f "$state_dir"/*.hidden
  sketchybar --bar hidden=off
fi

monitor=$(aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}')
state_file="$state_dir/$monitor.hidden"

if [ "$fullscreen" = true ] && [ -f "$edge_file" ]; then
  desired=hidden
else
  desired=visible
fi

if { [ "$desired" = hidden ] && [ ! -f "$state_file" ]; } ||
  { [ "$desired" = visible ] && [ -f "$state_file" ]; }; then
  # SketchyBar's "current" means the display under the pointer.
  aerospace move-mouse monitor-lazy-center
  sketchybar --bar hidden=current
  if [ "$desired" = hidden ]; then
    : >"$state_file"
  else
    rm -f "$state_file"
  fi
fi
