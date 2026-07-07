scriptencoding utf-8

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

" Cursor shape (block in normal, bar in insert); let terminal handle it.
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

" Folding (UFO is nvim-only; rely on built-in folds).
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
set foldenable
set foldcolumn=0

if !isdirectory(expand('~/.vim/undodir'))
  call mkdir(expand('~/.vim/undodir'), 'p')
endif
if !isdirectory(expand('~/.vim/pack'))
  call mkdir(expand('~/.vim/pack'), 'p')
endif
