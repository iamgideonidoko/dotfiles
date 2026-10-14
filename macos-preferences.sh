#!/usr/bin/env bash
# macOS preferences used by this dotfiles setup.
set -euo pipefail

if [[ $(uname) != Darwin ]]; then
  printf 'macos-preferences.sh must run on macOS\n' >&2
  exit 1
fi

# Verify admin access before changing any preferences.
sudo -v

# Appearance and window management.
defaults write NSGlobalDomain AppleHighlightColor -string '0.615686 0.823529 0.454902'
defaults write com.apple.dock expose-group-apps -bool true
defaults write -g NSWindowShouldDragOnGesture -bool true
# OmniWM activation owns motion and Spaces preferences and backs them up for rollback.
defaults write com.apple.dock autohide-delay -float 0

# Keyboard: match Omarchy's 40 repeats/s and 250 ms delay (macOS uses 15 ms units).
defaults write -g KeyRepeat -float 1.666667
defaults write -g InitialKeyRepeat -float 16.666667
defaults write -g ApplePressAndHoldEnabled -bool false

# Accessibility preference is stored in the system domain and needs admin access.
# Reduce Motion is managed by macos/window-manager.py so OmniWM animations stay enabled.

# Reload only processes affected by these preferences.
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall cfprefsd 2>/dev/null || true
