" number colors for (in)active windows
hi inactive ctermfg=242
hi active   ctermfg=Magenta

" set highlight groups
hi LineNr      ctermfg=Magenta
hi LineNrAbove ctermfg=Magenta
hi LineNrBelow ctermfg=Magenta

" highlight current line
set cursorline
hi CursorLine   cterm=None ctermbg=239
hi CursorLineNr cterm=None ctermfg=Yellow

" remove line highlighting on defocus
augroup linetoggle
	au!
	au BufEnter,InsertEnter * set winhl=LineNr:active
	au BufLeave,InsertLeave * set winhl=LineNr:inactive
	au BufEnter,WinEnter,FocusGained * setlocal cursorline   | set winhl=LineNr:active
	au BufLeave,WinLeave,FocusLost   * setlocal nocursorline | set winhl=LineNr:inactive
augroup END

" hide vertical split line and end-of-buffer tildes
hi VertSplit    ctermfg=240  ctermbg=None cterm=None
hi StatusLine   ctermfg=None ctermbg=None cterm=None
hi StatusLineNC ctermfg=None ctermbg=None cterm=None
set fillchars+=eob:\ ,

" hack to put cursor at the beggining of a tab instead of the end
set list lcs=tab:\ \ ,

" display tabs 4 characters wide
set tabstop=4
set shiftwidth=4
" ...with some exceptions
au FileType c,cpp,vim setlocal tabstop=8 shiftwidth=8
