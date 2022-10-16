" number colors for (in)active windows
hi inactive ctermfg=242
hi active   ctermfg=Magenta

" set highlight groups
hi LineNr      ctermfg=Magenta
hi LineNrAbove ctermfg=Magenta
hi LineNrBelow ctermfg=Magenta

" highlight current line
set cursorline
hi CursorLine   cterm=None ctermbg=238
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
au FileType c,cpp,go,vim,make setlocal tabstop=8 shiftwidth=8
au FileType html setlocal tabstop=2 shiftwidth=2

" remove annoying error/warning column
set scl=no

" syntax highlighting tweaks
hi goTSConstant ctermfg=7
hi TSFuncMacro ctermfg=7
hi TSFunctionCall ctermfg=81
hi link TSParameter Normal
hi link TSKeywordOperator Keyword
hi link TSOperator Normal
hi link TSFunction Normal
hi link TSProperty Normal
hi link TSField Normal
hi link number Normal
hi link TSConstBuiltin Constant
hi link TSMethodCall  TSFunctionCall
hi link TSFuncBuiltin TSFunctionCall
hi link TSConstructor TSFunctionCall
hi link CurSearch Search

highlight FloatBorder ctermfg=grey
hi NormalFloat cterm=bold ctermfg=white
hi Error ctermfg=red
