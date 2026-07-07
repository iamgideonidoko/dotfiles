scriptencoding utf-8

tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <M-q> <C-\><C-n>

augroup terminal_options
  autocmd!
  autocmd TerminalOpen * setlocal nonumber norelativenumber scrolloff=0
augroup END

" Open terminal at bottom with fixed height (mirrors nvim/lua/terminal.lua)
function! s:OpenSplitTerminal() abort
  belowright new
  wincmd J
  resize 12
  setlocal winfixheight
  terminal
endfunction

nnoremap <silent> <leader>ot :call <SID>OpenSplitTerminal()<CR>
