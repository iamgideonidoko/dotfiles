return { -- Colorscheme
  "folke/tokyonight.nvim",
  priority = 1000, -- Load before other start plugins
  init = function()
    ---@diagnostic disable: missing-fields
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl)
        hl.LineNrAbove = { fg = "#bfc9db" }
        hl.LineNrBelow = { fg = "#bfc9db" }
        hl.WinSeparator = { fg = "#555555" }
        hl.StatusLineNC = { bg = "NONE" }
      end,
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
  end,
}
