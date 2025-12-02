#!/usr/bin/env bash

sketchybar --add event aerospace_item_init
sketchybar --add event aerospace_workspace_change
sketchybar --add event hammerspoon_windows_change

aerospace_workspace=(
  drawing=off
  background.color=0x66262A3F
  background.corner_radius=10
  background.drawing=on
  background.border_color=0xAA7AA2F7
  background.border_width=0
  background.height=25
  icon.padding_left=10
  label.font="sketchybar-app-font:Regular:16.0"
  label.color=0xFFC0CAF5
  label.padding_right=20
  label.padding_left=0
  label.y_offset=-1
)

aerospace_separator_1=(
  icon="✦"
  drawing=off
  icon.font="$FONT:Heavy:16.0"
  icon.padding_left=4
  padding_left=10
  padding_right=15
  label.drawing=off
  background.drawing=off
)

aerospace_workspaces=(
  drawing=off
  label="◌"
  icon.drawing=off
  background.color=0x50FF00FF
  background.corner_radius=10
  background.drawing=on
  background.border_width=2
  background.border_color=0x44FF00FF
  background.height=25
  label.color=0xFFC0CAF5
  label.padding_right=10
  label.padding_left=10
)

aerospace_separator_2=(
  icon="􀆊"
  icon.font="$FONT:Heavy:16.0"
  icon.padding_left=4
  padding_left=10
  padding_right=15
  label.drawing=off
  background.drawing=off
  script="$PLUGIN_DIR/aerospace.sh"
)

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item "aerospace.workspace.$sid" left \
    --set "aerospace.workspace.$sid" icon="$sid" \
    click_script="aerospace workspace $sid" \
    "${aerospace_workspace[@]}"
done

sketchybar --add item aerospace.separator.1 left --set aerospace.separator.1 "${aerospace_separator_1[@]}"

sketchybar --add item aerospace.workspaces left --set aerospace.workspaces "${aerospace_workspaces[@]}"

sketchybar --add item aerospace.separator.2 left --set aerospace.separator.2 "${aerospace_separator_2[@]}" \
  --subscribe aerospace.separator.2 aerospace_workspace_change \
  --subscribe aerospace.separator.2 hammerspoon_windows_change \
  --subscribe aerospace.separator.2 aerospace_item_init

sketchybar --trigger aerospace_item_init
