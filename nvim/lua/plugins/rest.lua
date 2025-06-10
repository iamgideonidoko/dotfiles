return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
      vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<CR>", { desc = "[R]request [r]run" })
      vim.keymap.set("n", "<leader>rl", "<cmd>Rest logs<CR>", { desc = "[R]request [l]ogs" })
    end,
  },
}
