#!/usr/bin/env bash

AOE_OUTER_SOCKET=$(tmux -L aoe-dashboard show-environment -g AOE_OUTER_SOCKET 2>/dev/null | cut -d= -f2-)
AOE_OUTER_CLIENT=$(tmux -L aoe-dashboard show-environment -g AOE_OUTER_CLIENT 2>/dev/null | cut -d= -f2-)

[ -n "${AOE_OUTER_SOCKET:-}" ] && tmux -S "$AOE_OUTER_SOCKET" display-popup -c "$AOE_OUTER_CLIENT" -C
