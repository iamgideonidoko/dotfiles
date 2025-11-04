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
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
        hl.MiniStatusLineFilename = { fg = "#FFD700", bg = nil, bold = true }
        hl.StatusLineLoftSmartOrder = { fg = "#ffffff", bg = "#005f87", bold = true }
        hl.StatusLineTabIndicator = { fg = "#ffffff", bg = "#c678dd" }
        hl.MiniStatusLineFilenameInactive = { fg = "#6272a4", bg = "NONE" }
        hl.DapStoppedLine = { default = true, link = "Visual" }
        hl.Visual = { bg = "#364A82" }
      end,
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
    vim.api.nvim_set_hl(0, "MiniStatusLineFilename", { fg = "#FFD700", bg = nil, bold = true })
  end,
}
