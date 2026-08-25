#!/usr/bin/env bash

AOE_OUTER_SOCKET=$1
AOE_OUTER_CLIENT=$2
AOE_CURRENT_PATH=$3

tmux -S "$AOE_OUTER_SOCKET" display-popup -x C -y C -E -w 95% -h 90% -d "$AOE_CURRENT_PATH" "bash ~/dotfiles/tmux/aoe-popup.sh '$AOE_OUTER_SOCKET' '$AOE_OUTER_CLIENT' '$AOE_CURRENT_PATH'" >/dev/null 2>&1 || true
