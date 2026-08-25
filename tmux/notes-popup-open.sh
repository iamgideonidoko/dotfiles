#!/usr/bin/env bash

NOTES_OUTER_SOCKET=$1
NOTES_OUTER_CLIENT=$2
NOTES_CURRENT_PATH=$3

tmux -S "$NOTES_OUTER_SOCKET" display-popup -c "$NOTES_OUTER_CLIENT" -x C -y C -E -w 80% -h 80% -d "$NOTES_CURRENT_PATH" "bash ~/dotfiles/tmux/notes-popup.sh '$NOTES_OUTER_SOCKET' '$NOTES_OUTER_CLIENT'" >/dev/null 2>&1 || true
