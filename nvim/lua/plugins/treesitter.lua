return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
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
      },
      indent = { enable = true, disable = { "ruby" } },
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
      vim.keymap.set({ "x", "o" }, "af", function()
        ts_select.select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        ts_select.select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        ts_select.select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        ts_select.select_textobject("@class.inner", "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        ts_select.select_textobject("@local.scope", "locals")
      end)

      local ts_move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        ts_move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        ts_move.goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]o", function()
        ts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        ts_move.goto_next_start("@local.scope", "locals")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function()
        ts_move.goto_next_start("@fold", "folds")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        ts_move.goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        ts_move.goto_next_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        ts_move.goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        ts_move.goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        ts_move.goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        ts_move.goto_previous_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]d", function()
        ts_move.goto_next("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[d", function()
        ts_move.goto_previous("@conditional.outer", "textobjects")
      end)

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      local ts_swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>a", function()
        ts_swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>A", function()
        ts_swap.swap_previous("@parameter.outer")
      end)
    end,
  },
}
