scriptencoding utf-8

let s:jetpackfile = expand('~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim')
let s:jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'

if !filereadable(s:jetpackfile)
  call mkdir(fnamemodify(s:jetpackfile, ':h'), 'p')
  let s:cmd = has('win32')
    \ ? 'powershell -Command "Invoke-WebRequest -Uri ''' . s:jetpackurl . ''' -OutFile ''' . s:jetpackfile . '''"'
    \ : 'curl -fsSLo "' . s:jetpackfile . '" "' . s:jetpackurl . '"'
  call system(s:cmd)
  augroup jetpack_bootstrap
    autocmd!
    autocmd VimEnter * call jetpack#sync() | source $MYVIMRC
  augroup END
endif

packadd vim-jetpack
