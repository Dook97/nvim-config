" you need to have the Plug plugin manager installed
" use :PlugInstall to download these
call plug#begin('~/.config/nvim/plugged')
	Plug 'tpope/vim-surround'					" super useful to (un)surround stuff
	Plug 'preservim/nerdtree'					" integrated file manager
	Plug 'itchyny/lightline.vim'					" statusline plugin
	Plug 'tpope/vim-commentary'					" comment stuff
	Plug 'ap/vim-css-color'						" show colors in css files
	Plug 'unblevable/quick-scope'					" easier f/F navigation
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}	" a lot of functionality with ASTs
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'		" define bindings for actions with AST text objects
	Plug 'tpope/vim-repeat'						" enables . command for some plugins
	Plug 'glts/vim-magnum' 						" library needed for vim-radical
	Plug 'glts/vim-radical'						" number conversions
call plug#end()

" nerdtree
let NERDTreeMinimalUI			= 1
let NERDTreeDirArrows			= 1
let NERDTreeAutoDeleteBuffer		= 1
let NERDTreeShowHidden			= 1
let NERDTreeCascadeSingleChildDir	= 0
let NERDTreeCascadeOpenSingleChildDir	= 0

" lightline
let g:lightline				= { 'colorscheme' : 'powerline_transparent' }
let g:lightline.tabline			= { 'left' : [[ 'tabs' ]], 'right' : [[ ]] }
let g:lightline.tabline_separator	= { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator	= { 'left': '', 'right': '' }
let g:lightline.inactive = { 'left':  [[ 'filename']], 'right': [[ 'lineinfo' ]] }
let g:lightline.active = {
	\ 'left':  [[ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ]],
	\ 'right': [[ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ]]
\}

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

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<CR>',
			scope_incremental = '<CR>',
			node_incremental = '<TAB>',
			node_decremental = '<S-TAB>',
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

require"nvim-treesitter.highlight".set_custom_captures {
	["parameter"] = "Normal",
	["property"]  = "Normal",
	["operator"]  = "Normal",
	["function"]  = "Normal",
	["method"]    = "Normal",
}
EOF
