require("lazy").setup({
  -- Theme & UI
  require("plugins.theme"), -- Colorscheme
  require("plugins.statusline"), -- Statusline
  require("plugins.tabline"), -- Tabline
  require("plugins.dashboard"), -- Start screen
  require("plugins.indent_line"), -- Indentation guides

  -- Navigation
  require("plugins.oil"), -- File explorer
  require("plugins.telescope"), -- Fuzzy finder
  require("plugins.which-key"), -- Keybinding hints

  -- Editing
  require("plugins.sleuth"), -- Auto-detect indentation
  require("plugins.autopairs"), -- Auto pairs
  require("plugins.surround"), -- Surround
  require("plugins.comment"), -- Smart comments
  require("plugins.colorizer"), -- Color preview
  require("plugins.ufo"), -- Folding

  -- Code Intelligence
  require("plugins.mason"), -- Tool installer
  require("plugins.lspconfig"), -- LSP
  require("plugins.cmp"), -- Completion
  require("plugins.conform"), -- Formatting
  require("plugins.lint"), -- Linting
  require("plugins.treesitter"), -- Treesitter
  require("plugins.autotag"), -- Auto-close tags
  require("plugins.copilot"), -- AI completion

  -- Debugging
  require("plugins.dap"), -- Debug Adapter Protocol

  -- Git
  require("plugins.git"), -- Git integration

  -- Development Tools
  require("plugins.db"), -- Database
  require("plugins.rest"), -- REST client
  require("plugins.server"), -- Live server

  -- Writing
  require("plugins.markdown"), -- Markdown

  -- Workflow
  require("plugins.persistence"), -- Session persistence
  require("plugins.tmux"), -- Tmux integration
  require("plugins.wakatime"), -- Time tracking
  require("plugins.loft"), -- Buffer management

  -- DEV
  -- { import = "plugins._dev.loft" },
}, {
  defaults = {
    lazy = true, -- Lazy-load by default
    version = false, -- Don't use version constraints (faster)
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
    backdrop = 60,
  },
  install = {
    missing = true,
    colorscheme = { "rose-pine" },
  },
  checker = {
    enabled = false, -- Disable automatic plugin updates check
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false, -- Don't notify on config changes
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
      },
    },
  },
  profiling = {
    loader = false,
    require = false,
  },
  git = {
    timeout = 300, -- default is 120s
  },
})
