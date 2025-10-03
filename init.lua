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

for _, pkg in ipairs({
	{ src = "nvim-lualine/lualine.nvim" },                                     -- statusline
	{ src = "nvim-mini/mini.pairs" },                                          -- autopair parens, quotes, ...
	{ src = "kylechui/nvim-surround" },                                        -- (un)surround stuff
	{ src = "tpope/vim-sleuth" },                                              -- automatic indentation mode detection
	{ src = "psliwka/vim-smoothie" },                                          -- smooth scrolling
	{ src = "norcalli/nvim-colorizer.lua" },                                   -- css colors preview
	{ src = "stevearc/conform.nvim" },                                         -- ebin meta formatter thingy
	{ src = "nvim-lua/plenary.nvim" },                                         -- telescope prerequisite
	{ src = "nvim-telescope/telescope.nvim" },                                 -- conveniently search buffers, files & whatever else
	{ src = "nvim-treesitter/nvim-treesitter-context" },                       -- show current function name when scrolling
	{ src = "shirosaki/tabular", version = "fix_leading_spaces" },             -- multiline alignment
	{ src = "nvim-treesitter/nvim-treesitter", version = "main" },             -- a lot of functionality with ASTs
	{ src = "nvim-treesitter/nvim-treesitter-textobjects", version = "main" }, -- define bindings for actions with AST text objects
}) do
	pkg.src = "https://github.com/" .. pkg.src
	vim.pack.add({pkg})
end

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "powerline",
		component_separators = "│",
		section_separators = {},
	},
	sections = {
		lualine_b = { { "filename", path = 1 } },
		lualine_c = { "diagnostics" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = {},
	},
})

-- netrw settings
g.netrw_liststyle = 3
g.netrw_banner = 0

require("nvim-treesitter").install({
	"c", "cpp", "go", "javascript", "json", "python", "comment",
	"typescript", "c_sharp", "haskell", "markdown", "markdown_inline",
	"make", "html", "gitignore", "gitcommit", "arduino", "yaml",
	"sql", "css", "dockerfile", "bash", "rust", "query", "lua",
})

-- enable treesitter highlighting
au("FileType", {
	callback = function() pcall(vim.treesitter.start) end,
})

require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
})

-- hex/html colors highlighting
o.termguicolors = true
require("colorizer").setup({
	"css",
	"javascript",
	html = { mode = "foreground", },
})

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

-- boilerplate
require("mini.pairs").setup()
require("nvim-surround").setup()

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
map({ "i", "c" }, "<c-j>", "<c-y>")

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

local ts_obj_s = require("nvim-treesitter-textobjects.select")
for _, v in ipairs({
	{ "if", "@function.inner" },
	{ "af", "@function.outer" },
	{ "ic", "@class.inner" },
	{ "ac", "@class.outer" },
	{ "iP", "@parameter.inner" },
	{ "aP", "@parameter.outer" },
	{ "iC", "@comment.inner" },
	{ "aC", "@comment.outer" },
}) do
	map({ "x", "o" }, v[1], function()
		ts_obj_s.select_textobject(v[2], "textobjects")
	end)
end

local ts_obj_m = require("nvim-treesitter-textobjects.move")
for _, v in ipairs({
	{ "]f", ts_obj_m.goto_next_start },
	{ "]F", ts_obj_m.goto_next_end },
	{ "[f", ts_obj_m.goto_previous_start },
	{ "[F", ts_obj_m.goto_previous_end },
}) do
	map({ "n", "x", "o" }, v[1], function() v[2]("@function.outer", "textobjects") end)
end

-- <c-x><c-f> complete menu stays open as long as you accept tokens
au("CompleteDone", {
	callback = function()
		local e = vim.v.event
		if e.complete_type == "files" and e.reason == "accept" then
			vim.cmd.call([[feedkeys("\<c-x>\<c-f>", "n")]])
		end
	end,
})

-- ___ GENERAL OPTIONS ________________________________________

vim.cmd("filetype plugin on")

o.smartindent = true

-- set window title
o.title = true

-- when to show status line
o.laststatus = 1
au("LspAttach", { command = "set laststatus=2" })

o.ruler = false
au({ "WinEnter", "WinClosed", "OptionSet" }, {
	pattern = { "*", "laststatus" },
	callback = function() o.showmode = o.laststatus < 2 and vim.fn.winnr("$") < 2 end,
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
o.nu = true
o.rnu = true
au({ "BufEnter", "InsertLeave", "WinEnter", "FocusGained" }, { command = "if &nu | setlocal rnu" })
au({ "BufLeave", "InsertEnter", "WinLeave", "FocusLost" },   { command = "setlocal nornu" })
au("TermOpen", { command = "setlocal nonu nornu" })

-- fallback commentstring
au("BufEnter", {
	callback = function()
		if vim.fn.empty(l.commentstring) then l.commentstring = "# %s" end
	end,
})

-- tab line config
function SafariTabLine()
	local tab_count = vim.fn.tabpagenr("$")
	local tab_width = math.floor(o.columns / tab_count)
	local s = ""
	for i = 1, tab_count do
		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end
		local bufname = vim.fn.bufname(vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)])
		if bufname == "" then
			bufname = "[No Name]"
		else
			bufname = vim.fn.fnamemodify(bufname, ":t")
		end
		local label = i .. ":" .. bufname
		label = " " .. label .. " "
		if #label < tab_width then
			label = label .. string.rep(" ", tab_width - #label)
		else
			label = string.sub(label, 1, tab_width)
		end
		s = s .. label
	end
	return s
end
o.tabline = "%!v:lua.SafariTabLine()"

-- lsp diagnostic text
vim.diagnostic.config({
	virtual_text = true,
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
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
	end,
})
