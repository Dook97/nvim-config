function! LightlineFileinfo()
  return winwidth(0) < 80 ? '' : &fileformat . ' | ' . &fileencoding . ' | ' .  &filetype
endfunction

function! LightlineMode()
  return winwidth(0) < 50 ? '' : lightline#mode()
endfunction

function! LightlineLineinfo()
  return winwidth(0) < 50 ? '' : printf('%3s:%-2s', line('.'), col('.'))
endfunction

function! LightlineFilename()
  return expand('%') ==# '' ? '[NO NAME]'
  \ : (winwidth(0) > 60 ? fnamemodify(expand('%'), ':~:.')
  \ : expand('%:t')) . (&modified ? ' +' : '')
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !=# 'netrw' ? 'RO' : ''
endfunction

let g:lightline#lsp#indicator_warnings = 'W '
let g:lightline#lsp#indicator_errors = 'E '

lua <<EOF
vim.g.lightline = {
  colorscheme = 'dook',
  component_function = {
    mode = 'LightlineMode',
    readonly = 'LightlineReadonly',
    fileinfo = 'LightlineFileinfo',
    filename = 'LightlineFilename',
    lineinfo = 'LightlineLineinfo',
  },
  active = {
    left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'lsp_errors', 'lsp_warnings' } },
    right = { { 'lineinfo' }, { 'fileinfo' } }
  },
  inactive = {
    left = { { 'filename' } },
    right = { {} }
  },
  tabline = {
    left = { { 'tabs' } },
    right = { {} }
  },
  tabline_separator = {
    left = '',
    right = ''
  },
  tabline_subseparator = {
    left = '',
    right = ''
  },
}
EOF

call lightline#lsp#register()
