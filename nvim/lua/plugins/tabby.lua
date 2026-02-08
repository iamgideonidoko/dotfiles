return {
  "nanozuki/tabby.nvim",
  lazy = false,
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local utils = require("utils")

    local marked_nums_solid = { "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" }

    local debounced_keymap_first_nine_tabs = utils.debounce(function()
      local pre_key = "<leader>t"
      local total_tabs = vim.fn.tabpagenr("$")
      for i = 1, 9 do
        local key = pre_key .. i
        pcall(vim.keymap.del, "n", key)
      end
      if total_tabs == 1 then
        return
      end
      for i = 1, math.min(total_tabs, 9) do
        local key = pre_key .. i
        vim.keymap.set("n", key, function()
          vim.cmd(i .. "tabnext")
        end, { desc = "Go to tab " .. i, noremap = true, silent = true })
      end
    end, 800)
    local theme = {
      fill = "TabLineFill",
      head = { fg = "#7aa2f7", bg = "#1a1b26", style = "italic" },
      current_tab = { fg = "#1a1b26", bg = "#7aa2f7", style = "italic" },
      tab = { fg = "#c0caf5", bg = "#1a1b26", style = "italic" },
      win = { fg = "#1a1b26", bg = "#7aa2f7", style = "italic" },
      tail = { fg = "#7aa2f7", bg = "#1a1b26", style = "italic" },
    }

    require("tabby.tabline").set(function(line)
      return {
        {
          { "  ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab

          -- Clean tab name (remove [n+])
          local name = tab.name()
          local index = string.find(name, "%[%d")
          local tab_name = index and string.sub(name, 1, index - 1) or name

          -- Show modified status if any buffer in tab is modified
          local modified = false
          local win_ids = require("tabby.module.api").get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            local ok, b = pcall(vim.api.nvim_win_get_buf, win_id)
            if ok and vim.api.nvim_get_option_value("modified", { buf = b }) then
              modified = true
              break
            end
          end
          local tab_idx = require("utils").get_tab_index(tab.id)
          return {
            line.sep("", hl, theme.fill),
            tab_idx <= 9 and marked_nums_solid[tab_idx] or "",
            tab_name,
            modified and " " or "",
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          }
        end),
        line.spacer(),
        hl = theme.fill,
      }
    end)

    vim.keymap.set("n", "<leader>tt", function()
      vim.cmd(":$tabnew")
      require("loft.actions").close_buffer({})
    end, { noremap = true, desc = "New tab" })
    vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true, desc = "Close current tab" })
    vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { noremap = true, desc = "Close all other tabs" })
    vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { noremap = true, desc = "Previous tab" })
    vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { noremap = true, desc = "Next tab" })
    vim.keymap.set("n", "<leader>tr", ":Tabby rename_tab ", { noremap = true, desc = "Rename tab" })
    vim.keymap.set("n", "<leader>ft", ":Tabby pick_window<CR>", { noremap = true, desc = "[f]ind [t]ab" })
    vim.keymap.set("n", "<leader>tP", function()
      local idx = vim.fn.tabpagenr()
      if idx == 1 then
        vim.cmd("tabmove $")
      else
        vim.cmd("-tabmove")
      end
      vim.cmd("redrawstatus")
    end, { desc = "Move tab left" })
    vim.keymap.set("n", "<leader>tN", function()
      local idx = vim.fn.tabpagenr()
      local total = vim.fn.tabpagenr("$")
      if idx == total then
        vim.cmd("tabmove 0")
      else
        vim.cmd("+tabmove")
      end
      vim.cmd("redrawstatus")
    end, { desc = "Move tab right" })

    vim.keymap.set("n", "<leader>t_", function()
      if vim.o.showtabline == 2 then
        vim.o.showtabline = 0
      else
        vim.o.showtabline = 2
      end
    end, { desc = "Toggle tabline" })

    local notify_no_alt_tab = function()
      vim.notify("No alternate tab", vim.log.levels.ERROR)
    end
    vim.keymap.set("n", "<leader>ta", function()
      if vim.g.alternate_tabpagenr ~= nil then
        local ok = pcall(function()
          vim.cmd("tabnext " .. vim.g.alternate_tabpagenr)
        end)
        if not ok then
          notify_no_alt_tab()
        end
      else
        notify_no_alt_tab()
      end
    end, { desc = "Go to alternate tab" })
    local group = vim.api.nvim_create_augroup("CustomTabbyAUGroup", { clear = true })
    vim.api.nvim_create_autocmd("TabEnter", {
      group = group,
      callback = function()
        utils.debounce(function()
          require("loft.registry"):resume_update()
        end, 100)()
      end,
    })
    vim.api.nvim_create_autocmd("TabLeave", {
      group = group,
      callback = function()
        require("loft.registry"):pause_update()
        local idx = vim.fn.tabpagenr()
        vim.g.alternate_tabpagenr = idx
      end,
    })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = debounced_keymap_first_nine_tabs,
    })
    vim.api.nvim_create_autocmd("TabNew", {
      group = group,
      callback = debounced_keymap_first_nine_tabs,
    })
    vim.api.nvim_create_autocmd("TabClosed", {
      group = group,
      callback = debounced_keymap_first_nine_tabs,
    })
  end,
}
