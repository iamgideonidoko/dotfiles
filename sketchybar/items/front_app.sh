#!/usr/bin/env bash

front_app=(
  label.font.style=Black
  icon.background.drawing=on
  icon.background.image.scale=0.7
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)

sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched
