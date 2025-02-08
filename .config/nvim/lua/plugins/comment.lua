return {
  { -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    opts = {},
  },
  { -- Highlight TODO, NOTE, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}

-- vim: ts=2 sts=2 sw=2 et
