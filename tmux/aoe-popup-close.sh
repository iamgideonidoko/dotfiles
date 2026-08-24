#!/usr/bin/env bash

if [ -z "${AOE_OUTER_SOCKET:-}" ]; then
  AOE_OUTER_SOCKET=$(tmux -L aoe show-environment -g AOE_OUTER_SOCKET 2>/dev/null | cut -d= -f2-)
  AOE_OUTER_CLIENT=$(tmux -L aoe show-environment -g AOE_OUTER_CLIENT 2>/dev/null | cut -d= -f2-)
fi

[ -n "${AOE_OUTER_SOCKET:-}" ] && tmux -S "$AOE_OUTER_SOCKET" display-popup -c "$AOE_OUTER_CLIENT" -C
