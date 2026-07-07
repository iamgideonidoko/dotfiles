scriptencoding utf-8

" Escape (mirrors nvim <M-q> in n/i/c/v)
nnoremap <M-q> <Esc>
inoremap <M-q> <Esc>
vnoremap <M-q> <Esc>
cnoremap <M-q> <Esc>

" Clear search highlight
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <leader><CR> :nohlsearch<CR>

" Center after jumps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap G Gzz

" Movement in insert and terminal mode
inoremap <C-h> <Left>
tnoremap <C-h> <Left>
inoremap <C-l> <Right>
tnoremap <C-l> <Right>
inoremap <C-j> <Down>
tnoremap <C-j> <Down>
inoremap <C-k> <Up>
tnoremap <C-k> <Up>

" Disable arrow keys in normal mode
nnoremap <Left>  :echo "Use h to move!!"<CR>
nnoremap <Right> :echo "Use l to move!!"<CR>
nnoremap <Up>    :echo "Use k to move!!"<CR>
nnoremap <Down>  :echo "Use j to move!!"<CR>

" Disable <C-i>/<C-o> jumplist (matches nvim config)
nnoremap <C-i> <Nop>
nnoremap <C-o> <Nop>

" Insert an empty line above/below current line (mirrors nvim <M-o>/<M-i>)
function! s:AddEmptyLine(below) abort
  let lnum = line('.')
  if a:below
    call append(lnum, '')
  else
    call append(lnum - 1, '')
  endif
endfunction
nnoremap <silent> <M-o> :call <SID>AddEmptyLine(1)<CR>
nnoremap <silent> <M-i> :call <SID>AddEmptyLine(0)<CR>

" Window Management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>wv <C-w>v
nnoremap <leader>ws <C-w>s
nnoremap <leader>wc <C-w>c
nnoremap <leader>wo <C-w>o
nnoremap <leader>w- <C-w>-
nnoremap <leader>w+ <C-w>+
nnoremap <leader>w= <C-w>=

" Resize windows (mirrors nvim: <M-]> wider, <M-[> narrower, <M-}> taller, <M-{> shorter)
nnoremap <M-]> <C-w>5>
nnoremap <M-[> <C-w>5<
nnoremap <M-}> <C-w>+
nnoremap <M-{> <C-w>-

" Buffer Management
nnoremap <silent> <leader>x :bdelete<CR>
nnoremap <silent> <leader>X :bdelete!<CR>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>

" Toggle statusline (mirrors nvim <leader>_)
function! s:ToggleStatusline() abort
  if &laststatus == 0
    set laststatus=2
  else
    set laststatus=0
  endif
endfunction
nnoremap <silent> <leader>_ :call <SID>ToggleStatusline()<CR>

" Tab Management (nvim <leader>t group)
nnoremap <silent> <leader>tn :tabnew<CR>
nnoremap <silent> <leader>tc :tabclose<CR>
nnoremap <silent> <leader>to :tabonly<CR>
nnoremap <silent> <leader>tf :tabfirst<CR>
nnoremap <silent> <leader>tl :tablast<CR>

" Move lines up/down (matches nvim <M->>/<M-<>) plus <A-j>/<A-k> aliases
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv
inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi

" Duplicate lines
nnoremap <leader>d :t.<CR>
vnoremap <leader>d :t'><CR>gv

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

" Better paste in visual mode (mirrors nvim: yanked text stays in clipboard/unnamed register)
vnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>

" Yank to end of line
nnoremap Y y$

" Quickfix (mirrors nvim <leader>C* group)
nnoremap <silent> ]q :cnext<CR>zz
nnoremap <silent> [q :cprev<CR>zz
nnoremap <silent> ]l :lnext<CR>zz
nnoremap <silent> [l :lprev<CR>zz

function! s:QfWrap(try_cmd, catch_cmd) abort
  try
    execute a:try_cmd
  catch
    try
      execute a:catch_cmd
    catch
    endtry
  endtry
endfunction

nnoremap <silent> <leader>Co :copen<CR>
nnoremap <silent> <leader>Cn :call <SID>QfWrap('cnext', 'cfirst')<CR>
nnoremap <silent> <leader>Cp :call <SID>QfWrap('cprev', 'clast')<CR>
nnoremap <silent> <leader>Cr :cfdo s//g<Left><Left><Left>

" Custom toggles (mirrors nvim which-key T group)
function! s:ToggleRelativeNumber() abort
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

nnoremap <silent> <leader>Tr :call <SID>ToggleRelativeNumber()<CR>
nnoremap <silent> <leader>Ts :setlocal spell! spelllang=en_us<CR>
nnoremap <silent> <leader>Tl :set list!<CR>
