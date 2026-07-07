scriptencoding utf-8

nnoremap <silent> <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

" auto-pairs
let g:AutoPairsShortcutToggle = '<M-p>'
let g:AutoPairsShortcutFastWrap = '<M-e>'

" highlightedyank
let g:highlightedyank_highlight_duration = 150

" indentLine (mirrors indent-blankline; uses conceal)
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
let g:indentLine_fileTypeExclude = ['help', 'startify', 'man', 'netrw', 'json', 'coc-explorer']
let g:indentLine_bufTypeExclude = ['terminal', 'nofile']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
