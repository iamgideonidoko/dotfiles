return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "rshkarin/mason-nvim-lint",
  },
  config = function()
    local linters = {
      python = { "flake8" },
      lua = { "luacheck" },
      go = { "golangcilint" },
    }

    local js_related_language = require("utils").js_related_languages
    for _, language in ipairs(js_related_language) do
      linters[language] = { "eslint_d" }
    end

    local lint = require("lint")

    lint.linters.eslint_d = require("lint.linters.eslint_d")

    lint.linters.eslint_d.condition = function(ctx)
      local root_files = {
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
      local root = vim.fs.root(ctx.filename, root_files)
      return root ~= nil
    end

    lint.linters_by_ft = linters

    local skip_ft = {
      sh = true,
      bash = true,
      zsh = true,
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local timer = nil
    local function debounce_lint()
      if timer then
        timer:stop()
        timer:close()
      end
      timer = vim.uv.new_timer()
      timer:start(
        300,
        0,
        vim.schedule_wrap(function()
          timer:stop()
          timer:close()
          timer = nil
          local ft = vim.bo.filetype
          if not skip_ft[ft] then
            lint.try_lint()
          end
        end)
      )
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "TextChanged", "InsertLeave" }, {
      group = lint_augroup,
      callback = debounce_lint,
    })

    require("mason-nvim-lint").setup({
      ignore_install = { "clippy" },
    })
  end,
}
