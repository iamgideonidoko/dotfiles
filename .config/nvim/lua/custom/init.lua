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

