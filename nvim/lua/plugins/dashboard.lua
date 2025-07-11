return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local logo = [[
 _____  ___    _______    ______  ___      ___  __     ___      ___
(\"   \|"  \  /"     "|  /    " \|"  \    /"  ||" \   |"  \    /"  |
|.\\   \    |(: ______) // ____  \\   \  //  / ||  |   \   \  //   |
|: \.   \\  | \/    |  /  /    ) :)\\  \/. ./  |:  |   /\\  \/.    |
|.  \    \. | // ___)_(: (____/ //  \.    //   |.  |  |: \.        |
|    \    \ |(:      "|\        /    \\   /    /\  |\ |.  \    /:  |
 \___|\____\) \_______) \"_____/      \__/    (__\_|_)|___|\__/|___|

]]
    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = vim.split("\n\n" .. logo, "\n"),
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
