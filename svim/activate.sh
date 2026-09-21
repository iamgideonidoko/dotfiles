#!/usr/bin/env bash
# Replace Homebrew's leaking svim LaunchAgent after a successful local build.
set -euo pipefail

[[ $(uname) == Darwin ]] || { echo 'svim/activate.sh requires macOS' >&2; exit 1; }

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
uid=$(id -u)
label=com.dotfiles.svim
plist_dir="$HOME/Library/LaunchAgents"
plist="$plist_dir/$label.plist"
plist_temp=

if [[ ${1:-} = --skip-build ]]; then
  test -x "$HOME/.local/opt/svim/bin/svim"
else
  "$root_dir/install.sh"
fi
plutil -lint "$root_dir/$label.plist"
mkdir -p "$plist_dir"
mkdir -p "$HOME/Library/Logs"
plist_temp=$(mktemp "$plist_dir/.$label.XXXXXX")
trap 'if [[ -n $plist_temp ]]; then rm -f "$plist_temp"; fi' EXIT
cp "$root_dir/$label.plist" "$plist_temp"
plutil -replace StandardErrorPath -string "$HOME/Library/Logs/svim.log" "$plist_temp"
plutil -replace StandardOutPath -string "$HOME/Library/Logs/svim.log" "$plist_temp"
plutil -lint "$plist_temp"
if ! cmp -s "$plist_temp" "$plist"; then
  if [[ -e "$plist" || -L "$plist" ]]; then
    backup="$plist.backup.$(date +%Y%m%d%H%M%S)"
    while [[ -e "$backup" || -L "$backup" ]]; do backup="${backup}_next"; done
    mv "$plist" "$backup"
  fi
  mv "$plist_temp" "$plist"
  plist_temp=
fi

# Only stop Homebrew service after patched binary built and plist validated.
brew services stop svim >/dev/null 2>&1 || true
launchctl bootout "gui/$uid/homebrew.mxcl.svim" 2>/dev/null || true
launchctl bootout "gui/$uid/$label" 2>/dev/null || true
launchctl bootstrap "gui/$uid" "$plist"
launchctl kickstart -k "gui/$uid/$label"
launchctl print "gui/$uid/$label" >/dev/null
printf 'active patched svim service: %s\n' "$label"
