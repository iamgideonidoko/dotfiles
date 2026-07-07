scriptencoding utf-8

" Preview is OPT-IN via Ctrl-/ (preview is slowest fzf feature).
let g:fzf_preview_window = ['hidden:right:50%:wrap', 'ctrl-/']
let g:fzf_colors = {
  \ 'fg': ['fg', 'Normal'],
  \ 'bg': ['bg', 'Normal'],
  \ 'hl': ['fg', 'Comment'],
  \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+': ['fg', 'Statement'],
  \ 'info': ['fg', 'PreProc'],
  \ 'border': ['fg', 'FloatBorder'],
  \ 'prompt': ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker': ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header': ['fg', 'Comment'],
  \ }

let g:fzf_layout = {'down': '~100%'}
let $FZF_DEFAULT_OPTS .= join([
      \ '--layout=default',
      \ '--info=inline',
      \ '--border=top',
      \ '--prompt="❯ "',
      \ '--pointer=">"',
      \ '--marker="+"',
      \ '--height=100%',
      \ '--no-separator',
      \ '--cycle',
      \ '--bind=alt-q:abort',
      \ ], ' ')

augroup fzf_ui
  autocmd!
  autocmd FileType fzf set laststatus=0 noshowmode noruler
    \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

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
nnoremap <silent> <leader>/ :Buffers<CR>
nnoremap <silent> <leader>; :Buffers<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>fh :Helptags<CR>
nnoremap <silent> <leader>fk :Maps<CR>
nnoremap <silent> <leader>fg :Rg<CR>
xnoremap <silent> <leader>fg "sy:Rg <C-R>s<CR>
nnoremap <silent> <leader>fc :BLines<CR>
if g:vimrc_use_coc
  nnoremap <silent> <leader>fd :CocList diagnostics<CR>
endif
nnoremap <silent> <leader>fo :Lines<CR>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>f. :History<CR>
nnoremap <silent> <leader>fn :Files ~/.vim<CR>
nnoremap <silent> <leader>fl :Lines<CR>
if g:vimrc_use_coc
  nnoremap <silent> <leader>fs :Snippets<CR>
endif
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
