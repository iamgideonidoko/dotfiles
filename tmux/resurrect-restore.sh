#!/usr/bin/env bash

socket=$1
tmux_cmd=(tmux -S "$socket")

sleep 1

started=$("${tmux_cmd[@]}" display-message -p '#{start_time}')
now=$(date +%s)
[ -n "$started" ] && [ $((now - started)) -le 15 ] || exit 0
[ "$("${tmux_cmd[@]}" show-options -gqv @dotfiles-resurrect-restored)" = 1 ] && exit 0

restore=$("${tmux_cmd[@]}" show-options -gqv @resurrect-restore-script-path)
[ -x "$restore" ] || exit 0

"${tmux_cmd[@]}" set-option -g @dotfiles-resurrect-restored 1
TMUX="$socket,0,0" "$restore"
