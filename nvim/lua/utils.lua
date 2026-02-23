local utils = {}

utils.js_related_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
  "angular",
}

utils.check_keybinding_exists = function(mode, lhs)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, keymap in pairs(keymaps) do
    ---@diagnostic disable: undefined-field
    if keymap.lhs == lhs then
      return true
    end
  end
  return false
end

utils.command_exists = function(name)
  return vim.fn.exists(":" .. name) == 2
end

--- Adds an empty line either above or below the current line
--- @param to_below boolean
--- @return nil
utils.add_empty_line = function(to_below)
  local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
  if to_below then
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { "" }) -- Insert an empty line below the current line
  else
    vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, { "" }) -- Insert an empty line above the current line
  end
end

--- Ensure that a function is called only once in a given time frame
---@param func function
---@param timeout number Time in milliseconds
utils.debounce = function(func, timeout)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then
      vim.loop.timer_stop(timer)
    else
      timer = vim.loop.new_timer()
    end
    timer:start(timeout, 0, function()
      vim.schedule(function()
        func(unpack(args))
      end)
    end)
  end
end

--- Get the tab index of the give or current tab
---@param tab_id string|integer?
utils.get_tab_index = function(tab_id)
  local current_tab = tab_id or vim.api.nvim_get_current_tabpage()
  for i, t in ipairs(vim.api.nvim_list_tabpages()) do
    if t == current_tab then
      return i
    end
  end
  return nil
end

--- Get the tab index of the give or current tab
---@param no_multiline boolean?
utils.get_visual_selection = function(no_multiline)
  -- Store current selection in a temporary register without affecting clipboard
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg("z")
  if not text or text == "" then
    return
  end
  text = text:match("^%s*(.-)%s*$") or text
  return no_multiline and text:gsub("%s+", " ") or text
end

---@param mode string|string[]
---@param lhs string
---@param rhs function|string
---@param opts? table
utils.safe_map = function(mode, lhs, rhs, opts)
  pcall(vim.keymap.set, mode, lhs, rhs, opts or { silent = true })
end

--- @param visual_mode boolean
utils.delete_qf_items = function(visual_mode)
  local qf_list = vim.fn.getqflist()
  if #qf_list == 0 then
    return
  end
  local start_idx = vim.fn.line(".")
  local end_idx = start_idx
  if visual_mode then
    vim.cmd("normal! \27")
    start_idx = vim.fn.line("'<")
    end_idx = vim.fn.line("'>")
  end
  for i = end_idx, start_idx, -1 do
    table.remove(qf_list, i)
  end
  vim.fn.setqflist(qf_list, "r")
  if #qf_list > 0 then
    local new_cursor_line = math.min(start_idx, #qf_list)
    vim.api.nvim_win_set_cursor(0, { new_cursor_line, 0 })
  end
end

return utils
