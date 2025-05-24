" custom colorscheme
colorscheme dook2

filetype plugin on
set smartindent
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

" Automatically deletes all trailing whitespace and newlines at end of file on save
au BufWritePre * let currPos = getpos(".")
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/\n\+\%$//e
au BufWritePre * cal cursor(currPos[1], currPos[2])

" disable right click popup menu
set mousemodel=extend

" automatically normalize window sizes when neovim gets resized
au VimResized * execute "norm! \<c-w>="

" floating window border style
set winborder=rounded

" hide context lines when in cmdline/search so that we have a clear view of
" what we're doing
au CmdlineEnter,CmdlineLeave * :TSContextToggle

" hacky function to restart lspserver
function! Lspreload_fun()
	lua vim.lsp.stop_client(vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()}))
	sleep 100m
	edit
endfunction
command! LspReload call Lspreload_fun()

" insert mode completion options
set completeopt=fuzzy,menuone,noselect,popup,preview
set pumheight=7

" <c-x><c-f> complete menu stays open as long as you accept tokens
" no need to reopen it for every directory when completing longer paths
au CompleteDone * if v:event.complete_type ==# "files" && v:event.reason ==# "accept"
    \ | call feedkeys("\<c-x>\<c-f>", "n")

" fallback commentstring
au BufEnter * if empty(&commentstring) | setlocal commentstring=\#\ %s

" no comment on new line
au VimEnter * set formatoptions-=cro

" update hugo content dates
function! HugoTimeUpdate_f()
    let currPos = getpos(".")
    if search('^draft = true$')
	/\v^date \= '\zs([^']*)\ze'$/s//\=substitute(system('date -I'), '\n', '', 'g')/
    endif
    if search('^lastmod = ')
	/\v^lastmod \= '\zs([^']*)\ze'$/s//\=substitute(system('date -I'), '\n', '', 'g')/
    endif
    cal cursor(currPos[1], currPos[2])
endfunction
command! HugoTimeUpdate call HugoTimeUpdate_f()

set signcolumn=no

set iskeyword+=-

set sessionoptions-=blank
