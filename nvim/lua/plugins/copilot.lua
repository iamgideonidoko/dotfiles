return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75, -- ms delay before suggestions
        keymap = {
          accept = "<M-Space>",
          accept_word = false,
          accept_line = false,
          next = "<M-'>",
          prev = '<M-">',
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      server_opts_overrides = {
        trace = "off",
        settings = {
          advanced = {
            listCount = 3, -- Limit suggestions
            inlineSuggestCount = 3,
          },
        },
      },
    })
  end,
}
