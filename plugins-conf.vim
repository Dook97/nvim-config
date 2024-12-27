" download vim-plug if we don't have it already
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
              \ > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

" download custom lighline theme if we don't have it already
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged/lightline.vim/autoload/lightline/colorscheme/dook.vim"'))
	echo "Downloading custom lighline theme..."
	silent !curl "https://raw.githubusercontent.com/Dook97/nvim-config/main/lightline_colors.vim" --hsts ""
              \ > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged/lightline.vim/autoload/lightline/colorscheme/dook.vim
endif

" use :PlugInstall to download & update these
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-repeat'                                     " enables . command for some plugins
Plug 'tpope/vim-surround'                                   " super useful to (un)surround stuff
Plug 'itchyny/lightline.vim'                                " statusline
Plug 'josa42/nvim-lightline-lsp'                            " add err and warning sign to lightline
Plug 'numToStr/Comment.nvim'                                " comment stuff
Plug 'tpope/vim-sleuth'                                     " automatic indentation mode detection
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " a lot of functionality with ASTs
Plug 'nvim-treesitter/nvim-treesitter-textobjects'          " define bindings for actions with AST text objects
Plug 'neovim/nvim-lspconfig'                                " preconfigure lsp servers
Plug 'nvim-treesitter/playground'                           " allows displaying treesitter capture groups
Plug 'hrsh7th/cmp-nvim-lsp'                                 " autocomplete with LSP
Plug 'hrsh7th/cmp-buffer'                                   " autocomplete words in buffer
Plug 'hrsh7th/cmp-path'                                     " autocomplete paths
Plug 'hrsh7th/nvim-cmp'                                     " autocompletion engine
Plug 'psliwka/vim-smoothie'                                 " smooth scrolling
Plug 'norcalli/nvim-colorizer.lua'                          " css colors preview
Plug 'nvim-treesitter/nvim-treesitter-context'              " show current function name when scrolling
Plug 'nvim-lua/plenary.nvim'                                " Telescope prerequisite
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.8'}      " conveniently search buffers, files & whatever else
Plug 'shirosaki/tabular', { 'branch': 'fix_leading_spaces'} " multiline alignment plugin
call plug#end()

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

let g:smoothie_no_default_mappings = 1

nnoremap <unique> <C-d> <cmd>call smoothie#do("\<C-D>") <CR>
vnoremap <unique> <C-d> <cmd>call smoothie#do("\<C-D>") <CR>
nnoremap <unique> <C-u> <cmd>call smoothie#do("\<C-u>") <CR>
vnoremap <unique> <C-u> <cmd>call smoothie#do("\<C-u>") <CR>

" netrw settings
let g:netrw_liststyle = 3
let g:netrw_banner = 0
au FileType netrw setlocal bufhidden=delete " delete unused netrw buffers

" lightline
function! GetPluginName()
  return &filetype ==# 'vim-plug' ? 'PLUG'
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
  return &readonly && &filetype !=# 'netrw' ? 'RO' : ''
endfunction

let g:lightline = {
  \ 'colorscheme' : 'dook',
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

hi LightlineLeft_active_error ctermfg=white ctermbg=red guifg=white guibg=red

let g:lightline.inactive              = { 'left':  [[ 'filename']], 'right': [[ ]] }
let g:lightline.tabline               = { 'left' : [[ 'tabs' ]], 'right' : [[ ]] }
let g:lightline.tabline_separator     = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator  = { 'left': '', 'right': '' }

call lightline#lsp#register()

" load commentary plugin
lua require('Comment').setup()

" change color of number row based on error detection
hi! DiagnosticLineNrError ctermbg=red guibg=red
hi! DiagnosticLineNrWarn ctermbg=136 guibg=#af8700
sign define DiagnosticSignError numhl=DiagnosticLineNrError
sign define DiagnosticSignWarn  numhl=DiagnosticLineNrWarn

lua << EOF

-- a workaround for a neovim bug; see:
-- https://github.com/itchyny/lightline.vim/pull/659#issuecomment-1704032081
local util = require "vim.lsp.util"
local orig = util.make_floating_popup_options
util.make_floating_popup_options = function(width, height, opts)
  local orig_opts = orig(width, height, opts)
  orig_opts.noautocmd = true
  return orig_opts
end

-- rounded border around diagnostic messages
vim.diagnostic.config {
  float = { border = "rounded" },
  severity_sort = true,
}

-- rounded corners around floating windows
-- also no underlines under LSP errors/warnings
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
  ["textDocument/show_line_diagnostics"] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { underline = false }),
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
}

-- set LSP keymaps
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.setloclist({severity="error"})<CR>', bufopts)
  vim.keymap.set('n', '<space>E', vim.diagnostic.setloclist, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set({'n', 'v'}, '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if vim.snippet.active({ direction = 1 }) then
      return '<cmd>lua vim.snippet.jump(1)<cr>'
    else
      return '<Tab>'
    end
  end, { expr = true })
  client.server_capabilities.semanticTokensProvider = nil
end

local cmp = require('cmp')
-- nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- disable LSP support for snippets
-- capabilities.textDocument.completion.completionItem.snippetSupport = false

-- set up language server for C(++)
require('lspconfig')['clangd'].setup {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}

-- set up language server for python
require('lspconfig')['pyright'].setup{
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { '*' }
      }
    }
  },
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}
require('lspconfig')['ruff'].setup{
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}

-- set up language server for c#
require('lspconfig')['csharp_ls'].setup{
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
}

-- set up language server for go
require('lspconfig')['gopls'].setup{
  on_attach = on_attach,
  handlers=handlers,
  capabilities = capabilities,
  settings = {
    gopls = {
      staticcheck = true,
      linksInHover = false,
    },
  },
}

require('lspconfig')['rust_analyzer'].setup{
  on_attach = on_attach,
  handlers=handlers,
  capabilities = capabilities,
}

-- treesitter config
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c", "cpp", "go", "javascript", "json", "latex", "python", "comment",
    "typescript", "c_sharp", "haskell", "markdown", "markdown_inline",
    "make", "html", "gitignore", "gitcommit", "arduino", "yaml", "sql",
    "css", "dockerfile", "bash", "rust", "query", "lua"
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
      -- Automatically jump forward to textobj
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
  preselect = 'none',
  sources = {
    { name = 'nvim_lsp_signature_help' },
    {
        name = 'nvim_lsp',
        -- entry_filter = function(entry)
        --   -- disable snippets in LSP completion menu
        --   return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
        -- end
    },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
}

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require 'colorizer'.setup {
  'css';
  'javascript';
  html = {
    mode = 'foreground';
  }
}

EOF
