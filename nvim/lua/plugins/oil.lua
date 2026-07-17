return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  opts = {
    columns = { "icon" },
    view_options = {
      show_hidden = true,
    },
    float = {
      border = "rounded",
    },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-r>"] = "actions.refresh",
      ["<C-S-s>"] = {
        "actions.select",
        opts = { horizontal = true },
        desc = "Open entry in horizontal split",
      },
    },
  },
}
