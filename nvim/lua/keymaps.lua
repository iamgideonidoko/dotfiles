local utils = require("utils")

local set = vim.keymap.set
local opt = vim.opt

opt.hlsearch = true
set("n", "<Esc>", "<cmd>nohlsearch<CR>")
set({ "n", "i", "c", "v" }, "<M-q>", "<Esc>")

-- Diagnostic
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })
set("n", "<leader>e", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Show diagnostic [e]rror messages" })
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })
set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "Open workspace diagnostics" })

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
set("n", "<leader>Co", "<cmd>copen<cr>", { desc = "❰copen❱ Open quickfix list" })
set("n", "<leader>Cn", function()
  vim.cmd("try | cnext | catch | cfirst | catch | endtry")
end, { desc = "❰clast❱ Next quickfix (wrap)" })
set("n", "<leader>Cp", function()
  vim.cmd("try | cprev | catch | clast | catch | endtry")
end, { desc = "❰clast❱ Previous quickfix (wrap)" })
set("n", "<leader>CN", function()
  vim.cmd("try | cnfile | catch | cfirst | catch | endtry")
end, { desc = "❰cnfile❱ Next file (wrap)" })
set("n", "<leader>CP", function()
  vim.cmd("try | cpfile | catch | clast | catch | endtry")
end, { desc = "❰cpfile❱ Previous file (wrap)" })
set("n", "<leader>Cr", ":cfdo s//g<left><left>", { desc = "❰cfdo s//g❱ Replace in quickfix files" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local opts = { buffer = true, silent = true }
    -- Delete quickfix item
    set("n", "d", function()
      utils.delete_qf_items(false)
    end, opts)
    -- Delete selected quickfix items
    set("x", "d", function()
      utils.delete_qf_items(true)
    end, opts)
    -- Preview
    set("n", "p", "<cmd>.cc | wincmd p<cr>", opts)
    set("n", "r", ":cdo s///gc<Left><Left><Left><Left>", {
      buffer = true,
      desc = "Global replace on qf items",
    })
    set("n", "D", function()
      utils.delete_qf_buffer_items(false)
    end, { desc = "Delete all entries for current buffer", buffer = true })
    set("x", "D", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      utils.delete_qf_buffer_items(true)
    end, { desc = "Delete all entries for selected buffers", buffer = true })
  end,
})
