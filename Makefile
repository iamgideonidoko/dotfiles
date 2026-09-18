ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)
GH_EXTENSIONS := dlvhdr/gh-dash dlvhdr/gh-enhance
SKILL_AGENTS ?=

.PHONY: homebrew deps brew-install brew-clean symlink omarchy-setup omarchy-symlink omarchy-install omarchy-clean omarchy-audit hyprland-reload omarchy-reload shell font-jetbrains macos sketchybar gh-extensions mise mise-verify skills-export skills-install spicetify kb svim svim-activate svim-start svim-verify stylus aoe karabiner agent-config agent-optimize agent-verify

homebrew:
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

deps: homebrew
	brew trust felixkratz/formulae
	brew trust nikitabobko/tap
	brew trust --cask nikitabobko/tap/aerospace
	brew trust anomalyco/tap

brew-install: deps
	brew bundle --verbose --file=$(ROOT)brew/Brewfile

brew-clean: deps
	brew bundle cleanup --force --file=$(ROOT)brew/Brewfile

symlink:
	chmod +x ~/dotfiles/symlink.sh
	~/dotfiles/symlink.sh

omarchy-setup:
	chmod +x ./omarchy-setup.sh
	./omarchy-setup.sh setup

omarchy-symlink:
	chmod +x ./symlink-omarchy.sh
	./symlink-omarchy.sh

omarchy-install:
	chmod +x ./omarchy-packages.sh
	./omarchy-packages.sh install

omarchy-clean:
	chmod +x ./omarchy-packages.sh
	./omarchy-packages.sh clean

omarchy-audit:
	chmod +x ./omarchy-packages.sh
	./omarchy-packages.sh audit

hyprland-reload:
	hyprctl reload
	hyprctl configerrors

omarchy-reload: hyprland-reload
	omarchy restart shell

agent-config:
	./symlink.sh codex

agent-optimize: agent-config
	@command -v rtk >/dev/null || { echo 'rtk not found; install it first' >&2; exit 1; }
	@command -v headroom >/dev/null || { echo 'headroom not found; install it first' >&2; exit 1; }
	headroom install apply --scope user --providers manual --target codex
	rtk init --global --codex
	$(MAKE) agent-verify

agent-verify:
	@command -v rtk >/dev/null || { echo 'rtk not found' >&2; exit 1; }
	@command -v headroom >/dev/null || { echo 'headroom not found' >&2; exit 1; }
	@headroom_python="$$(head -n1 "$$(command -v headroom)" | sed 's/^#!//')"; "$$headroom_python" -c 'import fastapi' || { echo "Headroom proxy dependencies missing; run: uv tool install --python 3.13 --upgrade 'headroom-ai[proxy,mcp,code]'" >&2; exit 1; }
	@headroom install status | rg -q '^Status: +running$$' || { echo 'Headroom proxy is not running' >&2; exit 1; }
	@test -f "$$HOME/.codex/AGENTS.md"
	@test -r "$$HOME/.codex/RTK.md"
	@rg -q "^@$$HOME/\.codex/RTK\.md$$" "$$HOME/.codex/AGENTS.md"
	@rg -q "^@$$HOME/\.agents/skills/caveman/SKILL\.md$$" "$$HOME/.codex/AGENTS.md"
	@rg -q "^@$$HOME/\.agents/skills/ponytail/SKILL\.md$$" "$$HOME/.codex/AGENTS.md"
	rtk --version
	headroom --version
	@echo 'agent-verify: OK'

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

skills-export:
	bash skills/export.sh

skills-install:
	SKILL_AGENTS="$(SKILL_AGENTS)" bash skills/install.sh


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

karabiner:
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
