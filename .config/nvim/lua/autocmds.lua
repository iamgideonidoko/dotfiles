local utils = require("utils")

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Add keybinding if `EslintFixAll` is executable
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("custom-buffer-eslint-fix", { clear = true }),
	callback = function()
		vim.defer_fn(function()
			if utils.command_exists("EslintFixAll") then
				if not utils.check_keybinding_exists("n", "<leader>fe") then
					vim.keymap.set("n", "<leader>fe", function()
						vim.cmd("EslintFixAll")
					end, { desc = "[F]ix [E]SLint" })
				end
			else
				if utils.check_keybinding_exists("n", "<leader>fe") then
					vim.api.nvim_del_keymap("n", "<leader>fe")
				end
			end
		end, 500)
	end,
})

-- Delete buffers that return E211 i.e file no longer available
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("delete_e211_buffers", { clear = true }),
	callback = function()
		local file_path = vim.api.nvim_buf_get_name(0)
		if file_path == "" then
			return
		end
		-- Check if the file path exists
		local stat = vim.loop.fs_stat(file_path)
		if stat then
			-- The current buffer file path is valid
			return
		end
		local cwd = vim.fn.getcwd()
		-- Ensure that the file path is normalized and absolute
		local normalized_path = vim.fn.fnamemodify(file_path, ":p")
		-- Check if the file path starts with the current working directory
		if normalized_path:sub(1, #cwd) ~= cwd then
			return
		end
		-- Make exceptions for RestNvim buffer
		if string.find(normalized_path, "rest_nvim") then
			return
		end
		-- The current buffer file path is not valid so delete buffer
		-- close_buffer(true)
	end,
})

-- Immediately close buffer of deleted file via oil.nvim
vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(args)
		local parse_url = function(url)
			return url:match("^.*://(.*)$")
		end
		if args.data.err then
			return
		end
		for _, action in ipairs(args.data.actions) do
			if action.type == "delete" and action.entry_type == "file" then
				local path = parse_url(action.url)
				local bufnr = vim.fn.bufnr(path)
				if bufnr == -1 then
					return
				end
				-- close_buffer(true, bufnr)
			end
		end
	end,
})

-- Refresh status line on when recording starts and ends
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- vim: ts=2 sts=2 sw=2 et
