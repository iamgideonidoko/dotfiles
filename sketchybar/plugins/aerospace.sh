#!/usr/bin/env bash

PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"

update_icon() {
  for mid in $(aerospace list-monitors); do
    for sid in $(aerospace list-workspaces --monitor "$mid"); do
      apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
      icons=" "
      if [ -n "$apps" ]; then
        while read -r app; do
          icons+=" $("$PLUGIN_DIR/icon_map.sh" "$app")"
        done <<<"$apps"
      else
        icons=""
      fi

      CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
      if [ -n "$icons" ]; then
        sketchybar --set "aerospace.workspace.$sid" drawing=on label="$icons" label.padding_right=20 background.color=0x44FFFFFF
        if [ "$sid" = "$CURRENT_WORKSPACE" ]; then
          sketchybar --set "aerospace.workspace.$sid" background.color=0x607DCFFF
        fi
      elif [ "$sid" = "$CURRENT_WORKSPACE" ]; then
        sketchybar --set "aerospace.workspace.$sid" drawing=on label="" label.padding_right=10 background.color=0x607DCFFF
      else
        sketchybar --set "aerospace.workspace.$sid" drawing=off label=""
      fi
    done
  done
}

update_monitor() {
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
}

if
  [ "${SENDER:-}" = "hammerspoon_windows_change" ] ||
    [ "${SENDER:-}" = "aerospace_item_init" ] ||
    [ "${SENDER:-}" = "aerospace_workspace_change" ]
then
  update_icon
  update_monitor
fi
