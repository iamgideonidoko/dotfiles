local U = require("utils")
-- [[Autocommands (see `:help lua-guide-autocommands`)]]

-- Highlight when yanking (copying) text (see `:help vim.highlight.on_yank()`)
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- EslintFixAll
-- Check if the ESLint fix command exists when a buffer is read and init keybinding if true
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("custom-buffer-eslint-fix", { clear = true }),
	callback = function()
		vim.defer_fn(function()
			if U.command_exists("EslintFixAll") then
				if not U.check_keybinding_exists("n", "<leader>fe") then
					vim.keymap.set("n", "<leader>fe", function()
						vim.cmd("EslintFixAll")
					end, { desc = "[F]ix [E]SLint" })
				end
			else
				if U.check_keybinding_exists("n", "<leader>fe") then
					vim.api.nvim_del_keymap("n", "<leader>fe")
				end
			end
		end, 500)
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("delete_e211_buffers", { clear = true }),
	callback = function()
		-- Get the file path of the current buffer
		local path = vim.api.nvim_buf_get_name(0)
		-- Check if the path is empty
		if path == "" then
			-- The buffer does not have a file path
			return
		end

		-- Check if the file path exists
		local stat = vim.loop.fs_stat(path)
		if stat then
			-- The current buffer file path is valid
			return
		end
		local cwd = vim.fn.getcwd()
		-- Ensure that the file path is normalized and absolute
		local normalized_path = vim.fn.fnamemodify(path, ":p")
		-- print("path: ", path, "normalized path: ", normalized_path)
		-- Check if the file path starts with the current working directory
		if normalized_path:sub(1, #cwd) ~= cwd then
			return
		end
    -- Make exceptions for RestNvim buffer
		if string.find(normalized_path, "rest_nvim") then
			return
		end
		-- The current buffer file path is not valid so delete buffer
		U.smart_close_buffer(true)
	end,
})

-- vim: ts=2 sts=2 sw=2 et
