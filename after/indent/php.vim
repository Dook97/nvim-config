function! PhpIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif
  return indent(lnum)
endfunction
setlocal indentexpr=PhpIndent()
