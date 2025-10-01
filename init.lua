local o    = vim.o
local opt  = vim.opt
local g    = vim.g
local l    = vim.opt_local
local au   = vim.api.nvim_create_autocmd
local ucmd = vim.api.nvim_create_user_command

local map  = vim.keymap.set
local nmap = function(...) map("n", ...) end
local imap = function(...) map("i", ...) end
local vmap = function(...) map("v", ...) end
local cmap = function(...) map("c", ...) end
local omap = function(...) map("o", ...) end

vim.cmd.colorscheme("dook")

-- ___ PLUGINS ________________________________________________

g.smoothie_remapped_commands = { "<C-D>", "<C-U>" }

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
	"https://github.com/stevearc/conform.nvim",                                       -- ebin meta formatter thingy
	"https://github.com/nvim-lua/plenary.nvim",                                       -- telescope prerequisite
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x" },  -- conveniently search buffers, files & whatever else
	{ src = "https://github.com/shirosaki/tabular", version = "fix_leading_spaces" }, -- multiline alignment
})

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

" custom style
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'green'] ]
let s:p.normal.middle = [ [ 'mediumgreen', 'darkestgreen' ] ]
let s:p.normal.right = [ ['brightgreen', 'green', 'bold' ], ['brightgreen', 'darkestgreen'] ]
let s:p.normal.error = [ [ 'gray9', 'brightestred' ] ]
let s:p.normal.warning = [ [ 'gray1', 'yellow' ] ]

let s:p.insert.left = [ ['darkestcyan', 'white', 'bold'], ['white', 'darkblue'] ]
let s:p.insert.middle = [ [ 'mediumcyan', 'darkestblue' ] ]
let s:p.insert.right = [ [ 'mediumcyan', 'darkblue' ], [ 'mediumcyan', 'darkestblue' ] ]

let s:p.visual.left = [ ['darkred', 'brightorange', 'bold'], ['white', 'gray4'] ]
let s:p.visual.middle = [ [ 'gray7', 'gray2' ] ]
let s:p.visual.right = [ ['gray9', 'gray4'], ['gray8', 'gray2'] ]

let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray4'] ]
let s:p.replace.middle = s:p.visual.middle
let s:p.replace.right = s:p.visual.right

let s:p.tabline.left = [ [ 'gray9', 'none'] ]
let s:p.tabline.tabsel = [ [ 'gray10', 'darkestblue'] ]
let s:p.tabline.middle = [ [ 'none', 'none', 'none', 'none' ] ]
let s:p.tabline.right = [ [ 'none', 'none' ] ]

let s:p.inactive.right = [ ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.middle = s:p.visual.middle
let s:p.inactive.left = s:p.inactive.right[1:]

let g:lightline#colorscheme#__custom__#palette = lightline#colorscheme#fill(s:p)
]])

g.lightline = {
	colorscheme = "__custom__",
	component_function = {
		mode = "LightlineMode",
		readonly = "LightlineReadonly",
		fileinfo = "LightlineFileinfo",
		filename = "LightlineFilename",
		lineinfo = "LightlineLineinfo",
	},
	active = {
		left = {{ "mode", "paste" }, { "readonly", "filename", "lsp_errors", "lsp_warnings" }},
		right = {{ "lineinfo" }, { "fileinfo" }},
	},
	inactive = {
		left = {{ "filename" }},
		right = {{}},
	},
	tabline = { left = {{ "tabs" }}, right = {{}} },
	tabline_separator = { left = "", right = "" },
	tabline_subseparator = { left = "", right = "" },
}
g["lightline#lsp#indicator_warnings"] = "W "
g["lightline#lsp#indicator_errors"] = "E "
vim.fn["lightline#lsp#register"]()

-- netrw settings
g.netrw_liststyle = 3
g.netrw_banner = 0

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
o.termguicolors = true
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
for name, _ in vim.fs.dir(vim.fn.stdpath("config") .. "/lsp/") do
	vim.lsp.enable({ name:match("(.+)%.lua$") })
end

au("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
	end,
})

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
au("FileType", {
	pattern = vim.tbl_keys(require("conform").formatters_by_ft),
	group = vim.api.nvim_create_augroup("conform_formatexpr", { clear = true }),
	callback = function()
		l.formatexpr = 'v:lua.require("conform").formatexpr()'
	end,
})

-- ___ KEYBINDS _______________________________________________

g.mapleader = " "

-- alternate way to save
nmap("<leader>w", ":up<cr>")

-- make some backward-jumping operators inclusive
omap("F", "vF")
omap("T", "vT")
omap("b", "vb")
omap("B", "vB")
omap("^", "v^")
omap("0", "v0")

-- parens auto-close
imap("(", "()<Left>")
imap("{", "{}<Left>")
imap("[", "[]<Left>")
imap('"', '""<Left>')
imap("`", "``<Left>")

