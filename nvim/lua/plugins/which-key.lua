return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    local which_key = require("which-key")
    which_key.setup({
      win = {
        border = "rounded",
      },
    })
    -- Document existing key chains
    which_key.add({
      { "<leader>c", group = "[c]ode" },
      { "<leader>d", group = "[d]ebug" },
      { "<leader>r", group = "[r]e-" },
      { "<leader>f", group = "[f]ind" },
      { "<leader>w", group = "[w]orkspace" },
      { "<leader>t", group = "[t]ab" },
      { "<leader>T", group = "[T]oggle" },
      { "<leader>o", group = "[o]pen" },
      { "<leader>h", group = "Git [h]unk", mode = { "n", "v" } },
      { "<leader>l", group = "[l]oft" },
      { "<leader>R", group = "Kulala [R]est client" },
      { "<leader>Q", group = "[Q]uick fix" },
      { "<leader>D", group = "[D]adbod" },
    })
  end,
}
