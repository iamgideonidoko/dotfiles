brew-install:
	brew bundle --file=~/dotfiles/brew/Brewfile

symlink:
	chmod +x ~/dotfiles/symlink.sh
	~/dotfiles/symlink.sh
