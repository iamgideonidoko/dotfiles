deps:
	brew trust felixkratz/formulae
	brew trust nikitabobko/tap
	brew trust anomalyco/tap

brew-install: deps
	brew bundle --file=~/dotfiles/brew/Brewfile

brew-clean: deps
	brew bundle cleanup --force --file=~/dotfiles/brew/Brewfile

symlink:
	chmod +x ~/dotfiles/symlink.sh
	~/dotfiles/symlink.sh

path ?= ~/Downloads/vimium-options.json
vimium-options:
	@test -f $(path) && mv -f $(path) ./vimium/ || echo "File not found: $(path)"


kb:
	yarn --cwd karabiner build

.PHONY: svim svim-start svim-verify

svim:
	./svim/install.sh
	@printf 'Grant Accessibility to ~/.local/opt/svim/bin/svim, then run: make svim-start\n'

svim-start:
	./svim/activate.sh --skip-build

svim-verify:
	./svim/verify.sh 300
