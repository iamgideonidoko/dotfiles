#!/usr/bin/env bash

sketchybar --add event aerospace_item_init
sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_focus_change

aerospace_workspace=(
  drawing=off
  background.color=0x66262A3F
  background.corner_radius=6
  background.drawing=on
  background.border_color=0xAA7AA2F7
  background.border_width=0
  background.height=16
  icon.padding_left=5
  label.font.family="sketchybar-app-font"
  label.font.style=Regular
  label.font.size="$FONT_SIZE"
  label.color=0xFFC0CAF5
  label.padding_right=0
  label.padding_left=0
  label.y_offset=-2
  background.y_offset=-1
  icon.y_offset=-1
)

aerospace_separator_1=(
  icon="✦"
  drawing=off
  icon.font.style=Heavy
  icon.font.size="$FONT_SIZE_SMALL"
  icon.padding_left=4
  padding_left=2
  padding_right=2
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
  background.height=18
  label.color=0xFFC0CAF5
  label.padding_right=6
  label.padding_left=6
)

aerospace_fullscreen=(
  drawing=off
  script="$PLUGIN_DIR/aerospace-fullscreen.sh"
)

aerospace_separator_2=(
  icon="􀆊"
  icon.font.style=Heavy
  icon.font.size="$FONT_SIZE_SMALL"
  icon.padding_left=0
  padding_left=2
  padding_right=2
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

sketchybar --add item aerospace.fullscreen left --set aerospace.fullscreen "${aerospace_fullscreen[@]}" \
  --subscribe aerospace.fullscreen aerospace_item_init \
  --subscribe aerospace.fullscreen aerospace_workspace_change \
  --subscribe aerospace.fullscreen aerospace_focus_change \
  --subscribe aerospace.fullscreen space_change \
  --subscribe aerospace.fullscreen space_windows_change \
  --subscribe aerospace.fullscreen display_change \
  --subscribe aerospace.fullscreen system_woke

sketchybar --add item aerospace.separator.2 left --set aerospace.separator.2 "${aerospace_separator_2[@]}" \
  --subscribe aerospace.separator.2 aerospace_workspace_change \
  --subscribe aerospace.separator.2 aerospace_focus_change \
  --subscribe aerospace.separator.2 space_windows_change \
  --subscribe aerospace.separator.2 aerospace_item_init

sketchybar --trigger aerospace_item_init
