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
cat >"$test_dir/aerospace" <<'SH'
#!/bin/sh
if [ "$1" = list-windows ]; then
  printf '%s\n' '123 | Ghostty | Terminal'
else
  printf '%s\n' "aerospace $*" >>"$TEST_LOG"
fi
SH
chmod +x "$test_dir/pgrep" "$test_dir/omniwmctl" "$test_dir/open" "$test_dir/mdls" "$test_dir/aerospace"
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
[[ $(TEST_OMNI_RUNNING=1 bash "$test_dir/window" list) == '123 | Ghostty | Terminal' ]]
TEST_OMNI_RUNNING=1 bash "$test_dir/window" navigate 123
[[ $(tail -n 1 "$TEST_LOG") == 'aerospace focus --window-id 123' ]]
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
echo 'window helpers: OK'
