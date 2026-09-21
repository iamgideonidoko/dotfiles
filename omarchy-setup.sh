#!/usr/bin/env bash
set -euo pipefail

[[ $(uname) == Linux ]] && command -v omarchy >/dev/null || { echo 'omarchy-setup.sh requires Omarchy' >&2; exit 1; }

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_webapps() {
  while IFS= read -r app; do
    name=$(jq -r '.name' <<<"$app")
    url=$(jq -r '.url' <<<"$app")
    icon=$(jq -r '.icon' <<<"$app")
    custom_exec=$(jq -r '.custom_exec // empty' <<<"$app")
    mime_types=$(jq -r '.mime_types // empty' <<<"$app")
    omarchy webapp install "$name" "$url" "$icon" "${custom_exec:-}" "${mime_types:-}"
  done < <(sed '/^[[:space:]]*\/\//d' "$repo_dir/omarchy/webapps.jsonc" | jq -c '.[]')
}

install_tuis() {
  while IFS= read -r app; do
    name=$(jq -r '.name' <<<"$app")
    command=$(jq -r '.command' <<<"$app")
    style=$(jq -r '.style' <<<"$app")
    icon=$(jq -r '.icon' <<<"$app")
    omarchy tui install "$name" "$command" "$style" "$icon"
  done < <(sed '/^[[:space:]]*\/\//d' "$repo_dir/omarchy/tuis.jsonc" | jq -c '.[]')
}

remove_launchers() {
  while IFS= read -r name; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy webapp remove "$name" || true
  done <"$repo_dir/omarchy/webapps.drop"
  while IFS= read -r name; do
    [[ -z $name || $name == \#* ]] && continue
    omarchy tui remove "$name" || true
  done <"$repo_dir/omarchy/tuis.drop"
}

set_dark_theme() {
  local theme=rose-pine
  local colors="$repo_dir/omarchy/themes/$theme/colors.toml"

  grep -qx 'mode = "dark"' "$colors"
  omarchy theme set "$theme"
  grep -qx 'mode = "dark"' "$HOME/.local/state/omarchy/current/theme/colors.toml"
  omarchy theme bg set "$repo_dir/wallpapers/min-omarchy.jpg"
}

case "${1:-setup}" in
  setup)
    bash "$repo_dir/omarchy-packages.sh" install
    bash "$repo_dir/symlink-omarchy.sh"
    bash "$repo_dir/kanata/setup.sh"
    set_dark_theme
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
