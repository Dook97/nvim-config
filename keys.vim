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

" Alternate way to quit
nnoremap <leader>q :bd!<CR>
nnoremap <leader>Q :qa!<CR>

" format
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

" vertical split shortcut
nnoremap <C-w>v :vsplit<CR>

" easy tabs
nnoremap <leader>a gt
nnoremap <leader>A gT
nnoremap <leader>t :tabe<CR>

" copy to system clipboard
noremap Y "+y
nnoremap YY "+yy

" no-highlight shortcut
nnoremap <leader>h :noh<CR>

" netrw (file explorer)
nnoremap <leader>n :Explore<CR>

" switch to next buffer
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

" easier terminal mode escape
tnoremap <C-x> <C-\><C-n>
