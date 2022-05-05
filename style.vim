" number colors for (in)active windows
hi inactive ctermfg=242
hi active ctermfg=Magenta

" set initial
hi LineNr ctermfg=Magenta
hi LineNrAbove ctermfg=Magenta
hi LineNrBelow ctermfg=Magenta

" highlight current line
set cursorline
hi CursorLine cterm=None ctermbg=239
hi CursorLineNr cterm=None ctermfg=Yellow

" remove line highlighting on defocus
augroup linetoggle
	au!
	au BufEnter,InsertEnter * set winhl=LineNr:active
	au BufLeave,InsertLeave * set winhl=LineNr:inactive
	au BufEnter,WinEnter * setlocal cursorline | set winhl=LineNr:active
	au BufLeave,WinLeave * setlocal nocursorline | set winhl=LineNr:inactive
augroup END

" hide vertical split line and end-of-buffer tildes
hi VertSplit ctermfg=None ctermbg=None cterm=None
hi StatusLine ctermfg=None ctermbg=None cterm=None
hi StatusLineNC ctermfg=None ctermbg=None cterm=None
set fillchars+=vert:\ ,eob:\ ,
