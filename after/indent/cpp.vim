" Don't indent template
function! CppNoTemplateIndent()
    let l:cline_num = line('.')
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
        let l:pline_num = prevnonblank(l:pline_num - 1)
        let l:pline = getline(l:pline_num)
    endwhile
    let l:retv = cindent('.')
    let l:pindent = indent(l:pline_num)
    if l:pline =~# '^\s*template'
        let l:retv = l:pindent
    endif
    return l:retv
endfunction
setlocal indentexpr=CppNoTemplateIndent()
