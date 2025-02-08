-- [[Keymaps (see `:help vim.keymap.set()`)]]

local utils = require("utils")

local set = vim.keymap.set
local opt = vim.opt

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic message" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic message" })
set("n", "<leader>e", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Show diagnostic [e]rror messages" })
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })

-- Disable arrow keys in normal mode
set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Move in insert mode
set("i", "<C-h>", "<Left>", { desc = "Move left" })
set("i", "<C-l>", "<Right>", { desc = "Move right" })
set("i", "<C-j>", "<Down>", { desc = "Move down" })
set("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Control the size of splits (height/width)
set("n", "<M-,>", "<C-w>5<", { desc = "Decrease width" })
set("n", "<M-.>", "<C-w>5>", { desc = "Increase width" })
set("n", "<M-i>", "<C-W>-", { desc = "Decrease height" })
set("n", "<M-o>", "<C-W>+", { desc = "Increase height" })

-- Shift left and right in visual mode (and remain in visual mode)
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })

-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text" })

-- Insert an empty line below
set("n", "<M-j>", function()
  utils.add_empty_line(true)
end, { desc = "Insert an empty line below current", noremap = true, silent = true })
-- Insert an empty line above
set("n", "<M-k>", utils.add_empty_line, { desc = "Insert an empty line above current", noremap = true, silent = true })

-- Move line(s) up or down
set("n", "<S-M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
set("n", "<S-M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
set("v", "<S-M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set("v", "<S-M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
