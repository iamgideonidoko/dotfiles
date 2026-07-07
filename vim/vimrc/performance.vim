scriptencoding utf-8

set nocompatible
set lazyredraw
set ttyfast
set synmaxcol=300
set redrawtime=2000
set maxmempattern=5000
set updatetime=200
set timeoutlen=300
set ttimeoutlen=10

" Disable unused built-in plugins for faster startup.
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
" NOTE: netrw is intentionally kept (used as file explorer, replacing oil.nvim).
