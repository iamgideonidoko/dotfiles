#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

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
