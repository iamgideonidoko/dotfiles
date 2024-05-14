-- [[Autocommands (see `:help lua-guide-autocommands`)]]

-- Highlight when yanking (copying) text (see `:help vim.highlight.on_yank()`)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
