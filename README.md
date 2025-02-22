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

### Install Nerd Font

Download and install Comic Code (or any other) nerd font:

```
unzip -o -j ~/Downloads/Comic_Code_Nerd_Fonts.zip -d ~/Library/Fonts/
```

### Provide Permissions

Open the software the require additional permissions and grant them.

<br />

Done 😎
