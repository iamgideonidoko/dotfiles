return {
  "tpope/vim-dadbod",
  dependencies = {
    { "kristijanhusak/vim-dadbod-ui", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DB",
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
    "DBUIRenameBuffer",
    "DBUILastQueryInfo",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_winwidth = 30
    vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_disable_mappings = 0

    local function map(mode, lhs, rhs, opts)
      local options = { noremap = true, silent = true }
      if opts then
        options = vim.tbl_extend("force", options, opts)
      end
      vim.keymap.set(mode, lhs, rhs, options)
    end

    map("n", "<leader>Db", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
    map("n", "<leader>Df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
    map("n", "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Rename DB buffer" })
    map("n", "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", { desc = "Last query info" })
    map("v", "<leader>De", "<cmd>DBUIExecuteQuery<cr>", { desc = "Execute selected query" })
    map("n", "<leader>De", "<cmd>DBUIExecuteQuery<cr>", { desc = "Execute query" })

    local function quick_connect()
      local db_name = vim.fn.input("Database name: ")
      if db_name ~= "" then
        vim.cmd("DB " .. db_name)
      end
    end
    vim.api.nvim_create_user_command("QuickConnect", quick_connect, {})
    vim.keymap.set("n", "<leader>Dc", quick_connect, { desc = "Quick database connect" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        require("cmp").setup.buffer({
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
            { name = "luasnip" },
          },
        })
      end,
    })

    -- Custom database connections (examples)
    -- vim.g.dbs = {
    --   postgres_local = "postgresql://username:password@localhost:5432/database_name",
    --   mysql_local = "mysql://username:password@localhost:3306/database_name",
    --   sqlite_local = "sqlite:" .. vim.fn.expand("~/path/to/database.db"),
    --   sqlserver_local = "sqlserver://username:password@localhost:1433/database_name",
    -- }
  end,
}
