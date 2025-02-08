-- [[Configure and install plugins]]

-- Check status with `:Lazy` and update plugins with `:Lazy update`
-- NOTE: Use `opts = {}` to force a plugin to be loaded. (equivalent to: `require('Comment').setup({})`)
require("lazy").setup({
  require("plugins.mason"),
  require("plugins.git"),
  require("plugins.which-key"),
  require("plugins.telescope"),
  require("plugins.lspconfig"),
  require("plugins.conform"),
  require("plugins.cmp"),
  require("plugins.tokyonight"),
  require("plugins.mini"),
  require("plugins.treesitter"),
  require("plugins.debug"),
  require("plugins.indent_line"),
  require("plugins.lint"),
  require("plugins.autopairs"),
  require("plugins.autotag"),
  require("plugins.rest"),
  require("plugins.markdown"),
  require("plugins.server"),
  require("plugins.oil"),
  require("plugins.dashboard"),
  require("plugins.noice"),
  require("plugins.copilot"),
  require("plugins.wakatime"),
  require("plugins.tmux"),
  require("plugins.comment"),
  require("plugins.sleuth"),
  --- Dev plugins
  { import = "plugins._dev.loft" },
}, {
  ui = {
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
    border = "rounded",
  },
})

-- vim: ts=2 sts=2 sw=2 et
