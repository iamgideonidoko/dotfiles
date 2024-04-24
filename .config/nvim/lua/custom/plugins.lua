local plugins = {
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function ()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    -- Mason allows us to specify Neovim deps from within Neovim
    -- The benefit of this is that if we move our Neovim configuration to another machine
    -- our deps will come along with it.
    "williamboman/mason.nvim",
    opts = function ()
      local opts = require "plugins.configs.mason"
      opts.ensure_installed = {
        "lua-language-server",
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "phpactor"
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function ()
      require("nvim-ts-autotag").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function ()
      local opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "glsl",
        "pug",
        "markdown",
        "markdown_inline",
        "http",
        "json",
        "prisma",
        "vim",
        "vimdoc"
      }
      return opts
    end
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy"
  },
  {
    "nvimdev/lspsaga.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
        require("lspsaga").setup({})
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional
        "nvim-tree/nvim-web-devicons"     -- optional
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = {
      "http"
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
     require("rest-nvim").setup({
      -- Get config options at: https://github.com/rest-nvim/rest.nvim?tab=readme-ov-file#packernvim
    })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          -- theme = "powerline"
          theme = "gruvbox"
        }
      })
    end
  },
  {
    "codota/tabnine-nvim",
    event = "VeryLazy",
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        -- Options here => https://github.com/codota/tabnine-nvim?tab=readme-ov-file#activate-mandatory
        disable_auto_comment=true,
        accept_keymap="<A-Space>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 1000,
        suggestion_color = {gui = "##768390", cterm = 244},
        exclude_filetypes = {"TelescopePrompt", "NvimTree"},
        log_file_path = nil, -- absolute path to Tabnine log file
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  }
}

return plugins
