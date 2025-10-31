return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason.nvim",
    "zapling/mason-conform.nvim",
  },
  config = function()
    local formatters = {
      lua = { "stylua" },
      php = { "php_cs_fixer" },
      python = { "black" },
      sql = { "pg_format" },
      -- go = { "goimports" },
    }
    local js_related_language = require("utils").js_related_languages
    local prettier_supported = vim.tbl_values(js_related_language or {})
    vim.list_extend(prettier_supported, {
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "markdown.mdx",
      "graphql",
      "handlebars",
    })
    for _, language in ipairs(prettier_supported) do
      formatters[language] = {
        "prettierd",
      }
    end

    local shell_languages = { "sh", "bash", "zsh" }
    for _, language in ipairs(shell_languages) do
      formatters[language] = {
        "shfmt",
      }
    end

    require("conform").setup({
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable format on save for the below languages
        local disable_filetypes = { c = true, cpp = true }
        if vim.g.autoformat then
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        else
          return
        end
      end,
      formatters_by_ft = formatters,
      formatters = {
        pg_format = {
          command = "pg_format",
          args = { "--spaces", "2", "-" },
          stdin = true,
        },
      },
    })
    -- Close the gap between `mason.nvim` and `conform.nvim` ensuring specified formatters are installed
    require("mason-conform").setup()
  end,
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[f]or[m]at buffer",
    },
    {
      "<leader>Ta",
      function()
        if vim.g.autoformat then
          vim.g.autoformat = false
          print("Autoformat disabled!")
        else
          vim.g.autoformat = true
          print("Autoformat enabled!")
        end
      end,
      mode = "",
      desc = "[T]oggle [a]utoformat",
    },
  },
}
