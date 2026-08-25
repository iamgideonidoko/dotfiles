#!/usr/bin/env bash

if ! tmux -S "$AOE_OUTER_SOCKET" has-session -t aoe-dashboard 2>/dev/null; then
  tmux -S "$AOE_OUTER_SOCKET" new-session -d -s aoe-dashboard -c "$PWD" aoe
fi

tmux -S "$AOE_OUTER_SOCKET" set-option -t aoe-dashboard status off
tmux -S "$AOE_OUTER_SOCKET" set-option -t aoe-dashboard detach-on-destroy on
# Guard popup-producing plugin bindings by session. AoE dashboard uses outer tmux.
tmux -S "$AOE_OUTER_SOCKET" bind-key C-Space if-shell -F '#{==:#{session_name},aoe-dashboard}' '' "run-shell -b '#{TMUX_PLUGIN_MANAGER_PATH}/tmux-fzf/scripts/window.sh switch'"
tmux -S "$AOE_OUTER_SOCKET" bind-key p if-shell -F '#{==:#{session_name},aoe-dashboard}' '' "run-shell '#{TMUX_PLUGIN_MANAGER_PATH}/tmux-floax/scripts/floax.sh'"
tmux -S "$AOE_OUTER_SOCKET" bind-key P if-shell -F '#{==:#{session_name},aoe-dashboard}' '' "run-shell '#{TMUX_PLUGIN_MANAGER_PATH}/tmux-floax/scripts/menu.sh'"
tmux -L aoe set-environment -g AOE_OUTER_SOCKET "$AOE_OUTER_SOCKET"
tmux -L aoe set-environment -g AOE_OUTER_CLIENT "$AOE_OUTER_CLIENT"
tmux -L aoe set-option -g prefix C-b
tmux -L aoe bind-key C-b send-prefix
tmux -L aoe set-hook -g client-attached 'if-shell -F "#{m:aoe_*,#{session_name}}" "switch-client -T aoe-agent"'
tmux -L aoe bind-key -T aoe-agent C-b switch-client -T prefix
tmux -L aoe bind-key -T aoe-agent C-q detach-client
tmux -L aoe bind-key -T aoe-agent C-Space switch-client -T aoe-agent-prefix
tmux -L aoe bind-key -T aoe-agent-prefix a run-shell -b 'bash ~/dotfiles/tmux/aoe-popup-close.sh'
tmux -L aoe bind-key -T aoe-agent-prefix Escape switch-client -T aoe-agent
exec tmux -S "$AOE_OUTER_SOCKET" attach-session -t aoe-dashboard
