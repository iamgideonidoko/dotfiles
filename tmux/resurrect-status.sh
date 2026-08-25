#!/usr/bin/env bash

socket=$1

sleep 1

autosave="#(bash ~/dotfiles/tmux/resurrect-autosave.sh '$socket')"
status_right=$(tmux -S "$socket" show-options -gqv status-right)
case $status_right in
  *"$autosave"*) ;;
  *) tmux -S "$socket" set-option -g status-right "${status_right}${autosave}" ;;
esac
