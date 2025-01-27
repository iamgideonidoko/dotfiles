return { -- Helper plugins
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
}

-- vim: ts=2 sts=2 sw=2 et
