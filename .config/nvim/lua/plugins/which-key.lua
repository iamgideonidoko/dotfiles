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
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>o", group = "[O]pen" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
