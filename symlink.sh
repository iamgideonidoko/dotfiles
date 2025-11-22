#!/usr/bin/env bash
##############################################################################
# ASCII color codes
boldGreen="\033[1;32m"
boldYellow="\033[1;33m"
# boldRed="\033[1;31m"
boldPurple="\033[1;35m"
# boldBlue="\033[1;34m"
noColor="\033[0m"
##############################################################################
mkdir -p ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/starship
mkdir -p ~/.config/karabiner
mkdir -p ~/.config/svim
mkdir -p ~/.hammerspoon
mkdir -p ~/.config/yazi
mkdir -p ~/.config/eza
mkdir -p ~/.config/btop
mkdir -p ~/.config/fastfetch
mkdir -p ~/.config/aerospace
mkdir -p ~/.config/sketchybar
mkdir -p ~/.config/borders
mkdir -p ~/.vim/{undodir,plugged,autoload}
##############################################################################
# Helper function for creating symlinks
create_symlink() {
  local source_path=$1
  local target_path=$2
  local backup_needed=true
  # Check if the target is a file and contains the unique identifier
  if [ -f "$target_path" ] && grep -q "DO_NOT_BACK_UP_FIlE" "$target_path"; then
    backup_needed=false
  fi
  # Check if the target is a directory and contains the `DO_NOT_BACK_UP_DIR` file with the unique identifier
  if [ -d "$target_path" ] && [ -f "$target_path/DO_NOT_BACK_UP_DIR" ]; then
    backup_needed=false
  fi
  # Check if symlink already exists and points to the correct source
  if [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path")" = "$source_path" ]; then
      # echo "$target_path exists and is correct, no action needed"
      return 0
    else
      echo -e "${boldYellow}'$target_path' is a symlink"
      echo -e "but it points to a different source, updating it${noColor}"
    fi
  fi
  # Backup the target if it's not a symlink and backup is needed
  if [ -e "$target_path" ] && [ ! -L "$target_path" ] && [ "$backup_needed" = true ]; then
    local backup_path
    backup_path="${target_path}_backup_$(date +%Y%m%d%H%M%S)"
    echo -e "${boldYellow}Backing up your existing file '$target_path' to '$backup_path'${noColor}"
    mv "$target_path" "$backup_path"
  fi
  # Create the symlink
  ln -snf "$source_path" "$target_path"
  echo -e "${boldPurple}Created or updated symlink"
  echo -e "${boldGreen}FROM: '$source_path'"
  echo -e "  TO: '$target_path'${noColor}"
}
##############################################################################
# Creating symlinks for files
create_symlink ~/dotfiles/zsh/.zshrc ~/.zshrc
create_symlink ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
create_symlink ~/dotfiles/vim/.vimrc ~/.vimrc
create_symlink ~/dotfiles/vim/coc-settings.json ~/.vim/coc-settings.json
##############################################################################
# Creating symlinks for directories
create_symlink ~/dotfiles/nvim/ ~/.config/nvim
create_symlink ~/dotfiles/ghostty/ ~/.config/ghostty
create_symlink ~/dotfiles/starship/ ~/.config/starship
create_symlink ~/dotfiles/karabiner/ ~/.config/karabiner
create_symlink ~/dotfiles/svim/ ~/.config/svim
create_symlink ~/dotfiles/hammerspoon/ ~/.hammerspoon
create_symlink ~/dotfiles/yazi/ ~/.config/yazi
create_symlink ~/dotfiles/eza/ ~/.config/eza
create_symlink ~/dotfiles/btop/ ~/.config/btop
create_symlink ~/dotfiles/fastfetch/ ~/.config/fastfetch
create_symlink ~/dotfiles/aerospace/ ~/.config/aerospace
create_symlink ~/dotfiles/sketchybar/ ~/.config/sketchybar
create_symlink ~/dotfiles/borders/ ~/.config/borders
##############################################################################
