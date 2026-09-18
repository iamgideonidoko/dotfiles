#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

packages() {
  sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' "$repo_dir/omarchy/$1"
}

case "${1:-}" in
  install)
    mapfile -t pacman_packages < <(packages packages.pacman)
    mapfile -t aur_packages < <(packages packages.aur)
    ((${#pacman_packages[@]})) && omarchy pkg add "${pacman_packages[@]}"
    ((${#aur_packages[@]})) && omarchy pkg aur add "${aur_packages[@]}"
    ;;
  clean)
    mapfile -t drop_packages < <(packages packages.drop)
    ((${#drop_packages[@]})) && omarchy pkg drop "${drop_packages[@]}"
    omarchy agent usage update codex --force || true
    rm -f "$HOME/.local/state/omarchy/agents/usage/claude.json" "$HOME/.local/state/omarchy/agents/usage/fireworks.json"
    omarchy update orphan pkgs
    ;;
  audit)
    while IFS= read -r package; do
      pacman -Qi "$package" 2>/dev/null | awk -F': ' '/^(Name|Installed Size|Install Reason|Required By)[[:space:]]*:/ { print }'
      printf '\n'
    done < <(pacman -Qqe | sort)
    ;;
  *)
    echo "Usage: $0 {install|clean|audit}" >&2
    exit 64
    ;;
esac
