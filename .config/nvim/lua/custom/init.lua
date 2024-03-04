-- NvChad v2.0
-- This file is called when nvim is opened.
local api = vim.api
local opt = vim.opt
local cmd = vim.cmd

-- Enable relative line numbering
api.nvim_exec([[
  set relativenumber
]], false)

-- Set fold based on treesitter expression
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
cmd([[ set nofoldenable ]])
opt.foldcolumn = "1"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10
