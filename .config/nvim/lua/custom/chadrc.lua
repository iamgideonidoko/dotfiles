---@type ChadrcConfig
local M = {}

M.ui = { theme = "github_dark" }
M.plugins = "custom.plugins" -- Tells NvChad where custom plugin config is located
M.mappings = require "custom.mappings" -- Tells NvChad where custom mappings config is located 

return M
