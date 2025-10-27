#!/bin/bash

# Get just the monitor IDs (first column before '|')
focused_monitor=$(aerospace list-monitors --focused | awk -F'|' '{gsub(/ /,"",$1); print $1}')
monitors=($(aerospace list-monitors | awk -F'|' '{gsub(/ /,"",$1); print $1}'))

output=""
drawing="off"

if [ "${#monitors[@]}" -gt 1 ]; then
  drawing="on"
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
fi

# Trim trailing "|"
output=${output%|}

sketchybar --set aerospace_workspaces drawing="$drawing" label="$output" 
sketchybar --set space_separator_1 drawing="$drawing"
