return {
  "iamgideonidoko/loft.nvim",
  event = "VeryLazy",
  config = function()
    local loft = require("loft")
    local loft_actions = require("loft.actions")
    local loft_registry = require("loft.registry")
    loft.setup({
      keymaps = {
        general = {
          ["<leader>l)"] = loft_actions.switch_to_next_marked_buffer,
          ["<leader>l("] = loft_actions.switch_to_prev_marked_buffer,
          ["<leader>ls"] = {
            callback = function()
              loft_actions.toggle_smart_order({ notify = false })
            end,
            desc = "Toggle Smart Order ON and OFF",
          },
          ["<leader><leader>"] = loft_actions.open_loft,
          ["<leader>?"] = function()
            loft_actions.open_loft()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/", true, false, true), "nt", false)
          end,
        },
        ui = {
          ["<M-q>"] = "close",
          ["x"] = "toggle_mark_entry",
        },
      },
      persistence = {
        enabled = true,
      },
      window = {
        width = function()
          return vim.o.columns
        end,
        height = function()
          local registry_size = #loft_registry:get_registry()
          return math.min(registry_size > 0 and registry_size or 1, vim.o.lines - vim.o.cmdheight - 2)
        end,
        col = 0,
        row = function(h)
          return vim.o.lines - vim.o.cmdheight - h - 2
        end,
        title = "",
        footer = "",
        border = { "─", "─", "─", "", "", "", "", "" },
      },
      help_window = {
        border = "rounded",
        disable = true,
      },
    })
  end,
}
