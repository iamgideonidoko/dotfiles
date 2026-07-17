return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  dependencies = {
    "mason-org/mason.nvim",
    "zapling/mason-conform.nvim",
  },
  config = function()
    local formatters = {
      lua = { "stylua" },
      php = { "php_cs_fixer" },
      python = { "black" },
      sql = { "pg_format" },
      go = { "goimports" },
      rust = { "rustfmt" },
    }
    local utils = require("utils")
    local js_related = utils.js_related_languages or {}
    local prettier_fts = vim.tbl_values(js_related)
    vim.list_extend(prettier_fts, {
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
    for _, ft in ipairs(prettier_fts) do
      formatters[ft] = {
        "prettierd",
      }
    end

    for _, ft in ipairs({ "sh", "bash", "zsh" }) do
      formatters[ft] = {
        "shfmt",
      }
    end

    require("conform").setup({
      notify_on_error = false,
      notify_no_formatters = false,
      format_on_save = function(bufnr)
        if not vim.g.autoformat then
          return
        end

        local max_filesize = 500 * 1024 -- 500 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return
        end

        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 1000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          quiet = true,
        }
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
  end,
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "[f]or[m]at buffer",
    },
    {
      "<leader>Ta",
      function()
        vim.g.autoformat = not vim.g.autoformat
        print("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
      end,
      desc = "[T]oggle [a]utoformat",
    },
  },
}
