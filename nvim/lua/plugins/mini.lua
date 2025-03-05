return { -- Collection of small independent packages
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#FFD700", bg = "#262D43", bold = true })
    vim.api.nvim_set_hl(0, "StatusLineLoftSmartOrder", { fg = "#ffffff", bg = "#005f87", bold = true })
    statusline.setup({
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local git = statusline.section_git({ trunc_width = 75 })
          local diff = statusline.section_diff({ trunc_width = 75 })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp = statusline.section_lsp({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 140 })
          local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
          local location = "%l:%-2v"
          local search = statusline.section_searchcount({ trunc_width = 75 })
          local loft_ui = require("loft.ui")
          local record_reg = vim.fn.reg_recording()
          local recording = (string.len(record_reg) > 0 and "recording @" or "") .. record_reg
          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "StatusLineLoftSmartOrder", strings = { loft_ui:smart_order_indicator() } },
            "%<",
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { filename .. loft_ui:get_buffer_mark() } },
            "%=",
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
            { hl = "ErrorMsg", strings = { recording } },
          })
        end,
      },
    })
  end,
}
