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

      if [ -n "$icons" ]; then
        sketchybar --set "aerospace.workspace.$sid" drawing=on label="$icons" label.padding_right=20
      elif [ "$sid" = "$(aerospace list-workspaces --focused)" ]; then
        sketchybar --set "aerospace.workspace.$sid" drawing=on label="" label.padding_right=10
      else
        sketchybar --set "aerospace.workspace.$sid" drawing=off label=""
      fi
    done
  done
}

if [ "${SENDER:-}" = "aerospace_workspace_change" ]; then
  update_icon
  if [ -n "${FOCUSED_WORKSPACE:-}" ]; then
    sketchybar --set "aerospace.workspace.$FOCUSED_WORKSPACE" background.color=0x607DCFFF background.border_width=2
  fi
  if [ -n "${PREV_WORKSPACE:-}" ]; then
    sketchybar --set "aerospace.workspace.$PREV_WORKSPACE" background.color=0x44FFFFFF background.border_width=0
  fi
fi

if [ "${SENDER:-}" = "hammerspoon_windows_change" ]; then
  update_icon
fi
