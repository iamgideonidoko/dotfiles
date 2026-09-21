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

step_unless() {
  local description=$1
  shift
  local check=$1
  shift

  if [[ $dry_run == false ]] && "$check"; then
    printf '\n==> %s (already configured; skipping)\n' "$description"
    return
  fi
  step "$description" "$@"
}

brew_bundle_installed() {
  command -v brew >/dev/null &&
    brew bundle check --file="$repo_dir/brew/Brewfile" >/dev/null 2>&1
}

jetbrains_nerd_font_installed() {
  find "$HOME/Library/Fonts" -maxdepth 1 -type f \
    -name 'JetBrainsMonoNerdFont-*.ttf' -print -quit 2>/dev/null | grep -q .
}

headroom_installed() {
  command -v headroom >/dev/null || return 1
  local python
  python="$(head -n1 "$(command -v headroom)" | sed 's/^#!//')"
  [[ -n $python && -x $python ]] && "$python" -c 'import fastapi'
}

agent_optimized() {
  make -s -C "$repo_dir" agent-verify >/dev/null 2>&1
}

gh_extensions_installed() {
  command -v gh >/dev/null || return 1
  local extension
  while read -r extension; do
    gh extension list | awk '{print $1}' | grep -qxF "$extension" || return 1
  done < <(make -s -C "$repo_dir" -pn | sed -n 's/^GH_EXTENSIONS := //p' | tr ' ' '\n')
}

brew_service_running() {
  brew services list 2>/dev/null |
    awk -v service="$1" '$1 == service && $2 == "started" { found = 1 } END { exit !found }'
}

sketchybar_running() {
  brew_service_running sketchybar
}

borders_running() {
  brew_service_running borders
}

aerospace_running() {
  pgrep -x AeroSpace >/dev/null
}

svim_running() {
  launchctl print "gui/$(id -u)/com.dotfiles.svim" >/dev/null 2>&1
}

pause_for() {
  printf '\n%s\n' "$1"
  [[ $dry_run == true ]] && return
  [[ -t 0 ]] || { echo 'Interactive terminal required; rerun setup after completing this step' >&2; exit 1; }
  read -r -p 'Press Enter when done (Ctrl-C to stop): ' _
}

verify_aerospace() {
  for _ in {1..10}; do
    pgrep -x AeroSpace >/dev/null && return 0
    sleep 1
  done
  echo 'AeroSpace did not start; check macOS permissions and rerun setup' >&2
  return 1
}

step_unless 'Install Homebrew packages' brew_bundle_installed bash "$repo_dir/macos-packages.sh" install
step 'Link configuration' bash "$repo_dir/symlink-macos.sh"
step 'Apply macOS preferences' bash "$repo_dir/macos-preferences.sh"
step 'Install pinned runtimes' make -C "$repo_dir" mise
step_unless 'Install Nerd Font' jetbrains_nerd_font_installed make -C "$repo_dir" font-jetbrains
step 'Install agent skills' make -C "$repo_dir" skills-install
step_unless 'Install GitHub extensions' gh_extensions_installed mise exec -- make -C "$repo_dir" gh-extensions
step 'Install agent session sounds' make -C "$repo_dir" aoe
step_unless 'Install Headroom' headroom_installed uv tool install --python 3.13 'headroom-ai[proxy,mcp,code]'
step_unless 'Configure Codex and Headroom' agent_optimized make -C "$repo_dir" agent-optimize
step_unless 'Start Sketchybar' sketchybar_running make -C "$repo_dir" sketchybar
step_unless 'Start window borders' borders_running brew services start borders
step_unless 'Start AeroSpace' aerospace_running open -a AeroSpace
step 'Verify AeroSpace' verify_aerospace
step_unless 'Install and start patched SketchyVim' svim_running make -C "$repo_dir" svim-activate
pause_for 'Grant Accessibility permission to ~/.local/opt/svim/bin/svim in System Settings.'
step 'Verify patched SketchyVim' bash "$repo_dir/svim/verify.sh" 60
pause_for 'Open Spotify, sign in, and leave it open for one minute.'
step 'Apply Spotify theme' make -C "$repo_dir" spicetify
if [[ $dry_run == true ]]; then
  printf '\nDry run complete; no changes made.\n'
else
  printf '\nmacOS setup complete. Grant any remaining app permissions requested on first launch.\n'
fi
