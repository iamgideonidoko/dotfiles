" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DO_NOT_BACK_UP_FIlE
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PERFORMANCE OPTIMIZATIONS
set nocompatible
set lazyredraw
set ttyfast
set synmaxcol=300
set updatetime=300
set timeoutlen=500
set ttimeoutlen=10
set regexpengine=1

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

" PLUGIN MANAGEMENT WITH VIM-PLUG
" Auto-install vim-plug if not present
let data_dir = has('win32') ? '$HOME/vimfiles' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" LSP & Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Text Manipulation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'

" Navigation & UI
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'liuchengxu/vim-which-key'

" Language Support
Plug 'sheerun/vim-polyglot'

" Utilities
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'romainl/vim-cool'

" Colorschemes
Plug 'ghifarit53/tokyonight-vim'

call plug#end()

" CORE VIM SETTINGS
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
set history=1000
set clipboard=unnamed,unnamedplus
set mouse=a
set backspace=indent,eol,start
set nrformats-=octal
set formatoptions+=j

" Visual
set number
set relativenumber
set cursorline
set signcolumn=yes
set showmatch
set matchtime=2
set scrolloff=8
set sidescrolloff=8
set display+=lastline
set cmdheight=1
set shortmess+=c
set noshowmode
set showcmd
set laststatus=2
set showtabline=1
set splitbelow
set splitright
set fillchars=vert:│,fold:─
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:␣
" Normal mode: block, no blink
let &t_EI = "\e[2 q"  
" Insert mode: vertical bar, no blink
let &t_SI = "\e[6 q"  
set guicursor=n:block,i:ver25
augroup cursor_init " Redraw cursor on VimEnter
  autocmd!
  autocmd VimEnter * execute 'normal! <C-L>'
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
set tabstop=4
set softtabstop=4
set shiftwidth=4
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

" Folding
set foldmethod=indent
set foldlevelstart=99
set nofoldenable

" COLORSCHEME
set termguicolors
set background=dark

" TokyoNight style options
" Available: 'night' (default), 'storm'
let g:tokyonight_style = 'night'  " darker variant
" let g:tokyonight_style = 'storm'  " lighter variant

" Enable italic keywords (works best with fonts like Fira Code)
let g:tokyonight_enable_italic = 1

" Disable italic comments (if you prefer)
" let g:tokyonight_disable_italic_comment = 1

" Make menu background transparent
let g:tokyonight_menu_selection_background = 'blue'

" Control word highlighting under cursor
" Options: 'grey background', 'bold', 'underline', 'italic'
let g:tokyonight_current_word = 'grey background'

" Transparent background (for terminal transparency)
let g:tokyonight_transparent_background = 1

" Cursor line customization
let g:tokyonight_cursor = 'auto'

" Darker sidebar and floating windows
let g:tokyonight_sidebars = ['qf', 'vista_kind', 'terminal', 'packer']

" Apply colorscheme
colorscheme tokyonight

" Better diff colors
hi DiffAdd guibg=#283b4d
hi DiffChange guibg=#272d43
hi DiffDelete guifg=#f7768e guibg=#3f2d3d
hi DiffText guibg=#394b70

" Transparent background for floating windows
hi NormalFloat guibg=#1a1b26
hi FloatBorder guifg=#565f89

" Better search highlighting
hi Search guibg=#3d59a1 guifg=#c0caf5
hi IncSearch guibg=#ff9e64 guifg=#1a1b26

" Visual mode selection
hi Visual guibg=#364a82

" For vim-gitgutter
hi GitGutterAdd guifg=#9ece6a
hi GitGutterChange guifg=#e0af68
hi GitGutterDelete guifg=#f7768e

" For vim-which-key
hi WhichKey guifg=#bb9af7
hi WhichKeySeperator guifg=#565f89
hi WhichKeyGroup guifg=#7aa2f7
hi WhichKeyDesc guifg=#c0caf5

" LEADER & MAPPINGS
let mapleader = " "
let maplocalleader = ","

" Essential Remaps
nnoremap ; :
vnoremap ; :
inoremap jk <Esc>
inoremap kj <Esc>

" Better movement
nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" Center after jumps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap G Gzz

" Window Management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>wv <C-w>v
nnoremap <leader>ws <C-w>s
nnoremap <leader>wc <C-w>c
nnoremap <leader>wo <C-w>o

" Resize windows
nnoremap <M-Up> :resize +2<CR>
nnoremap <M-Down> :resize -2<CR>
nnoremap <M-Left> :vertical resize -2<CR>
nnoremap <M-Right> :vertical resize +2<CR>

" Buffer Management
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Quick Actions
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>e :e<Space>
nnoremap <leader>r :source $MYVIMRC<CR>:echo "Config reloaded!"<CR>

" Clear search highlight
nnoremap <leader><CR> :nohlsearch<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

" Text Manipulation
" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi

" Duplicate lines
nnoremap <leader>d :t.<CR>
vnoremap <leader>d :t'><CR>gv

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

" Better paste in visual mode
vnoremap p "_dP

" Yank to end of line
nnoremap Y y$

" Select all
nnoremap <leader>a ggVG

" Quick fix navigation
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprev<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [l :lprev<CR>zz

" COC.NVIM CONFIGURATION
" Required extensions (install via :CocInstall)
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer',
  \ 'coc-go',
  \ 'coc-snippets',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-pairs',
  \ 'coc-highlight',
  \ ]

" Completion
" Use Tab for trigger completion
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use Enter to confirm completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Navigation
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gT <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Diagnostics navigation
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)

" Documentation
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Code Actions
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <leader>cA <Plug>(coc-codeaction-source)
nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>cl <Plug>(coc-codelens-action)

