let mapleader=" "

" Alternate way to save
nnoremap <leader>w :up<CR>

" Parens auto-close
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ` ``<Esc>i

" Alternate way to quit
nnoremap <leader>q :q!<CR>
nnoremap <leader>Q :qa!<CR>

" Chop line into shorter lines
nnoremap Q gqq
vnoremap Q gq

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Easy scrolling
noremap <C-x> <C-e>
noremap <C-z> <C-y>

" easy moving between windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" resize window
nnoremap = <C-w>+
nnoremap - <C-w>-
nnoremap \ <C-w><
nnoremap ' <C-w>>

" counterpart to <C-a> - substracts one from number
nnoremap <C-s> <C-x>

" split to empty buffer
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>s :new<CR>

" easy tabs
nnoremap <leader>a gt
nnoremap <leader>t :tabe<CR>

" copy to system clipboard
noremap Y "+y
nnoremap YY "+yy

" no-highlight shortcut
nnoremap <leader>h :noh<CR>

" netrw (file explorer)
nnoremap <leader>n :Explore<CR>
