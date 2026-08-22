# dotfiles

![Preview](./preview.jpg)

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

Download and install JetBrainsMono Nerd Font:

```sh
curl -L -o JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" && unzip JetBrainsMono.zip -d ~/Library/Fonts/
```

### Configure macOS

Apply the macOS preferences used by this setup. This enables shared Spaces across
displays, so change `spans-displays` to `false` in [`macos.sh`](./macos.sh) if
you use multiple monitors with separate Spaces.

```sh
./macos.sh
```

For monitor placement, follow the [AeroSpace monitor arrangement guide](https://nikitabobko.github.io/AeroSpace/guide#proper-monitor-arrangement).

### Configurations for SketchyVim

1. Build and start patched service. Do not use `brew services restart svim`;
   Homebrew's v1.0.11 binary leaks exited `svim.sh` children on macOS.

   ```sh
   ~/dotfiles/svim/activate.sh
   ```

2. Verify after normal typing for one minute:

   ```sh
   ~/dotfiles/svim/verify.sh
   ```

### Configurations for Sketchybar

1. Make plugins executable

   ```sh
   find ~/dotfiles/sketchybar -type f -name "*.sh" -exec chmod +x {} \;
   ```

2. Install Sketchybar-app-font

   ```sh
   curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
   ```

3. Start the brew service

   ```sh
   brew services restart sketchybar
   ```

### Provide Permissions

Open the software the require additional permissions and grant them. Also add the software like Scoot that should be login items.

<br />

Done! 😎
