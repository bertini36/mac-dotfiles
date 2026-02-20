syntax on

if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set background=dark
set nu

" Writing shortcuts
" Readline-like shortcuts (Insert mode)
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
inoremap <C-b> <C-o>b
inoremap <C-f> <C-o>w
inoremap <C-w> <C-w>
inoremap <C-x> <Esc>cc

" Readline-like shortcuts (Command-line mode)
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>
cnoremap <C-w> <C-w>
cnoremap <C-x> <C-u>

nnoremap <C-d> yyp
inoremap <C-d> <Esc>yypgi