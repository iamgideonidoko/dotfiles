scriptencoding utf-8

set termguicolors
set background=dark

" Rose Pine variant: 'main' (default), 'moon', 'dawn'
let g:rosepine_variant = 'main'
let g:rosepine_enable_italics = 1
let g:rosepine_disable_background = 1
let g:rosepine_disable_float_background = 1

augroup colorscheme_overrides
  autocmd!
  autocmd ColorScheme rosepine hi Comment gui=none
augroup END

silent! colorscheme rosepine

" Better diff colors (rose-pine main palette)
hi DiffAdd    guibg=#1e2d22
hi DiffChange guibg=#26233a
hi DiffDelete guifg=#eb6f92 guibg=#2d1b24
hi DiffText   guibg=#383050

" Transparent background for floating windows / separator
hi NormalFloat guibg=#1f1d2e
hi FloatBorder guifg=#6e6a86
hi WinSeparator guifg=#403d52 gui=none

" Better search highlighting
hi Search    guibg=#3d59a1 guifg=#c0caf5
hi IncSearch guibg=#ff9e64 guifg=#1a1b26

" Visual mode selection
hi Visual guibg=#364a82

" Pmenu (completion menus)
hi Pmenu      guibg=#26233a
hi PmenuSel   guifg=#c0caf5 guibg=#403d52 gui=bold
hi PmenuSbar  guibg=#26233a
hi PmenuThumb guibg=#6e6a86

" vim-gitgutter signs
hi GitGutterAdd    guifg=#9ccfd8
hi GitGutterChange guifg=#e0af68
hi GitGutterDelete guifg=#eb6f92
hi link GitGutterAddLine DiffAdd
hi link GitGutterChangeLine DiffChange
hi link GitGutterDeleteLine DiffDelete

" conflict-marker.vim
hi ConflictMarkerBegin guibg=#2f2d3e
hi ConflictMarkerOurs  guifg=#eb6f92 guibg=#2d1b24
hi ConflictMarkerTheirs guifg=#9ccfd8 guibg=#1e2d22
hi ConflictMarkerEnd   guibg=#2f2d3e

" vim-which-key
hi WhichKey          guifg=#c4a7e7 gui=bold
hi WhichKeySeperator guifg=#6e6a86
hi WhichKeyGroup     guifg=#31748f gui=italic
hi WhichKeyDesc      guifg=#c0caf5

" coc.nvim highlights
hi CocFloating      guibg=#1f1d2e
hi CocErrorSign     guifg=#eb6f92
hi CocWarningSign   guifg=#e0af68
hi CocInfoSign      guifg=#9ccfd8
hi CocHintSign      guifg=#c4a7e7
hi CocErrorFloat    guifg=#eb6f92
hi CocWarningFloat  guifg=#e0af68
hi CocInfoFloat     guifg=#9ccfd8
hi CocHintFloat     guifg=#c4a7e7
hi CocHighlightText guibg=#26233a
hi CocUnderline     gui=undercurl guisp=#e0af68

" TODO / FIXME / NOTE highlights (mirrors folke/todo-comments.nvim)
augroup todo_highlights
  autocmd!
  autocmd Syntax * syntax match TodoStatement /\c\<\(TODO\|FIXME\|HACK\|BUG\|XXX\|NOTE\|WARN\|PERF\)/ containedin=.*Comment.*
augroup END
hi TodoStatement guifg=#f6c177 gui=bold
