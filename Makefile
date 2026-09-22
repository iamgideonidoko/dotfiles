ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
.DEFAULT_GOAL := noop
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)
GH_EXTENSIONS := dlvhdr/gh-dash dlvhdr/gh-enhance
SKILL_AGENTS ?=
VIMIUM_OPTION_PATH ?= ~/Downloads/vimium-options.json

# ╭────────────────────╮
# │ GENERAL / AGNOSTIC │
# ╰────────────────────╯

.PHONY: noop gh-extensions skills-export skills-install aoe spicetify vimium-options stylus kanata mise agent-config agent-optimize agent-verify

noop:
	@:

gh-extensions:
	@for extension in $(GH_EXTENSIONS); do gh extension install "$$extension" --force; done

skills-export:
	bash skills/export.sh

skills-install:
	SKILL_AGENTS="$(SKILL_AGENTS)" bash skills/install.sh

aoe:
	aoe sounds install

spicetify:
	# Sign in to Spotify first. First run backs up Spotify; later runs apply the theme.
	spicetify config current_theme RosePine color_scheme Main inject_css 1 replace_colors 1
	@if grep -q '^\[Backup\]$$' "$$(spicetify -c)"; then \
		spicetify apply; \
	else \
		spicetify backup apply; \
	fi

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

kanata:
	npm --prefix kanata run build

mise:
	@command -v mise >/dev/null || { echo 'mise not found; install platform packages first' >&2; exit 1; }
	@test -f "$$HOME/.config/mise/config.toml" || { printf 'Run make symlink-macos or make omarchy-symlink before make mise\n' >&2; exit 1; }
	mise install

agent-config:
	bash $(ROOT)codex/render-agents.sh

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

# ╭────────────────╮
# │ MACOS SPECIFIC │
# ╰────────────────╯

.PHONY: macos-only macos-install macos-clean macos-audit macos-setup symlink-macos font-jetbrains macos-preferences sketchybar karabiner svim svim-activate svim-start svim-verify

macos-only:
	@test "$$(uname)" = Darwin || { echo 'This target requires macOS' >&2; exit 1; }

symlink-macos macos-install macos-clean macos-audit macos-setup font-jetbrains macos-preferences sketchybar karabiner svim svim-activate svim-start svim-verify: macos-only

symlink-macos:
	bash $(ROOT)symlink-macos.sh

macos-install:
	bash $(ROOT)macos-packages.sh install

macos-clean:
	# Review carefully: removes Homebrew packages outside brew/Brewfile.
	bash $(ROOT)macos-packages.sh clean

macos-audit:
	bash $(ROOT)macos-packages.sh audit

macos-setup:
	bash $(ROOT)macos-setup.sh

font-jetbrains:
	@font_archive=$$(mktemp); trap 'rm -f "$$font_archive"' EXIT; curl -fL -o "$$font_archive" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip; unzip -o "$$font_archive" -d "$$HOME/Library/Fonts/"

macos-preferences:
	./macos-preferences.sh

sketchybar:
	find $(ROOT)sketchybar -type f -name '*.sh' -exec chmod +x {} +
	curl -fL -o "$$HOME/Library/Fonts/sketchybar-app-font.ttf" https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf
	brew services restart sketchybar

karabiner:
	yarn --cwd karabiner build

svim:
	# Patched service prevents SketchyVim child-process leaks; grant Accessibility before starting it.
	./svim/install.sh
	@printf 'Grant Accessibility to ~/.local/opt/svim/bin/svim, then run: make svim-start\n'

svim-activate:
	./svim/activate.sh

svim-start:
	./svim/activate.sh --skip-build

svim-verify:
	./svim/verify.sh 300

# ╭──────────────────╮
# │ OMARCHY SPECIFIC │
# ╰──────────────────╯

.PHONY: omarchy-only omarchy-symlink omarchy-install omarchy-clean omarchy-audit omarchy-setup hyprland-reload omarchy-reload kanata-setup kanata-restart

omarchy-only:
	@test "$$(uname)" = Linux && command -v omarchy >/dev/null || { echo 'This target requires Omarchy' >&2; exit 1; }

omarchy-symlink omarchy-install omarchy-clean omarchy-audit omarchy-setup hyprland-reload omarchy-reload kanata-setup kanata-restart: omarchy-only

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

omarchy-setup:
	chmod +x ./omarchy-setup.sh
	./omarchy-setup.sh setup

hyprland-reload:
	hyprctl reload
	hyprctl configerrors

omarchy-reload: omarchy-symlink hyprland-reload
	omarchy-shell shell rescanPlugins
	omarchy restart shell

kanata-setup:
	$(MAKE) kanata
	$(MAKE) omarchy-install
	$(MAKE) omarchy-symlink
	./kanata/setup.sh

kanata-restart: kanata
	kanata_cmd_allowed --check --cfg "$$HOME/.config/kanata/kanata.kbd"
	systemctl --user daemon-reload
	systemctl --user restart kanata.service
	systemctl --user --no-pager --full status kanata.service
