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
U.smart_close_buffer = function(force)
	local bufnr = vim.api.nvim_get_current_buf()
	if not force and vim.api.nvim_buf_get_option(bufnr, "modified") then
		return vim.api.nvim_err_writeln("Buffer is modified. Force required.")
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

return U

-- vim: ts=2 sts=2 sw=2 et
