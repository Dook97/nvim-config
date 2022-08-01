let mapleader=" "

" Alternate way to save
nnoremap <leader>w :up<CR>

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

" parens auto-close
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap ` ``<Esc>i

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

" split to empty buffer
nnoremap <C-w>v :vnew<CR>

" easy tabs
nnoremap <leader>a gt
nnoremap <leader>t :tabe<CR>

" built in terminal escape to normal mode
tnoremap <C-x> <C-\><C-N>

" copy to system clipboard
noremap Y "+y
nnoremap YY "+yy

" no-highlight shortcut
nnoremap <leader>h :noh<CR>

" Nerd tree
nnoremap <leader>n :NERDTreeToggle<CR>

" Check file in shellcheck:
nnoremap <leader>s :!clear && shellcheck -x %<CR>

" slightly easier commenting
noremap <leader>c :Commentary<CR>
