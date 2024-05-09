local M = {}

-- In order to disable a default keymap, use
-- M.disabled = {
--   n = {
--       ["<leader>h"] = "",
--       ["<C-a>"] = ""
--   }
-- }

M.general = {
  n = {
    ["<C-h>"] = { "<cmd>TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd>TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd>TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd>TmuxNavigateUp<CR>", "window up" }
  }
}

-- Your custom mappings
M.custom = {
  -- Normal mode
  n = {
    -- Eslint
    ["<leader>le"] = {"<cmd>EslintFixAll<CR>", "Run ESLint fix" },

    -- REST.NVIM
    -- Finder & related actions
    ["<leader>rr"] = {"<Plug>RestNvim", "Run request under cursor" },
    ["<leader>rp"] = {"<Plug>RestNvimPreview", "Preview request cURL command" },

    -- LSPSAGA
    -- Finder & related actions
    ["<leader>lff"] = {"<cmd>Lspsaga finder<CR>", "Open finder" },
    ["<leader>lfc"] = {"<cmd>Lspsaga code_action<CR>", "Perform code action" },
    ["<leader>lfo"] = {"<cmd>Lspsaga outline<CR>", "Outline" },
    ["<leader>lfr"] = {"<cmd>Lspsaga rename<CR>", "Rename" },
    ["<leader>lfl"] = {"<cmd>Lspsaga open_log<CR>", "Open Lspsaga log" },
    -- Diagnostics
    ["<leader>ldp"] = {"<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostics" },
    ["<leader>ldn"] = {"<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostics" },
    ["<leader>ldc"] = {"<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show cursor diagnostics" },
    ["<leader>ldb"] = {"<cmd>Lspsaga show_buf_diagnostics<CR>", "Show buffer diagnostics" },
    ["<leader>ldl"] = {"<cmd>Lspsaga show_line_diagnostics<CR>", "Show line diagnostics" },
    ["<leader>ldw"] = {"<cmd>Lspsaga show_workspace_diagnostics<CR>", "Show workspace diagnostics" },
    -- Toggle
    ["<leader>ltt"] = {"<cmd>Lspsaga term_toggle<CR>", "Toggle terminal" },
    ["<leader>ltw"] = {"<cmd>Lspsaga winbar_toggle<CR>", "Toggle winbar" },
    -- Locate Definition
    ["<leader>lgd"] = {"<cmd>Lspsaga goto_definition<CR>", "Go to definition" },
    ["<leader>lgt"] = {"<cmd>Lspsaga goto_type_definition<CR>", "Go to type definition" },
    -- Peek Definition
    ["<leader>lpd"] = {"<cmd>Lspsaga peek_definition<CR>", "Peek definition" },
    ["<leader>lpt"] = {"<cmd>Lspsaga peek_type_definition<CR>", "Peek type definition" },
    ["<leader>lph"] = {"<cmd>Lspsaga hover_doc<CR>", "Peek type in hover" },

    -- DAP
    ["<leader>drd"] = {"<cmd> DapToggleBreakpoint <CR>", "Add breakpoint at line" },
    ["<leader>drr"] = {"<cmd> DapContinue <CR>", "Start or continue the debugger" },

  },
}

return M
