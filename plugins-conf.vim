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
	silent !mkdir -p
              \ ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged/lightline.vim/autoload/lightline/colorscheme
	silent !curl "https://raw.githubusercontent.com/Dook97/nvim-config/main/lightline_colors.vim" --hsts ""
              \ > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged/lightline.vim/autoload/lightline/colorscheme/dook.vim
endif

" use :PlugInstall to download & update these
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
  Plug 'tpope/vim-repeat'                                     " enables . command for some plugins
  Plug 'tpope/vim-surround'                                   " super useful to (un)surround stuff
  Plug 'itchyny/lightline.vim'                                " statusline
  Plug 'numToStr/Comment.nvim'                                " comment stuff
  Plug 'tpope/vim-sleuth'                                     " automatic indentation mode detection
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " a lot of functionality with ASTs
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'          " define bindings for actions with AST text objects
  Plug 'neovim/nvim-lspconfig'                                " preconfigure lsp servers
  Plug 'nvim-treesitter/playground'                           " allows displaying treesitter capture groups
  Plug 'josa42/nvim-lightline-lsp'                            " add err and warning sign to lightline
  Plug 'hrsh7th/cmp-nvim-lsp'                                 " autocomplete with LSP
  Plug 'hrsh7th/cmp-buffer'                                   " autocomplete words in buffer
  Plug 'hrsh7th/cmp-path'                                     " autocomplete paths
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'                  " shows info about the function signature
  Plug 'hrsh7th/nvim-cmp'                                     " autocompletion engine
  Plug 'psliwka/vim-smoothie'                                 " smooth scrolling
call plug#end()

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

hi LightlineLeft_active_error ctermfg=white ctermbg=red

let g:lightline.inactive              = { 'left':  [[ 'filename']], 'right': [[ ]] }
let g:lightline.tabline               = { 'left' : [[ 'tabs' ]], 'right' : [[ ]] }
let g:lightline.tabline_separator     = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator  = { 'left': '', 'right': '' }

call lightline#lsp#register()

" load commentary plugin
lua require('Comment').setup()

" change color of number row based on error detection
hi! DiagnosticLineNrError ctermbg=red
hi! DiagnosticLineNrWarn ctermbg=136
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
sign define DiagnosticSignWarn  text= texthl=DiagnosticSignWarn  linehl= numhl=DiagnosticLineNrWarn

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
}

-- set LSP keymaps
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)
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

-- set up language server for C(++)
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
}

EOF
