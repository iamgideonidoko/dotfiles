return {
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "InsertEnter",
  --   opts = {
  --     keymaps = {
  --       accept_suggestion = "<M-Space>",
  --       clear_suggestion = "<C-]>",
  --       accept_word = "<M-w>",
  --     },
  --     ignore_filetypes = { cpp = true }, -- Custom ignore list
  --     color = {
  --       suggestion_color = "#808080",
  --     },
  --   },
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-Space>",
          accept_word = false,
          accept_line = false,
          next = "<M-'>",
          prev = '<M-">',
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        ["."] = false,
      },
    },
  },
}
