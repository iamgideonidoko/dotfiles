#!/usr/bin/env bash

socket=$1
tmux_cmd=(tmux -S "$socket")

interval=$("${tmux_cmd[@]}" show-options -gqv @dotfiles-resurrect-save-interval)
case $interval in
  ''|*[!0-9]*) interval=5 ;;
esac

now=$(date +%s)
last=$("${tmux_cmd[@]}" show-options -gqv @dotfiles-resurrect-last-save)
case $last in
  ''|*[!0-9]*) last=0 ;;
esac

[ $((now - last)) -ge $((interval * 60)) ] || exit 0

save=$("${tmux_cmd[@]}" show-options -gqv @resurrect-save-script-path)
[ -x "$save" ] || exit 0

TMUX="$socket,0,0" "$save" quiet >/dev/null 2>&1 || exit 0
"${tmux_cmd[@]}" set-option -g @dotfiles-resurrect-last-save "$now"
