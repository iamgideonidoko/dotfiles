#!/usr/bin/env bash

svim=(
  script="$PLUGIN_DIR/svim.sh"
  icon="$INSERT_MODE"
  icon.padding_right=4
  icon.font.size="$FONT_SIZE_LARGE"
  updates=on
  drawing=off
)

sketchybar --add event svim_update \
  --add item svim right \
  --set svim "${svim[@]}" \
  --subscribe svim svim_update
