-- Leader keys (MUST be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat = false -- Toggle with <leader>Ta
vim.g.have_nerd_font = true

-- Load configuration files in an optimized order
require("options") -- fastest, no dependencies
require("lazy-bootstrap") -- Plugin manager bootstrap
require("lazy-plugins")
require("keymaps") -- after plugins for lazy-loaded keybinds
require("autocmds") -- after plugins for features
require("terminal")

-- Startup profiling
-- vim.defer_fn(function()
--   require('performance').show_memory()
--   require('performance').check_slow_plugins()
-- end, 100)

-- Modeline
-- vim: ts=2 sts=2 sw=2 et
