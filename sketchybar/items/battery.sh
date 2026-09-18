#!/usr/bin/env bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font.size="$FONT_SIZE_LARGE"
  label.font.size="$FONT_SIZE"
  padding_right=2
  padding_left=2
  label.drawing=on
  update_freq=120
  updates=on
)

sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke
