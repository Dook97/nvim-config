vim.g.smoothie_remapped_commands = { "<C-D>", "<C-U>" }

vim.pack.add({
	"https://github.com/kylechui/nvim-surround",                                      -- (un)surround stuff
	"https://github.com/itchyny/lightline.vim",                                       -- statusline
	"https://github.com/josa42/nvim-lightline-lsp",                                   -- add err and warning sign to lightline
	"https://github.com/tpope/vim-sleuth",                                            -- automatic indentation mode detection
	"https://github.com/nvim-treesitter/nvim-treesitter",                             -- a lot of functionality with ASTs
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",                 -- define bindings for actions with AST text objects
	"https://github.com/nvim-treesitter/nvim-treesitter-context",                     -- show current function name when scrolling
	"https://github.com/psliwka/vim-smoothie",                                        -- smooth scrolling
	"https://github.com/norcalli/nvim-colorizer.lua",                                 -- css colors preview
	"https://github.com/nvim-lua/plenary.nvim",                                       -- telescope prerequisite
	"https://github.com/stevearc/conform.nvim",                                       -- ebin meta formatter thingy
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x" },  -- conveniently search buffers, files & whatever else
	{ src = "https://github.com/shirosaki/tabular", version = "fix_leading_spaces" }, -- multiline alignment
})

-- lightline
local theme = (os.getenv("XDG_DATA_HOME") or "~/.local/share")
	.. "/nvim/site/pack/core/opt/lightline.vim/autoload/lightline/colorscheme/dook.vim"
if vim.fn.filereadable(theme) == 0 then
	print("Downloading custom lightline theme...")
	vim.fn.system({
		"curl",
		"-fLo",
		theme,
		"--create-dirs",
		"https://raw.githubusercontent.com/Dook97/nvim-config/main/lightline_colors.vim",
	})
end

-- has to be defined in vimscript, idk why
vim.cmd([[
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
]])

vim.g["lightline#lsp#indicator_warnings"] = "W "
vim.g["lightline#lsp#indicator_errors"] = "E "
vim.g.lightline = {
	colorscheme = "dook",
	component_function = {
		mode = "LightlineMode",
		readonly = "LightlineReadonly",
		fileinfo = "LightlineFileinfo",
		filename = "LightlineFilename",
		lineinfo = "LightlineLineinfo",
	},
	active = {
		left = { { "mode", "paste" }, { "readonly", "filename", "lsp_errors", "lsp_warnings" } },
		right = { { "lineinfo" }, { "fileinfo" } },
	},
	inactive = {
		left = { { "filename" } },
		right = { {} },
	},
	tabline = { left = { { "tabs" } },
		right = { {} },
	},
	tabline_separator    = { left = "", right = "", },
	tabline_subseparator = { left = "", right = "", },
}
vim.cmd("call lightline#lsp#register()")

-- netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

-- treesitter config
require("nvim-treesitter.configs").setup({
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
			set_jumps = true, -- jumplist
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
})

-- hex/html colors highlighting
vim.o.termguicolors = true
require("colorizer").setup({
	"css",
	"javascript",
	html = {
		mode = "foreground",
	},
})

-- lsp diagnostic text
vim.diagnostic.config({
	virtual_text = true,
	-- diagnostic messages are highlighted via line numbers instead of signcolumn
	signs = {
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
			[vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
		},
	},
})

-- lsp conf
vim.lsp.config("*", {
	root_markers = { ".git" },
})
-- enable all configured LSP servers
local servers = vim.fn.systemlist([[ ls ${XDG_CONFIG_HOME}/nvim/lsp/ | sed -E 's/(.*)\\.lua$/\\1/' ]])
for _, line in ipairs(servers) do
	vim.lsp.enable({ line:match("(.+)%.lua$") })
end

require("treesitter-context").setup({ enable = true })
require("nvim-surround").setup()

require("conform").setup({
	formatters_by_ft = {
		sh   = { "shfmt", "shellcheck" },
		zsh  = { "shfmt", "shellcheck" },
		bash = { "shfmt", "shellcheck" },
		go   = { "gofmt" },
		cs   = { "clang-format" },
		js   = { "clang-format" },
		java = { "clang-format" },
		json = { "jq" },
		lua  = { "stylua" },
	},
})

-- use conform as gq for filetypes that have a formatter set
vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(require("conform").formatters_by_ft),
	group = vim.api.nvim_create_augroup("conform_formatexpr", { clear = true }),
	callback = function()
		vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()'
	end,
})
