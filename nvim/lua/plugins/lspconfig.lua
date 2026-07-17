return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = vim.uv.fs_realpath(vim.fn.stdpath("config") .. "/lua") },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("default-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local telescope = require("telescope.builtin")
        map("gd", telescope.lsp_definitions, "[g]oto [d]efinition")
        map("gr", telescope.lsp_references, "[g]oto [r]eferences")
        map("gI", telescope.lsp_implementations, "[g]oto [I]mplementation")
        map("gt", telescope.lsp_type_definitions, "[g]oto [t]ype definition")
        map("<leader>os", telescope.lsp_document_symbols, "[o]pen document [s]ymbols")
        map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("default-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
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

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>Th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [h]ints")
        end
      end,
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- UFO folding support
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local lspconfig = require("lspconfig")

    lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
      capabilities = capabilities,
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "tailwindcss",
        "eslint",
        "cssls",
        "html",
        "intelephense",
        "glsl_analyzer",
        "pyright",
        "lua_ls",
        "gopls",
        "bashls",
        "rust_analyzer",
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({})
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    vim.uv.fs_realpath(vim.fn.stdpath("config") .. "/lua"),
                  },
                },
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
                telemetry = { enable = false },
              },
            },
          })
        end,
        ["rust_analyzer"] = function()
          lspconfig.rust_analyzer.setup({
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = { command = "clippy" },
                procMacro = { enable = true },
                cargo = { allFeatures = true },
              },
            },
          })
        end,
      },
    })
  end,
}
