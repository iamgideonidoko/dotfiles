#!/usr/bin/env bash

AOE_OUTER_SOCKET=$1
AOE_OUTER_CLIENT=$2
AOE_CURRENT_PATH=$3

if ! tmux -L aoe-dashboard has-session -t aoe-dashboard 2>/dev/null; then
  tmux -L aoe-dashboard new-session -d -s aoe-dashboard -c "$AOE_CURRENT_PATH" aoe
  tmux -L aoe-dashboard set-option -t aoe-dashboard status off
  tmux -L aoe-dashboard set-option -t aoe-dashboard detach-on-destroy on
fi

tmux -L aoe-dashboard set-environment -g AOE_OUTER_SOCKET "$AOE_OUTER_SOCKET"
tmux -L aoe-dashboard set-environment -g AOE_OUTER_CLIENT "$AOE_OUTER_CLIENT"
tmux -L aoe-dashboard unbind-key C-b
tmux -L aoe-dashboard set-option -g prefix C-Space
tmux -L aoe-dashboard bind-key C-Space send-prefix
# AoE's Kitty enhancement negotiation cannot cross this popup's nested tmux
# client. Meta+Enter is AoE's supported non-Kitty newline path (ESC + CR).
tmux -L aoe-dashboard bind-key -n S-Enter send-keys M-Enter
tmux -L aoe-dashboard bind-key a run-shell -b 'bash ~/dotfiles/tmux/aoe-popup-close.sh'
exec tmux -L aoe-dashboard attach-session -t aoe-dashboard
