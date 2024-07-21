local U = {}

local function get_loaded_buffers()
	local result = {}
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			table.insert(result, buf)
		end
	end
	return result
end

U.js_related_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
	"angular",
}

-- Delete a buffer without closing splits
-- Switch a loaded alt buffer
U.smart_close_buffer = function(force, given_bufnr)
	local bufnr = given_bufnr or vim.api.nvim_get_current_buf()
	if not force and vim.api.nvim_buf_get_option(bufnr, "modified") then
		return vim.api.nvim_err_writeln("Buffer is modified. Force required.")
	end
	if not force and vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
		return vim.api.nvim_err_writeln("Buffer is a terminal. Force required.")
	end
	-- Alternate bufnr
	---@diagnostic disable: param-type-mismatch
	local alt_bufnr = vim.fn.bufnr("#")
	local alt_bufnr_active = alt_bufnr ~= -1 and vim.fn.bufloaded(alt_bufnr) == 1
	-- Next bufnr
	local loaded_buffers = get_loaded_buffers()
	local next_bufnr = nil
	local found_current = false
	for _, buf in ipairs(loaded_buffers) do
		if found_current then
			next_bufnr = buf
			break
		end
		if buf == bufnr then
			found_current = true
		end
	end
	if #loaded_buffers > 1 and not next_bufnr then
		-- The next loaded buffer is likely the first
		for _, buf in ipairs(loaded_buffers) do
			next_bufnr = buf
			break
		end
	end
	-- Loop through all windows that is displaying the current buffer
	for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
		if alt_bufnr_active then
			vim.api.nvim_win_set_buf(win, alt_bufnr)
		elseif next_bufnr then
			vim.api.nvim_win_set_buf(win, next_bufnr)
		else
			-- Set window buffer to a new empty buffer
			vim.api.nvim_win_set_buf(win, vim.api.nvim_create_buf(false, true))
		end
	end
	-- Finally, delete the original buffer
	vim.api.nvim_buf_delete(bufnr, { force = force })
end

U.check_keybinding_exists = function(mode, lhs)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in pairs(keymaps) do
		---@diagnostic disable: undefined-field
		if keymap.lhs == lhs then
			return true
		end
	end
	return false
end

U.command_exists = function(name)
	return vim.api.nvim_get_commands({})[name] ~= nil
end

--- Adds an empty line either above or below the current line
--- @param to_below boolean
--- @return nil
U.add_empty_line = function(to_below)
	local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
	if to_below then
		vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { "" }) -- Insert an empty line below the current line
	else
		vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, { "" }) -- Insert an empty line above the current line
	end
end

return U

-- vim: ts=2 sts=2 sw=2 et
