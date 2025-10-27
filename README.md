# dotfiles

![Preview](./preview.png)

## Setup

Follow the below steps to set up in a few seconds.

### Install Packager Manager

I default to Homebrew as my package manager since it has most of the software I need, so start by installing it:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Clone dotfiles

Clone this dotfiles repo into the `~/dotfiles` directory:

```sh
git clone git@github.com:iamgideonidoko/dotfiles.git ~/dotfiles
```

### Install Software

Install all the software listed in the `Brewfile`:

```sh
make brew-install
```

### Create Symlink

Create a symlink to the necessary configuration files and directories:

```sh
make symlink
```

### Reload Zsh

```sh
source ~/.zshrc
```

### Install Nerd Font

Download and install Comic Code (or any other) nerd font:

```sh
unzip -o -j ~/Downloads/Comic_Code_Nerd_Fonts.zip -d ~/Library/Fonts/
```

### Configurations for SketchyVim

1. You can change the macOS selection color using:

   ```sh
   defaults write NSGlobalDomain AppleHighlightColor -string "0.615686 0.823529 0.454902"
   ```

2. Start the brew service

   ```sh
   brew services restart svim
   ```

### Configurations for Sketchybar

1. Make plugins executable

   ```sh
   find ~/dotfiles/sketchybar -type f -name "*.sh" -exec chmod +x {} \;
   chmod +x ~/dotfiles/sketchybar/**/*.sh
   ```

2. Install Sketchybar-app-font

   ```sh
   curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.23/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
   ```

3. Start the brew service

   ```sh
   brew services restart sketchybar
   ```

### Configurations for a better Aerospace experience

1. Arrange your monitors properly if applicable: [see here](https://nikitabobko.github.io/AeroSpace/guide#proper-monitor-arrangement)

2. Group windows by application (Show window bigger in mission control)

   ```bash
   defaults write com.apple.dock expose-group-apps -bool true && killall Dock

   ```

3. Move windows by dragging any part of the window

   ```bash
   defaults write -g NSWindowShouldDragOnGesture -bool true
   ```

4. Disable windows opening animations

   ```bash
   defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
   ```

5. Prevent displays from having separate spaces && restart

   ```bash
    defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
   ```

### Provide Permissions

Open the software the require additional permissions and grant them. Also add the software like Scoot that should be login items.

<br />

Done! 😎
