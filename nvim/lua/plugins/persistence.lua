return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    need = 1,
    branch = true,
  },
  keys = {
    {
      "<leader>Pl",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>PL",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>Po",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>Px",
      function()
        require("persistence").stop()
      end,
      desc = "Stop Saving Current Session",
    },
  },
}
