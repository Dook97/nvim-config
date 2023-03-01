" set highlight groups
hi LineNr      ctermfg=242
hi LineNrAbove ctermfg=242
hi LineNrBelow ctermfg=242

" highlight current line
set cursorline
hi CursorLine   cterm=None ctermbg=238
hi CursorLineNr cterm=None ctermfg=Yellow

" remove line highlighting on defocus
augroup linetoggle
	au!
	au BufEnter,WinEnter,FocusGained * setlocal cursorline
	au BufLeave,WinLeave,FocusLost   * setlocal nocursorline
augroup END

" matching paren highlighting
hi MatchParenActive ctermfg=232 ctermbg=81 cterm=bold
hi! link MatchParen MatchParenActive
au InsertEnter * hi clear MatchParen
au InsertLeave * hi! link MatchParen MatchParenActive

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
au FileType c,cpp,go,make,lex,yacc setlocal tabstop=8 shiftwidth=8
au FileType html setlocal tabstop=2 shiftwidth=2

" remove annoying LSP error/warning column
set scl=no

" syntax highlighting tweaks
hi lightBlue ctermfg=81
hi! Normal ctermfg=254
hi! link @text.literal Normal
hi! @punctuation.special ctermfg=11
hi! Title ctermfg=Magenta
hi! link TSFunctionCall lightBlue
hi! link Identifier lightBlue
hi! link @Include lightBlue
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
hi! link @text.literal lightBlue
"
" make floating windows not hideous
hi! NormalFloat cterm=bold ctermfg=white ctermbg=235
hi! Pmenu cterm=none ctermfg=245 ctermbg=235
hi! PmenuSel ctermfg=cyan ctermbg=240
hi! PmenuThumb ctermbg=245
hi! link PmenuSbar Normal

" remove annoying LSP underline
hi! clear DiagnosticUnderlineError
hi! clear DiagnosticUnderlineWarn
hi! clear DiagnosticUnderlineInfo
hi! clear DiagnosticUnderlineHint
