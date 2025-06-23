local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.foldmethod = "expr" -- Set fold based on treesitter expression
opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd([[ set nofoldenable ]])
opt.foldcolumn = "1"
opt.undofile = true -- Save undo history
opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.smartcase = true
opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time (smaller sequence displays which-key popup sooner)
opt.splitright = true -- Configure how new splits should be opened
opt.splitbelow = true
opt.list = false -- Sets how neovim will display certain whitespace characters in the editor
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split" -- Preview substitutions live, as you type!
opt.cursorline = true -- Show which line your cursor is on
opt.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
opt.shortmess:append("sI") -- disable nvim intro
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
vim.diagnostic.config({
  virtual_text = true,
})
vim.o.laststatus = 2
vim.o.showtabline = 0
