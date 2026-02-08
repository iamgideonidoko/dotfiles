return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "rshkarin/mason-nvim-lint",
  },
  config = function()
    local linters = {
      -- markdown = { "markdownlint" },
      python = { "flake8" },
      lua = { "luacheck" },
      go = { "golangcilint" },
      -- rust = { "clippy" }, -- used via rust_analyzer in lspconfig
    }

    local js_related_language = require("utils").js_related_languages
    for _, language in ipairs(js_related_language) do
      linters[language] = {
        "eslint_d",
      }
    end

    local shell_languages = { "sh", "bash", "zsh" }
    for _, language in ipairs(shell_languages) do
      linters[language] = {
        "shellcheck",
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

    -- filetypes to skip linting for (handled by LSP, e.g., bashls)
    local skip_ft = {
      sh = true,
      bash = true,
      zsh = true,
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    
    -- Debounced linting for better performance
    local timer = nil
    local function debounce_lint()
      if timer then
        vim.loop.timer_stop(timer)
      end
      timer = vim.loop.new_timer()
      timer:start(300, 0, vim.schedule_wrap(function()
        local ft = vim.bo.filetype
        if not skip_ft[ft] then
          lint.try_lint()
        end
      end))
    end
    
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      callback = debounce_lint,
    })
    -- Bridge between `mason.nvim` and `nvim-lint`
    require("mason-nvim-lint").setup({
      ignore_install = { "clippy" },
    })
  end,
}
