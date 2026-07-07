scriptencoding utf-8

let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_change_to_dir = 0
let g:startify_center = 1
let g:startify_custom_header = startify#center([
      \ '        ________ ++     ________        ',
      \ '       /VVVVVVVV\++++  /VVVVVVVV\       ',
      \ '       \VVVVVVVV/++++++\VVVVVVVV/       ',
      \ '        |VVVVVV|++++++++/VVVVV/''        ',
      \ '        |VVVVVV|++++++/VVVVV/''         ',
      \ '       +|VVVVVV|++++/VVVVV/''+          ',
      \ '     +++|VVVVVV|++/VVVVV/''+++++        ',
      \ '   +++++|VVVVVV|/VVVVV/''+++++++++      ',
      \ '     +++|VVVVVVVVVVV/''+++++++++        ',
      \ '       +|VVVVVVVVV/''+++++++++          ',
      \ '        |VVVVVVV/''+++++++++            ',
      \ '        |VVVVV/''+++++++++              ',
      \ '        |VVV/''+++++++++                ',
      \ '        ''V/''   ++++++                 ',
      \ '                   ++                   ',
      \ ])
let g:startify_padding_left = (&columns - 25) / 2
let s:pad = repeat(' ', g:startify_padding_left)
let g:startify_lists = [
      \ {'type': 'commands', 'header': startify#center(['Commands'])},
      \ ]
let g:startify_commands = [
      \ {'q': [s:pad . '[q] Quit', 'qa']},
      \ ]
let g:startify_custom_footer = startify#center([
      \ '󰉋 ' . fnamemodify(getcwd(), ':t')
      \ ])

augroup startify_sessions
  autocmd!
  autocmd VimEnter *
    \ if !argc() && line('$') == 1 && empty(getline(1)) && exists(':Startify')
    \ | Startify
    \ | endif
augroup END
