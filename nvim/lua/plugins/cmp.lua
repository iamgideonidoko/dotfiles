return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "v0.*",

  opts = {
    keymap = {
      preset = "none",
      ["<C-a>"] = { "show", "hide" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-n>"] = { "snippet_forward", "fallback" },
      ["<C-p>"] = { "snippet_backward", "fallback" },
    },

    completion = {
      list = {
        max_items = 20,
        selection = { preselect = false, auto_insert = false },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = { border = "rounded" },
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = {
          -- Only complete from visible buffers
          opts = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[#bufs + 1] = vim.api.nvim_win_get_buf(win)
              end
              return bufs
            end,
          },
        },
      },
    },

    snippets = { preset = "default" },
  },
}
