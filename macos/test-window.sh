#!/usr/bin/env bash
# Check window navigation and IPC failures with fake commands, not live windows.
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
export TEST_LOG="$test_dir/log"
cat >"$test_dir/pgrep" <<'SH'
#!/bin/sh
exit "${TEST_OMNI_RUNNING:-0}"
SH
cat >"$test_dir/omniwmctl" <<'SH'
#!/bin/sh
if [ "$1" = query ]; then
  [ "${TEST_IPC_FAIL:-0}" = 0 ] || exit 3
  if [ "$2" = workspaces ]; then
    printf '{"ok":true,"result":{"kind":"workspaces","payload":{"workspaces":[{"layout":"%s"}]}}}\n' "${TEST_LAYOUT:-dwindle}"
    exit
  fi
  if [ -n "${TEST_WINDOWS:-}" ]; then
    printf '{"ok":true,"result":{"kind":"windows","payload":{"windows":%s}}}\n' "$TEST_WINDOWS"
    exit
  fi
  printf '%s\n' '{"ok":true,"result":{"kind":"windows","payload":{"windows":[{"id":"ow_test","app":{"name":"Ghostty"},"title":"Terminal"},{"id":"ow_emulator","app":{"name":"qemu-system-aarch64"},"title":"Android"}]}}}'
else
  printf '%s\n' "$*" >>"$TEST_LOG"
fi
SH
cat >"$test_dir/open" <<'SH'
#!/bin/sh
printf '%s\n' "open $*" >>"$TEST_LOG"
SH
cat >"$test_dir/mdls" <<'SH'
#!/bin/sh
printf '%s\n' '(null)'
SH
cat >"$test_dir/python3" <<'SH'
#!/bin/sh
cat >/dev/null
[ "${TEST_AX_FAIL:-0}" = 0 ] || exit 1
printf '%s\n' "${TEST_NATIVE_ID:-202}"
SH
cat >"$test_dir/dotfiles-window-history" <<'SH'
#!/bin/sh
printf 'history %s\n' "$*" >>"$TEST_LOG"
SH
chmod +x "$test_dir/pgrep" "$test_dir/omniwmctl" "$test_dir/open" "$test_dir/mdls" "$test_dir/python3" "$test_dir/dotfiles-window-history"
# The helper adds Homebrew paths, so copy it with only the test PATH for isolation.
sed '/^export PATH=/d' "$repo_dir/macos/window" >"$test_dir/window"
export PATH="$test_dir:$PATH"
bash "$test_dir/window" app Ghostty
bash "$test_dir/window" app Notes
bash "$test_dir/window" emulator
[[ $(cat "$TEST_LOG") == $'window navigate ow_test\nopen -a Notes\nwindow navigate ow_emulator' ]]
[[ $(bash "$test_dir/window" list) == $'ow_test\tGhostty\tTerminal\now_emulator\tqemu-system-aarch64\tAndroid' ]]
before=$(cat "$TEST_LOG")
if TEST_IPC_FAIL=1 bash "$test_dir/window" app Ghostty; then
  echo 'IPC failure must not launch an app' >&2
  exit 1
fi
if TEST_IPC_FAIL=1 bash "$test_dir/window" emulator; then
  echo 'IPC failure must not launch an emulator' >&2
  exit 1
fi
[[ $(cat "$TEST_LOG") == "$before" ]]
if TEST_IPC_FAIL=1 bash "$test_dir/window" list; then
  echo 'Failed window query must not list windows' >&2
  exit 1
fi
bash "$test_dir/window" navigate ow_test
[[ $(tail -n 1 "$TEST_LOG") == 'window navigate ow_test' ]]
TEST_OMNI_RUNNING=1 bash "$test_dir/window" app Ghostty
[[ $(tail -n 1 "$TEST_LOG") == 'open -a Ghostty' ]]
TEST_LAYOUT=niri bash "$test_dir/window" resize grow
TEST_LAYOUT=niri bash "$test_dir/window" resize shrink
TEST_LAYOUT=dwindle bash "$test_dir/window" resize grow
TEST_LAYOUT=dwindle bash "$test_dir/window" resize shrink
[[ $(tail -n 4 "$TEST_LOG") == $'command set-container-primary-span +5%\ncommand set-container-primary-span -5%\ncommand resize-focused grow\ncommand resize-focused shrink' ]]
before=$(cat "$TEST_LOG")
if TEST_IPC_FAIL=1 bash "$test_dir/window" resize grow; then
  echo 'Failed workspace query must not resize' >&2
  exit 1
fi
if TEST_LAYOUT=unknown bash "$test_dir/window" resize grow; then
  echo 'Unknown layout must not resize' >&2
  exit 1
fi
if bash "$test_dir/window" resize invalid; then
  echo 'Invalid resize direction must fail' >&2
  exit 1
fi
[[ $(cat "$TEST_LOG") == "$before" ]]
export TEST_WINDOWS='[
  {"id":"older","pid":42,"windowId":101,"app":{"name":"Ghostty"},"workspace":{"number":1},"display":{"id":"external"},"isFocused":false},
  {"id":"recent","pid":42,"windowId":202,"app":{"name":"Ghostty"},"workspace":{"number":9},"display":{"id":"built-in"},"isFocused":false}
]'
bash "$test_dir/window" app Ghostty
[[ $(tail -n 1 "$TEST_LOG") == 'window navigate recent' ]]
TEST_NATIVE_ID=101 bash "$test_dir/window" app Ghostty
[[ $(tail -n 1 "$TEST_LOG") == 'window navigate older' ]]
before=$(cat "$TEST_LOG")
if TEST_AX_FAIL=1 bash "$test_dir/window" app Ghostty; then
  echo 'Failed focus lookup must not select an arbitrary window' >&2
  exit 1
fi
if TEST_NATIVE_ID=999 bash "$test_dir/window" app Ghostty; then
  echo 'Unmanaged focused window must not select an arbitrary window' >&2
  exit 1
fi
[[ $(cat "$TEST_LOG") == "$before" ]]
TEST_WINDOWS=$(jq '.[0].isFocused = true' <<<"$TEST_WINDOWS")
TEST_AX_FAIL=1 bash "$test_dir/window" app Ghostty
[[ $(tail -n 1 "$TEST_LOG") == 'window navigate older' ]]
unset TEST_WINDOWS
bash "$test_dir/window" previous
[[ $(tail -n 1 "$TEST_LOG") == 'history previous' ]]
echo 'window helpers: OK'
