#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO_DIR="$repo_dir"
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

[[ $(uname) == Darwin ]] || { echo 'macos-packages.sh requires macOS' >&2; exit 1; }

bootstrap() {
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  command -v brew >/dev/null || { echo 'Homebrew unavailable after install' >&2; exit 1; }
}

trust() {
  brew trust felixkratz/formulae
  brew trust nikitabobko/tap
  brew trust --cask nikitabobko/tap/aerospace
  brew trust anomalyco/tap
}

install_executors() {
  local name verify_command install_command
  while IFS=$'\t' read -r name verify_command install_command; do
    [[ -z $name || $name == \#* ]] && continue
    [[ -n $verify_command && -n $install_command ]] || { echo "Invalid executor entry: $name" >&2; return 1; }
    if bash -o pipefail -c "$verify_command" >/dev/null 2>&1; then
      printf 'Skipping %s (already installed)\n' "$name"
      continue
    fi
    printf 'Installing %s\n' "$name"
    bash -o pipefail -c "$install_command"
    bash -o pipefail -c "$verify_command" >/dev/null 2>&1 || { echo "$name installation did not pass verification" >&2; return 1; }
  done < "$repo_dir/macos/executors.tsv"
}

case "${1:-}" in
  bootstrap)
    bootstrap
    ;;
  trust)
    bootstrap
    trust
    ;;
  install)
    bootstrap
    trust
    brew bundle --no-upgrade --verbose --file="$repo_dir/brew/Brewfile"
    mise install
    install_executors
    ;;
  clean)
    bootstrap
    brew bundle cleanup --file="$repo_dir/brew/Brewfile"
    ;;
  audit)
    bootstrap
    brew bundle check --file="$repo_dir/brew/Brewfile"
    ;;
  *)
    echo "Usage: $0 {bootstrap|trust|install|clean|audit}" >&2
    exit 64
    ;;
esac
