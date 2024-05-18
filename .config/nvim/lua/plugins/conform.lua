return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		dependencies = {
			-- Dependencies for managing formatters
			"williamboman/mason.nvim",
			"zapling/mason-conform.nvim",
		},
		config = function()
			local formatters = {
				lua = { "stylua" },
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
				-- You can use a sub-list to tell conform to run *until* a formatter is found.
				formatters[language] = {
					{
						"prettierd" --[[, "prettier"]],
					},
				}
			end

			require("conform").setup({
				notify_on_error = false,
				-- format_on_save = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					if vim.g.autoformat then
						return {
							timeout_ms = 500,
							lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
						}
					else
						return false
					end
				end,
				formatters_by_ft = formatters,
			})
			-- Close the gap between `mason.nvim` and `conform.nvim` ensuring specified formatters are installed
			require("mason-conform").setup()
		end,
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]or[m]at buffer",
			},
			{
				"<leader>ta",
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
	},
}

-- vim: ts=2 sts=2 sw=2 et
