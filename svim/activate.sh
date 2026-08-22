#!/usr/bin/env bash
# Replace Homebrew's leaking svim LaunchAgent after a successful local build.
set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
uid=$(id -u)
label=com.dotfiles.svim
plist_dir="$HOME/Library/LaunchAgents"
plist="$plist_dir/$label.plist"

if [[ ${1:-} = --skip-build ]]; then
  test -x "$HOME/.local/opt/svim/bin/svim"
else
  "$root_dir/install.sh"
fi
plutil -lint "$root_dir/$label.plist"
mkdir -p "$plist_dir"
ln -sfn "$root_dir/$label.plist" "$plist"

# Only stop Homebrew service after patched binary built and plist validated.
brew services stop svim >/dev/null 2>&1 || true
launchctl bootout "gui/$uid/homebrew.mxcl.svim" 2>/dev/null || true
launchctl bootout "gui/$uid/$label" 2>/dev/null || true
launchctl bootstrap "gui/$uid" "$root_dir/$label.plist"
launchctl kickstart -k "gui/$uid/$label"
launchctl print "gui/$uid/$label" >/dev/null
printf 'active patched svim service: %s\n' "$label"