-- smart quit
nmap("<leader>q", function()
	if vim.fn.winnr("$") == 1 and vim.fn.tabpagenr("$") == 1 then
		vim.cmd("qa!")
		return
	end
	local win_count = 0
	local current_buf = vim.api.nvim_get_current_buf()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == current_buf then
			win_count = win_count + 1
		end
	end
	if win_count > 1 then
		vim.cmd("close!")
		return
	end
	vim.cmd("bdelete!")
end)

-- kill all buffers
nmap("<leader>Q", ":qa!<cr>")

-- quickly switch/delete/... buffers
nmap("<c-b>", "<cmd>buffers<cr>:b")

-- format
nmap("Q", "gqq")
vmap("Q", "gq")

-- better tabbing
vmap("<", "<gv")
vmap(">", ">gv")

-- vertical split shortcut
nmap("<c-w>v", ":vsplit<cr>")

-- copy to system clipboard
map({ "n", "v", "o" }, "Y", '"+y')
nmap("YY", '"+yy')

-- netrw (file explorer)
nmap("<leader>n", ":Explore<cr>")

-- paste over a selection without changing contents of the unnamed register
vmap("<leader>p", '"_dP')

-- save file as sudo on files that require root permission
cmap("w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")

-- tabular plugin shortcut
map({ "n", "v" }, "<c-t>", ":Tab /")

-- extended regex in searches
map({ "n", "v", "o" }, "/", "/\\v")
map({ "n", "v", "o" }, "/", "/\\v")

-- telescope
local tscope = require("telescope.builtin")
nmap("<leader>ff", function()
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
	if is_git_repo then
		tscope.git_files({ show_untracked = true })
	else
		tscope.find_files()
	end
end)
nmap("<leader>Ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nmap("<leader>man", function() tscope.man_pages({ sections = { "ALL" } }) end)
nmap("<leader>help", tscope.help_tags)

-- LSP
nmap("grd", vim.lsp.buf.definition)
nmap("grD", vim.lsp.buf.declaration)
nmap("grr", function() tscope.lsp_references({ show_line = false }) end)
nmap("gre", function() tscope.diagnostics({ bufnr = 0 }) end)
nmap("<c-w>[", "<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>") -- counterpart to <c-w>]
ucmd("LspStop", function() vim.lsp.stop_client(vim.lsp.get_clients()) end, {})
ucmd("LspRestart", function(kwargs)
	local name = kwargs.fargs[1]
	for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
		local bufs = vim.lsp.get_buffers_by_client_id(client.id)
		client:stop()
		vim.wait(30000, function()
			return vim.lsp.get_client_by_id(client.id) == nil
		end)
		local client_id = vim.lsp.start(client.config, { attach = false })
		if client_id then
			for _, buf in ipairs(bufs) do
				vim.lsp.buf_attach_client(buf, client_id)
			end
		end
	end
end, {
	nargs = "?",
	complete = function() return vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients()) end,
})

-- stolen from neovim runtime
local function comment(move)
	local lhs, rhs = (function()
		local ref_position = vim.api.nvim_win_get_cursor(0)
		local buf_cs = vim.bo.commentstring
		local ts_parser = vim.treesitter.get_parser(0, "", { error = false })
		if not ts_parser then
			return buf_cs
		end
		local row, col = ref_position[1] - 1, ref_position[2]
		local ref_range = { row, col, row, col + 1 }
		local caps = vim.treesitter.get_captures_at_pos(0, row, col)
		for i = #caps, 1, -1 do
			local id, metadata = caps[i].id, caps[i].metadata
			local md_cms = metadata["bo.commentstring"] or metadata[id] and metadata[id]["bo.commentstring"]
			if md_cms then
				return md_cms
			end
		end
		local ts_cs, res_level = nil, 0
		local function traverse(lang_tree, level)
			if not lang_tree:contains(ref_range) then
				return
			end
			local lang = lang_tree:lang()
			local filetypes = vim.treesitter.language.get_filetypes(lang)
			for _, ft in ipairs(filetypes) do
				local cur_cs = vim.filetype.get_option(ft, "commentstring")
				if cur_cs ~= "" and level > res_level then
					ts_cs = cur_cs
				end
			end
			for _, child_lang_tree in pairs(lang_tree:children()) do
				traverse(child_lang_tree, level + 1)
			end
		end
		traverse(ts_parser, 1)
		return ts_cs or buf_cs
	end)():match("^(.-)%%s(.*)$")
	local shiftstr = string.rep(vim.keycode("<Left>"), #rhs)
	vim.fn.feedkeys(move .. lhs .. rhs .. shiftstr, "n")
end
-- comment below/above/at the end of current line
nmap("gco", function() comment("o") end)
nmap("gcO", function() comment("O") end)
nmap("gcA", function() comment("A ") end)

-- keep cursor in place when joining lines
nmap("J", "mzJ`z:delmarks z<cr>")

-- autocompletion accept
imap("<c-j>", "<c-y>")

-- remove annoying, unnecessary default behaviour
map({ "n", "v" }, "<Space>", "<Nop>")

-- update hugo content dates
vim.cmd([[
function! HugoTimeUpdate_f()
	let currPos = getpos(".")
	if search('^draft = true$')
		/\v^date \= '\zs([^']*)\ze'$/s//\=substitute(system('date -I'), '\n', '', 'g')/
	endif
	if search('^lastmod = ')
		/\v^lastmod \= '\zs([^']*)\ze'$/s//\=substitute(system('date -I'), '\n', '', 'g')/
	endif
	call cursor(currPos[1], currPos[2])
