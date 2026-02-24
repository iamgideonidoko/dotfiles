local colors = {
  line_number = "#bfc9db",
  separator = "#555555",
  filename = "#FFD700",
  tab_indicator_bg = "#a055bb",
  loft_order_bg = "#005f87",
}
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
        hl.LineNrAbove = { fg = colors.line_number }
        hl.LineNrBelow = { fg = colors.line_number }
        hl.WinSeparator = { fg = colors.separator, bold = false }
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
        hl.MiniStatusLineFilename = { fg = colors.filename, bg = nil, bold = true }
        hl.StatusLineLoftSmartOrder = { fg = c.fg, bg = colors.loft_order_bg, bold = true }
        hl.StatusLineTabIndicator = { fg = c.fg, bg = colors.tab_indicator_bg }
        hl.MiniStatusLineFilenameInactive = { fg = colors.line_number, bg = "NONE", bold = false }
        hl.DapStoppedLine = { default = true, link = "Visual" }
        hl.AvantePromptInput = { fg = c.fg, bg = c.bg_popup }
        hl.AvantePromptInputBorder = { fg = colors.separator, bg = c.bg_popup }
        hl.PmenuSel = { fg = c.fg, bg = c.bg_search, bold = true }
      end,
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
    vim.api.nvim_set_hl(0, "MiniStatusLineFilename", { fg = colors.filename, bg = nil, bold = true })
  end,
}
