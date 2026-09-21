# dotfiles

![Preview](./preview.jpg)

## Setup

Clone the repository, then run the macOS or Omarchy setup.

### Clone dotfiles

Clone this repository into `~/dotfiles`, then run these commands from that directory.

```sh
git clone git@github.com:iamgideonidoko/dotfiles.git ~/dotfiles
```

### Full macOS setup

On a new Mac, run this from the cloned repository in an interactive terminal:

```sh
make macos-setup
```

The script installs Brewfile packages, links configuration, applies macOS
preferences, installs pinned runtimes and agent tools, and starts Sketchybar,
borders, AeroSpace, Headroom, and patched SketchyVim. It pauses for Spotify
sign-in and SketchyVim Accessibility permission. Fix any failed step and rerun;
installed steps are safe to repeat. It never removes extra Homebrew packages.
Preview the steps with `bash macos-setup.sh --dry-run`.

Individual commands remain available: `make brew-install`, `make symlink`,
`make macos`, `make mise`, and `make brew-audit`. Run `make brew-clean` only when
you intend to review and remove packages outside the Brewfile.

### Configure Omarchy

On Omarchy, deploy Linux-owned config and install declared packages:

```sh
make omarchy-symlink
make omarchy-install
omarchy theme set rose-pine
```

For a full Linux setup, including Ghostty, Zsh, owned config, defaults, and
manifest cleanup:

```sh
make omarchy-setup
```

Add wanted launcher entries to `omarchy/webapps.jsonc` and
`omarchy/tuis.jsonc`. Add only explicitly unwanted launcher names to their
matching `*.drop` files.

`make omarchy-clean` removes only packages named in
[`omarchy/packages.drop`](./omarchy/packages.drop), removes stale non-Codex
agent usage records, then opens Omarchy's orphan-package review.

### Individual setup commands

The commands below are useful when setting up or repairing one component.

### Install Runtime Versions

Install pinned Node, Python, Go, and Rust versions through Mise.

```sh
make mise
```

### Install Agent Skills

```sh
make skills-install
```

Skills install for Codex by default. Edit [`skills/manifest.json`](./skills/manifest.json)
to change agents; run `make skills-export` after changing installed skills.

### Install GitHub Extensions

```sh
make gh-extensions
```

### Open Zsh

```sh
make shell
```

### Install Nerd Font

Download and install JetBrainsMono Nerd Font:

```sh
make font-jetbrains
```

### Configure macOS

Apply the macOS preferences used by this setup. This enables shared Spaces across
displays, so change `spans-displays` to `false` in [`macos.sh`](./macos.sh) if
you use multiple monitors with separate Spaces.

```sh
make macos
```

For monitor placement, follow the [AeroSpace monitor arrangement guide](https://nikitabobko.github.io/AeroSpace/guide#proper-monitor-arrangement).

### Configurations for SketchyVim

1. Build and start patched service. Do not manage `svim` through Homebrew's
   service; its v1.0.11 binary leaks exited `svim.sh` children on macOS.

   ```sh
   make svim-activate
   ```

2. Verify after normal typing for one minute:

   ```sh
   make svim-verify
   ```

### Configurations for Sketchybar

```sh
make sketchybar
```

### Configure Spotify Theme

Open Spotify, sign in, and leave it open for one minute. Then run:

```sh
make spicetify
```

### Provide Permissions

Open the software the require additional permissions and grant them. Also add the software like Scoot that should be login items.

<br />

Done! 😎
