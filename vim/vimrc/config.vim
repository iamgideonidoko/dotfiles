scriptencoding utf-8

" Mirrors ~/dotfiles/nvim as faithfully as possible in plain Vim 9.
" Plugin manager : vim-jetpack (lazy + auto-install)
" Target         : Vim 9.1+ with +channel +job +termguicolors (e.g. Homebrew vim)
" Optional deps  : node/npm (coc.nvim), ripgrep, fzf, lazygit
"
" Neovim-only plugins without perfect Vim ports (intentionally skipped):
"   oil.nvim          -> netrw (kept enabled; maps `-` to :Explore just like oil)
"   telescope.nvim    -> fzf.vim (same fuzzy UX, different commands)
"   nvim-lspconfig    -> coc.nvim (closest LSP/completion story in vim)
"   blink.cmp         -> coc.nvim
"   nvim-treesitter   -> vim-polyglot (regex-based syntax packs)
"   nvim-ufo          -> vim built-in folding (foldmethod=indent / marker)
"   dashboard-nvim    -> vim-startify
"   persistence.nvim  -> vim-obsession (+ startify sessions)
"   gitsigns.nvim     -> vim-gitgutter + vim-fugitive
"   git-conflict.nvim -> conflict-marker.vim
"   indent-blankline  -> indentLine
"   nvim-colorizer    -> vim-css-color

" OPT-IN FEATURE FLAGS
"
" Edit these (or override them in ~/.vimrc.local which is sourced below) to
" toggle heavyweight features on this machine without touching dotfiles.
"
"   g:vimrc_use_ai = 1  -> load coc.nvim LSP/completion (default: off)
let g:vimrc_use_ai = get(g:, 'vimrc_use_ai', 0)

" Machine-local overrides (not version controlled): belongs in ~/.vimrc.local.
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
  let g:vimrc_use_ai = get(g:, 'vimrc_use_ai', 0)
endif

let g:autoformat = get(g:, 'autoformat', 0)
let mapleader = ' '
let maplocalleader = ' '
