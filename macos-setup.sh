#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
dry_run=false
[[ ${1:-} == --dry-run ]] && dry_run=true
[[ $# -le 1 && ( $# -eq 0 || $dry_run == true ) ]] || { echo "Usage: $0 [--dry-run]" >&2; exit 64; }
if [[ $dry_run == false && $(uname) != Darwin ]]; then
  echo 'macos-setup.sh requires macOS' >&2
  exit 1
fi
cd "$repo_dir"

step() {
  printf '\n==> %s\n' "$1"
  shift
  if [[ $dry_run == true ]]; then
    printf '  %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

pause_for() {
  printf '\n%s\n' "$1"
  [[ $dry_run == true ]] && return
  [[ -t 0 ]] || { echo 'Interactive terminal required; rerun setup after completing this step' >&2; exit 1; }
  read -r -p 'Press Enter when done (Ctrl-C to stop): ' _
}

step 'Link configuration' bash "$repo_dir/symlink-macos.sh"
step 'Install packages, runtimes, and executors' bash "$repo_dir/macos-packages.sh" install
step 'Apply macOS preferences' bash "$repo_dir/macos-preferences.sh"
pause_for 'Grant Accessibility permission to ~/.local/opt/svim/bin/svim in System Settings.'
step 'Verify patched SketchyVim' bash "$repo_dir/svim/verify.sh" 60
pause_for 'Open Spotify, sign in, and leave it open for one minute.'
step 'Apply Spotify theme' make -C "$repo_dir" spicetify
if [[ $dry_run == true ]]; then
  printf '\nDry run complete; no changes made.\n'
else
  printf '\nmacOS setup complete. Grant any remaining app permissions requested on first launch.\n'
fi
