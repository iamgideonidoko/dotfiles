ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)
GH_EXTENSIONS := dlvhdr/gh-dash dlvhdr/gh-enhance

.PHONY: homebrew deps brew-install brew-clean symlink shell font-jetbrains macos sketchybar gh-extensions mise mise-verify spicetify kb svim svim-activate svim-start svim-verify stylus aoe

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

gh-extensions:
	@for extension in $(GH_EXTENSIONS); do gh extension install "$$extension" --force; done

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


aoe:
	aoe sounds install

spicetify:
	spicetify config current_theme RosePine color_scheme Main inject_css 1 replace_colors 1
	spicetify backup apply

VIMIUM_OPTION_PATH ?= ~/Downloads/vimium-options.json
vimium-options:
	@test -f $(path) && mv -f $(VIMIUM_OPTION_PATH) ./vimium/ || echo "File not found: $(path)"

stylus:
	@set -- "$(HOME)"/Downloads/stylus*.json; \
	if [ ! -f "$$1" ]; then \
		echo "No Stylus backup found"; \
		exit 1; \
	fi; \
	latest="$$(ls -t "$$@" | head -n 1)"; \
	mkdir -p "$(ROOT)stylus"; \
	mv -f "$$latest" "$(ROOT)stylus/stylus.json" || exit 1; \
	for backup in "$$@"; do [ "$$backup" = "$$latest" ] || rm -f "$$backup"; done; \
	echo "Updated $(ROOT)stylus/stylus.json"

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
