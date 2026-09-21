#!/usr/bin/env bash
set -euo pipefail

[[ $(uname) == Linux ]] && command -v omarchy >/dev/null || { echo 'omarchy-packages.sh requires Omarchy' >&2; exit 1; }

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO_DIR="$repo_dir"
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

packages() {
  sed 's/[[:space:]]*#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' "$repo_dir/omarchy/$1"
}

install_packages() {
  local source=$1 package
  local -a missing=()
  while IFS= read -r package; do
    if pacman -Q "$package" >/dev/null 2>&1; then
      printf 'Skipping %s (already installed)\n' "$package"
    else
      missing+=("$package")
    fi
  done < <(packages "packages.$source")
  ((${#missing[@]})) || return 0
  if [[ $source == aur ]]; then
    omarchy pkg aur add "${missing[@]}"
  else
    omarchy pkg add "${missing[@]}"
  fi
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
  done < "$repo_dir/omarchy/executors.tsv"
}

case "${1:-}" in
  install)
    install_packages pacman
    install_packages aur
    mise install
    install_executors
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
