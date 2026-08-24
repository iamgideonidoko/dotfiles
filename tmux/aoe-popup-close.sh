#!/usr/bin/env bash

tmux -S "$AOE_OUTER_SOCKET" display-popup -c "$AOE_OUTER_CLIENT" -C
