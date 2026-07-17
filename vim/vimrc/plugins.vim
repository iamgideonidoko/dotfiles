scriptencoding utf-8

call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}

" LSP & Completion (mirrors nvim-lspconfig + blink.cmp + friendly-snippets)
if g:vimrc_use_coc
  Jetpack 'neoclide/coc.nvim', {'branch': 'release'}
endif

" Fuzzy Finder (mirrors telescope.nvim + plenary + telescope-fzf-native + ui-select)
Jetpack 'junegunn/fzf', {'do': { -> fzf#install() } }
Jetpack 'junegunn/fzf.vim'

" Git (mirrors gitsigns.nvim + git-conflict.nvim)
Jetpack 'tpope/vim-fugitive'
Jetpack 'airblade/vim-gitgutter'
Jetpack 'rhysd/conflict-marker.vim'

" Text Manipulation (mirrors mini.surround + nvim-autopairs + nvim-ts-autotag)
Jetpack 'tpope/vim-surround'
Jetpack 'tpope/vim-repeat'
Jetpack 'jiangmiao/auto-pairs'
Jetpack 'alvan/vim-closetag', {'for': ['html', 'xml', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'jsx', 'tsx']}

" Navigation & UI (mirrors mini.statusline + which-key.nvim + highlight yank)
Jetpack 'itchyny/lightline.vim'
Jetpack 'liuchengxu/vim-which-key'
Jetpack 'machakann/vim-highlightedyank'

" Language Support (mirrors nvim-treesitter + nvim-ts-autotag + nvim-colorizer)
Jetpack 'sheerun/vim-polyglot'
Jetpack 'ap/vim-css-color'
Jetpack 'Yggdroot/indentLine'
Jetpack 'tpope/vim-sleuth'
Jetpack 'iamcco/markdown-preview.nvim', {'for': 'markdown', 'do': 'call mkdp#util#install()'}

" Utilities
Jetpack 'mbbill/undotree', {'on': 'UndotreeToggle'}
Jetpack 'tpope/vim-unimpaired'
Jetpack 'wellle/targets.vim'
Jetpack 'romainl/vim-cool'
Jetpack 'tpope/vim-eunuch'

" Sessions & Dashboard (mirrors persistence.nvim + dashboard-nvim)
Jetpack 'tpope/vim-obsession'
Jetpack 'mhinz/vim-startify'

" Tmux integration (mirrors vim-tmux-navigator)
Jetpack 'christoomey/vim-tmux-navigator'

" AI (mirrors copilot.lua + copilot-cmp)
if g:vimrc_use_copilot
  Jetpack 'github/copilot.vim'
endif

" Time tracking
Jetpack 'wakatime/vim-wakatime'

" Icons (must load late so it can patch other plugins)
Jetpack 'ryanoasis/vim-devicons'

" Colorscheme (mirrors rose-pine/neovim)
Jetpack 'rose-pine/vim', {'as': 'rosepine'}

call jetpack#end()
