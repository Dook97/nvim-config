" automatically organize imports on write and format
" au BufWritePre *.go lua vim.lsp.buf.format()
" au BufWritePre *.go lua vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
