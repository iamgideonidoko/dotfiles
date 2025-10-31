#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_update_windows

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item "space.$sid" left \
    --subscribe "space.$sid" aerospace_workspace_change \
    --set "space.$sid" \
    drawing=off \
    background.color=0x66262A3F \
    background.corner_radius=10 \
    background.drawing=on \
    background.border_color=0xAA7AA2F7 \
    background.border_width=0 \
    background.height=25 \
    icon="$sid" \
    icon.padding_left=10 \
    label.font="sketchybar-app-font:Regular:16.0" \
    label.color=0xFFC0CAF5 \
    label.padding_right=20 \
    label.padding_left=0 \
    label.y_offset=-1 \
    script="$PLUGIN_DIR/aerospace.sh $sid" \
    click_script="aerospace workspace $sid"
done

# Load Icons on startup
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
    sketchybar --set "space.$sid" label="$icons"

    if [ -n "$icons" ]; then
      sketchybar --set "space.$sid" drawing=on label="$icons"
    else
      sketchybar --set "space.$sid" drawing=off label=""
    fi
  done
done

sketchybar --add item space_separator_1 left \
  --set space_separator_1 icon="✦" \
  drawing=off \
  icon.font="$FONT:Heavy:16.0" \
  icon.padding_left=4 \
  padding_left=10 \
  padding_right=15 \
  label.drawing=off \
  background.drawing=off

sketchybar --add item aerospace_workspaces left \
  --set aerospace_workspaces \
  drawing=off \
  label="?" \
  background.color=0x50FF00FF \
  background.corner_radius=10 \
  background.drawing=on \
  background.border_width=2 \
  background.border_color=0x44FF00FF \
  background.height=25 \
  label.color=0xFFC0CAF5 \
  label.padding_right=10 \
  label.padding_left=0 \
  script="$PLUGIN_DIR/aerospace_workspaces.sh" \
  --subscribe aerospace_workspaces aerospace_workspace_change

sketchybar --add item space_separator_2 left \
  --set space_separator_2 icon="􀆊" \
  icon.font="$FONT:Heavy:16.0" \
  icon.padding_left=4 \
  padding_left=10 \
  padding_right=15 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/aerospace_windows.sh" \
  --subscribe space_separator_2 aerospace_update_windows \
  --subscribe space_separator_2 aerospace_workspace_change \
  --subscribe space_separator_2 space_windows_change
