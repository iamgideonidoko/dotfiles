#!/usr/bin/env bash

if [ -z "${NOTES_OUTER_SOCKET:-}" ]; then
  NOTES_OUTER_SOCKET=$(tmux -L notes show-environment -g NOTES_OUTER_SOCKET 2>/dev/null | cut -d= -f2-)
  NOTES_OUTER_CLIENT=$(tmux -L notes show-environment -g NOTES_OUTER_CLIENT 2>/dev/null | cut -d= -f2-)
fi

[ -n "${NOTES_OUTER_SOCKET:-}" ] && tmux -S "$NOTES_OUTER_SOCKET" display-popup -c "$NOTES_OUTER_CLIENT" -C
