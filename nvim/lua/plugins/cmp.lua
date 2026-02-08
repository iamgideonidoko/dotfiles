return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- This build step is needed for regex support in snippets but it's not supported in many Windows environments.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    luasnip.config.setup({
      history = false,
      updateevents = "TextChanged,TextChangedI",
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",
    })

    cmp.setup({
      performance = {
        debounce = 150, -- Delay before completion triggers
        throttle = 60, -- Minimum time between updates
        fetching_timeout = 500, -- Timeout for source fetch
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 20, -- Limit completion items shown
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        -- Manual trigger
        ["<C-a>"] = function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete({})
          end
        end,
        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        -- Move to the left of each of the expansion locations
        ["<C-n>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        -- Move to the right of each of the expansion locations
        ["<C-p>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = {
        {
          name = "lazydev",
          group_index = 0, -- skip loading LuaLS completions
        },
        {
          name = "nvim_lsp",
          priority = 1000,
          max_item_count = 20,
        },
        {
          name = "luasnip",
          priority = 750,
          max_item_count = 10,
        },
        {
          name = "path",
          priority = 500,
          max_item_count = 10,
        },
        {
          name = "buffer",
          priority = 250,
          max_item_count = 5,
          keyword_length = 3, -- Only complete after 3 chars
          option = {
            get_bufnrs = function()
              -- Only complete from visible buffers
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      },
      window = {
        completion = cmp.config.window.bordered({ border = "rounded" }),
        documentation = cmp.config.window.bordered({ border = "rounded" }),
      },
    })
  end,
}
