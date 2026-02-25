-- Use `<leader>a` for Avante AI-assisted coding
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "copilot",
    providers = {
      copilot = {
        model = "gpt-5-mini",
      },
    },
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = " ",
        win = {
          style = "input",
          border = "rounded",
        },
      },
    },
    mappings = {
      -- submit = {
      --   normal = "<S-CR>",
      --   insert = "<S-CR>",
      -- },
    },
    selection = {
      hint_display = "none",
    },
    ui = {
      border = "rounded",
    },
    windows = {
      sidebar_header = {
        rounded = true,
      },
      edit = {
        border = "rounded",
      },
      ask = {
        border = "rounded",
      },
    },
  },
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
