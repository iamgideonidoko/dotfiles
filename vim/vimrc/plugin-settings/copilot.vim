scriptencoding utf-8

if !g:vimrc_use_copilot
  finish
endif

let g:copilot_filetypes = {
  \ 'yaml': v:true,
  \ 'markdown': v:true,
  \ 'help': v:false,
  \ 'gitcommit': v:true,
  \ 'gitrebase': v:false,
  \ '.*': v:true,
  \ }
let g:copilot_no_tab_map = 1
let g:copilot_assume_mapped = 1

" Don't conflict with Tab (used for coc completion); accept with <M-Space>, dismiss with <C-]>
imap <silent><nowait> <M-Space> <Plug>(copilot-accept)
imap <silent><nowait> <M-'> <Plug>(copilot-next)
imap <silent><nowait> <M-"> <Plug>(copilot-previous)
let g:copilot_boundary_keys = []
