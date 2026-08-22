#!/usr/bin/env bash
# macOS preferences used by this dotfiles setup.
set -euo pipefail

if [[ $(uname) != Darwin ]]; then
  printf 'macos.sh must run on macOS\n' >&2
  exit 1
fi

# Verify admin access before changing any preferences.
sudo -v

# Appearance and window management.
defaults write NSGlobalDomain AppleHighlightColor -string '0.615686 0.823529 0.454902'
defaults write com.apple.dock expose-group-apps -bool true
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.spaces spans-displays -bool true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock appswitcher-animation-off -bool true

# Keyboard: fast repeat, short delay, and no press-and-hold accent picker.
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
defaults write -g ApplePressAndHoldEnabled -bool false

# Accessibility preference is stored in the system domain and needs admin access.
sudo defaults write com.apple.universalaccess reduceMotion -bool true

# Reload only processes affected by these preferences.
killall Dock
killall SystemUIServer
killall cfprefsd
