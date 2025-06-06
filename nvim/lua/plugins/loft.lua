return {
  "iamgideonidoko/loft.nvim",
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
        },
        ui = {
          ["<M-q>"] = "close",
        },
      },
    })
  end,
}
