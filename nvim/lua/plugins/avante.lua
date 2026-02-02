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
      },
    },
    selection = {
      hint_display = "none",
    },
  },
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
  },
}
