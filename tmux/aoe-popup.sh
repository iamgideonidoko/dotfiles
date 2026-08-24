#!/usr/bin/env bash

if ! tmux -S "$AOE_OUTER_SOCKET" has-session -t aoe-dashboard 2>/dev/null; then
  tmux -S "$AOE_OUTER_SOCKET" new-session -d -s aoe-dashboard -c "$PWD" aoe
fi

tmux -S "$AOE_OUTER_SOCKET" set-option -t aoe-dashboard status off
tmux -S "$AOE_OUTER_SOCKET" set-option -t aoe-dashboard detach-on-destroy on
tmux -L aoe set-environment -g AOE_OUTER_SOCKET "$AOE_OUTER_SOCKET"
tmux -L aoe set-environment -g AOE_OUTER_CLIENT "$AOE_OUTER_CLIENT"
tmux -L aoe set-option -g prefix C-b
tmux -L aoe bind-key C-b send-prefix
tmux -L aoe bind-key -n C-q detach-client
tmux -L aoe bind-key -n C-Space switch-client -T aoe-popup
tmux -L aoe bind-key -T aoe-popup a run-shell -b 'bash ~/dotfiles/tmux/aoe-popup-close.sh'
exec tmux -S "$AOE_OUTER_SOCKET" attach-session -t aoe-dashboard
