return {
  dir = "~/work/loft.nvim",
  dev = true,
  config = function()
    local actions = require("loft.actions")
    require("loft").setup({
      keymaps = {
        general = {
          ["<M-l>"] = actions.switch_to_next_marked_buffer,
          ["<M-h>"] = actions.switch_to_prev_marked_buffer,
          ["<leader>ls"] = {
            callback = function()
              actions.toggle_smart_order({ notify = false })
            end,
            desc = "Toggle Smart Order ON and OFF",
          },
          ["<leader><leader>"] = actions.open_loft,
          ["<leader>?"] = function()
            actions.open_loft()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/", true, false, true), "nt", false)
          end,
        },
        ui = {
          ["<M-q>"] = "close",
        },
      },
      persistence = {
        enabled = true,
      },
    })
  end,
}
