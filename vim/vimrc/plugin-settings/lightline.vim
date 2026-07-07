scriptencoding utf-8

function! VimrcCocStatus() abort
  return exists('*coc#status') ? coc#status() : ''
endfunction

function! VimrcCocCurrentFunction() abort
  return exists('*CocCurrentFunction') ? CocCurrentFunction() : ''
endfunction

let g:lightline = {
  \ 'colorscheme': 'rosepine',
  \ 'active': {
  \   'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']],
  \   'right': [['lineinfo'], ['percent'], ['cocstatus', 'fileformat', 'fileencoding', 'filetype']]
  \ },
  \ 'inactive': {
  \   'left': [['filename']],
  \   'right': [['lineinfo'], ['percent']]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'VimrcCocStatus',
  \   'currentfunction': 'VimrcCocCurrentFunction'
  \ },
  \ 'tabline': {
  \   'left': [['tabs']],
  \   'right': [[]]
  \ },
  \ 'mode_map': {
  \   'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V', 'V': 'VL',
  \   "\<C-v>": 'VB', 'c': 'C', 's': 'S', 'S': 'SL',
  \   "\<C-s>": 'SB', 't': 'T',
  \  },
  \ }
let g:lightline#ale#indicator_warnings = '⚠'
let g:lightline#ale#indicator_errors = '✘'

augroup lightline_coc
  autocmd!
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

" Use devicons in lightline filenames (visual parity with mini.statusline use_icons)
let g:webdevicons_enable = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_nerdtree = 0
let g:webdevicons_conceal_nerdtree_brackets = 0
