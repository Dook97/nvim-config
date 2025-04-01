set background=dark
hi clear

set termguicolors

" highlight current line
set cursorline
hi! LineNr       cterm=NONE ctermfg=242 gui=NONE guifg=#6c6c6c
hi! CursorLine   cterm=NONE ctermbg=238 gui=NONE guibg=#444444
hi! CursorLineNr cterm=NONE ctermfg=11  gui=NONE guifg=#fffe00

" matching paren highlighting
hi! MatchParenActive cterm=bold ctermbg=81 ctermfg=232 gui=bold guibg=#5fd7ff guifg=#08080a
hi! link MatchParen MatchParenActive
au InsertEnter * hi clear MatchParen
au InsertLeave * hi! link MatchParen MatchParenActive

" style vertical split line
hi! VertSplit cterm=NONE ctermfg=240 ctermbg=NONE gui=NONE guifg=#585858
hi! clear StatusLine
hi! clear StatusLineNC

hi lightBlue			cterm=NONE ctermfg=81 gui=NONE guifg=#59d0fd
hi! Normal			cterm=NONE ctermfg=254 ctermbg=NONE gui=NONE guifg=#e5e5e5 guibg=NONE
hi! Keyword			cterm=NONE ctermfg=11 gui=NONE guifg=#fffe00
hi! Type			cterm=NONE ctermfg=121 gui=NONE guifg=#87ffaf
hi! Comment			cterm=NONE ctermfg=14 gui=NONE guifg=#00ffff
hi! Constant			cterm=NONE ctermfg=13 gui=NONE guifg=#ff00ff
hi! Title			cterm=NONE ctermfg=13 gui=NONE guifg=#ff00ff
hi! @text.emphasis		cterm=italic gui=italic
hi! @text.strong		cterm=bold gui=bold
hi! @punctuation.special	ctermfg=11
hi! Folded			ctermfg=14 ctermbg=236 guibg=#383838 guifg=#59d0fd
hi! Todo			ctermfg=0 ctermbg=11 guibg=#ffff00 guifg=black

hi! link Statement		Keyword
hi! link Include		Keyword
hi! link Identifier		Normal
hi! link Repeat			Keyword
hi! link Special		Normal
hi! link cssBraces		Normal
hi! link CurSearch		Search
hi! link Number			Normal
hi! link Character		Normal
hi! link Function		Normal
hi! link Macro			lightBlue
hi! link Operator		Normal
hi! link Property		Normal
hi! link xmlTag			lightBlue
hi! link xmlTagName		lightBlue
hi! link Special		Normal
hi! link @boolean		Constant
hi! link @string		Normal
hi! link @string.escape		Constant
hi! link @PreProc		Keyword
hi! link @Define		@PreProc
hi! link @parameter		Normal
hi! link @function.call		lightBlue
hi! link @function.builtin	@function.call
hi! link @method.call		@function.call
hi! link @conditional		Keyword
hi! link @constructor		NONE
hi! link @constant.builtin	Constant
hi! link @keyword.operator	Keyword
hi! link @storageclass		Keyword
hi! link @text.literal		lightBlue
hi! link @attribute		lightBlue
hi! link @type.qualifier	Keyword
hi! link arduinoFunc		@function.call
hi! link @text.danger		@text.todo
hi! link yaccAction		@function.call
hi! link yaccVar		Keyword
hi! link cmakeCommand		@function.call
hi! link cmakeKWproject		Keyword
hi! link manReference		lightBlue
hi! link @function.method.call	@function.call
hi! link qfLineNr		Normal
hi! link @comment.todo		Search
hi! link @comment.error		Search

" make floating windows not hideous
hi! NormalFloat cterm=bold ctermfg=white ctermbg=235 gui=bold guifg=white guibg=#262626
hi! Pmenu cterm=NONE ctermfg=245 ctermbg=235 gui=NONE guibg=#262626 guifg=#738589
hi! PmenuSel ctermfg=cyan ctermbg=240 guifg=cyan guibg=#738589
hi! PmenuThumb ctermbg=245 guibg=#738589
hi! link PmenuSbar Normal
hi! FloatBorder ctermbg=235 guibg=#262626

" remove annoying LSP underline
hi! clear DiagnosticUnderlineError
hi! clear DiagnosticUnderlineWarn
hi! clear DiagnosticUnderlineInfo
hi! clear DiagnosticUnderlineHint

" as far as I can tell this is just annoying in LSP windows and doesn't do
" anything useful
hi! Error ctermfg=9 ctermbg=NONE guifg=Red guibg=NONE
