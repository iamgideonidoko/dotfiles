#!/usr/bin/env bash
# Verify service identity and detect new unreaped svim children.
set -euo pipefail

interval=${1:-60}
(( interval > 0 )) || { printf 'interval must be positive\n' >&2; exit 2; }
binary="$HOME/.local/opt/svim/bin/svim"

test -x "$binary"
codesign --verify --strict --verbose=2 "$binary"
nm -u "$binary" | grep -q 'waitpid'

pid=$(pgrep -f "^$binary$" || true)
test -n "$pid"
test "$(printf '%s\n' "$pid" | wc -l | tr -d ' ')" = 1

zombie_count() {
  ps -axo ppid=,state= | awk -v parent="$pid" '$1 == parent && $2 ~ /^Z/ { count++ } END { print count + 0 }'
}

before=$(zombie_count)
sleep "$interval"
after=$(zombie_count)
printf 'svim_pid=%s zombies_before=%s zombies_after=%s\n' "$pid" "$before" "$after"
test "$after" -le "$before"
