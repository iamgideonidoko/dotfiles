" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DO_NOT_BACK_UP_FILE
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mirrors ~/dotfiles/nvim as faithfully as possible in plain Vim 9.
" Plugin manager : vim-jetpack (lazy + auto-install)
" Target         : Vim 9.1+ with +channel +job +termguicolors (e.g. Homebrew vim)
" Optional deps  : node/npm (coc.nvim, copilot.vim), ripgrep, fzf, lazygit
"
" Neovim-only plugins without perfect Vim ports (intentionally skipped):
"   noice.nvim        -> plain vim cmdline/messaging (good enough in modern vim 9)
"   oil.nvim          -> netrw (kept enabled; maps `-` to :Explore just like oil)
"   telescope.nvim    -> fzf.vim (same fuzzy UX, different commands)
"   nvim-lspconfig    -> coc.nvim (the closest LSP/completion story in vim)
"   nvim-cmp          -> coc.nvim
"   nvim-treesitter   -> vim-polyglot (regex-based syntax packs)
"   nvim-ufo          -> vim's built-in folding (foldmethod=indent / marker)
"   dashboard-nvim    -> vim-startify
"   persistence.nvim   -> vim-obsession (+ startify sessions)
"   gitsigns.nvim     -> vim-gitgutter + vim-fugitive
"   git-conflict.nvim -> conflict-marker.vim
"   indent-blankline  -> indentLine
"   nvim-colorizer    -> vim-css-color

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PERFORMANCE OPTIMIZATIONS
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
set lazyredraw
set ttyfast
set synmaxcol=300
set redrawtime=2000
set maxmempattern=5000
set updatetime=200
set timeoutlen=300
set ttimeoutlen=10

