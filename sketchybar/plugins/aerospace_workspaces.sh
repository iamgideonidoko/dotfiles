#!/usr/bin/env bash

# Get just the monitor IDs (first column before '|')
focused_monitor=$(aerospace list-monitors --focused | awk -F'|' '{gsub(/ /,"",$1); print $1}')
mapfile -t monitors < <(aerospace list-monitors | awk -F'|' '{gsub(/ /,"",$1); print $1}')

if [ "${#monitors[@]}" -gt 1 ]; then
  output=""
  for m in "${monitors[@]}"; do
    # Get the workspace currently focused on this monitor
    ws="$(aerospace list-workspaces --monitor "$m" --visible 2>/dev/null)"

    # Append with * if this monitor is focused
    if [ "$m" = "$focused_monitor" ]; then
      output+="*${ws}|"
    else
      output+="${ws}|"
    fi
  done
  # Trim trailing "|"
  output=${output%|}
  sketchybar --set aerospace.workspaces drawing="on" label="$output"
  sketchybar --set aerospace.separator.1 drawing="on"
else
  sketchybar --set aerospace.workspaces drawing="off"
  sketchybar --set aerospace.separator.1 drawing="off"
fi
