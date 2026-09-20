# General/agnostic

.PHONY: format lint

format:
	stylua lua/ --config-path=.stylua.toml

lint:
	luacheck lua/ --globals vim
