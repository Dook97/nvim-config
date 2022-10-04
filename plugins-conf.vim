" you need to have the Plug plugin manager installed
" use :PlugInstall to download these
call plug#begin('~/.config/nvim/plugged')
	Plug 'tpope/vim-repeat'						" enables . command for some plugins
	Plug 'tpope/vim-surround'					" super useful to (un)surround stuff
	Plug 'itchyny/lightline.vim'					" statusline plugin
	Plug 'tpope/vim-commentary'					" comment stuff
	Plug 'ap/vim-css-color'						" show colors in css files
	Plug 'unblevable/quick-scope'					" easier f/F navigation
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}	" a lot of functionality with ASTs
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'		" define bindings for actions with AST text objects
	Plug 'nvim-treesitter/playground'				" :TSHighlightCapturesUnderCursor
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
	\ 'left':  [[ 'mode', 'paste' ], [ 'readonly', 'filename' ]],
	\ 'right': [[ 'lineinfo' ], [ 'fileinfo' ]]
\ }

let g:lightline.inactive		= { 'left':  [[ 'filename']], 'right': [[ ]] }
let g:lightline.tabline			= { 'left' : [[ 'tabs' ]], 'right' : [[ ]] }
let g:lightline.tabline_separator	= { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator	= { 'left': '', 'right': '' }

" quick-scope
hi QuickScopePrimary   cterm=reverse
hi QuickScopeSecondary cterm=reverse
let g:qs_highlight_on_keys = ['f', 'F']

" tree-sitter config
lua << EOF
require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = {
		"c", "cpp", "go", "javascript", "json", "latex", "python", "typescript", "lua"
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		additional_vim_regex_highlighting = false,
	},

	require'nvim-treesitter.configs'.setup {
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<leader><leader>",
				node_incremental = "<leader>i",
				node_decremental = "<leader>d",
			},
		},
	},

	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["aL"] = "@loop.outer",
				["iL"] = "@loop.inner",
				["aP"] = "@parameter.outer",
				["iP"] = "@parameter.inner",
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
EOF

" require"nvim-treesitter.highlight".set_custom_captures {
" 	["constant.builtin"] = "Normal",
" 	["function.builtin"] = "TSFunction",
" 	["constructor"]      = "TSFunction",
" 	["method.call"]      = "TSFunction",
" 	["namespace"]        = "Normal",
" 	["parameter"]        = "Normal",
" 	["property"]         = "Normal",
" 	["operator"]         = "Normal",
" }

hi goTSConstant ctermfg=7
hi link TSParameter Normal
hi link TSKeywordOperator Keyword
hi link TSOperator Normal
hi link TSFunction Normal
hi link TSFuncMacro Normal
hi link TSProperty Normal
hi link TSField Normal
hi link number Normal
hi link TSConstBuiltin Constant
hi link TSMethodCall  TSFunctionCall
hi link TSFuncBuiltin TSFunctionCall
hi link TSConstructor TSFunctionCall
hi TSFunctionCall ctermfg=81
