define COMMENT
Mostly commands to sync the various configs I have
endef

sync-nvim:
	rsync -av --delete --exclude='.git' ~/.config/nvim/ ./.config/nvim/

sync-tmux:
	rsync -av --delete --exclude='plugins'  ~/.config/tmux/ ./.config/tmux/

sync-svim:
	rsync -av --delete --exclude='.git' ~/.config/svim/ ./.config/svim/
