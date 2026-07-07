scriptencoding utf-8

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
