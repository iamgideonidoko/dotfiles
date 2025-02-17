vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- Exit terminal mode
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Escape terminal mode" })
-- Alternatively close with Alt + "q"uit to quit terminal mode
vim.keymap.set("t", "<M-q>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- Open a terminal at the bottom of the screen with a fixed height
vim.keymap.set("n", ",st", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end)
