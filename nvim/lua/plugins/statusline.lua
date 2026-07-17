return {
  "echasnovski/mini.statusline",
  version = false,
  lazy = false,
  config = function()
    local statusline = require("mini.statusline")
    local utils = require("utils")

    local loft = {
      smart_order_indicator = function()
        return ""
      end,
      get_buffer_mark = function()
        return ""
      end,
    }

    do
      local ok, ui = pcall(require, "loft.ui")
      if ok then
        loft = ui
      end
    end

    local cached_edges = {}

    local get_edge_hl = function(hl_name)
      local cache = cached_edges[hl_name]
      local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
      local bg = hl.bg

      if cache and cache.bg == bg then
        return cache.name, bg
      end

      local edge_name = hl_name .. "Edge"
      vim.api.nvim_set_hl(0, edge_name, { fg = bg, bg = "none" })
      cached_edges[hl_name] = { name = edge_name, bg = bg }
      return edge_name, bg
    end

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
        if #str == 0 then
          return ""
        end

        local edge_hl, bg = get_edge_hl(s.hl)
        if not bg then
          return string.format("%%#%s# %s ", s.hl, str)
        end
        return string.format("%%#%s#%%#%s#%s%%#%s#", edge_hl, s.hl, str, edge_hl)
      end, groups)
      return table.concat(parts, "")
    end

    statusline.setup({
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = math.huge })
          local git = statusline.section_git({ trunc_width = 75 })
          local diff = statusline.section_diff({ trunc_width = 75 })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp = statusline.section_lsp({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 0 })
          local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
          local location = "%l:%-2v"
          local search = statusline.section_searchcount({ trunc_width = 75 })

          local record_reg = vim.fn.reg_recording()
          local recording = #record_reg > 0 and "recording @" .. record_reg or ""

          local tab_idx = utils.get_tab_index()
          local total_tabs = #vim.api.nvim_list_tabpages()
          local tab_indicator = total_tabs > 1 and "T" .. tab_idx or ""

          -- Update CursorLineNr color to match current mode
          local _, mode_bg = get_edge_hl(mode_hl)
          if mode_bg then
            vim.api.nvim_set_hl(0, "CursorLineNr", {
              fg = mode_bg,
              bg = nil,
              bold = true,
            })
          end
          return combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "StatusLineTabIndicator", strings = { tab_indicator } },
            { hl = "StatusLineLoftSmartOrder", strings = { loft:smart_order_indicator() } },
            "%<",
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
            "%<",
            { hl = "MiniStatusLineFilename", strings = { filename .. loft:get_buffer_mark() } },
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
  end,
}
