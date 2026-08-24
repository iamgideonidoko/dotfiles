#!/usr/bin/env bash

tmux -L aoe set-environment -g AOE_OUTER_SOCKET "$AOE_OUTER_SOCKET"
tmux -L aoe set-environment -g AOE_OUTER_CLIENT "$AOE_OUTER_CLIENT"
exec aoe
