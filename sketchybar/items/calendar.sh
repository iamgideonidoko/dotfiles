#!/usr/bin/env bash

calendar=(
  icon=cal
  icon.font.style=Black
  icon.padding_right=4
  label.align=right
  update_freq=30
  icon.font.size="$FONT_SIZE"
  label.font.size="$FONT_SIZE"
  script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" \
  --subscribe calendar system_woke
