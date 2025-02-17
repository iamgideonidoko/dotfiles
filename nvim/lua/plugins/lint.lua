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
    }
    local js_related_language = require("utils").js_related_languages
    for _, language in ipairs(js_related_language) do
      linters[language] = {
        "eslint_d",
      }
    end
    local lint = require("lint")
    lint.linters_by_ft = linters
    if lint.linters.luacheck then
      lint.linters.luacheck.args = { "--config", "../../.luacheckrc" }
    end
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    -- Bridge between `mason.nvim` and `nvim-lint`
    require("mason-nvim-lint").setup()
  end,
}
