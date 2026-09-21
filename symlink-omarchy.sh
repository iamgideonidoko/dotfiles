#!/usr/bin/env bash
set -euo pipefail

[[ $(uname) == Linux ]] && command -v omarchy >/dev/null || { echo 'symlink-omarchy.sh requires Omarchy' >&2; exit 1; }

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local source="$1" target="$2" backup
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf 'Backed up %s\n' "$target"
  fi
  ln -s "$source" "$target"
  printf 'Linked %s\n' "$target"
}

link "$repo_dir/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
link "$repo_dir/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
link "$repo_dir/hypr/looknfeel.lua" "$HOME/.config/hypr/looknfeel.lua"
link "$repo_dir/hypr/input.lua" "$HOME/.config/hypr/input.lua"
link "$repo_dir/hypr/monitors.lua" "$HOME/.config/hypr/monitors.lua"
link "$repo_dir/hypr/autostart.lua" "$HOME/.config/hypr/autostart.lua"
link "$repo_dir/hypr/hyprsunset.conf" "$HOME/.config/hypr/hyprsunset.conf"
link "$repo_dir/hypr/xdph.conf" "$HOME/.config/hypr/xdph.conf"
link "$repo_dir/hypr/.luarc.json" "$HOME/.config/hypr/.luarc.json"
link "$repo_dir/omarchy/shell.json" "$HOME/.config/omarchy/shell.json"
link "$repo_dir/omarchy/plugins/iamgideonidoko.active-window" "$HOME/.config/omarchy/plugins/iamgideonidoko.active-window"
link "$repo_dir/omarchy/defaults/agent" "$HOME/.config/omarchy/defaults/agent"
link "$repo_dir/omarchy/extensions/omarchy-menu.jsonc" "$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"
link "$repo_dir/omarchy/themes/rose-pine" "$HOME/.config/omarchy/themes/rose-pine"
link "$repo_dir/omarchy/xdg-terminals.list" "$HOME/.config/xdg-terminals.list"
link "$repo_dir/kanata/kanata.kbd" "$HOME/.config/kanata/kanata.kbd"
link "$repo_dir/kanata/kanata.service" "$HOME/.config/systemd/user/kanata.service"
link "$repo_dir/ghostty/config.linux" "$HOME/.config/ghostty/config"
link "$repo_dir/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
link "$repo_dir/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
link "$repo_dir/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
link "$repo_dir/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
link "$repo_dir/btop/btop.conf" "$HOME/.config/btop/btop.conf"
link "$repo_dir/btop/themes/rose-pine.theme" "$HOME/.config/btop/themes/rose-pine.theme"
link "$repo_dir/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
link "$repo_dir/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "$repo_dir/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
link "$repo_dir/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
link "$repo_dir/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
link "$repo_dir/eza/theme.yml" "$HOME/.config/eza/theme.yml"
link "$repo_dir/starship/starship.toml" "$HOME/.config/starship.toml"
link "$repo_dir/git/ignore" "$HOME/.config/git/ignore"
link "$repo_dir/mise/config.toml" "$HOME/.config/mise/config.toml"
link "$repo_dir/tmux/main.conf" "$HOME/.config/tmux/tmux.conf"
link "$repo_dir/nvim" "$HOME/.config/nvim"
link "$repo_dir/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
link "$repo_dir/ghui/config.json" "$HOME/.config/ghui/config.json"
link "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"
