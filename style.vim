" number colors for (in)active windows
hi inactive ctermfg=242
hi active   ctermfg=Magenta

" set highlight groups
hi LineNr      ctermfg=Magenta
hi LineNrAbove ctermfg=Magenta
hi LineNrBelow ctermfg=Magenta

" matching paren highlighting
hi MatchParenActive ctermfg=232 ctermbg=81 cterm=bold
hi! link MatchParen MatchParenActive
au InsertEnter * hi clear MatchParen
au InsertLeave * hi! link MatchParen MatchParenActive

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

" style vertical split line
hi VertSplit    ctermfg=240  ctermbg=None cterm=None
hi StatusLine   ctermfg=None ctermbg=None cterm=None
hi StatusLineNC ctermfg=None ctermbg=None cterm=None

" hide end-of-buffer tildes
set fillchars+=eob:\ ,

" hack to put cursor at the beggining of a tab instead of the end
set list lcs=tab:\ \ ,

" display tabs 4 characters wide
set tabstop=4
set shiftwidth=4
" ...with some exceptions
au FileType c,cpp,go,vim,make,lex,yacc setlocal tabstop=8 shiftwidth=8
au FileType html setlocal tabstop=2 shiftwidth=2

" remove annoying error/warning column
set scl=no

" syntax highlighting tweaks
hi! TSFunctionCall ctermfg=81
hi! Identifier cterm=none ctermfg=81
hi! @Include ctermfg=81
hi! link Special Normal
hi! link goTSConstant Normal
hi! link TSFuncMacro Normal
hi! link @function Normal
hi! link @variable Normal
hi! link @method Normal
hi! link @string.escape Normal
hi! link cssBraces Normal
hi! link CurSearch Search
hi! link Number Normal
hi! link @PreProc Keyword
hi! link @field Normal
hi! link @parameter Normal
hi! link @function.call TSFunctionCall
hi! link @method.call TSFunctionCall
hi! link @constructor Normal
hi! link @function.builtin TSFunction
hi! link @special Normal
hi! link @constant.builtin Constant
hi! link @operator Normal
hi! link @property Normal
hi! link @keyword.operator Keyword
hi! link @storageclass Keyword

" make floating windows not hideous
hi! NormalFloat cterm=bold ctermfg=white
