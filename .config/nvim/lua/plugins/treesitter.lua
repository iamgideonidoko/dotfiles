return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "javascript",
      "typescript",
      "http",
      "json",
      "tsx",
      "glsl",
      "xml",
      "graphql",
      "regex",
    },
    auto_install = true,
    highlight = {
      enable = true,
      use_languagetree = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  config = function(_, opts)
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup(opts)
  end,
}

-- vim: ts=2 sts=2 sw=2 et
