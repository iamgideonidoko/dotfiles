" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DO_NOT_BACK_UP_FIlE
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set leader key to spacebar
let mapleader = " "
" I always want to show the status line at the bottom (0 never, 1 if 2 windows, 2 always)
set laststatus=2
" Allows me to delete characters when type backspace in insert mode
set backspace=indent,eol,start
" Change the color of visually or visual selected text
highlight Visual ctermfg=white ctermbg=blue guifg=white guibg=blue
" Info to be shown in the status line
" %f filename, %y filetype, %m modified flag, %r RO flag, %= align to right, %l line, %c column
set statusline=%f\ %y\ %m\ %r\ %=Line:\ %l\ Column:\ %c
" Set Vim's operating mode to nocompatible with Vi (Vim's default behavior)
" This allows Vim to use features not found in standard Vi.
set nocompatible
" Enable line numbers
set relativenumber
" Set tabs to have 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
" Enable syntax highlighting
syntax on
" Define custom highlight color for inline code in Markdown
autocmd FileType markdown highlight markdownCode ctermfg=yellow ctermbg=NONE
" I always like lines to be broken at 80 characters
set textwidth=80
" Disable line wrapping
" I had to disable this for my bulletpoints to work
set nowrap
" I need this so that indentation works properly with bulletpoints and the
" bullets.vim plugin
set autoindent
" Wrapping at the word level instead of breaking words in the middle
set linebreak
" Show matching brackets/parenthesis
set showmatch
" Set the default search to case-insensitive
set ignorecase
" But make search case-sensitive if it contains uppercase characters
set smartcase
" Highlight search results
set hlsearch
" Enable mouse in all modes
set mouse=a
" Mapping to enter command mode
imap kj <Esc>
" When in visual mode, you can move lines of text up and down
" Enter visual mode, select what you need to select and press J or K to move
" the section up or down
vmap J :m '>+1<CR>gv=gv
vmap K :m '<-2<CR>gv=gv
" When going down or up, centers cursor in the middle of the screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Toggle line numbers with mn
nnoremap mn :set number!<CR>
" When searching and do n or N, cursor stays in the middle
nnoremap n nzzzv
nnoremap N Nzzzv
" Copy to the system clipboard either in normal or visual mode
" In visual mode, select the text and then do <Leader>y to copy it
" If in normal mode do <Leader>y then 'ap' to copy a paragraph
nnoremap <Leader>y "+y
vmap <Leader>y "+y
nnoremap <Leader>Y "+Y
" Q enters Ex mode, this disables it
nnoremap Q <nop>
" Use gh to move to the beginning of the line in normal mode
" Use gl to move to the end of the line in normal mode
nnoremap gh ^
nnoremap gl $
" Better navigation: when no count is given, use gj/gk for j/k
nnoremap j gj
nnoremap k gk
" This is for visual mode
xnoremap j gj
xnoremap k gk
" Use leader+w to save or write files
nnoremap <leader>ww :w<cr>
" Create a task used with bullets plugin
nnoremap <leader>ml i- [ ] <Esc>a
" Copy to the system clipboard
vnoremap y "+y
nnoremap y "+y
" Set cursor to line in insert mode
let &t_SI = "\e[5 q"
" Set cursor to block in normal mode
let &t_EI = "\e[2 q"
" This fixed paste issues in tmux
" https://vi.stackexchange.com/questions/23110/pasting-text-on-vim-inside-tmux-breaks-indentation
if &term =~ "screen"                                                   
    let &t_BE = "\e[?2004h"                                              
    let &t_BD = "\e[?2004l"                                              
    exec "set t_PS=\e[200~"                                              
    exec "set t_PE=\e[201~"                                              
endif
" vim-plug automatic installation
" This code goes in your .vimrc before plug#begin() call
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Remember that before this call you need to have the vim-plug automatic
" installation section
call plug#begin()
" List your plugins here
Plug 'bullets-vim/bullets.vim'
call plug#end()
