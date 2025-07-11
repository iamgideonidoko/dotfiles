return { -- Collection of small independent packages
  "echasnovski/mini.nvim",
  config = function()
    local combine_groups = function(groups)
      local parts = vim.tbl_map(function(s)
        if type(s) == "string" then
          return s
        end
        if type(s) ~= "table" then
          return ""
        end
        local string_arr = vim.tbl_filter(function(x)
          return type(x) == "string" and x ~= ""
        end, s.strings or {})
        local str = table.concat(string_arr, " ")
        if str:len() == 0 then
          return ""
        end
        local hl = vim.api.nvim_get_hl(0, { name = s.hl })
        vim.api.nvim_set_hl(0, s.hl .. "Edge", {
          fg = hl.bg,
          bg = "none",
        })
        if hl.bg == nil then
          return string.format("%%#%s# %s ", s.hl, str)
        end
        return string.format("%%#%sEdge#%%#%s#%s%%#%sEdge#", s.hl, s.hl, str, s.hl)
      end, groups)
      return table.concat(parts, "")
    end
    local statusline = require("mini.statusline")
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
          local tab_idx = require("utils").get_tab_index()
          local total_tabs = #vim.api.nvim_list_tabpages()
          local tab_indicator = total_tabs > 1 and "T" .. tab_idx or ""
          return combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "StatusLineTabIndicator", strings = { tab_indicator } },
            { hl = "StatusLineLoftSmartOrder", strings = { loft_ui:smart_order_indicator() } },
            "%<",
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
            "%<",
            { hl = "MiniStatusLineFilename", strings = { filename .. loft_ui:get_buffer_mark() } },
            "%=",
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
            { hl = "ErrorMsg", strings = { recording } },
          })
        end,
        inactive = function()
          local filepath = vim.fn.expand("%:~")
          filepath = #filepath > 0 and filepath .. " " or filepath
          local border = string.rep("━", vim.api.nvim_win_get_width(0) - #filepath)
          return "%#MiniStatusLineFilenameInactive#" .. filepath .. "%#WinSeparator#" .. border
        end,
      },
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup({ silent = true })
  end,
}
