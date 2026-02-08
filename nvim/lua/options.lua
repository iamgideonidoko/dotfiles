local opt = vim.opt

-- CORE EDITOR SETTINGS
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showmode = false
opt.clipboard = "unnamedplus"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 5
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.list = false
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
opt.shortmess:append("sIcC")
opt.whichwrap:append("<>[]hl")
opt.fillchars = { eob = " " }
vim.o.laststatus = 2
vim.o.showtabline = 0
vim.o.winborder = "rounded"

-- FILE HANDLING
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false -- Disable swap files (use version control)
opt.backup = false
opt.writebackup = false
opt.autoread = true -- Auto-reload files changed outside vim
opt.confirm = true -- Confirm before closing unsaved buffers

-- PERFORMANCE OPTIMIZATIONS
-- Rendering & Redraw
opt.lazyredraw = false -- Allow for noice.nvim
opt.ttyfast = true -- Faster terminal connection
opt.redrawtime = 2000 -- More time for loading syntax
opt.synmaxcol = 300 -- Only highlight first 300 columns
opt.maxmempattern = 5000 -- Increase pattern matching memory

-- Timing
opt.updatetime = 200 -- Faster completion & CursorHold
opt.timeoutlen = 300 -- Which-key popup delay
opt.ttimeoutlen = 10 -- Key code delay (escape key response)

-- Completion & Popups
opt.pumheight = 15 -- Limit popup menu height
opt.pumblend = 0 -- Disable popup transparency (faster)
opt.winblend = 0 -- Disable window transparency (faster)

-- File System
opt.hidden = true -- Keep buffers loaded in background
opt.history = 1000 -- Command history
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- Folding (UFO-optimized)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

-- Syntax & Highlighting
vim.g.syntax_on = 1

-- DISABLE UNUSED PROVIDERS
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- DISABLE UNUSED BUILT-IN PLUGINS
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- LSP & DIAGNOSTICS
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  signs = true,
  update_in_insert = false, -- Don't update diagnostics while typing
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

-- LSP Handlers optimization
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
  max_height = 30,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  max_width = 80,
  max_height = 30,
})

-- Debounce LSP document updates
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 30
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- FILETYPE DETECTION
vim.filetype.add({
  extension = {
    env = "config",
  },
  filename = {
    [".env"] = "config",
  },
  pattern = {
    ["%.env%..*"] = "config",
  },
})
