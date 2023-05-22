" you need to have the Plug plugin manager installed
" use :PlugInstall to download these
call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-repeat'                                     " enables . command for some plugins
  Plug 'tpope/vim-surround'                                   " super useful to (un)surround stuff
  Plug 'itchyny/lightline.vim'                                " statusline plugin
  Plug 'numToStr/Comment.nvim'                                " comment stuff
  Plug 'tpope/vim-sleuth'                                     " automatic indentation mode detection
  Plug 'ap/vim-css-color'                                     " show colors in css files
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " a lot of functionality with ASTs
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'          " define bindings for actions with AST text objects
  Plug 'neovim/nvim-lspconfig'                                " preconfigure lsp servers
  Plug 'nvim-treesitter/playground'                           " allows displaying treesitter capture groups
  Plug 'josa42/nvim-lightline-lsp'                            " add err and warning sign to lightline
  Plug 'hrsh7th/cmp-nvim-lsp'                                 " autocomplete with LSP
  Plug 'hrsh7th/cmp-buffer'                                   " autocomplete words in buffer
  Plug 'hrsh7th/cmp-path'                                     " autocomplete paths
  Plug 'hrsh7th/nvim-cmp'                                     " autocompletion engine
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'                  " shows info about the function signature
call plug#end()

" netrw settings
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" lightline
function! GetPluginName()
  return &filetype ==# 'nerdtree' ? 'NERD'
  \ : &filetype ==# 'vim-plug' ? 'PLUG'
  \ : ''
endfunction

function! LightlineFileinfo()
  return GetPluginName() !=# '' || winwidth(0) < 80 ? ''
  \ : &fileformat . ' | ' . &fileencoding . ' | ' .  &filetype
endfunction

function! LightlineMode()
  return GetPluginName() !=# '' || winwidth(0) < 50 ? '' : lightline#mode()
endfunction

function! LightlineLineinfo()
  return GetPluginName() !=# '' || winwidth(0) < 50 ? '' : printf('%3s:%-2s', line('.'), col('.'))
endfunction

function! LightlineFilename()
  return GetPluginName() !=# '' ? GetPluginName()
  \ : expand('%') ==# '' ? '[NO NAME]'
  \ : (winwidth(0) > 60 ? expand('%:p:~')
  \ : expand('%:t')) . (&modified ? ' +' : '')
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !=# 'nerdtree' ? 'RO' : ''
endfunction

let g:lightline = {
  \ 'colorscheme' : 'powerline_transparent',
  \ 'component_function': {
    \ 'mode': 'LightlineMode',
    \ 'readonly': 'LightlineReadonly',
    \ 'fileinfo' : 'LightlineFileinfo',
    \ 'filename': 'LightlineFilename',
  \ 'lineinfo': 'LightlineLineinfo',
  \ },
\ }

let g:lightline.active = {
  \ 'left':  [[ 'mode', 'paste' ], [ 'readonly', 'filename', 'lsp_errors', 'lsp_warnings' ]],
  \ 'right': [[ 'lineinfo' ], [ 'fileinfo' ]]
\ }

let g:lightline#lsp#indicator_warnings = 'W '
let g:lightline#lsp#indicator_errors = 'E '

hi LightlineLeft_active_error ctermfg=white ctermbg=red

call lightline#lsp#register()

let g:lightline.inactive    = { 'left':  [[ 'filename']], 'right': [[ ]] }
let g:lightline.tabline      = { 'left' : [[ 'tabs' ]], 'right' : [[ ]] }
let g:lightline.tabline_separator  = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator  = { 'left': '', 'right': '' }

" load commentary plugin
lua require('Comment').setup()

" change color of number row based on error detection
hi! DiagnosticLineNrError ctermbg=red
hi! DiagnosticLineNrWarn ctermbg=136
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
sign define DiagnosticSignWarn  text= texthl=DiagnosticSignWarn  linehl= numhl=DiagnosticLineNrWarn

lua << EOF
-- rounded border around diagnostic messages
vim.diagnostic.config {
  -- float = { border = "rounded" },
  severity_sort = true,
}

-- rounded corners around floating windows
-- also no underlines under LSP errors/warnings
local handlers = {
  -- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
  -- ["textDocument/show_line_diagnostics"] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { underline = false }),
}

-- set LSP keymaps
local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>A', vim.lsp.buf.code_action, bufopts)
  client.server_capabilities.semanticTokensProvider = nil
end

local cmp = require('cmp')
-- nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- disable LSP support for snippets
capabilities.textDocument.completion.completionItem.snippetSupport = false

require('lspconfig')['clangd'].setup {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}

-- set up language server for python
require('lspconfig')['pyright'].setup{
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}

-- set up language server for c#
require('lspconfig')['csharp_ls'].setup{
  on_attach = on_attach,
  handlers=handlers,
  capabilities = capabilities,
}

-- treesitter config
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c", "cpp", "go", "javascript", "json", "latex", "python", "comment",
    "typescript", "lua", "c_sharp", "haskell", "markdown", "markdown_inline",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aP"] = "@parameter.outer",
        ["iP"] = "@parameter.inner",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["iC"] = "@comment.inner",
        ["aC"] = "@comment.outer",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]p"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[p"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
}

cmp.setup {
  sources = {
    { name = 'nvim_lsp_signature_help' },
    {
        name = 'nvim_lsp',
        entry_filter = function(entry)
          -- disable snippets in LSP completion menu
          return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
        end
    },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
  end
}

EOF
