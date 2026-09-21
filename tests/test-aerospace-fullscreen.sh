#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
export MOCK_STATE="$test_dir/state" TMPDIR="$test_dir" PATH="$test_dir/bin:$PATH"
mkdir -p "$test_dir/bin" "$MOCK_STATE"
printf '1\n' >"$MOCK_STATE/window"
printf 'false\n' >"$MOCK_STATE/fullscreen"
printf '1\n' >"$MOCK_STATE/monitor"

cat >"$test_dir/bin/aerospace" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  list-windows) printf '%s|%s\n' "$(<"$MOCK_STATE/window")" "$(<"$MOCK_STATE/fullscreen")" ;;
  list-monitors) cat "$MOCK_STATE/monitor" ;;
  fullscreen)
    case "$2" in
      on) printf 'true\n' >"$MOCK_STATE/fullscreen" ;;
      off) printf 'false\n' >"$MOCK_STATE/fullscreen" ;;
    esac
    ;;
  move-mouse) ;;
  *) exit 2 ;;
esac
EOF
cat >"$test_dir/bin/sketchybar" <<'EOF'
#!/usr/bin/env bash
[ "$1" = --bar ] || exit 2
if [ "$2" = hidden=off ]; then
  rm -f "$MOCK_STATE"/bar-*
  exit
fi
[ "$2" = hidden=current ] || exit 2
monitor=$(<"$MOCK_STATE/monitor")
bar="$MOCK_STATE/bar-$monitor"
if [ -f "$bar" ]; then rm "$bar"; else : >"$bar"; fi
EOF
chmod +x "$test_dir/bin/aerospace" "$test_dir/bin/sketchybar"
helper="$repo_dir/sketchybar/plugins/aerospace-fullscreen.sh"

bash "$helper" fullscreen
test -f "$MOCK_STATE/bar-1"
test "$(<"$MOCK_STATE/fullscreen")" = true
bash "$helper" maximized
test ! -f "$MOCK_STATE/bar-1"
test "$(<"$MOCK_STATE/fullscreen")" = true
bash "$helper" maximized
test "$(<"$MOCK_STATE/fullscreen")" = false

bash "$helper" fullscreen
printf '2\n' >"$MOCK_STATE/window"
printf 'false\n' >"$MOCK_STATE/fullscreen"
printf '2\n' >"$MOCK_STATE/monitor"
bash "$helper" sync
test -f "$MOCK_STATE/bar-1"
test ! -f "$MOCK_STATE/bar-2"
printf '1\n' >"$MOCK_STATE/window"
printf '1\n' >"$MOCK_STATE/monitor"
printf 'true\n' >"$MOCK_STATE/fullscreen"
bash "$helper" sync
test -f "$MOCK_STATE/bar-1"
printf 'false\n' >"$MOCK_STATE/fullscreen"
bash "$helper" sync
test ! -f "$MOCK_STATE/bar-1"

printf 'true\n' >"$MOCK_STATE/fullscreen"
bash "$helper" fullscreen
test "$(<"$MOCK_STATE/fullscreen")" = false
test ! -f "$MOCK_STATE/bar-1"

bash "$helper" fullscreen
SENDER=aerospace_item_init bash "$helper" sync
test -f "$MOCK_STATE/bar-1"
printf 'aerospace fullscreen: OK\n'
