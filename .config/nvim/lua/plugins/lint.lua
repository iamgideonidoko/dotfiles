return {
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Dependencies for managing linters
			"williamboman/mason.nvim",
			"rshkarin/mason-nvim-lint",
		},
		config = function()
			-- Specify the linters to run (see https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#usage)
			local linters = {
				markdown = { "markdownlint" },
			}

			local js_related_language = require("utils").js_related_languages
			for _, language in ipairs(js_related_language) do
				linters[language] = {
					"eslint_d",
				}
			end

			-- Configure linters
			local lint = require("lint")
			lint.linters_by_ft = linters

			-- Create autocommand which carries out the actual linting on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
			-- Close the gap between `mason.nvim` and `nvim-lint` ensuring specified linters are installed
			require("mason-nvim-lint").setup()
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
