scriptencoding utf-8

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
