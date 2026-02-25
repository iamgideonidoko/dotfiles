local colors = {
  line_number = "#908caa", -- rose-pine subtle
  separator = "#403d52", -- rose-pine highlight_med
  filename = "#f6c177", -- rose-pine gold
  tab_indicator_bg = "#c4a7e7", -- rose-pine iris
  loft_order_bg = "#31748f", -- rose-pine pine
}
return { -- Colorscheme
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- Load before other start plugins
  init = function()
    require("rose-pine").setup({
      variant = "main",
      dark_variant = "main",
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
      highlight_groups = {
        LineNrAbove = { fg = colors.line_number },
        LineNrBelow = { fg = colors.line_number },
        WinSeparator = { fg = colors.separator, bold = false },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        StatusLineTerm = { bg = "NONE" },
        StatusLineTermNC = { bg = "NONE" },
        MiniStatusLineFilename = { fg = colors.filename, bold = true },
        StatusLineLoftSmartOrder = { fg = "text", bg = colors.loft_order_bg, bold = true },
        StatusLineTabIndicator = { fg = "base", bg = colors.tab_indicator_bg },
        MiniStatusLineFilenameInactive = { fg = colors.line_number, bold = false },
        DapStoppedLine = { default = true, link = "Visual" },
        AvantePromptInput = { fg = "text", bg = "overlay" },
        AvantePromptInputBorder = { fg = colors.separator, bg = "overlay" },
        PmenuSel = { fg = "text", bg = "highlight_med", bold = true },
      },
    })
    vim.cmd.colorscheme("rose-pine")
    vim.cmd.hi("Comment gui=none")
    vim.api.nvim_set_hl(0, "MiniStatusLineFilename", { fg = colors.filename, bg = nil, bold = true })
  end,
}
