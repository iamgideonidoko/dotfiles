return { -- Collection of small independent packages
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#FFD700", bg = "#262D43", bold = true })
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      -- Macro recording indicator
      local recording = ""
      local record_reg = vim.fn.reg_recording()
      if record_reg ~= "" then
        recording = " %#ErrorMsg# recording @" .. record_reg -- red highlight for visibility
      end

      return "%2l:%-2v" .. recording
    end
    local original_section_filename = statusline.section_filename
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function(...)
      return original_section_filename(...) .. require("loft.ui"):get_buffer_mark()
    end
  end,
}

-- " %s ",

-- vim: ts=2 sts=2 sw=2 et
