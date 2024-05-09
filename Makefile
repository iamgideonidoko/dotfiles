# Update sync Neovim configuration
sync-nvim-config:
	rsync -v --exclude='.git' ~/.config/nvim/ ./.config/nvim/