" Disable unused built-in plugins for faster startup
let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
" NOTE: netrw is intentionally kept (used as the file explorer, replacing oil.nvim).

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN MANAGEMENT (vim-jetpack)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:jetpackfile = expand('~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim')
let s:jetpackurl  = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if !filereadable(s:jetpackfile)
  call mkdir(fnamemodify(s:jetpackfile, ':h'), 'p')
  let s:cmd = has('win32')
    \ ? 'powershell -Command "Invoke-WebRequest -Uri ''' . s:jetpackurl . ''' -OutFile ''' . s:jetpackfile . '''"'
    \ : 'curl -fsSLo "' . s:jetpackfile . '" "' . s:jetpackurl . '"'
  call system(s:cmd)
  augroup jetpack_bootstrap
    autocmd!
    autocmd VimEnter * call jetpack#sync() | source $MYVIMRC
  augroup END
endif
packadd vim-jetpack

call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}

" LSP & Completion (mirrors nvim-lspconfig + nvim-cmp + LuaSnip + cmp-*)
Jetpack 'neoclide/coc.nvim', {'branch': 'release'}

" Fuzzy Finder (mirrors telescope.nvim + plenary + telescope-fzf-native + ui-select)
Jetpack 'junegunn/fzf', { 'do': { -> fzf#install() } }
Jetpack 'junegunn/fzf.vim'

" Git (mirrors gitsigns.nvim + git-conflict.nvim)
Jetpack 'tpope/vim-fugitive'
Jetpack 'airblade/vim-gitgutter'
Jetpack 'rhysd/conflict-marker.vim'

" Text Manipulation (mirrors mini.surround + Comment.nvim + nvim-autopairs + nvim-ts-autotag)
Jetpack 'tpope/vim-surround'
Jetpack 'tpope/vim-commentary'
Jetpack 'tpope/vim-repeat'
Jetpack 'jiangmiao/auto-pairs'
Jetpack 'alvan/vim-closetag', { 'for': ['html', 'xml', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'jsx', 'tsx'] }

" Navigation & UI (mirrors mini.statusline + which-key.nvim + highlight yank)
Jetpack 'itchyny/lightline.vim'
Jetpack 'liuchengxu/vim-which-key'
Jetpack 'machakann/vim-highlightedyank'

" Language Support (mirrors nvim-treesitter + nvim-ts-autotag + nvim-colorizer)
Jetpack 'sheerun/vim-polyglot'
Jetpack 'ap/vim-css-color'
Jetpack 'Yggdroot/indentLine'
Jetpack 'tpope/vim-sleuth'
Jetpack 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': 'call mkdp#util#install()' }

" Utilities
Jetpack 'mbbill/undotree', { 'on': 'UndotreeToggle' }
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
Jetpack 'github/copilot.vim'

" Time tracking
Jetpack 'wakatime/vim-wakatime'

" Icons (must load late so it can patch other plugins)
Jetpack 'ryanoasis/vim-devicons'

" Colorscheme (mirrors rose-pine/neovim)
Jetpack 'rose-pine/vim', { 'as': 'rosepine' }

call jetpack#end()

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CORE VIM SETTINGS
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set hidden
set autoread
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vim/undodir
set undolevels=10000
set history=1000
set clipboard=unnamed,unnamedplus
set mouse=a
set backspace=indent,eol,start
set nrformats-=octal
set formatoptions+=j
set confirm
set sessionoptions=buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds,terminal

" Visual
set number
set relativenumber
set cursorline
set signcolumn=yes
set showmatch
set matchtime=2
set scrolloff=5
set sidescrolloff=8
set display+=lastline
set cmdheight=1
set shortmess+=sIcC
set noshowmode
set showcmd
set laststatus=2
set showtabline=1
set splitbelow
set splitright
set breakindent
if exists('+smoothscroll')
  set smoothscroll
endif
if exists('+inccommand')
  set inccommand=split
endif
set fillchars=vert:│,fold:─,eob:\ 
set listchars=tab:»\ ,trail:·,extends:❯,precedes:❮,nbsp:␣
set whichwrap+=<,>,[,],h,l

" Cursor shape (block in normal, bar in insert); let the terminal handle it
let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"
set guicursor=n:block,i:ver25
augroup cursor_init
  autocmd!
  autocmd VimEnter * silent! execute 'normal! \<C-L>'
augroup END

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

" Indentation
filetype plugin indent on
syntax enable
set autoindent
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set smarttab

" Completion
set completeopt=menuone,noinsert,noselect
set pumheight=15
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.pyc,*.class
set wildignore+=*/.git/*,*/.svn/*,*/.DS_Store
set wildignore+=*/node_modules/*,*/vendor/*
set wildignore+=*/dist/*,*/build/*,*.lock

" Folding (UFO is nvim-only; rely on built-in folds)
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
set foldenable
set foldcolumn=0

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORSCHEME & HIGHLIGHTS
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors
set background=dark

" Rose Pine variant: 'main' (default), 'moon', 'dawn'
let g:rosepine_variant = 'main'
let g:rosepine_enable_italics = 1
" Transparent background (for terminal transparency; matches nvim styles.transparency)
let g:rosepine_disable_background = 1
let g:rosepine_disable_float_background = 1

augroup colorscheme_overrides
  autocmd!
  autocmd ColorScheme rosepine hi Comment gui=none
augroup END

silent! colorscheme rosepine

" Better diff colors (rose-pine main palette)
hi DiffAdd    guibg=#1e2d22
hi DiffChange guibg=#26233a
hi DiffDelete guifg=#eb6f92 guibg=#2d1b24
hi DiffText   guibg=#383050

" Transparent background for floating windows / separator
hi NormalFloat guibg=#1f1d2e
hi FloatBorder guifg=#6e6a86
hi WinSeparator guifg=#403d52 gui=none

" Better search highlighting
hi Search    guibg=#3d59a1 guifg=#c0caf5
hi IncSearch guibg=#ff9e64 guifg=#1a1b26

" Visual mode selection
hi Visual    guibg=#364a82

" Pmenu (completion menus)
hi Pmenu     guibg=#26233a
hi PmenuSel  guifg=#c0caf5 guibg=#403d52 gui=bold
hi PmenuSbar guibg=#26233a
hi PmenuThumb guibg=#6e6a86

" vim-gitgutter signs
hi GitGutterAdd    guifg=#9ccfd8
hi GitGutterChange guifg=#e0af68
hi GitGutterDelete guifg=#eb6f92
hi link GitGutterAddLine    DiffAdd
hi link GitGutterChangeLine DiffChange
hi link GitGutterDeleteLine DiffDelete

" conflict-marker.vim
hi ConflictMarkerBegin  guibg=#2f2d3e
hi ConflictMarkerOurs    guifg=#eb6f92 guibg=#2d1b24
hi ConflictMarkerTheirs  guifg=#9ccfd8 guibg=#1e2d22
hi ConflictMarkerEnd     guibg=#2f2d3e

" vim-which-key
hi WhichKey         guifg=#c4a7e7 gui=bold
hi WhichKeySeperator guifg=#6e6a86
hi WhichKeyGroup    guifg=#31748f gui=italic
hi WhichKeyDesc     guifg=#c0caf5

" coc.nvim highlights
hi CocFloating      guibg=#1f1d2e
hi CocErrorSign     guifg=#eb6f92
hi CocWarningSign   guifg=#e0af68
hi CocInfoSign      guifg=#9ccfd8
hi CocHintSign      guifg=#c4a7e7
hi CocErrorFloat    guifg=#eb6f92
hi CocWarningFloat  guifg=#e0af68
hi CocInfoFloat     guifg=#9ccfd8
hi CocHintFloat     guifg=#c4a7e7
hi CocHighlightText guibg=#26233a
hi CocUnderline     gui=undercurl guisp=#e0af68

" TODO / FIXME / NOTE highlights (mirrors folke/todo-comments.nvim)
augroup todo_highlights
  autocmd!
  autocmd Syntax * syntax match TodoStatement /\c\<\(TODO\|FIXME\|HACK\|BUG\|XXX\|NOTE\|WARN\|PERF\)/ containedin=.*Comment.*
augroup END
hi TodoStatement guifg=#f6c177 gui=bold

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LEADER & MAPPINGS
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "
let maplocalleader = " "

" Escape (mirrors nvim <M-q> in n/i/c/v)
nnoremap <M-q> <Esc>
inoremap <M-q> <Esc>
vnoremap <M-q> <Esc>
cnoremap <M-q> <Esc>

" Clear search highlight
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <leader><CR> :nohlsearch<CR>

" Center after jumps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap G Gzz

" Movement in insert and terminal mode
inoremap <C-h> <Left>
tnoremap <C-h> <Left>
inoremap <C-l> <Right>
tnoremap <C-l> <Right>
inoremap <C-j> <Down>
tnoremap <C-j> <Down>
inoremap <C-k> <Up>
tnoremap <C-k> <Up>

" Disable arrow keys in normal mode
nnoremap <Left>  :echo "Use h to move!!"<CR>
nnoremap <Right> :echo "Use l to move!!"<CR>
nnoremap <Up>    :echo "Use k to move!!"<CR>
nnoremap <Down>  :echo "Use j to move!!"<CR>

" Disable <C-i>/<C-o> jumplist (matches nvim config)
nnoremap <C-i> <Nop>
nnoremap <C-o> <Nop>

" Insert an empty line above/below the current line (mirrors nvim <M-o>/<M-i>)
nnoremap <silent> <M-o> :call <SID>AddEmptyLine(1)<CR>
nnoremap <silent> <M-i> :call <SID>AddEmptyLine(0)<CR>
function! s:AddEmptyLine(below) abort
  let lnum = line('.')
  if a:below
    call append(lnum, '')
  else
    call append(lnum - 1, '')
  endif
endfunction

" Window Management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>wv <C-w>v
nnoremap <leader>ws <C-w>s
nnoremap <leader>wc <C-w>c
nnoremap <leader>wo <C-w>o
nnoremap <leader>w- <C-w>-
nnoremap <leader>w+ <C-w>+
nnoremap <leader>w= <C-w>=

" Resize windows (mirrors nvim: <M-]> wider, <M-[> narrower, <M-}> taller, <M-{> shorter)
nnoremap <M-]> <C-w>5>
nnoremap <M-[> <C-w>5<
nnoremap <M-}> <C-w>+
nnoremap <M-{> <C-w>-

" Buffer Management
nnoremap <silent> <leader>x :bdelete<CR>
nnoremap <silent> <leader>X :bdelete!<CR>
nnoremap <silent> <Tab>    :bnext<CR>
nnoremap <silent> <S-Tab>  :bprevious<CR>

" Toggle statusline (mirrors nvim <leader>_)
nnoremap <silent> <leader>_ :call <SID>ToggleStatusline()<CR>
function! s:ToggleStatusline() abort
  if &laststatus == 0
    set laststatus=2
  else
    set laststatus=0
  endif
endfunction

" Tab Management (nvim's <leader>t group)
nnoremap <silent> <leader>tn :tabnew<CR>
nnoremap <silent> <leader>tc :tabclose<CR>
nnoremap <silent> <leader>to :tabonly<CR>
nnoremap <silent> <leader>tf :tabfirst<CR>
nnoremap <silent> <leader>tl :tablast<CR>

" Move lines up/down (matches nvim <M->>/<M-<>) plus <A-j>/<A-k> aliases
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv
inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi

" Duplicate lines
nnoremap <leader>d :t.<CR>
vnoremap <leader>d :t'><CR>gv

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

" Better paste in visual mode (mirrors nvim: yanked text stays in clipboard/unnamed register)
vnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>

" Yank to end of line
nnoremap Y y$

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" QUICKFIX (mirrors nvim <leader>C* group)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> ]q :cnext<CR>zz
nnoremap <silent> [q :cprev<CR>zz
nnoremap <silent> ]l :lnext<CR>zz
nnoremap <silent> [l :lprev<CR>zz

nnoremap <silent> <leader>Co :copen<CR>
nnoremap <silent> <leader>Cn :call <SID>QfWrap('cnext', 'cfirst')<CR>
nnoremap <silent> <leader>Cp :call <SID>QfWrap('cprev', 'clast')<CR>
nnoremap <silent> <leader>Cr :cfdo s//g<Left><Left><Left>
function! s:QfWrap(try_cmd, catch_cmd) abort
  try
    execute a:try_cmd
  catch
    try
      execute a:catch_cmd
    catch
    endtry
  endtry
endfunction

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COC.NVIM CONFIGURATION
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Required extensions (coc will offer to install missing ones on next startup)
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-tailwindcss',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-intelephense',
  \ 'coc-pyright',
  \ 'coc-go',
  \ 'coc-snippets',
  \ 'coc-prettier',
  \ 'coc-highlight',
  \ 'coc-sh',
  \ 'coc-rust-analyzer',
  \ ]

" Manual trigger completion (mirrors vim-cmp <C-a> toggle)
inoremap <silent><expr> <C-space> coc#refresh()

" Use Tab / S-Tab to navigate completion (matches nvim-cmp <Tab>/<S-Tab>)
function! s:CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Confirm completion with <CR>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Snippets (matches nvim LuaSnip jump next/prev)
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" GoTo code navigation (mirrors nvim lspconfig)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gI <Plug>(coc-implementation)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gD <Plug>(coc-declaration)

" Workspace / document symbols
nnoremap <silent> <leader>os :CocList outline<CR>
nnoremap <silent> <leader>ws :CocList -I symbols<CR>

" Diagnostics navigation and float (mirrors nvim keymaps.lua)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nnoremap <silent> <leader>e :call CocActionAsync('diagnosticInfo')<CR>
nnoremap <silent> <leader>q :CocList diagnostics<CR>
nnoremap <silent> <leader>Q :CocList -I diagnostics<CR>

" Documentation
function! s:ShowDocumentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

" Code Actions (mirrors nvim lspconfig)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>cA <Plug>(coc-codeaction-source)
nmap <silent> <leader>cf <Plug>(coc-fix-current)
nmap <silent> <leader>cl <Plug>(coc-codelens-action)
nmap <silent> <leader>rn <Plug>(coc-rename)

" Formatting (mirrors conform.nvim <leader>fm + <leader>F)
nmap <silent> <leader>fm <Plug>(coc-format)
xmap <silent> <leader>fm <Plug>(coc-format-selected)
nmap <silent> <leader>F  <Plug>(coc-format)
xmap <silent> <leader>F  <Plug>(coc-format-selected)

" Selection Ranges (mirrors nvim cmp/lsp range select)
nmap <silent> <leader>cs <Plug>(coc-range-select)
xmap <silent> <leader>cs <Plug>(coc-range-select)

" Lists (mirrors nvim CocList-style keybindings)
nnoremap <silent><nowait> <leader>cc :CocList commands<CR>
nnoremap <silent><nowait> <leader>co :CocList outline<CR>
nnoremap <silent><nowait> <leader>cd :CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>ce :CocList extensions<CR>
nnoremap <silent><nowait> <leader>cS :CocList -I symbols<CR>

" Highlight symbol under cursor (matches nvim CursorHold document_highlight)
augroup coc_highlight_group
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Toggle format on save (mirrors conform's vim.g.autoformat = false + <leader>Ta)
let g:autoformat = 0
nnoremap <silent> <leader>Ta :call <SID>ToggleAutoformat()<CR>
function! s:ToggleAutoformat() abort
  let g:autoformat = !g:autoformat
  echo 'Autoformat ' . (g:autoformat ? 'enabled!' : 'disabled!')
endfunction

" ESLint fix all buffers (mirrors nvim LspEslintFixAll)
nnoremap <silent> <leader>fe :CocCommand eslint.executeAutofix<CR>

" """"
" Status Line Integration
" """"
function! CocCurrentFunction() abort
  return get(b:, 'coc_current_function', '')
endfunction

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF CONFIGURATION
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'FloatBorder'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'],
  \ }

" Use ripgrep if available (matches nvim telescope vimgrep_arguments)
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --no-ignore-vcs --glob "!.git/*"'
        \ . ' --glob "!node_modules/*" --glob "!.venv/*" --glob "!vendor/*"'
        \ . ' --glob "!dist/*" --glob "!build/*" --glob "!coverage/*"'
        \ . ' --glob "!*.lock" --glob "!package-lock.json"'
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

" fzf.vim mappings (aligned to nvim telescope <leader>f* group)
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fa :call fzf#vim#files('', {'options': '--hidden'})<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>/  :Buffers<CR>
nnoremap <silent> <leader>;  :Buffers<CR>
nnoremap <silent> <C-p>      :Files<CR>
nnoremap <silent> <leader>fh :Helptags<CR>
nnoremap <silent> <leader>fk :Maps<CR>
nnoremap <silent> <leader>fg :Rg<CR>
xnoremap <silent> <leader>fg "sy:Rg <C-R>s<CR>
nnoremap <silent> <leader>fc :BLines<CR>
nnoremap <silent> <leader>fd :CocList diagnostics<CR>
nnoremap <silent> <leader>fo :Lines<CR>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>f. :History<CR>
nnoremap <silent> <leader>fn :Files ~/.vim<CR>
nnoremap <silent> <leader>fl :Lines<CR>
nnoremap <silent> <leader>fs :Snippets<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>
nnoremap <silent> <leader>f` :Marks<CR>
nnoremap <silent> <leader>f" :Registers<CR>
nnoremap <silent> <leader>f: :Commands<CR>
nnoremap <silent> <leader>fS :History/<CR>
nnoremap <silent> <leader>fC :History:<CR>

" Search word under cursor (matches nvim <leader>fw / <leader>*)
nnoremap <silent> <leader>fw :Rg <C-R><C-W><CR>
vnoremap <silent> <leader>* "sy:Rg <C-R>s<CR>
nnoremap <silent> <leader>* :Rg <C-R><C-W><CR>

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIT CONFIGURATION
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fugitive mappings (matches nvim git + fugitive functional surface)
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gl :Git log --oneline<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gP :Git pull<CR>
nnoremap <silent> <leader>gf :Git fetch<CR>

" GitGutter signs (mirrors nvim gitsigns signs)
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_preview_win_floating = 1

" GitGutter mappings (mirrors nvim gitsigns <leader>h* + ]c/[c)
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nmap <leader>hS :Git add %<CR>
nmap <leader>hu :Git reset<CR>
nmap <leader>hb :Git blame %<CR>
nmap <leader>hd :Gdiffsplit<CR>
nnoremap <silent> <leader>Tb :GitGutterToggle<CR>

" Text objects for hunks
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" conflict-marker.vim (mirrors git-conflict.nvim); provides [x ]x jumps
let g:conflict_marker_enable_mappings = 1

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NETRW CONFIGURATION (mirrors oil.nvim, '-' to open directory)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_altv = 1
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_winsize = 25

function! s:SetupNetrwMappings() abort
  nmap <buffer> a <C-^>
  nmap <buffer> r <C-L>
  nmap <buffer> q :bd<CR>
  nmap <buffer> ? :let g:netrw_banner = !get(g:, 'netrw_banner', 1)<CR><C-L>
endfunction

augroup netrw_setup
  autocmd!
  autocmd FileType netrw call s:SetupNetrwMappings()
augroup END

nnoremap <silent> - :Explore<CR>

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" WHICH-KEY CONFIGURATION (mirrors which-key.nvim)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:which_key_timeout = 300
let g:which_key_show_delay = 0
let g:which_key_use_floating_win = 0
let g:which_key_vertical = 0
let g:which_key_run_on_exit = 0

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>

let g:which_key_map = {}
let g:which_key_map.f = { 'name' : '+file' }
let g:which_key_map.g = { 'name' : '+git' }
let g:which_key_map.b = { 'name' : '+buffer' }
let g:which_key_map.w = { 'name' : '+window' }
let g:which_key_map.c = { 'name' : '+code' }
let g:which_key_map.d = { 'name' : '+debug' }
let g:which_key_map.r = { 'name' : '+re-' }
let g:which_key_map.t = { 'name' : '+tab' }
let g:which_key_map.T = { 'name' : '+toggle' }
let g:which_key_map.o = { 'name' : '+open' }
let g:which_key_map.h = { 'name' : '+git-hunk' }
let g:which_key_map.C = { 'name' : '+quickfix' }
call which_key#register('<Space>', 'g:which_key_map')

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LIGHTLINE CONFIGURATION (mirrors mini.statusline)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
  \ 'colorscheme': 'rosepine',
  \ 'active': {
  \   'left': [['mode', 'paste'],
  \            ['gitbranch', 'readonly', 'filename', 'modified']],
  \   'right': [['lineinfo'],
  \             ['percent'],
  \             ['cocstatus', 'fileformat', 'fileencoding', 'filetype']]
  \ },
  \ 'inactive': {
  \   'left': [['filename']],
  \   'right': [['lineinfo'], ['percent']]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction'
  \ },
  \ 'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [ [] ]
  \ },
  \ 'mode_map': {
  \   'n' : 'N', 'i' : 'I', 'R' : 'R', 'v' : 'V', 'V' : 'VL',
  \   "\<C-v>": 'VB', 'c' : 'C', 's' : 'S', 'S' : 'SL',
  \   "\<C-s>": 'SB', 't': 'T',
  \  },
  \ }
let g:lightline#ale#indicator_warnings = '⚠'
let g:lightline#ale#indicator_errors = '✘'

" Update lightline on CoC status / diagnostic change
augroup lightline_coc
  autocmd!
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

" Use devicons in lightline filenames (visual parity with mini.statusline use_icons)
let g:webdevicons_enable = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_nerdtree = 0
let g:webdevicons_conceal_nerdtree_brackets = 0

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UNDOTREE CONFIGURATION
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTOPAIRS / HIGHLIGHTEDYANK / CLOSETAG / INDENTLINE CONFIGURATION
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto-pairs
let g:AutoPairsShortcutToggle = '<M-p>'
let g:AutoPairsShortcutFastWrap = '<M-e>'

" highlightedyank
let g:highlightedyank_highlight_duration = 150

" indentLine (mirrors indent-blankline; uses conceal)
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
let g:indentLine_fileTypeExclude = ['help', 'startify', 'man', 'netrw', 'json', 'coc-explorer']
let g:indentLine_bufTypeExclude = ['terminal', 'nofile']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STARTIFY / SESSIONS (mirrors dashboard-nvim + persistence.nvim)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions'] },
  \ { 'type': 'files',     'header': ['   MRU'] },
  \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
  \ ]
let g:startify_bookmarks = [
  \ { 'c': '~/dotfiles/vim/.vimrc' },
  \ { 'n': '~/dotfiles/nvim/init.lua' },
  \ '~/.config/zsh/.zshrc',
  \ ]
let g:startify_custom_header = []

" Auto-save session when leaving vim with :Obsess running; restore last session on launch
augroup startify_sessions
  autocmd!
  autocmd VimEnter *
    \   if !argc() && line('$') == 1 && empty(getline(1)) && exists(':Startify')
    \ |   Startify
    \ | endif
augroup END

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COPILOT.VIM CONFIGURATION (mirrors copilot.lua)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:copilot_filetypes = {
  \ 'yaml': v:true,
  \ 'markdown': v:true,
  \ 'help': v:false,
  \ 'gitcommit': v:true,
  \ 'gitrebase': v:false,
  \ '.*': v:true,
  \ }
let g:copilot_no_tab_map = 1
let g:copilot_assume_mapped = 1
" Don't conflict with Tab (used for coc completion); accept with <M-Space>, dismiss with <C-]>
imap <silent><nowait> <M-Space> <Plug>(copilot-accept)
imap <silent><nowait> <M-'> <Plug>(copilot-next)
imap <silent><nowait> <M-"> <Plug>(copilot-previous)
let g:copilot_boundary_keys = []

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MARKDOWN PREVIEW
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_open_to_the_world = 0
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_theme = 'dark'

augroup markdown_keymaps
  autocmd!
  autocmd FileType markdown nnoremap <buffer><silent> <leader>mp :MarkdownPreviewToggle<CR>
augroup END

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TERMINAL CONFIGURATION (mirrors nvim/lua/terminal.lua)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <M-q> <C-\><C-n>

augroup terminal_options
  autocmd!
  autocmd TerminalOpen * setlocal nonumber norelativenumber scrolloff=0
augroup END

" Open a terminal at the bottom of the screen with a fixed height (mirrors <leader>:n)
nnoremap <silent> <leader>ot :call <SID>OpenSplitTerminal()<CR>
function! s:OpenSplitTerminal() abort
  belowright new
  wincmd J
  resize 12
  setlocal winfixheight
  terminal
endfunction

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTOCOMMANDS
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc_general
  autocmd!

  " Return to last edit position (mirrors jump-to-last-pos)
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g'\"" | endif

  " Trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

  " Auto-resize splits on window resize (with tab restore)
  autocmd VimResized * let s:cur_tab = tabpagenr() | tabdo wincmd = | exec 'tabnext ' . s:cur_tab

  " Format on save when g:autoformat is on (mirrors conform.nvim format_on_save)
  autocmd BufWritePre * if g:autoformat | call CocActionAsync('format') | endif

  " Check for changes on focus/terminal close (mirrors checktime autocmd)
  autocmd FocusGained,BufEnter * if &buftype !=# 'nofile' | checktime | endif

  " Disable auto comment continuation on new lines (mirrors no-auto-comment)
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Cursorline only in active window (mirrors active-cursorline)
  autocmd BufEnter,WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " Close certain filetypes with `q` (mirrors close_with_q)
  autocmd FileType help,man,qf,netrw nnoremap <buffer> q :close<CR>
augroup END

" Filetype-specific settings (mirrors nvim filetype_settings)
augroup filetype_settings
  autocmd!
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,json,yaml,html,css,scss
    \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType markdown setlocal wrap linebreak spell
  autocmd FileType gitcommit setlocal spell textwidth=72
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType css,scss,json,javascriptreact,typescriptreact,vue,svelte,xml
    \ setlocal commentstring=<!--\ %s\ -->
augroup END

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILETYPE DETECTION (mirrors nvim.filetype.add for .env files)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup custom_filetypes
  autocmd!
  autocmd BufNewFile,BufRead .env,*.env,*.env.* setfiletype config
augroup END

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM TOGGLE FUNCTIONS (mirrors nvim which-key T group)
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle relative line numbers (was <leader>tr; now under T group)
function! s:ToggleRelativeNumber() abort
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction
nnoremap <silent> <leader>Tr :call <SID>ToggleRelativeNumber()<CR>

" Toggle spell check
nnoremap <silent> <leader>Ts :setlocal spell! spelllang=en_us<CR>

" Toggle whitespace list
nnoremap <silent> <leader>Tl :set list!<CR>

" Create directory if it doesn't exist when saving
function! s:MkNonExDir(file, buf) abort
  if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir) | call mkdir(dir, 'p') | endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" ENSURE DIRECTORIES
if !isdirectory(expand('~/.vim/undodir'))
  call mkdir(expand('~/.vim/undodir'), 'p')
endif
if !isdirectory(expand('~/.vim/pack'))
  call mkdir(expand('~/.vim/pack'), 'p')
endif

" vim: ts=2 sts=2 sw=2 et