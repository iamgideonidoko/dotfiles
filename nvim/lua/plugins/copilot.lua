---@type "github" | "supermaven"
local preferred_copilot = "supermaven"

return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = preferred_copilot == "supermaven",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<M-Space>",
        clear_suggestion = "<C-]>",
        accept_word = "<M-w>",
      },
      ignore_filetypes = { cpp = true },
      color = {
        suggestion_color = "#808080",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = preferred_copilot == "github",
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
