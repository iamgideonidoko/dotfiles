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
				-- You can use a sub-list to tell conform to run *until* a formatter is found.
				javascript = {
					{
						"prettierd" --[[, "prettier"]],
					},
				},
				html = { "htmlbeautifier" },
			}
			local js_related_language = require("utils").js_related_languages
			for _, language in ipairs(js_related_language) do
				formatters[language] = {
					{
						"prettierd" --[[, "prettier"]],
					},
				}
			end

			require("conform").setup({
				notify_on_error = false,
				format_on_save = false,
				-- format_on_save = function(bufnr)
				-- 	-- Disable "format_on_save lsp_fallback" for languages that don't
				-- 	-- have a well standardized coding style. You can add additional
				-- 	-- languages here or re-enable it for the disabled ones.
				-- 	local disable_filetypes = { c = true, cpp = true }
				-- 	return {
				-- 		timeout_ms = 500,
				-- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				-- 	}
				-- end,
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
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
