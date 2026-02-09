local line_color = "#bfc9db"
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
      on_highlights = function(hl, c)
        hl.LineNrAbove = { fg = line_color }
        hl.LineNrBelow = { fg = line_color }
        hl.WinSeparator = { fg = "#555555" }
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
        hl.MiniStatusLineFilename = { fg = "#FFD700", bg = nil, bold = true }
        hl.StatusLineLoftSmartOrder = { fg = "#ffffff", bg = "#005f87", bold = true }
        hl.StatusLineTabIndicator = { fg = "#ffffff", bg = "#c678dd" }
        hl.MiniStatusLineFilenameInactive = { fg = "#6272a4", bg = "NONE" }
        hl.DapStoppedLine = { default = true, link = "Visual" }
        hl.AvantePromptInput = { fg = c.fg, bg = c.bg_popup }
        hl.AvantePromptInputBorder = { fg = line_color, bg = c.bg_popup }
        hl.FloatTitle = { fg = c.fg_dark, bg = c.bg_popup }
      end,
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
    vim.api.nvim_set_hl(0, "MiniStatusLineFilename", { fg = "#FFD700", bg = nil, bold = true })
  end,
}
