return { -- HTTP client
  "rest-nvim/rest.nvim",
  ft = {
    "http",
  },
  dependencies = { { "nvim-lua/plenary.nvim" } },
  commit = "84e81a19ab24ccf05c9233d34d4dfce61c233abe",
  config = function()
    require("rest-nvim").setup({
      -- Get config options at: https://github.com/rest-nvim/rest.nvim/tree/84e81a19ab24ccf05c9233d34d4dfce61c233abe?tab=readme-ov-file#packernvim
    })
    vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { desc = "[R]request [r]run" })
    vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", { desc = "[R]equest [p]preview" })
  end,
}
