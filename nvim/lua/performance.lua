-- PERFORMANCE PROFILING & MONITORING UTILITIES
-- Use these commands to diagnose performance issues:
-- :lua require('performance').profile_startup()
-- :lua require('performance').profile_plugins()
-- :lua require('performance').check_slow_plugins()
local M = {}

-- Profile startup time
function M.profile_startup()
  vim.cmd("profile start /tmp/nvim-startup.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
  print("Profiling started. Restart nvim and check /tmp/nvim-startup.log")
end

-- Show plugin load times
function M.profile_plugins()
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  print(string.format("Loaded %d/%d plugins in %sms", stats.loaded, stats.count, ms))

  vim.cmd("Lazy profile")
end

-- Check for slow plugins (>20ms load time)
function M.check_slow_plugins()
  local lazy = require("lazy")
  local plugins = lazy.plugins()
  local slow = {}

  for _, plugin in ipairs(plugins) do
    if plugin._.loaded and plugin._.loaded.time then
      local time = plugin._.loaded.time
      if time > 20 then
        table.insert(slow, { name = plugin.name, time = time })
      end
    end
  end

  table.sort(slow, function(a, b)
    return a.time > b.time
  end)

  if #slow > 0 then
    print("Slow plugins (>20ms):")
    for _, p in ipairs(slow) do
      print(string.format("  %s: %.2fms", p.name, p.time))
    end
  else
    print("No slow plugins detected!")
  end
end

-- Show memory usage
function M.show_memory()
  local mem = vim.loop.resident_set_memory() / 1024 / 1024
  print(string.format("Memory usage: %.2f MB", mem))
end

-- Profile function execution
function M.profile_function(fn, name)
  local start = vim.loop.hrtime()
  fn()
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(string.format("%s took %.2fms", name or "Function", elapsed))
end

-- Benchmark buffer operations
function M.benchmark_buffer()
  -- Test buffer creation
  M.profile_function(function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_delete(buf, { force = true })
  end, "Buffer creation")

  -- Test setting lines
  M.profile_function(function()
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    for i = 1, 1000 do
      lines[i] = "Line " .. i
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_delete(buf, { force = true })
  end, "Setting 1000 lines")
end

-- Clear all caches
function M.clear_caches()
  vim.cmd("LuaCacheClear")
  require("lazy").clear()
  print("Caches cleared!")
end

return M
