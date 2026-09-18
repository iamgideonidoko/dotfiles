#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

records() {
  sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' "$repo_dir/omarchy/$1"
}

install_webapps() {
  while IFS=$'\t' read -r name url icon custom_exec mime_types; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy webapp install "$name" "$url" "$icon" "${custom_exec:-}" "${mime_types:-}"
  done <"$repo_dir/omarchy/webapps.install.tsv"
}

install_tuis() {
  while IFS=$'\t' read -r name command style icon; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy tui install "$name" "$command" "$style" "$icon"
  done <"$repo_dir/omarchy/tuis.install.tsv"
}

remove_launchers() {
  while IFS= read -r name; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy webapp remove "$name" || true
  done <"$repo_dir/omarchy/webapps.remove.txt"
  while IFS= read -r name; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy tui remove "$name" || true
  done <"$repo_dir/omarchy/tuis.remove.txt"
}

case "${1:-setup}" in
  setup)
    bash "$repo_dir/omarchy-packages.sh" install
    bash "$repo_dir/symlink-omarchy.sh"
    omarchy theme set rose-pine
    omarchy default terminal ghostty
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != /usr/bin/zsh ]]; then
      chsh -s /usr/bin/zsh "$USER"
    fi
    install_webapps
    install_tuis
    remove_launchers
    bash "$repo_dir/omarchy-packages.sh" clean
    ;;
  launchers-install)
    install_webapps
    install_tuis
    ;;
  launchers-clean)
    remove_launchers
    ;;
  *)
    echo "Usage: $0 {setup|launchers-install|launchers-clean}" >&2
    exit 64
    ;;
esac
