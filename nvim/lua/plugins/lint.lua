return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "rshkarin/mason-nvim-lint",
  },
  config = function()
    local linters = {
      markdown = { "markdownlint" },
      python = { "flake8" },
      lua = { "luacheck" },
      -- go = { "golangcilint" },
    }
    local js_related_language = require("utils").js_related_languages
    for _, language in ipairs(js_related_language) do
      linters[language] = {
        "eslint_d",
      }
    end
    local lint = require("lint")
    local util = require("lspconfig.util")
    lint.linters.eslint_d = {
      name = "eslint_d",
      cmd = "eslint_d",
      stdin = true,
      args = {
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      },
      stream = "stdout",
      ignore_exitcode = true,
      env = nil,
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
        source = "eslint_d",
        severity = vim.diagnostic.severity.WARN,
      }),
      condition = function(ctx)
        local root_file = {
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "eslint.config.ts",
          "eslint.config.mts",
          "eslint.config.cts",
          "package.json",
          ".git",
        }

        local root = util.root_pattern(unpack(root_file))(ctx.filename)
        return root ~= nil
      end,
    }
    lint.linters_by_ft = linters

    -- `.luacheck` config is attempted to be loaded from the current to system root (use below to specify exact)
    -- if lint.linters.luacheck then
    --   lint.linters.luacheck.args = { "--config", "../../.luacheckrc" }
    -- end
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    -- Bridge between `mason.nvim` and `nvim-lint`
    require("mason-nvim-lint").setup()
  end,
}
