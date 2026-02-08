return {
  "folke/noice.nvim",
  event = "VeryLazy",
  priority = 50,
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
          timeout = 2000,
          max_width = 80,
          max_height = 20,
          render = "compact",
        })
      end,
    },
  },
  config = function()
    require("noice").setup({
      throttle = 1000 / 30, -- limit updates to 30fps
      lsp = {
        progress = {
          enabled = false, -- Disable LSP progress (use fidget instead)
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

    vim.keymap.set("n", "<leader>nl", function()
      require("noice").cmd("last")
    end, { desc = "Noice Last Message" })
    vim.keymap.set("n", "<leader>nh", function()
      require("noice").cmd("history")
    end, { desc = "Noice Message History" })
    vim.keymap.set("n", "<leader>nm", "<cmd>messages<cr>", { desc = "All Messages" })
    vim.keymap.set("n", "<leader>nd", function()
      require("noice").cmd("dismiss")
    end, { desc = "Noice Dismiss All" })
  end,
}
