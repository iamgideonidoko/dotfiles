return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    "hrsh7th/nvim-cmp",
    { -- fallback is `mini`
      "rcarriga/nvim-notify",
      config = function()
        local notify = require("notify")
        ---@diagnostic disable: missing-fields
        notify.setup({
          stages = "no_animation",
        })
      end,
    },
  },
  config = function()
    require("noice").setup({
      lsp = {
        progress = {
          enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        hover = {
          silent = true, -- set to true to not show a message if hover is not available
        },
        view = "notify",
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      routes = {
        -- {
        -- 	filter = { event = "msg_showmode" },
        -- 	view = "notify",
        -- },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "fewer lines" },
            },
          },
          view = "mini",
        },
      },
      views = {
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NoiceCmdlinePopupBorder" },
          },
          scrollbar = false,
        },
        confirm = {
          position = "50%",
        },
        notify = {
          render = "wrapped-compact",
        },
      },
    })
  end,
}
