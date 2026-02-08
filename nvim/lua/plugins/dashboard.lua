return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  priority = 100,
  opts = function()
    local logo = {
      "    ++        ++    " .. "",
      "  ++++++      ++++  " .. "",
      "==+++++++     +=====" .. "",
      "===-++++++    ======" .. "",
      "====-++++++   ======" .. "",
      "------======= ======" .. "",
      "------ =======-=====" .. "",
      "------   ===========" .. "",
      "------    ======----" .. "",
      "------     =======--" .. "",
      "  ::::      ======= " .. "",
      "    ::        =--   " .. "",
      "",
      "",
    }
    local opts = {
      theme = "doom",
      hide = {
        statusline = true,
        tabline = true,
        winbar = true,
      },
      config = {
        header = logo,
        center = {
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          return {
            "󰉋 " .. cwd_name,
          }
        end,
        vertical_center = true,
        center_align = false,
      },
    }
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end
    return opts
  end,
}
