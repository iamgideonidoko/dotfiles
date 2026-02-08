local utils = require("utils")
return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
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
        "jsonc",
        "tsx",
        "glsl",
        "xml",
        "graphql",
        "regex",
      },
      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = { "ruby" },
        disable = function(lang, buf)
          local max_filesize = 500 * 1024 -- 500 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true, disable = { "ruby" } },
      incremental_selection = { enable = false }, -- Disable if unused
    },
    config = function(_, opts)
      -- Prefer git instead of curl in order to improve connectivity in some environments
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          select_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
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
      -- You can also use captures from other query groups like `locals.scm`
      -- utils.safe_map({ "x", "o" }, "as", function()
      --   ts_select.select_textobject("@local.scope", "locals")
      -- end, { desc = "Select around local scope" })

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
      utils.safe_map({ "n", "x", "o" }, "][", function()
        ts_move.goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next class end" })
      utils.safe_map({ "n", "x", "o" }, "[]", function()
        ts_move.goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous class end" })
      utils.safe_map({ "n", "x", "o" }, "]d", function()
        ts_move.goto_next("@conditional.outer", "textobjects")
      end, { desc = "Next conditional" })
      utils.safe_map({ "n", "x", "o" }, "[d", function()
        ts_move.goto_previous("@conditional.outer", "textobjects")
      end, { desc = "Previous conditional" })
      utils.safe_map({ "n", "x", "o" }, "]o", function()
        ts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
      end, { desc = "Next loop start" })
      utils.safe_map({ "n", "x", "o" }, "]s", function()
        ts_move.goto_next_start("@local.scope", "locals")
      end, { desc = "Next local scope start" })
      utils.safe_map({ "n", "x", "o" }, "]z", function()
        ts_move.goto_next_start("@fold", "folds")
      end, { desc = "Next fold start" })

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      utils.safe_map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
      utils.safe_map(
        { "n", "x", "o" },
        ",",
        ts_repeat_move.repeat_last_move_previous,
        { desc = "Repeat last move previous" }
      )
      -- Make builtin f, F, t, T also repeatable with ; and ,
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