" Refactoring
nmap <leader>cr <Plug>(coc-rename)
nmap <leader>cR <Plug>(coc-refactor)

" Formatting
nmap <leader>F <Plug>(coc-format)
xmap <leader>F <Plug>(coc-format-selected)

" Selection Ranges
nmap <silent> <leader>cs <Plug>(coc-range-select)
xmap <silent> <leader>cs <Plug>(coc-range-select)

" Lists
nnoremap <silent><nowait> <leader>cd :CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>ce :CocList extensions<CR>
nnoremap <silent><nowait> <leader>cc :CocList commands<CR>
nnoremap <silent><nowait> <leader>co :CocList outline<CR>
nnoremap <silent><nowait> <leader>cS :CocList -I symbols<CR>

" Snippets
imap <C-j> <Plug>(coc-snippets-expand-jump)
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" Highlight Symbol
autocmd CursorHold * silent call CocActionAsync('highlight')

" Status Line Integration
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

" FZF CONFIGURATION
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Use ripgrep if available
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

" FZF Mappings
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>/  :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fL :BLines<CR>
nnoremap <leader>fc :Commands<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>ft :Filetypes<CR>

" Search word under cursor
nnoremap <leader>* :Rg <C-R><C-W><CR>
vnoremap <leader>* "sy:Rg <C-R>s<CR>

" Quick file/buffer access
nnoremap <C-p> :Files<CR>
nnoremap <leader>; :Buffers<CR>

" GIT CONFIGURATION
" Fugitive mappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gP :Git pull<CR>
nnoremap <leader>gf :Git fetch<CR>

" GitGutter settings
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '│'
let g:gitgutter_preview_win_floating = 1

" GitGutter mappings
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" Text objects for hunks
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)


" NETRW CONFIGURATION
let g:netrw_banner = 0
" Flat list style (wide, one-per-line with minimal info)
let g:netrw_liststyle = 1
" Auto-switch to file's directory when opening
set autochdir
" Minimal visual tweaks
let g:netrw_altv = 1
let g:netrw_sort_sequence = '[\/]$,*'

function! SetupNetrwMappings()
  " Alternate directory
  nmap <buffer> a   <C-^>
  " Refresh
  nmap <buffer> r   <C-L>
  " Quit
  nmap <buffer> q   :bd<CR>
  " Toggle netrw banner in-place
  nmap <buffer> ?   :let g:netrw_banner = !get(g:, 'netrw_banner', 1)<CR><C-L>
endfunction

augroup netrw_setup
  autocmd!
  autocmd FileType netrw call SetupNetrwMappings()
augroup END

nnoremap - :Explore<CR>

" WHICH-KEY CONFIGURATION
let g:which_key_timeout = 100 " in ms
let g:which_key_show_delay = 0
let g:which_key_use_floating_win = 0 " split instead of floating (floating not supported in vim)

" Trigger
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>

" Key Groups 
let g:which_key_map = {}
let g:which_key_map.f = { 'name' : '+file' }
let g:which_key_map.g = { 'name' : '+git' }
let g:which_key_map.g.s = 'git status'
let g:which_key_map.b = { 'name' : '+buffer' }

call which_key#register('<Space>', 'g:which_key_map')

" Optional Styling
highlight WhichKey        gui=bold
highlight WhichKeyGroup   gui=italic
highlight WhichKeyDesc    gui=NONE

" LIGHTLINE CONFIGURATION
let g:lightline = {
  \ 'colorscheme': 'tokyonight',
  \ 'active': {
  \   'left': [['mode', 'paste'],
  \            ['gitbranch', 'readonly', 'filename', 'modified']],
  \   'right': [['lineinfo'],
  \             ['percent'],
  \             ['cocstatus', 'fileformat', 'fileencoding', 'filetype']]
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
  \   'n' : 'N',
  \   'i' : 'I',
  \   'R' : 'R',
  \   'v' : 'V',
  \   'V' : 'VL',
  \   "\<C-v>": 'VB',
  \   'c' : 'C',
  \   's' : 'S',
  \   'S' : 'SL',
  \   "\<C-s>": 'SB',
  \   't': 'T',
  \  },
  \ }

" Update lightline on CoC status change
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" UNDOTREE CONFIGURATION
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

" AUTO PAIRS CONFIG
let g:AutoPairsShortcutToggle = '<M-p>'
let g:AutoPairsShortcutFastWrap = '<M-e>'

" AUTOCOMMANDS
augroup vimrc_general
  autocmd!
  " Return to last edit position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g'\"" | endif
  
  " Trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
  
  " Auto-resize splits on window resize
  autocmd VimResized * tabdo wincmd =
  
  " Highlight yanked text
  if exists('##TextYankPost')
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  endif
augroup END

" Filetype specific settings
augroup filetype_settings
  autocmd!
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType javascript,typescript,json,yaml,html,css,scss
    \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType markdown setlocal wrap linebreak spell
  autocmd FileType gitcommit setlocal spell textwidth=72
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" CUSTOM FUNCTIONS
" Toggle relative line numbers
function! ToggleRelativeNumber()
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction
nnoremap <leader>tr :call ToggleRelativeNumber()<CR>

" Toggle spell check
nnoremap <leader>ts :setlocal spell! spelllang=en_us<CR>

" Toggle list (show whitespace)
nnoremap <leader>tl :set list!<CR>

" Create directory if it doesn't exist when saving
function! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir) | call mkdir(dir, 'p') | endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Quick terminal
nnoremap <leader>T :terminal<CR>

" ENSURE DIRECTORIES
if !isdirectory(expand("~/.vim/undodir"))
  call mkdir(expand("~/.vim/undodir"), "p")
endif
