return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- Useful UI notification and status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = {
          window = {
            winblend = 0,
            border = "rounded",
          },
        },
      },
    },
    -- Configure Lua LSP for Neovim config, runtime and plugins
    -- (completion, annotations and signatures of Neovim apis)
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("default-lsp-attach", { clear = true }),
      --  This function gets run when an LSP attaches to a particular buffer
      callback = function(event)
        -- LSP specific keymap util
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        -- Jump to the definition of the word under your cursor.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [d]efinition")
        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [r]eferences")
        -- Jump to the implementation of the word under your cursor.
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        -- Jump to the type of the word under your cursor.
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [d]efinition")
        -- Fuzzy find all the symbols (variables, functions, types...) in your current document.
        map("<leader>os", require("telescope.builtin").lsp_document_symbols, "[O]pen document [s]ymbols")
        -- Fuzzy find all the symbols in your current workspace.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [s]ymbols")
        -- Rename the variable under your cursor.
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        -- Execute a code action
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [a]ction")
        -- Opens a popup that displays documentation about the word under your cursor
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Highlight references of the word under your cursor when your cursor rests there for a little while
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("default-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          -- Clear reference highlighting
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("default-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "default-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        -- Enable inlay hints in your code, if there's language server support
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            ---@diagnostic disable-next-line: missing-parameter
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    -- NOTE: LSP servers and clients are able to communicate to each other what features they support
    -- By default, Neovim doesn't support everything that is in the LSP specification
    -- `nvim-cmp`, `luasnip` and so on give more capabilities to Neovim

    -- Create new capabilities with nvim cmp, and then broadcast to the servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      ts_ls = {},
      tailwindcss = {},
      eslint = {},
      cssls = {},
      html = {},
      intelephense = {}, -- PHP
      glsl_analyzer = {},
      pyright = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- Disable `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      -- gopls = {},
    }
    local ensure_installed = vim.tbl_keys(servers or {})
    ---@diagnostic disable-next-line: missing-fields
    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
