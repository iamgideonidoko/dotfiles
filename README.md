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

```
unzip -o -j ~/Downloads/Comic_Code_Nerd_Fonts.zip -d ~/Library/Fonts/
```

### Configurations for a better Aerospace experience

1. Arrange your monitors properly if applicable: [see here](https://nikitabobko.github.io/AeroSpace/guide#proper-monitor-arrangement)

2. Group windows by application (Show window bigger in mission control)

   ```sh
   defaults write com.apple.dock expose-group-apps -bool true && killall Dock

   ```

3. Move windows by dragging any part of the window

   ```sh
   defaults write -g NSWindowShouldDragOnGesture -bool true
   ```

4. Prevent displays from having separate spaces

   ```sh
    defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
   ```

### Provide Permissions

Open the software the require additional permissions and grant them. Also add the software like Scoot that should be login items.

<br />

Done! 😎
