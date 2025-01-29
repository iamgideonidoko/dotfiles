local utils = require("utils")

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add keybinding if `EslintFixAll` is executable
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("custom-buffer-eslint-fix", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      if utils.command_exists("EslintFixAll") then
        if not utils.check_keybinding_exists("n", "<leader>fe") then
          vim.keymap.set("n", "<leader>fe", function()
            vim.cmd("EslintFixAll")
          end, { desc = "[F]ix [E]SLint" })
        end
      else
        if utils.check_keybinding_exists("n", "<leader>fe") then
          vim.api.nvim_del_keymap("n", "<leader>fe")
        end
      end
    end, 500)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "LoftSmartOrderToggle", "LoftBufferMark" },
  callback = function()
    vim.cmd("redrawstatus") -- Redraw statusline
  end,
})

-- vim: ts=2 sts=2 sw=2 et
