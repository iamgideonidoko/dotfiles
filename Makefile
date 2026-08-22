ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)

.PHONY: homebrew deps brew-install brew-clean symlink shell font-jetbrains macos sketchybar mise mise-verify kb svim svim-activate svim-start svim-verify

homebrew:
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

deps: homebrew
	brew trust felixkratz/formulae
	brew trust nikitabobko/tap
	brew trust anomalyco/tap

brew-install: deps
	brew bundle --file=$(ROOT)brew/Brewfile

brew-clean: deps
	brew bundle cleanup --force --file=$(ROOT)brew/Brewfile

symlink:
	chmod +x ~/dotfiles/symlink.sh
	~/dotfiles/symlink.sh

shell:
	exec /bin/zsh -l

font-jetbrains:
	@font_archive=$$(mktemp); trap 'rm -f "$$font_archive"' EXIT; curl -fL -o "$$font_archive" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip; unzip -o "$$font_archive" -d "$$HOME/Library/Fonts/"

macos:
	./macos.sh

sketchybar:
	find $(ROOT)sketchybar -type f -name '*.sh' -exec chmod +x {} +
	curl -fL -o "$$HOME/Library/Fonts/sketchybar-app-font.ttf" https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf
	brew services restart sketchybar

mise:
	@test -f "$$HOME/.config/mise/config.toml" || { printf 'Run make symlink before make mise\n' >&2; exit 1; }
	brew install mise
	mise install
	$(MAKE) mise-verify

mise-verify:
	mise exec node -- node --version
	mise exec python -- python --version
	mise exec go -- go version
	mise exec rust -- rustc --version

path ?= ~/Downloads/vimium-options.json
vimium-options:
	@test -f $(path) && mv -f $(path) ./vimium/ || echo "File not found: $(path)"


kb:
	yarn --cwd karabiner build

svim:
	./svim/install.sh
	@printf 'Grant Accessibility to ~/.local/opt/svim/bin/svim, then run: make svim-start\n'

svim-activate:
	./svim/activate.sh

svim-start:
	./svim/activate.sh --skip-build

svim-verify:
	./svim/verify.sh 300