endfunction
command! HugoTimeUpdate call HugoTimeUpdate_f()
]])

-- ___ GENERAL OPTIONS ________________________________________

vim.cmd("filetype plugin on")

o.smartindent = true

-- set window title
o.title = true

-- when to show status line
o.laststatus = 1
au("LspAttach", { command = "set laststatus=2" })
au({ "WinEnter", "WinClosed", "OptionSet" }, {
	pattern = { "*", "laststatus" },
	callback = function()
		local val = o.laststatus < 2 and vim.fn.winnr("$") < 2
		o.showmode = val
		o.ruler = val
	end,
})

-- reserved number of lines from top and bottom of viewport
o.scrolloff = 5

-- don't wrap long lines
o.wrap = false

-- splits open at the bottom and right
o.splitbelow = true
o.splitright = true

-- persistent undo
o.undofile = true

-- search is case insensitive unless upper case character is in the query
o.ignorecase = true
o.smartcase = true

-- lazy redraw - screen will not be redrawn while executing macros etc
o.lz = true

-- time to wait for a mapped sequence to complete
o.timeoutlen = 750

-- hack to put cursor at the beggining of a tab instead of the end
o.list = true
o.lcs = "tab:  "

-- disable right click popup menu
o.mousemodel = "extend"

-- floating window border style
o.winborder = "rounded"

-- insert mode completion options
o.autocomplete = true
o.complete = "o,.,w,b,u"
o.completeopt = "fuzzy,menuone,noselect,popup"
o.pumheight = 7
o.pummaxwidth = 80
opt.shortmess:prepend("c") -- avoid having to press enter on snippet completion

-- indentation settings
opt.cinoptions:append({ ":0", "g0", "N-s" })
opt.cinkeys:remove("0#")

-- hide end-of-buffer tildes
opt.fillchars:append({ eob = " " })

-- automatically deletes all trailing whitespace and newlines at end of file on save
au("BufWritePre", {
	callback = function()
		local curpos = vim.fn.getpos(".")
		vim.cmd([[%s/\v(\s+$|\n+%$)//e]])
		vim.fn.setpos(".", curpos)
	end,
})

-- remove line highlighting on defocus
au({ "BufEnter", "WinEnter", "FocusGained" }, { command = "setlocal cursorline" })
au({ "BufLeave", "WinLeave", "FocusLost" },   { command = "setlocal nocursorline" })

-- automatically normalize window sizes when neovim gets resized
au("VimResized", { command = "wincmd =" })

-- hide context lines when in cmdline/search so that we have a clear view of
-- what we're doing
au({ "CmdlineEnter", "CmdlineLeave" }, { command = "TSContext toggle" })

-- don't save empty windows on :mksession
opt.sessionoptions:remove("blank")

-- briefly highlight yanked region
au("TextYankPost", { callback = function() vim.highlight.on_yank() end, })

-- disable dumb bloat
o.signcolumn = "no"

-- .h files are C not C++
g.c_syntax_for_h = 1

-- hybrid numbers - relative in normal mode, absolute in insert mode
l.nu = true
l.rnu = true
au({ "BufEnter", "InsertLeave", "WinEnter", "FocusGained" }, { command = "if &nu | setlocal rnu" })
au({ "BufLeave", "InsertEnter", "WinLeave", "FocusLost" },   { command = "setlocal nornu" })
au("TermOpen", { command = "setlocal nonu nornu" })

-- <c-x><c-f> complete menu stays open as long as you accept tokens
au("CompleteDone", {
	callback = function()
		local e = vim.v.event
		if e.complete_type == "files" and e.reason == "accept" then
			vim.cmd.call([[feedkeys("\<c-x>\<c-f>", "n")]])
		end
	end,
})

-- fallback commentstring
au("BufEnter", {
	callback = function()
		if vim.fn.empty(l.commentstring) then l.commentstring = "# %s" end
	end,
})
