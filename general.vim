" custom colorscheme
colorscheme dook2

filetype plugin on
set smartindent
au FileType python set nosmartindent " smartindent doesn't play well with python comments
set fileencoding=utf-8

" set window title
set title

" show statusline automatically when coding, else only on multiple splits
set laststatus=1
au LspAttach * set laststatus=2

" unncessary since we're using lightline plugin
set noruler noshowmode

" reserved number of lines from top and bottom of viewport
set scrolloff=1

" don't wrap long lines
set nowrap

" indentation settings
set cinoptions+=:0,g0,N-s
set cinkeys-=0#

" Don't indent template
function! CppNoTemplateIndent()
    let l:cline_num = line('.')
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
        let l:pline_num = prevnonblank(l:pline_num - 1)
        let l:pline = getline(l:pline_num)
    endwhile
    let l:retv = cindent('.')
    let l:pindent = indent(l:pline_num)
    if l:pline =~# '^\s*template'
        let l:retv = l:pindent
    endif
    return l:retv
endfunction

autocmd BufEnter *.{cpp,hpp} setlocal indentexpr=CppNoTemplateIndent()

" Splits open at the bottom and right
set splitbelow splitright

" persistent undo
set undofile

" search is case insensitive unless upper case character is in the query
set ignorecase smartcase

" lazy redraw - screen will not be redrawn while executing macros etc
set lz

" time to wait for a mapped sequence to complete
set timeoutlen=750

" hybrid numbers - relative in normal mode, absolute in insert mode
set nu rnu
augroup numbertoggle
	au BufEnter,InsertLeave,WinEnter,FocusGained * if &nu && mode() != "i" | set rnu   | endif
	au BufLeave,InsertEnter,WinLeave,FocusLost   * if &nu                  | set nornu | endif
	au TermOpen * setlocal nonu nornu
augroup END

" remove line highlighting on defocus
augroup linetoggle
	au BufEnter,WinEnter,FocusGained * setlocal cursorline
	au BufLeave,WinLeave,FocusLost   * setlocal nocursorline
augroup END

" hide end-of-buffer tildes
set fillchars+=eob:\ ,

" hack to put cursor at the beggining of a tab instead of the end
set list lcs=tab:\ \ ,

" remove annoying LSP error/warning column
set scl=no

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
set mousemodel=extend

au VimResized * execute "norm! \<c-w>="

" .h files are C not C++
let g:c_syntax_for_h = 1
