local U = {}
_G.buffer_usage = _G.buffer_usage or {}
U.updating_buffer = false
U.short_updating_buffer = false -- would be reset by the `update_buffer_usage` function

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

-- Function to clean up invalid buffers from the buffer usage list
local function cleanup_buffer_usage()
	-- Filter out invalid buffers
	local valid_buffers = {}
	for _, buf in ipairs(_G.buffer_usage) do
		if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
			table.insert(valid_buffers, buf)
		end
	end
	_G.buffer_usage = valid_buffers
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
	if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
		return vim.api.nvim_err_writeln("Buffer is modified. Force required.")
	end
	if not force and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == "terminal" then
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
	U.updating_buffer = true
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
	cleanup_buffer_usage()
	U.updating_buffer = false
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

U.is_floating_window = function()
	local win_id = vim.api.nvim_get_current_win()
	local win_config = vim.api.nvim_win_get_config(win_id)
	return win_config.relative ~= ""
end

U.is_oil_buffer = function()
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	return filetype == "oil" -- Replace 'oil' with the actual filetype used by oil.nvim
end

U.update_buffer_usage = function()
	if U.is_floating_window() or U.is_oil_buffer() or U.updating_buffer then
		return
	end
	local buf = vim.api.nvim_get_current_buf()
	if U.short_updating_buffer then
		U.short_updating_buffer = false
		return
	end
	-- Remove the buffer if it already exists to push it to the end
	for i, b in ipairs(_G.buffer_usage) do
		if b == buf then
			table.remove(_G.buffer_usage, i)
			break
		end
	end
	-- Insert the buffer at the end (most recently used)
	table.insert(_G.buffer_usage, buf)
end

-- Function to navigate to the next buffer in the most recently used order
U.bnext_mru = function()
	cleanup_buffer_usage()
	-- If there are no buffers or only one buffer, do nothing
	if #_G.buffer_usage <= 1 then
		return
	end

	-- Get the current buffer and find its index in the buffer_usage list
	local current_buf = vim.api.nvim_get_current_buf()
	local current_index
	for i, buf in ipairs(_G.buffer_usage) do
		if buf == current_buf then
			current_index = i
			break
		end
	end

	-- Buffer not found in record
	if current_index == nil then
		return
	end

	-- Calculate the next index in a circular manner
	local next_index = (current_index % #_G.buffer_usage) + 1
	local next_buf = _G.buffer_usage[next_index]

	U.updating_buffer = true
	-- Switch to the next buffer
	vim.api.nvim_set_current_buf(next_buf)
	U.updating_buffer = false
end

-- Function to navigate to the previous buffer in the most recently used order
U.bprev_mru = function()
	cleanup_buffer_usage()
	-- If there are no buffers or only one buffer, do nothing
	if #_G.buffer_usage <= 1 then
		return
	end

	-- Get the current buffer and find its index in the buffer_usage list
	local current_buf = vim.api.nvim_get_current_buf()
	local current_index
	for i, buf in ipairs(_G.buffer_usage) do
		if buf == current_buf then
			current_index = i
			break
		end
	end

	-- Buffer not found in record
	if current_index == nil then
		return
	end

	-- Calculate the previous index in a circular manner
	local prev_index = current_index - 1
	if prev_index < 1 then
		prev_index = #_G.buffer_usage
	end
	local prev_buf = _G.buffer_usage[prev_index]

	U.updating_buffer = true
	-- Switch to the previous buffer
	vim.api.nvim_set_current_buf(prev_buf)
	U.updating_buffer = false
end

return U

-- vim: ts=2 sts=2 sw=2 et
