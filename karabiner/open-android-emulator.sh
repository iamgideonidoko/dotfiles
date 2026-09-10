#!/usr/bin/env bash
set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
emulator="$HOME/Library/Android/sdk/emulator/emulator"
window_id="$(aerospace list-windows --all | awk -F'|' '$2 ~ /qemu-system-aarch64/ { gsub(/ /, "", $1); print $1; exit }')"

if [ -n "$window_id" ]; then
  aerospace focus --window-id "$window_id"
  exit
fi

avd="$($emulator -list-avds | head -n 1)"
[ -n "$avd" ] && "$emulator" -avd "$avd" >/dev/null 2>&1 &
