return {
  { -- "gc" to comment
    "numToStr/Comment.nvim",
    opts = {},
  },
  { -- Highlight TODO, NOTE, etc
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
