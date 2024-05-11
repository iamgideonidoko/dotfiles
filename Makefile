# Update sync Neovim configuration
define COMMENT
Mostly commands to sync the various configs I publicly have
endef

sync-nvim:
	rsync -av --delete --exclude='.git' ~/.config/nvim/ ./.config/nvim/

sync-nvim-chad:
	rsync -av --delete --exclude='.git' --exclude='.gitignore' --exclude='.github' --exclude='.ignore' --exclude='LICENSE'  ~/.config/nvim-chad/ ./.config/nvim-chad/

sync-tmux:
	rsync -av --delete --exclude='plugins'  ~/.config/tmux/ ./.config/tmux/
