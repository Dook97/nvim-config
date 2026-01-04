set background=dark
set termguicolors
hi clear

set termguicolors

" Hide stupid lsp highlights
lua <<EOF
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
EOF

" highlight current line
set cursorline
hi! LineNr       gui=none guifg=#6c6c6c
hi! CursorLine   gui=none guibg=#333333
hi! CursorLineNr gui=none guifg=#fffe00

" matching paren highlighting
hi! MatchParenActive gui=bold guibg=#5fd7ff guifg=#08080a
hi! link MatchParen MatchParenActive
au InsertEnter * hi clear MatchParen
au InsertLeave * hi! link MatchParen MatchParenActive

" style vertical split line
hi! WinSeparator gui=None guifg=#585858
hi! clear StatusLine
hi! clear StatusLineNC
hi! TabLineSel guifg=#00c7ff guibg=#003f71

hi! Normal                      cterm=none ctermfg=254 ctermbg=none gui=none guifg=#d5d5d5 guibg=none
hi! Keyword                     gui=none guifg=#d0d000
hi! Type                        gui=none guifg=#919191
hi! Title                       gui=none guifg=#ff00ff
hi! @text.emphasis              gui=italic
hi! @text.strong                gui=bold
hi! Folded                      guibg=#383838 guifg=#59d0fd
hi! Todo                        guibg=#ffff00 guifg=black
hi! String                      guibg=none guifg=#5fbb25
hi! @comment.note               guifg=magenta
hi! Search                      guibg=Yellow guifg=black
hi! TreesitterContext           guibg=#265601
hi! manSubHeading               guifg=Magenta
hi! Added                       guifg=#19d50c
hi! Removed                     guifg=Red
hi! SpellBad                    guibg=#800000

hi! clear PreProc
hi! clear Define

au FileType vim hi! clear Type

hi lightBlue                    cterm=none ctermfg=81 gui=none guifg=#59d0fd
hi! link Comment                lightBlue
hi! link Constant               Normal
hi! link Statement              Keyword
hi! link Include                Keyword
hi! link Identifier             Normal
hi! link Repeat                 Keyword
hi! link Special                Normal
hi! link cssBraces              Normal
hi! link CurSearch              Search
hi! link Number                 Normal
hi! link Character              Normal
hi! link Function               Normal
hi! link Macro                  lightBlue
hi! link Operator               Normal
hi! link Property               Normal
hi! link xmlTag                 lightBlue
hi! link xmlTagName             lightBlue
hi! link Special                Normal
hi! link @boolean               Constant
hi! link @parameter             Normal
hi! link @function.call         Normal
hi! link @function.builtin      @function.call
hi! link @method.call           @function.call
hi! link @conditional           Keyword
hi! link @constructor           NONE
hi! link @constant              Normal
hi! link @constant.builtin      Constant
hi! link @storageclass          Keyword
hi! link @text.literal          lightBlue
hi! link @attribute             lightBlue
hi! link @type.qualifier        Keyword
hi! link @type.builtin          @type
hi! link arduinoFunc            @function.call
hi! link @text.danger           @text.todo
hi! link yaccAction             @function.call
hi! link yaccVar                Keyword
hi! link cmakeCommand           @function.call
hi! link cmakeKWproject         Keyword
hi! link manReference           lightBlue
hi! link manOptionDesc          lightBlue
hi! link @function.method.call  @function.call
hi! link qfLineNr               Normal
hi! link @comment.todo          Search
hi! link @comment.error         Search
hi! link @markup.list           lightBlue
hi! link @variable.parameter.bash NONE
hi! link @attribute.css         Normal
hi! link @type.css              Normal

" make floating windows not hideous
hi! NormalFloat     gui=bold guifg=white guibg=#262626
hi! Pmenu           gui=none guibg=#262626 guifg=#738589
hi! PmenuSel        guifg=black guibg=cyan gui=bold
hi! PmenuThumb      guibg=#738589
hi! FloatBorder     guibg=#262626
hi! link PmenuSbar  Normal
hi! FloatTitle guibg=#d5d5d5 guifg=black gui=bold
hi! MiniPickPrompt gui=bold guifg=Cyan guibg=#262626

" as far as I can tell this is just annoying in LSP windows and doesn't do
" anything useful
hi! clear Error

" change color of number row based on error detection
lua vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})
hi! DiagnosticUnderlineError cterm=none gui=none
hi! DiagnosticUnderlineWarn cterm=none gui=none
hi! DiagnosticLineNrError ctermbg=red guibg=red ctermfg=white guifg=white
hi! DiagnosticLineNrWarn ctermbg=136 guibg=#af8700 ctermfg=white guifg=white
hi! clear DiagnosticUnderlineInfo
hi! clear DiagnosticUnderlineHint

hi! DiagnosticError guifg=red

hi! @markup.heading.1.delimiter.vimdoc gui=none
" hi! @markup.raw.vimdoc guifg=#5fbb25
hi! @markup.link.vimdoc gui=italic guifg=#59d0fd
hi! link @string.special.url.vimdoc @markup.link.vimdoc

hi! qfLineNr gui=bold guifg=red
hi! qfFileName gui=bold guifg=Magenta
