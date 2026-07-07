scriptencoding utf-8

if !g:vimrc_use_coc
  finish
endif

" Required extensions (coc will offer to install missing ones on next startup)
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-tailwindcss',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-phpls',
  \ 'coc-pyright',
  \ 'coc-go',
  \ 'coc-snippets',
  \ 'coc-prettier',
  \ 'coc-highlight',
  \ 'coc-sh',
  \ 'coc-rust-analyzer',
  \ ]

" Manual trigger completion (mirrors vim-cmp <C-a> toggle)
inoremap <silent><expr> <C-space> coc#refresh()

" Use Tab / S-Tab to navigate completion (matches nvim-cmp <Tab>/<S-Tab>)
function! s:CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Confirm completion with <CR>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Snippets (matches nvim LuaSnip jump next/prev)
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" GoTo code navigation (mirrors nvim lspconfig)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gI <Plug>(coc-implementation)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gD <Plug>(coc-declaration)

" Workspace / document symbols
nnoremap <silent> <leader>os :CocList outline<CR>
nnoremap <silent> <leader>ws :CocList -I symbols<CR>

" Diagnostics navigation and float (mirrors nvim keymaps.lua)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nnoremap <silent> <leader>e :call CocActionAsync('diagnosticInfo')<CR>
nnoremap <silent> <leader>q :CocList diagnostics<CR>
nnoremap <silent> <leader>Q :CocList -I diagnostics<CR>

" Documentation
function! s:ShowDocumentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

" Code Actions (mirrors nvim lspconfig)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>cA <Plug>(coc-codeaction-source)
nmap <silent> <leader>cf <Plug>(coc-fix-current)
nmap <silent> <leader>cl <Plug>(coc-codelens-action)
nmap <silent> <leader>rn <Plug>(coc-rename)

" Formatting (mirrors conform.nvim <leader>fm + <leader>F)
nmap <silent> <leader>fm <Plug>(coc-format)
xmap <silent> <leader>fm <Plug>(coc-format-selected)
nmap <silent> <leader>F <Plug>(coc-format)
xmap <silent> <leader>F <Plug>(coc-format-selected)

" Selection Ranges (mirrors nvim cmp/lsp range select)
nmap <silent> <leader>cs <Plug>(coc-range-select)
xmap <silent> <leader>cs <Plug>(coc-range-select)

" Lists (mirrors nvim CocList-style keybindings)
nnoremap <silent><nowait> <leader>cc :CocList commands<CR>
nnoremap <silent><nowait> <leader>co :CocList outline<CR>
nnoremap <silent><nowait> <leader>cd :CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>ce :CocList extensions<CR>
nnoremap <silent><nowait> <leader>cS :CocList -I symbols<CR>

" Highlight symbol under cursor (matches nvim CursorHold document_highlight)
augroup coc_highlight_group
  autocmd!
  autocmd CursorHold * if exists('*CocActionAsync') | silent call CocActionAsync('highlight') | endif
augroup END

" Toggle format on save (mirrors conform autoformat toggle)
let g:autoformat = get(g:, 'autoformat', 0)
function! s:ToggleAutoformat() abort
  let g:autoformat = !g:autoformat
  echo 'Autoformat ' . (g:autoformat ? 'enabled!' : 'disabled!')
endfunction
nnoremap <silent> <leader>Ta :call <SID>ToggleAutoformat()<CR>

" ESLint fix all buffers (mirrors nvim LspEslintFixAll)
nnoremap <silent> <leader>fe :CocCommand eslint.executeAutofix<CR>

" Status Line Integration
function! CocCurrentFunction() abort
  return get(b:, 'coc_current_function', '')
endfunction
