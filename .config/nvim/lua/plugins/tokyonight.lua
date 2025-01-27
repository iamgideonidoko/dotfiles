return { -- Colorscheme
  "folke/tokyonight.nvim",
  priority = 1000, -- Load before other start plugins
  init = function()
    ---@diagnostic disable: missing-fields
    require("tokyonight").setup({
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
  end,
}

-- vim: ts=2 sts=2 sw=2 et
