#!/usr/bin/env bash

NOTES_OUTER_SOCKET=${1:-${NOTES_OUTER_SOCKET:-}}
NOTES_OUTER_CLIENT=${2:-${NOTES_OUTER_CLIENT:-}}
NOTES_DIR="$HOME/notes"
mkdir -p "$NOTES_DIR"

if ! tmux -L notes has-session -t notes-popup 2>/dev/null; then
  tmux -L notes new-session -d -s notes-popup -c "$NOTES_DIR" nvim
fi

tmux -L notes set-option -t notes-popup status off
tmux -L notes set-option -t notes-popup detach-on-destroy on
tmux -L notes set-environment -g NOTES_OUTER_SOCKET "$NOTES_OUTER_SOCKET"
tmux -L notes set-environment -g NOTES_OUTER_CLIENT "$NOTES_OUTER_CLIENT"
tmux -L notes unbind-key C-b
tmux -L notes set-option -g prefix C-Space
tmux -L notes bind-key C-Space send-prefix
tmux -L notes bind-key k run-shell -b 'bash ~/dotfiles/tmux/notes-popup-close.sh'

exec tmux -L notes attach-session -t notes-popup
