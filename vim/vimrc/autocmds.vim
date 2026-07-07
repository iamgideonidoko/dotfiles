scriptencoding utf-8

augroup vimrc_general
  autocmd!

  " Return to last edit position (mirrors jump-to-last-pos)
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') |
    \ exe "normal! g'\"" | endif

  " Trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

  " Auto-resize splits on window resize (with tab restore)
  autocmd VimResized * let s:cur_tab = tabpagenr() | tabdo wincmd = | exec 'tabnext ' . s:cur_tab

  " Format on save when g:autoformat is on and coc is loaded (mirrors conform.nvim)
  autocmd BufWritePre * if get(g:, 'autoformat', 0) && g:vimrc_use_coc && exists('*CocActionAsync') | call CocActionAsync('format') | endif

  " Check for changes on focus/terminal close (mirrors checktime autocmd)
  autocmd FocusGained,BufEnter * if &buftype !=# 'nofile' | checktime | endif

  " Disable auto comment continuation on new lines (mirrors no-auto-comment)
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Cursorline only in active window (mirrors nvim active-cursorline).
  autocmd BufEnter,WinEnter * if &buftype ==# '' && !&previewwindow | setlocal cursorline | endif
  autocmd WinLeave * if &buftype ==# '' && !&previewwindow | setlocal nocursorline | endif

  " Restore line numbers after fzf closes.
  autocmd BufEnter * if &buftype ==# '' && !&previewwindow | setlocal number relativenumber | endif

  " Close certain filetypes with `q` (mirrors close_with_q)
  autocmd FileType help,man,qf,netrw nnoremap <buffer> q :close<CR>
augroup END

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

augroup custom_filetypes
  autocmd!
  autocmd BufNewFile,BufRead .env,*.env,*.env.* setfiletype config
augroup END

function! s:MkNonExDir(file, buf) abort
  if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" vim: ts=2 sts=2 sw=2 et
