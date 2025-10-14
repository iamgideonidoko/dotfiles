return {
  "iamgideonidoko/loft.nvim",
  config = function()
    local actions = require("loft.actions")
    require("loft").setup({
      keymaps = {
        general = {
          ["<leader>l)"] = actions.switch_to_next_marked_buffer,
          ["<leader>l("] = actions.switch_to_prev_marked_buffer,
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
