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
set("n", "<M-[>", "<C-w>5<", { desc = "Decrease width" })
set("n", "<M-]>", "<C-w>5>", { desc = "Increase width" })
set("n", "<M-{>", "<C-W>-", { desc = "Decrease height" })
set("n", "<M-}>", "<C-W>+", { desc = "Increase height" })

set("n", "<C-i>", "<Nop>", { noremap = true, silent = true })
set("n", "<C-o>", "<Nop>", { noremap = true, silent = true })

-- Shift left and right in visual mode (and remain in visual mode)
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })

-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text" })

-- Insert an empty line above or below the current line
set("n", "<M-o>", function()
  utils.add_empty_line(true)
end, { desc = "Insert an empty line below current" })
set("n", "<M-i>", utils.add_empty_line, { desc = "Insert an empty line above current", noremap = true, silent = true })

-- Move line(s) up or down
set("n", "<M->>", ":m .+1<CR>==", { noremap = true, silent = true })
set("n", "<M-<>", ":m .-2<CR>==", { noremap = true, silent = true })
set("v", "<M->>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set("v", "<M-<>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

set("n", "<leader>_", function()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 2
  else
    vim.o.laststatus = 0
  end
end, { desc = "Toggle statusline" })

-- <<<<<<QUICKFIX>>>>>>>
-- Quickfix window management
set("n", "<leader>Co", "<cmd>copen<cr>", { desc = "❰copen❱ Open quickfix list" })
set("n", "<leader>Cc", "<cmd>cclose<cr>", { desc = "❰cclose❱ Close quickfix list" })
set("n", "<leader>Ct", "<cmd>cwindow<cr>", { desc = "❰cwindow❱ Toggle quickfix list" })
-- Navigate quickfix entries
set("n", "<leader>Cn", "<cmd>cnext<cr>", { desc = "❰cnext❱ Next quickfix item" })
set("n", "<leader>Cp", "<cmd>cprev<cr>", { desc = "❰cprev❱ Previous quickfix item" })
set("n", "<leader>Cf", "<cmd>cfirst<cr>", { desc = "❰cfirst❱ First quickfix item" })
set("n", "<leader>Cl", "<cmd>clast<cr>", { desc = "❰clast❱ Last quickfix item" })
-- Navigate with error wrapping (safer navigation)
set("n", "<leader>C]", function()
  vim.cmd("try | cnext | catch | cfirst | catch | endtry")
end, { desc = "❰clast❱ Next quickfix (wrap)" })
set("n", "<leader>C[", function()
  vim.cmd("try | cprev | catch | clast | catch | endtry")
end, { desc = "❰clast❱ Previous quickfix (wrap)" })
-- File-level navigation
set("n", "<leader>C.", "<cmd>cnfile<cr>", { desc = "❰cnfile❱ Next file in quickfix" })
set("n", "<leader>C,", "<cmd>cpfile<cr>", { desc = "❰cpfile❱ Previous file in quickfix" })
-- Quickfix operations
set("n", "<leader>Cr", ":cdo s//g<left><left>", { desc = "❰cdo s//g❱ Replace in quickfix items" })
set("n", "<leader>Ca", ":cdo ", { desc = "❰cdo ❱ Execute command on quickfix items" })
set("n", "<leader>Cs", ":cfdo s//g<left><left>", { desc = "❰cfdo s//g❱ Replace in quickfix files" })
-- Clear quickfix list
set("n", "<leader>CC", function()
  vim.fn.setqflist({})
  print("Quickfix list cleared")
end, { desc = "Clear quickfix list" })
-- Jump to current quickfix item
set("n", "<leader>C<cr>", "<cmd>cc<cr>", { desc = "Jump to current quickfix item" })
-- Make operations
set("n", "<leader>Cm", "<cmd>make<cr>", { desc = "Run make" })
set("n", "<leader>CM", "<cmd>make!<cr>", { desc = "Run make (silent)" })
-- Location list equivalents (bonus)
set("n", "<leader>CL", "<cmd>lopen<cr>", { desc = "❰lopen❱ Open location list" })
set("n", "<leader>Ck", "<cmd>lnext<cr>", { desc = "❰lnext❱ Next location item" })
set("n", "<leader>Cj", "<cmd>lprev<cr>", { desc = "❰lprev❱ Previous location item" })
-- Advanced: Send grep/search results to quickfix
set("n", "<leader>Cg", function()
  local input = vim.fn.input("Grep: ")
  if input ~= "" then
    vim.cmd("grep! " .. vim.fn.shellescape(input))
    vim.cmd("copen")
  end
end, { desc = "Grep to quickfix" })
-- Send current buffer diagnostics to quickfix (LSP integration)
set("n", "<leader>Ce", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end, { desc = "Diagnostics to quickfix" })
set("n", "<leader>Cd", function()
  local qf = vim.fn.getqflist()
  local cur = vim.fn.line(".") - 1
  table.remove(qf, cur + 1)
  vim.fn.setqflist(qf, "r")
end, { desc = "Delete quickfix item" })
set("n", "<leader>CD", function()
  local cur = vim.fn.bufnr("%")
  local qf = vim.fn.getqflist()
  local filtered = vim.tbl_filter(function(item)
    return item.bufnr ~= cur
  end, qf)
  vim.fn.setqflist(filtered, "r")
end, { desc = "Delete quickfix file entries" })
