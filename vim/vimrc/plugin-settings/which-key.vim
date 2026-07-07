scriptencoding utf-8

let g:which_key_timeout = 300
let g:which_key_show_delay = 0
let g:which_key_use_floating_win = 0
let g:which_key_vertical = 0
let g:which_key_run_on_exit = 0

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>

let g:which_key_map = {}
let g:which_key_map.f = {'name': '+file'}
let g:which_key_map.g = {'name': '+git'}
let g:which_key_map.b = {'name': '+buffer'}
let g:which_key_map.w = {'name': '+window'}
let g:which_key_map.c = {'name': '+code'}
let g:which_key_map.d = {'name': '+debug'}
let g:which_key_map.r = {'name': '+re-'}
let g:which_key_map.t = {'name': '+tab'}
let g:which_key_map.T = {'name': '+toggle'}
let g:which_key_map.o = {'name': '+open'}
let g:which_key_map.h = {'name': '+git-hunk'}
let g:which_key_map.C = {'name': '+quickfix'}
call which_key#register('<Space>', 'g:which_key_map')
