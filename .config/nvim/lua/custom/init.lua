-- NvChad v2.0
-- This file is called when nvim is opened.
local api = vim.api
local opt = vim.opt
local cmd = vim.cmd
local keymap = vim.keymap

-- Enable relative line numbering
api.nvim_exec([[
  set relativenumber
]], false)

-- Set fold based on treesitter expression
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
cmd([[ set nofoldenable ]])
opt.foldcolumn = "1"

-- Bindings for Lspsaga
local lspsaga_binding_opt = { noremap = true, silent = true }
keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', lspsaga_binding_opt)
