scriptencoding utf-8

" Fugitive mappings (matches nvim git + fugitive functional surface)
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gl :Git log --oneline<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gP :Git pull<CR>
nnoremap <silent> <leader>gf :Git fetch<CR>

" GitGutter signs (mirrors nvim gitsigns signs)
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_updatetime = get(g:, 'gitgutter_updatetime', 0)
let g:gitgutter_max_signs = 500
let g:gitgutter_map_keys = 0
let g:gitgutter_git_args = ''
let g:gitgutter_diff_base = ''

" Real debouncing: only re-scan on writes/enter, not while typing.
if has('gui_running') || !exists('$TMUX')
  let g:gitgutter_realtime = 0
endif
let g:gitgutter_terminal_reports_focus = 0

" GitGutter mappings (mirrors nvim gitsigns <leader>h* + ]c/[c)
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nmap <leader>hS :Git add %<CR>
nmap <leader>hu :Git reset<CR>
nmap <leader>hb :Git blame %<CR>
nmap <leader>hd :Gdiffsplit<CR>
nnoremap <silent> <leader>Tb :GitGutterToggle<CR>

" Text objects for hunks
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" conflict-marker.vim (mirrors git-conflict.nvim); provides [x ]x jumps
let g:conflict_marker_enable_mappings = 1
