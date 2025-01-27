-- [[Bootstrap `lazy.nvim` plugin manager (see `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim)]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field

-- Add lazy to the `runtimepath` (rtp), this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

-- vim: ts=2 sts=2 sw=2 et
