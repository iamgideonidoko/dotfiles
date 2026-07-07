scriptencoding utf-8

let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! s:Source(module) abort
  let l:path = s:root . '/vimrc/' . a:module
  if !filereadable(l:path)
    throw 'Missing vim module: ' . l:path
  endif
  execute 'source' fnameescape(l:path)
endfunction

" Load configuration files in an optimized order.
call s:Source('config.vim')
call s:Source('performance.vim')
call s:Source('jetpack.vim')
call s:Source('plugins.vim')
call s:Source('options.vim')
call s:Source('plugin-settings/theme.vim')
call s:Source('keymaps.vim')
call s:Source('plugin-settings/coc.vim')
call s:Source('plugin-settings/fzf.vim')
call s:Source('plugin-settings/git.vim')
call s:Source('plugin-settings/netrw.vim')
call s:Source('plugin-settings/which-key.vim')
call s:Source('plugin-settings/lightline.vim')
call s:Source('plugin-settings/ui.vim')
call s:Source('plugin-settings/sessions.vim')
call s:Source('plugin-settings/copilot.vim')
call s:Source('plugin-settings/markdown.vim')
call s:Source('terminal.vim')
call s:Source('autocmds.vim')

delfunction s:Source
unlet s:root

" vim: ts=2 sts=2 sw=2 et
