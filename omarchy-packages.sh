#!/usr/bin/env bash
set -euo pipefail

[[ $(uname) == Linux ]] && command -v omarchy >/dev/null || { echo 'omarchy-packages.sh requires Omarchy' >&2; exit 1; }

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

packages() {
  sed 's/[[:space:]]*#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' "$repo_dir/omarchy/$1"
}

install_tools() {
  local name executable install_command
  while IFS=$'\t' read -r name executable install_command; do
    [[ -z $name || $name == \#* ]] && continue
    [[ -n $executable && -n $install_command ]] || { echo "Invalid tool entry: $name" >&2; return 1; }
    if command -v "$executable" >/dev/null 2>&1; then
      printf 'Skipping %s (already installed)\n' "$name"
      continue
    fi
    printf 'Installing %s\n' "$name"
    bash -o pipefail -c "$install_command"
    command -v "$executable" >/dev/null 2>&1 || { echo "$name installed but $executable is not on PATH" >&2; return 1; }
  done < "$repo_dir/omarchy/tools.tsv"
}

case "${1:-}" in
  install)
    mapfile -t pacman_packages < <(packages packages.pacman)
    mapfile -t aur_packages < <(packages packages.aur)
    ((${#pacman_packages[@]})) && omarchy pkg add "${pacman_packages[@]}"
    ((${#aur_packages[@]})) && omarchy pkg aur add "${aur_packages[@]}"
    if command -v lt >/dev/null 2>&1; then
      echo 'Skipping localtunnel (already installed)'
    else
      mise install npm:localtunnel
    fi
    install_tools
    ;;
  clean)
    mapfile -t drop_packages < <(packages packages.drop)
    ((${#drop_packages[@]})) && omarchy pkg drop "${drop_packages[@]}"
    for package in "${drop_packages[@]}"; do
      rm -f "$HOME/.local/share/applications/$package.desktop"
    done
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
