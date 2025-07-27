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
Plug 'tpope/vim-repeat'                                      " enables . command for some plugins
Plug 'tpope/vim-surround'                                    " super useful to (un)surround stuff
Plug 'itchyny/lightline.vim'                                 " statusline
Plug 'josa42/nvim-lightline-lsp'                             " add err and warning sign to lightline
Plug 'tpope/vim-sleuth'                                      " automatic indentation mode detection
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " a lot of functionality with ASTs
Plug 'nvim-treesitter/nvim-treesitter-textobjects'           " define bindings for actions with AST text objects
Plug 'nvim-treesitter/nvim-treesitter-context'               " show current function name when scrolling
Plug 'psliwka/vim-smoothie'                                  " smooth scrolling
Plug 'norcalli/nvim-colorizer.lua'                           " css colors preview
Plug 'nvim-lua/plenary.nvim'                                 " Telescope prerequisite; manually apply this https://github.com/nvim-lua/plenary.nvim/pull/649/commits/7750bc895a1f06aa7a940f5aea43671a74143be0
Plug 'nvim-telescope/telescope.nvim', {'branch': '0.1.x'}    " conveniently search buffers, files & whatever else
Plug 'shirosaki/tabular', { 'branch': 'fix_leading_spaces' } " multiline alignment plugin
Plug 'vim-scripts/AutoComplPop'                              " automatically suggest completions while typing
call plug#end()

let g:smoothie_no_default_mappings = 1

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
  \ : (winwidth(0) > 60 ? fnamemodify(expand('%'), ':~:.')
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

lua << EOF

-- treesitter config
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c", "cpp", "go", "javascript", "json", "python", "comment",
    "typescript", "c_sharp", "haskell", "markdown", "markdown_inline",
    "make", "html", "gitignore", "gitcommit", "arduino", "yaml", "sql",
    "css", "dockerfile", "bash", "rust", "query", "lua"
  },
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

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require('colorizer').setup {
  'css';
  'javascript';
  html = {
    mode = 'foreground';
  }
}

vim.diagnostic.config({
  virtual_text = true,
  -- diagnostic messages are highlighted via line numbers instead of signcolumn
  signs = {
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticLineNrError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticLineNrWarn',
    },
  },
})

vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.lsp.enable({'clangd'})
vim.lsp.enable({'gopls'})
vim.lsp.enable({'pyright'})
vim.lsp.enable({'ruff'})

require('treesitter-context').setup({enable=true})

EOF
