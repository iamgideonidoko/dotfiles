local utils = require("utils")

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Keybinding for ESLint fix all
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("custom-buffer-eslint-fix", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      local eslint_fix_all_command = "LspEslintFixAll"
      local eslint_fix_all_exists = utils.command_exists(eslint_fix_all_command)
      if eslint_fix_all_exists then
        if not utils.check_keybinding_exists("n", "<leader>fe") then
          vim.keymap.set("n", "<leader>fe", function()
            vim.cmd(eslint_fix_all_command)
          end, { desc = "[F]ix [e]SLint" })
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
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})
