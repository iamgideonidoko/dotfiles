return { -- File explorer
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      float = {
        border = "rounded",
      },
      confirmation = {
        border = "rounded",
      },
      progress = {
        border = "rounded",
      },
      ssh = {
        border = "rounded",
      },
      keymaps_help = {
        border = "rounded",
      },
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true, -- Files that start with "."
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
        ["<C-S-s>"] = {
          "actions.select",
          opts = { horizontal = true },
          desc = "Open the entry in a horizontal split",
        },
      },
    })
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
