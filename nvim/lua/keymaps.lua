local utils = require("utils")

local set = vim.keymap.set
local opt = vim.opt

opt.hlsearch = true
set("n", "<Esc>", "<cmd>nohlsearch<CR>")
set({ "n", "i", "c", "v" }, "<M-q>", "<Esc>")

-- Diagnostic
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

-- Movement in insert mode
set({ "i", "t" }, "<C-h>", "<Left>", { desc = "Move left" })
set({ "i", "t" }, "<C-l>", "<Right>", { desc = "Move right" })
set({ "i", "t" }, "<C-j>", "<Down>", { desc = "Move down" })
set({ "i", "t" }, "<C-k>", "<Up>", { desc = "Move up" })

-- Control the size of windows
set("n", "<M-,>", "<C-w>5<", { desc = "Decrease width" })
set("n", "<M-.>", "<C-w>5>", { desc = "Increase width" })
set("n", "<M-i>", "<C-W>-", { desc = "Decrease height" })
set("n", "<M-o>", "<C-W>+", { desc = "Increase height" })

-- Shift left and right in visual mode (and remain in visual mode)
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })

-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text" })

-- Insert an empty line above or below the current line
set("n", "<M-j>", function()
  utils.add_empty_line(true)
end, { desc = "Insert an empty line below current", noremap = true, silent = true })
set("n", "<M-k>", utils.add_empty_line, { desc = "Insert an empty line above current", noremap = true, silent = true })

-- Move line(s) up or down
set("n", "<S-M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
set("n", "<S-M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
set("v", "<S-M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set("v", "<S-M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>_", function()
  if vim.o.laststatus == 2 then
    vim.o.laststatus = 1
  else
    vim.o.laststatus = 2
  end
end, { desc = "Toggle statusline" })

-- <<<<<<QUICKFIX>>>>>>>
-- Quickfix window management
vim.keymap.set("n", "<leader>Qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>Qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>Qt", "<cmd>cwindow<cr>", { desc = "Toggle quickfix list" })
-- Navigate quickfix entries
vim.keymap.set("n", "<leader>Qn", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>Qp", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>Qf", "<cmd>cfirst<cr>", { desc = "First quickfix item" })
vim.keymap.set("n", "<leader>Ql", "<cmd>clast<cr>", { desc = "Last quickfix item" })
-- Navigate with error wrapping (safer navigation)
vim.keymap.set("n", "<leader>Q]", function()
  vim.cmd("try | cnext | catch | cfirst | catch | endtry")
end, { desc = "Next quickfix (wrap)" })
vim.keymap.set("n", "<leader>Q[", function()
  vim.cmd("try | cprev | catch | clast | catch | endtry")
end, { desc = "Previous quickfix (wrap)" })
-- File-level navigation
vim.keymap.set("n", "<leader>Q.", "<cmd>cnfile<cr>", { desc = "Next file in quickfix" })
vim.keymap.set("n", "<leader>Q,", "<cmd>cpfile<cr>", { desc = "Previous file in quickfix" })
-- Quickfix operations
vim.keymap.set("n", "<leader>Qr", ":cdo s//g<left><left>", { desc = "Replace in quickfix items" })
vim.keymap.set("n", "<leader>Qa", ":cdo ", { desc = "Execute command on quickfix items" })
vim.keymap.set("n", "<leader>Qs", ":cfdo s//g<left><left>", { desc = "Replace in quickfix files" })
-- Clear quickfix list
vim.keymap.set("n", "<leader>QC", function()
  vim.fn.setqflist({})
  print("Quickfix list cleared")
end, { desc = "Clear quickfix list" })
-- Jump to current quickfix item
vim.keymap.set("n", "<leader>Q<cr>", "<cmd>cc<cr>", { desc = "Jump to current quickfix item" })
-- Make operations
vim.keymap.set("n", "<leader>Qm", "<cmd>make<cr>", { desc = "Run make" })
vim.keymap.set("n", "<leader>QM", "<cmd>make!<cr>", { desc = "Run make (silent)" })
-- Location list equivalents (bonus)
vim.keymap.set("n", "<leader>QL", "<cmd>lopen<cr>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>Qk", "<cmd>lnext<cr>", { desc = "Next location item" })
vim.keymap.set("n", "<leader>Qj", "<cmd>lprev<cr>", { desc = "Previous location item" })
-- Advanced: Send grep/search results to quickfix
vim.keymap.set("n", "<leader>Qg", function()
  local input = vim.fn.input("Grep: ")
  if input ~= "" then
    vim.cmd("grep! " .. vim.fn.shellescape(input))
    vim.cmd("copen")
  end
end, { desc = "Grep to quickfix" })
-- Send current buffer diagnostics to quickfix (LSP integration)
vim.keymap.set("n", "<leader>Qd", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end, { desc = "Diagnostics to quickfix" })
