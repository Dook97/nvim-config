set background=dark
hi clear

" set highlight groups
hi LineNr      ctermfg=242
hi LineNrAbove ctermfg=242
hi LineNrBelow ctermfg=242

" highlight current line
set cursorline
hi CursorLine   cterm=None ctermbg=238
hi CursorLineNr cterm=None ctermfg=Yellow

" matching paren highlighting
hi MatchParenActive ctermfg=232 ctermbg=81 cterm=bold
hi! link MatchParen MatchParenActive
au InsertEnter * hi clear MatchParen
au InsertLeave * hi! link MatchParen MatchParenActive

" style vertical split line
hi VertSplit    ctermfg=240  ctermbg=None cterm=None
hi StatusLine   ctermfg=None ctermbg=None cterm=None
hi StatusLineNC ctermfg=None ctermbg=None cterm=None

" syntax highlighting tweaks
hi lightBlue			ctermfg=81
hi! Normal			ctermfg=254
hi! Title			ctermfg=Magenta
hi! @text.emphasis		cterm=italic
hi! @text.strong		cterm=bold
hi! @punctuation.special	ctermfg=11
hi! link Identifier		Normal
hi! link Special		Normal
hi! link cssBraces		Normal
hi! link CurSearch		Search
hi! link Number			Normal
hi! link Function		Normal
hi! link Operator		Normal
hi! link Property		Normal
hi! link xmlTag			lightBlue
hi! link xmlTagName		lightBlue
hi! link Special		Normal
hi! link @string.escape		Normal
hi! link @PreProc		Keyword
hi! link @parameter		Normal
hi! link @function.call		lightBlue
hi! link @function.builtin	@function.call
hi! link @method.call		@function.call
" hi! link @function.macro	Normal
hi! link @constructor		NONE
hi! link @constant.builtin	Constant
hi! link @keyword.operator	Keyword
hi! link @storageclass		Keyword
hi! link @text.literal		lightBlue
hi! link @attribute		lightBlue
hi! link @type.qualifier	Keyword
hi! link arduinoFunc		@function.call
hi! link @text.danger		@text.todo

" make floating windows not hideous
hi! NormalFloat cterm=bold ctermfg=white ctermbg=235
hi! Pmenu cterm=none ctermfg=245 ctermbg=235
hi! PmenuSel ctermfg=cyan ctermbg=240
hi! PmenuThumb ctermbg=245
hi! link PmenuSbar Normal
hi! FloatBorder ctermbg=235

" remove annoying LSP underline
hi! clear DiagnosticUnderlineError
hi! clear DiagnosticUnderlineWarn
hi! clear DiagnosticUnderlineInfo
hi! clear DiagnosticUnderlineHint

" as far as I can tell this is just annoying in LSP windows and doesn't do
" anything useful
hi! clear Error
