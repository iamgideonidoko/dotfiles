#!/usr/bin/env bash

PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"

update() {
  local all_workspaces all_windows current_workspace focused_monitor workspace app icons background_color output m ws
  local -a monitors set_args
  local -A workspace_apps visible_workspaces_by_monitor

  all_workspaces=$(aerospace list-workspaces --all)
  all_windows=$(aerospace list-windows --all --format '%{workspace}|%{app-name}')
  current_workspace=$(aerospace list-workspaces --focused)
  focused_monitor=$(aerospace list-monitors --focused --format '%{monitor-id}')
  mapfile -t monitors < <(aerospace list-monitors --format '%{monitor-id}')

  while IFS='|' read -r workspace app; do
    [ -n "$workspace" ] || continue
    workspace_apps["$workspace"]+="${workspace_apps[$workspace]:+$'\n'}$app"
  done <<<"$all_windows"

  while IFS='|' read -r m ws; do
    visible_workspaces_by_monitor["$m"]="$ws"
  done < <(aerospace list-workspaces --monitor all --visible --format '%{monitor-id}|%{workspace}')

  for sid in $all_workspaces; do
    icons=""
    while read -r app; do
      [ -n "$app" ] && icons+=" $("$PLUGIN_DIR/icon_map.sh" "$app")"
    done <<<"${workspace_apps[$sid]-}"

    if [ -n "$icons" ]; then
      background_color=0x44FFFFFF
      [ "$sid" = "$current_workspace" ] && background_color=0x607DCFFF
      set_args+=(--set "aerospace.workspace.$sid" drawing=on label="$icons" label.padding_right=13 background.color="$background_color")
    elif [ "$sid" = "$current_workspace" ]; then
      set_args+=(--set "aerospace.workspace.$sid" drawing=on label="" label.padding_right=0 background.color=0x607DCFFF)
    else
      set_args+=(--set "aerospace.workspace.$sid" drawing=off label="" label.padding_right=0)
    fi
  done

  if [ "${#monitors[@]}" -gt 1 ]; then
    output=""
    for m in "${monitors[@]}"; do
      ws="${visible_workspaces_by_monitor[$m]-}"
      [ "$m" = "$focused_monitor" ] && output+="*"
      output+="${ws}|"
    done
    set_args+=(--set aerospace.workspaces drawing=on "label=${output%|}" --set aerospace.separator.1 drawing=on)
  else
    set_args+=(--set aerospace.workspaces drawing=off --set aerospace.separator.1 drawing=off)
  fi

  sketchybar "${set_args[@]}"
}

if
  [ "${SENDER:-}" = "aerospace_focus_change" ] ||
    [ "${SENDER:-}" = "aerospace_item_init" ] ||
    [ "${SENDER:-}" = "aerospace_workspace_change" ] ||
    [ "${SENDER:-}" = "space_windows_change" ]
then
  update
fi
