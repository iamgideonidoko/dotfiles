-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Keybinding for ESLint fix all
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("custom-buffer-eslint-fix", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.keymap.set("n", "<leader>fe", function()
        vim.cmd("LspEslintFixAll")
      end, { buffer = args.buf, desc = "[f]ix [e]SLint" })
    end
  end,
})

-- Check if file changed outside of vim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Disable features for large files (>1MB)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("large_file_performance", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.b[args.buf].large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.schedule(function()
        vim.bo[args.buf].syntax = ""
      end)
    end
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

-- Auto-resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    local cur_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. cur_tab)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  desc = "Clean Loft registry after oil.nvim deletions",
  callback = function(args)
    local actions = args.data and args.data.actions or {}
    local needs_clean = false
    for _, action in ipairs(actions) do
      if action.type == "delete" or action.type == "trash" then
        needs_clean = true
        break
      end
    end
    if needs_clean then
      local ok, registry = pcall(require, "loft.registry")
      if ok then
        registry:clean()
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("jump-to-last-pos", { clear = true }),
  desc = "Return to last edit position when opening a file",
  callback = function()
    local exclude = { "gitcommit", "commit", "gitrebase" }
    if vim.tbl_contains(exclude, vim.bo.filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable auto comment continuation on new lines",
  group = vim.api.nvim_create_augroup("no-auto-comment", { clear = true }),
  pattern = "*",
  callback = function()
    -- vim.schedule ensures this runs after the default ftplugins
    vim.schedule(function()
      vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end)
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("active-cursorline", { clear = true }),
  desc = "Enable cursorline in active window",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = "active-cursorline",
  desc = "Disable cursorline when leaving window",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("NoiceHideStatusline", { clear = true }),
  callback = function()
    local cmd = vim.fn.getcmdline()
    if cmd:match("^%%s/") or cmd:match("^s/") then
      vim.o.laststatus = 3
    else
      vim.o.laststatus = 2
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = "NoiceHideStatusline",
  callback = function()
    vim.o.laststatus = 2
  end,
})
