return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- run when plugin is installed
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1 -- install only when make can be run
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<c-l>"] = false,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<c-d>"] = function(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)
              if picker.prompt_title == "Buffers" then
                actions.delete_buffer(prompt_bufnr)
              end
            end,
          },
        },
        -- file_ignore_patterns = { "node_modules", ".git", ".next", ".nx" },
      },
      -- pickers = {}
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Load extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")
    local set = vim.keymap.set
    set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [h]elp" })
    set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [k]eymaps" })
    set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
    set("n", "<leader>fa", function()
      builtin.find_files({ follow = true, no_ignore = true, hidden = true })
    end, { desc = "[F]ind [f]iles" })
    set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [s]elect Telescope" })
    set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [w]ord" })
    set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "[F]ind [c]urrent word" })
    set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [g]rep" })
    set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [d]iagnostics" })
    set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [r]esume" })
    set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind recent files ("." for repeat)' })
    set("n", "<leader>fb", function()
      builtin.buffers({ sort_mru = true, ignore_current_buffer = true, show_all_buffers = true })
    end, { desc = "[F]ind existing [b]uffers" })
    set("n", "<leader>f/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[F]uzzi[/]y search in current buffer" })
    set("n", "<leader>fo", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[F]ind in [o]pen Files" })
    set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
