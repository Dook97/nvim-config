" disable autocompletion
setlocal noac
augroup tscope | au! BufLeave * if &ft ==# 'TelescopePrompt' | setlocal ac | augroup END
