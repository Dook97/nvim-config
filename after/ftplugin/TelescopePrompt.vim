set noac
augroup tscope_ac
  au!
  au FileType * if index(['TelescopePrompt','TelescopeResults'], &ft) < 0 | set ac
augroup END
