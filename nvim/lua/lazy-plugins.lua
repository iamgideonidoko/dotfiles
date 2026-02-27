require("lazy").setup({
  -- Core utilities (load early)
  require("plugins.sleuth"), -- Auto-detect indentation
  require("plugins.mini"), -- Statusline & surround

  -- UI & Visuals
  require("plugins.theme"), -- Colorscheme
  require("plugins.indent_line"), -- Indentation guides
  require("plugins.noice"), -- Better UI
  require("plugins.dashboard"), -- Start screen

  -- Navigation & Search
  require("plugins.telescope"), -- Fuzzy finder
  require("plugins.oil"), -- File explorer
  require("plugins.which-key"), -- Keybinding hints

  -- LSP & Completion
  require("plugins.mason"), -- LSP installer
  require("plugins.lspconfig"), -- LSP configs
  require("plugins.cmp"), -- Completion
  require("plugins.conform"), -- Formatting
  require("plugins.lint"), -- Linting

  -- Treesitter
  require("plugins.treesitter"), -- Syntax highlighting

  -- Code Intelligence
  require("plugins.copilot"), -- AI completion
  require("plugins.avante"), -- AI assistant
  require("plugins.ufo"), -- Folding

  -- Language Support
  require("plugins.autopairs"), -- Auto close brackets
  require("plugins.autotag"), -- Auto close tags
  require("plugins.comment"), -- Smart comments
  require("plugins.dadbod"), -- Database

  -- Git
  require("plugins.git"), -- Git integration

  -- Utilities
  require("plugins.tmux"), -- Tmux integration
  require("plugins.colorizer"), -- Color preview
  require("plugins.markdown"), -- Markdown preview
  require("plugins.rest"), -- REST client
  require("plugins.server"), -- Live server
  require("plugins.tabby"), -- Tab bar
  require("plugins.wakatime"), -- Time tracking
  require("plugins.dap"), -- Debugger
  require("plugins.persistence"), -- Session persistence
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
})
