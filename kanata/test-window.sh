#!/usr/bin/env bash
set -euo pipefail

test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
export TEST_WINDOW_DIR="$test_dir"
cat >"$test_dir/clients.json" <<'JSON'
[
  {"address":"0x10","class":"com.mitchellh.ghostty","pid":1,"workspace":{"id":1},"focusHistoryID":0},
  {"address":"0x20","class":"google-chrome","pid":2,"workspace":{"id":1},"focusHistoryID":1},
  {"address":"0x30","class":"com.mitchellh.ghostty","pid":1,"workspace":{"id":3},"focusHistoryID":2},
  {"address":"0x40","class":"chrome-youtube.com__-Default","pid":2,"workspace":{"id":2},"focusHistoryID":3},
  {"address":"0x50","class":"com.mitchellh.ghostty","pid":1,"workspace":{"id":2},"focusHistoryID":4},
  {"address":"0x60","class":"google-chrome","pid":2,"workspace":{"id":3},"focusHistoryID":5},
  {"address":"0x70","class":"TUI.tile","pid":1,"workspace":{"id":2},"focusHistoryID":6},
  {"address":"0x80","class":"TUI.float","pid":1,"workspace":{"id":3},"focusHistoryID":7}
]
JSON
cat >"$test_dir/hyprctl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
case "$1" in
  clients) cat "$TEST_WINDOW_DIR/clients.json" ;;
  activewindow)
    jq --arg address "$(cat "$TEST_WINDOW_DIR/active")" \
      '.[] | select(.address == $address)' "$TEST_WINDOW_DIR/clients.json"
    ;;
  dispatch)
    [[ $2 =~ address:(0x[0-9a-f]+) ]] || exit 1
    printf '%s' "${BASH_REMATCH[1]}" >"$TEST_WINDOW_DIR/active"
    jq --arg address "${BASH_REMATCH[1]}" \
      'map(if .address == $address then .focusHistoryID = 0 else .focusHistoryID += 1 end)' \
      "$TEST_WINDOW_DIR/clients.json" >"$TEST_WINDOW_DIR/next.json"
    mv "$TEST_WINDOW_DIR/next.json" "$TEST_WINDOW_DIR/clients.json"
    ;;
esac
SH
chmod +x "$test_dir/hyprctl"
export PATH="$test_dir:$PATH"
window=$(cd "$(dirname "$0")" && pwd)/window

check() {
  "$window" cycle "$1"
  [[ $(cat "$test_dir/active") == "$2" ]] || {
    printf 'Expected %s, got %s\n' "$2" "$(cat "$test_dir/active")" >&2
    exit 1
  }
}

printf '0x10' >"$test_dir/active"
check next 0x50
check next 0x30
check next 0x10
check prev 0x30
printf '0x20' >"$test_dir/active"
check next 0x60
check next 0x20
printf '0x40' >"$test_dir/active"
check next 0x40
printf '0x70' >"$test_dir/active"
check next 0x70
printf 'window cycling: OK\n'
