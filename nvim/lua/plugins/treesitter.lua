local utils = require("utils")

local languages = {
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "vim",
  "vimdoc",
  "javascript",
  "typescript",
  "http",
  "json",
  "tsx",
  "glsl",
  "xml",
  "graphql",
  "regex",
}

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("BigFileCheck", { clear = true }),
  pattern = "*",
  callback = function(event)
    local max_filesize = 500 * 1024 -- 500 KB
    local ok, stats = pcall(vim.uv.fs_stat, event.match)
    if ok and stats and stats.size > max_filesize then
      vim.b[event.buf].bigfile = true
      vim.cmd("syntax off")
    end
  end,
})

local function cleanup_legacy_install(plugin_dir)
  for _, path in ipairs({
    vim.fs.joinpath(plugin_dir, "parser"),
    vim.fs.joinpath(plugin_dir, "parser-info"),
    vim.fs.joinpath(plugin_dir, "queries"),
  }) do
    if vim.uv.fs_stat(path) then
      vim.fn.delete(path, "rf")
    end
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    branch = "main",
    build = ":TSUpdate",
    opts = {
      ensure_installed = languages,
      highlight = {
        enable = true,
        disable = function(_, buf)
          return vim.b[buf].bigfile
        end,
      },
      indent = {
        enable = true,
        disable = { "ruby" },
      },
    },
    config = function(plugin, opts)
      local nvim_treesitter = require("nvim-treesitter")
      local install = require("nvim-treesitter.install")

      cleanup_legacy_install(plugin.dir)

      install.prefer_git = true
      install.compilers = { "gcc", "clang" }
      vim.treesitter.language.register("json", "jsonc")

      nvim_treesitter.setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          select_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
        },
        move = {
          set_jumps = true,
        },
      })

      local ts_select = require("nvim-treesitter-textobjects.select")
      utils.safe_map({ "x", "o" }, "af", function()
        ts_select.select_textobject("@function.outer", "textobjects")
      end, { desc = "Select around function" })
      utils.safe_map({ "x", "o" }, "if", function()
        ts_select.select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inside function" })
      utils.safe_map({ "x", "o" }, "ac", function()
        ts_select.select_textobject("@class.outer", "textobjects")
      end, { desc = "Select around class" })
      utils.safe_map({ "x", "o" }, "ic", function()
        ts_select.select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inside class" })

      local ts_move = require("nvim-treesitter-textobjects.move")
      utils.safe_map({ "n", "x", "o" }, "]m", function()
        ts_move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      utils.safe_map({ "n", "x", "o" }, "[m", function()
        ts_move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      utils.safe_map({ "n", "x", "o" }, "]M", function()
        ts_move.goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })
      utils.safe_map({ "n", "x", "o" }, "[M", function()
        ts_move.goto_previous_end("@function.outer", "textobjects")
      end, { desc = "Previous function end" })
      utils.safe_map({ "n", "x", "o" }, "]]", function()
        ts_move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      utils.safe_map({ "n", "x", "o" }, "[[", function()
        ts_move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous class start" })

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      utils.safe_map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
      utils.safe_map(
        { "n", "x", "o" },
        ",",
        ts_repeat_move.repeat_last_move_previous,
        { desc = "Repeat last move previous" }
      )
      utils.safe_map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, desc = "Builtin f move" })
      utils.safe_map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, desc = "Builtin F move" })
      utils.safe_map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, desc = "Builtin t move" })
      utils.safe_map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, desc = "Builtin T move" })

      local ts_swap = require("nvim-treesitter-textobjects.swap")
      utils.safe_map("n", "[x", function()
        ts_swap.swap_next("@parameter.inner")
      end, { desc = "Swap parameter with next" })
      utils.safe_map("n", "]x", function()
        ts_swap.swap_previous("@parameter.outer")
      end, { desc = "Swap parameter with previous" })
    end,
  },
}
