local U = {}
_G.buffer_usage = _G.buffer_usage or {}
U.updating_buffer = false
U.auto_off_disable_updating_buffer = false -- would be reset by the `update_buffer_usage` function
U.telescope_selection_made = false

local function get_loaded_buffers()
	local result = {}
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if 1 == vim.fn.buflisted(buf) then
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
		if 1 == vim.fn.buflisted(buf) then
			table.insert(valid_buffers, buf)
		end
	end
	_G.buffer_usage = valid_buffers
end

-- @param bufnr number
U.is_buffer_in_other_splits = function(bufnr)
	local current_win = vim.api.nvim_get_current_win()
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		if win ~= current_win then
			local buf = vim.api.nvim_win_get_buf(win)
			if buf == bufnr then
				return true
			end
		end
	end
	return false
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
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	if filetype == "dashboard" then
		local last_buf = _G.buffer_usage[#_G.buffer_usage]
		if last_buf == nil then
			return
		end
		return vim.api.nvim_set_current_buf(last_buf)
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
	local buf = vim.api.nvim_get_current_buf()
	if U.is_floating_window() or U.updating_buffer then
		return
	end
	if U.auto_off_disable_updating_buffer then
		U.auto_off_disable_updating_buffer = false
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
	if 1 ~= vim.fn.buflisted(buf) then
		return
	end
	table.insert(_G.buffer_usage, buf)
end

-- Function to navigate to the next buffer in the most recently used order
U.bnext_mru = function()
	cleanup_buffer_usage()
	if U.is_oil_buffer() then
		return U.smart_close_buffer()
	end
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
	if U.is_oil_buffer() then
		return U.smart_close_buffer()
	end
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

U.mru_sorted_bufnrs = function()
	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end
		if bufnr == vim.api.nvim_get_current_buf() then
			return false -- Exempt current buffer
		end
		return true
	end, vim.api.nvim_list_bufs())
	if not next(bufnrs) then
		print("No buffers found")
		return
	end
	table.sort(bufnrs, function(a, b)
		return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
	end)
	return bufnrs
end

--- @param table table
--- @param value any
U.table_contains = function(table, value)
	for _, buf in ipairs(table) do
		if buf == value then
			return true
		end
	end
	return false
end

--- @param table table
--- @param item any
U.get_table_index = function(table, item)
	for index, value in ipairs(table) do
		if value == item then
			return index
		end
	end
	return nil
end

-- Refresh the buffer manager content/list
local function render_buffers_in_manager()
	if _G.buf_manager_buf_id and vim.api.nvim_buf_is_valid(_G.buf_manager_buf_id) then
		-- Make buffer modifiable to update content
		vim.api.nvim_set_option_value("modifiable", true, {
			buf = _G.buf_manager_buf_id,
		})
		-- Fill the buffer with buffer numbers and file names
		local buf_lines = {}
		for _, buf_id in ipairs(_G.buffer_usage) do
			local buffer = vim.fn.getbufinfo(buf_id)[1]
			if buffer then
				local bufname = buffer.name ~= "" and buffer.name or "[No Name]"
				local bufnr = buffer.bufnr
				local flags = ""
				local is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
				if is_modified then
					flags = flags .. "[+]"
				end
				local relative_path = vim.fn.fnamemodify(bufname, ":.")
				table.insert(buf_lines, string.format("%s%d>%s", flags, bufnr, relative_path))
			end
		end
		-- Set the lines and make buffer non-modifiable again
		vim.api.nvim_buf_set_lines(_G.buf_manager_buf_id, 0, -1, false, buf_lines)
		vim.api.nvim_set_option_value("modifiable", false, {
			buf = _G.buf_manager_buf_id,
		})
	end
end

-- Move the current buffer up in the buffer_usage table
local function move_buffer_in_manager__up()
	local current_line = vim.fn.line(".")
	if #_G.buffer_usage == 0 then
		return
	end
	if current_line > 1 then
		-- Swap the current buffer with the one above
		local temp = _G.buffer_usage[current_line]
		_G.buffer_usage[current_line] = _G.buffer_usage[current_line - 1]
		_G.buffer_usage[current_line - 1] = temp
		vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { current_line - 1, 1 })
	else
		-- If we are at the first line, move it to the last position
		local first_buffer = _G.buffer_usage[1]
		table.remove(_G.buffer_usage, 1)
		table.insert(_G.buffer_usage, first_buffer)
		vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { #_G.buffer_usage, 1 })
	end
	render_buffers_in_manager()
end

-- Move the current buffer down in the buffer_usage table
local function move_buffer_in_manager_down()
	local current_line = vim.fn.line(".")
	if #_G.buffer_usage == 0 then
		return
	end
	if current_line < #_G.buffer_usage then
		-- Swap the current buffer with the one below
		local temp = _G.buffer_usage[current_line]
		_G.buffer_usage[current_line] = _G.buffer_usage[current_line + 1]
		_G.buffer_usage[current_line + 1] = temp
		vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { current_line + 1, 1 })
	else
		-- If we are at the last line, move it to the first position
		local last_buffer = _G.buffer_usage[#_G.buffer_usage]
		table.remove(_G.buffer_usage)
		table.insert(_G.buffer_usage, 1, last_buffer)
		vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { 1, 1 })
	end
	render_buffers_in_manager()
end

