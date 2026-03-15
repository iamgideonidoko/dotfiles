brew-install:
	brew bundle --file=~/dotfiles/brew/Brewfile

symlink:
	chmod +x ~/dotfiles/symlink.sh
	~/dotfiles/symlink.sh

path ?= ~/Downloads/vimium-options.json
vimium-options:
	@test -f $(path) && mv -f $(path) ./vimium/ || echo "File not found: $(path)"
