" custom colorscheme
colorscheme dook97

set smartindent
au FileType python set nosmartindent " smartindent doesn't play well with python comments
set fileencoding=utf-8

" set window title
set title

" show statusline automatically when coding, else only on multiple splits
set laststatus=1
au LspAttach * set laststatus=2

" unncessary since were using lightline plugin
set noruler
set noshowmode

" reserved number of lines from top and bottom of viewport
set scrolloff=1

" dont indent switch cases and private/public/protected specifiers
set cinoptions+=:0,g0
set cinkeys-=0#

" Splits open at the bottom and right
set splitbelow splitright

" persistent undo
set undofile

" search is case insensitive unless upper case character is in the query
set ignorecase
set smartcase

" lazy redraw - screen will not be redrawn while executing macros etc
set lz

" hybrid numbers - relative in normal mode, absolute in insert mode
set nu rnu
augroup numbertoggle
	au BufEnter,InsertLeave,WinEnter,FocusGained * if &nu && mode() != "i" | set rnu   | endif
	au BufLeave,InsertEnter,WinLeave,FocusLost   * if &nu                  | set nornu | endif
	au TermOpen * setlocal nonu nornu
augroup END

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save
au BufWritePre * let currPos = getpos(".")
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/\n\+\%$//e
au BufWritePre * cal cursor(currPos[1], currPos[2])

" automatically organize imports on write and format
augroup gostuff
	au!
	au BufWritePre *.go lua vim.lsp.buf.format()
	au BufWritePre *.go lua vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
augroup END

" disable right click popup menu
behave xterm