local function close_buffer_manager()
	if _G.buf_manager_buf_id and vim.api.nvim_buf_is_valid(_G.buf_manager_buf_id) then
		vim.api.nvim_buf_delete(_G.buf_manager_buf_id, { force = true })
		_G.buf_manager_buf_id = nil
	end
	if _G.buf_manager_win_id and vim.api.nvim_win_is_valid(_G.buf_manager_win_id) then
		vim.api.nvim_win_close(_G.buf_manager_win_id, true)
		_G.buf_manager_win_id = nil
	end
end

local function delete_buffer_in_manager()
	local current_line = vim.fn.line(".")
	if #_G.buffer_usage == 0 then
		return
	end
	local bufnr = _G.buffer_usage[current_line]
	if bufnr == nil then
		return
	end
	U.smart_close_buffer(false, bufnr)
	render_buffers_in_manager()
	local win_config = vim.api.nvim_win_get_config(_G.buf_manager_win_id)
	win_config.height = math.min(#_G.buffer_usage > 0 and #_G.buffer_usage or 1, vim.o.lines - 2)
	vim.api.nvim_win_set_config(_G.buf_manager_win_id, win_config)
end

U.open_buffer_manager = function()
	local last_win_b4_manager = vim.api.nvim_get_current_win()
	local last_buf_b4_manager = vim.api.nvim_get_current_buf()
	_G.buffer_usage = _G.buffer_usage or {}
	cleanup_buffer_usage()
	-- Focus buffer manager window already exists
	if _G.buf_manager_win_id and vim.api.nvim_win_is_valid(_G.buf_manager_win_id) then
		vim.api.nvim_set_current_win(_G.buf_manager_win_id)
		return
	end
	local max_height = vim.o.lines - 2
	local max_width = vim.o.columns - 4
	local win_height = math.min(#_G.buffer_usage > 0 and #_G.buffer_usage or 1, max_height)
	local win_width = math.min(50, max_width)
	_G.buf_manager_buf_id = vim.api.nvim_create_buf(false, true)
	local win_opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = (vim.o.lines - win_height) / 2,
		col = (vim.o.columns - win_width) / 2,
		style = "minimal",
		border = "rounded",
		title = "Buffer Manager",
		title_pos = "center",
		noautocmd = true,
	}
	-- Floating buffer manager
	_G.buf_manager_win_id = vim.api.nvim_open_win(_G.buf_manager_buf_id, true, win_opts)
	vim.api.nvim_set_option_value("cursorline", true, {
		win = _G.buf_manager_win_id,
	})
	vim.api.nvim_set_option_value("modifiable", false, {
		buf = _G.buf_manager_buf_id,
	})
	vim.api.nvim_set_option_value("wrap", false, {
		win = _G.buf_manager_win_id,
	})
	render_buffers_in_manager()
	local last_buf_index = U.get_table_index(_G.buffer_usage, last_buf_b4_manager)
	if last_buf_index then
		vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { last_buf_index, 1 })
	end
	-- Prevent overriding
	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
		group = vim.api.nvim_create_augroup("BufferManagerPreventLoad", { clear = true }),
		callback = function()
			if vim.api.nvim_get_current_win() == _G.buf_manager_win_id then
				local current_buf_id = vim.api.nvim_get_current_buf()
				if current_buf_id ~= _G.buf_manager_buf_id then
					vim.api.nvim_set_current_buf(_G.buf_manager_buf_id)
					if not U.table_contains(_G.buffer_usage, current_buf_id) then
						vim.api.nvim_buf_delete(current_buf_id, { force = true })
					end
				end
			end
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "<C-k>", "", {
		noremap = true,
		silent = true,
		callback = function()
			move_buffer_in_manager__up()
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "k", "", {
		noremap = true,
		silent = true,
		callback = function()
			local current_line = vim.fn.line(".")
			if #_G.buffer_usage == 0 then
				return
			end
			if current_line > 1 then
				vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { current_line - 1, 1 })
			else
				vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { #_G.buffer_usage, 1 })
			end
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "<C-j>", "", {
		noremap = true,
		silent = true,
		callback = function()
			move_buffer_in_manager_down()
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "j", "", {
		noremap = true,
		silent = true,
		callback = function()
			local current_line = vim.fn.line(".")
			if #_G.buffer_usage == 0 then
				return
			end
			if current_line < #_G.buffer_usage then
				vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { current_line + 1, 1 })
			else
				vim.api.nvim_win_set_cursor(_G.buf_manager_win_id, { 1, 1 })
			end
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "<Esc>", "", {
		noremap = true,
		silent = true,
		callback = function()
			close_buffer_manager()
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "<CR>", "", {
		noremap = true,
		silent = true,
		callback = function()
			U.updating_buffer = true
			local current_line = vim.fn.line(".")
			close_buffer_manager()
			local selected_buffer = _G.buffer_usage[current_line]
			if
				selected_buffer ~= nil
				and last_win_b4_manager ~= nil
				and vim.api.nvim_win_is_valid(last_win_b4_manager)
			then
				vim.api.nvim_win_set_buf(last_win_b4_manager, _G.buffer_usage[current_line])
			end
			U.updating_buffer = false
		end,
	})
	vim.api.nvim_buf_set_keymap(_G.buf_manager_buf_id, "n", "<C-d>", "", {
		noremap = true,
		silent = true,
		callback = function()
			delete_buffer_in_manager()
		end,
	})
end

return U

-- vim: ts=2 sts=2 sw=2 et
