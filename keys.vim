let mapleader=" "

" Alternate way to save
nnoremap <leader>w :up<CR>

" make F and T inclusive operators (include character under cursor)
onoremap F vF
onoremap T vT

" Parens auto-close
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" kill buffer
nnoremap <leader>q :bd!<CR>
" kill all buffers
nnoremap <leader>Q :qa!<CR>
" close a split (doesn't close the underlying buffer)
nnoremap <leader>c :close<CR>

" quickly switch/delete/... buffers
noremap <c-b> :buffers<CR>:b

" format
nnoremap Q gqq
vnoremap Q gq

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" vertical split shortcut
nnoremap <C-w>v :vsplit<CR>

" copy to system clipboard
noremap Y "+y
nnoremap YY "+yy

" netrw (file explorer)
nnoremap <leader>n :Explore<CR>

" switch to next buffer
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

" unfuck python commenting
au FileType python nnoremap gco o#<space>
au FileType python nnoremap gcO O#<space>

" use extended regex for searching by default
nnoremap / /\v
vnoremap / /\v
nnoremap <leader>/ /
vnoremap <leader>/ /
nnoremap :s :s/\v
nnoremap <leader>:s :s/
nnoremap :g :g/\v
nnoremap <leader>:g :g/

" paste over a selection without changing contents of the unnamed register
vnoremap <leader>p "_dP

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
