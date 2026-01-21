local o    = vim.o
local g    = vim.g
local v    = vim.v
local bo   = vim.bo
local wo   = vim.wo
local opt  = vim.opt

local map  = vim.keymap.set
local au   = vim.api.nvim_create_autocmd
local ucmd = vim.api.nvim_create_user_command

vim.cmd.colorscheme("dook")

-- ___ PLUGINS ________________________________________________

g.smoothie_remapped_commands = { "<C-D>", "<C-U>" }

for _, pkg in ipairs({
	{ src = "tpope/vim-sleuth" },                                  -- automatic indentation mode detection
	{ src = "psliwka/vim-smoothie" },                              -- smooth scrolling
	{ src = "stevearc/conform.nvim" },                             -- ebin meta formatter thingy
	{ src = "kylechui/nvim-surround" },                            -- (un)surround stuff
	{ src = "nvim-lualine/lualine.nvim" },                         -- statusline
	{ src = "nvim-mini/mini.extra" },                              -- extra pickers for mini.pick
	{ src = "nvim-mini/mini.pick" },                               -- general pickers
	{ src = "shirosaki/tabular", version = "fix_leading_spaces" }, -- multiline alignment
	{ src = "nvim-treesitter/nvim-treesitter" },                   -- a lot of functionality with ASTs
	{ src = "nvim-treesitter/nvim-treesitter-textobjects" },       -- define bindings for actions with AST text objects
	{ src = "nvim-treesitter/nvim-treesitter-context" },           -- show current function name when scrolling
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
	inactive_sections = {
		lualine_c = { { "filename", path = 1 } },
	},
})

-- netrw settings
g.netrw_liststyle = 3
-- g.netrw_banner = 0

require("nvim-treesitter").install({
	"c", "cpp", "go", "javascript", "json", "python", "comment",
	"typescript", "c_sharp", "haskell", "markdown", "markdown_inline",
	"make", "html", "gitignore", "gitcommit", "arduino", "yaml",
	"sql", "css", "dockerfile", "bash", "rust", "query", "lua",
})

-- highlighting
au("FileType", {
	callback = function() pcall(vim.treesitter.start) end,
})

require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true, set_jumps = true },
})

au("PackChanged", { command = "TSUpdate" })

-- for some langs use external formatters with range formatting provided by conform
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

-- use conform's formatexpr for filetypes that have a formatter set
au("FileType", {
	pattern = vim.tbl_keys(require("conform").formatters_by_ft),
	callback = function()
		bo.formatexpr = 'v:lua.require("conform").formatexpr()'
	end,
})

-- boilerplate
require("nvim-surround").setup()
require("mini.extra").setup()

-- mini.pick without gay icons
local pick = require("mini.pick")
pick.setup({ source = { show = pick.default_show }, mappings = { choose_marked = "<C-q>" } })

-- ___ KEYBINDS _______________________________________________

g.mapleader = " "

-- alternate way to save
map("n", "<leader>w", ":up<cr>")

-- make some backward-jumping operators inclusive
map("o", "F", "vF")
map("o", "T", "vT")
map("o", "b", "vb")
map("o", "B", "vB")
map("o", "^", "v^")
map("o", "0", "v0")

-- smart quit
map("n", "<leader>q", function()
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
map("n", "<leader>Q", ":qa!<cr>")

-- format
map("n", "Q", "gqq")
map("v", "Q", "gq")

-- better tabbing
map("v", "<", "<gv")
map("v", ">", ">gv")

-- vertical split shortcut
map("n", "<c-w>v", ":vsplit<cr>")

-- copy to system clipboard
map({ "n", "v", "o" }, "Y", '"+y')
map("n", "YY", '"+yy')

-- netrw (file explorer)
map("n", "<leader>n", ":Explore<cr>")

-- paste over a selection without changing contents of the unnamed register
map("v", "<leader>p", '"_dP')

-- save file as sudo on files that require root permission
map("c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")

-- tabular plugin shortcut
map({ "n", "v" }, "<c-t>", ":Tab /\\v")

-- extended regex in searches
map({ "n", "v", "o" }, "/", "/\\v")

-- picker
map("n", "<leader>ff", ":Pick files<cr>")
map("n", "<leader>fb", ":Pick buffers<cr>")
map("n", "<leader>fg", ":Pick grep_live<cr>")
map("n", "<leader>fm", ":Pick manpages<cr>")
map("n", "<leader>fh", ":Pick help<cr>")

-- LSP
map("n", "grd", vim.lsp.buf.definition)
map("n", "grD", vim.lsp.buf.declaration)
map("n", "<c-w>[", "<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>") -- counterpart to <c-w>]
map("n", "gre", "<cmd>Pick diagnostic<cr>")
map("n", "grr", "<cmd>Pick lsp scope=\"references\"<cr>")

-- comment below/above/at the end of current line
local function comment(move)
	-- get current commenstring based on treesitter; stolen from neovim runtime
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
map("n", "gco", function() comment("o") end)
map("n", "gcO", function() comment("O") end)
map("n", "gcA", function() comment("A ") end)

-- keep cursor in place when joining lines
map("n", "J", "mzJ`z:delmarks z<cr>")

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

-- treesitter textobjects mappings
local tssel = require("nvim-treesitter-textobjects.select").select_textobject
local tsmov = require("nvim-treesitter-textobjects.move")
local tsswp = require("nvim-treesitter-textobjects.swap")
map("n", "<leader>s", function() tsswp.swap_next("@parameter.inner") end)
map("n", "<leader>a", function() tsswp.swap_previous("@parameter.inner") end)
map({ "v", "o" }, "if", function() tssel("@function.inner", "textobjects") end)
map({ "v", "o" }, "af", function() tssel("@function.outer", "textobjects") end)
map({ "v", "o" }, "ic", function() tssel("@class.inner", "textobjects") end)
map({ "v", "o" }, "ac", function() tssel("@class.outer", "textobjects") end)
map({ "v", "o" }, "ia", function() tssel("@parameter.inner", "textobjects") end)
map({ "v", "o" }, "aa", function() tssel("@parameter.outer", "textobjects") end)
map({ "v", "o" }, "iC", function() tssel("@comment.inner", "textobjects") end)
map({ "v", "o" }, "aC", function() tssel("@comment.outer", "textobjects") end)
map({ "n", "v", "o" }, "]f", function() tsmov.goto_next_start("@function.outer") end)
map({ "n", "v", "o" }, "]F", function() tsmov.goto_next_end("@function.outer") end)
map({ "n", "v", "o" }, "[f", function() tsmov.goto_previous_start("@function.outer") end)
map({ "n", "v", "o" }, "[F", function() tsmov.goto_previous_end("@function.outer") end)

-- <c-x><c-f> complete menu stays open as long as you accept tokens
au("CompleteDone", {
	callback = function()
		local e = v.event
		if e.complete_type == "files" and e.reason == "accept" then
			vim.cmd.call([[feedkeys("\<c-x>\<c-f>", "n")]])
		end
	end,
})

-- hide autocompletion when trying to view signature help
map("i", "<c-s>", function()
	vim.cmd.call([[feedkeys("\<c-e>", "n")]])
	vim.lsp.buf.signature_help()
end)

-- show git blame for current line(s)
map({"n", "v"}, "<leader>gb", function()
  local start_line, end_line
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end
  local file = vim.fn.expand("%")
  local cmd = string.format("git blame -c -L %d,%d -- %s |& tr '\t' ' '", start_line, end_line, file)
  local out = vim.fn.systemlist(cmd)
  if start_line == end_line then
    vim.api.nvim_echo({{out[1], "Normal"}}, false, {})
  else
    for _, line in ipairs(out) do
      vim.api.nvim_echo({{line, "Normal"}}, false, {})
    end
  end
end)

-- disable smoothie in diff buffers (doesnt play well with folds)
au("BufEnter", {
	callback = function()
		if vim.wo.diff then
			map({ "n", "v" }, "<c-d>", "<c-d>", { buffer = true })
			map({ "n", "v" }, "<c-u>", "<c-u>", { buffer = true })
		end
	end,
})

ucmd("Grep", function(opts)
  vim.cmd("silent! cclose")
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
end, { nargs = "+" })

-- take current command prefix into account when using <c-p>/<c-n>
map("c", "<c-p>", "<up>")
map("c", "<c-n>", "<down>")

-- easier completion accept
map({ "i", "c" }, "<c-j>", "<c-y>")

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

-- keep some space betwwen cursor and window edges
o.scrolloff = 2
o.sidescrolloff = 5

-- don't wrap long lines
o.wrap = false

-- splits open at the bottom and right
o.splitbelow = true
o.splitright = true

-- persistent undo
o.undofile = true
-- o.swapfile = false

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
o.complete = "o,.,w,f"
o.completeopt = "fuzzy,menuone,noselect,popup"
o.pumheight = 7
o.pummaxwidth = 80
opt.shortmess:prepend("c") -- avoid having to press enter on snippet completion
-- au("LspAttach", { command = "setlocal complete^=o" })

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
o.cursorline = false -- to prevent cursorline showing in multiple splits when started with -o/-O
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
o.rnu = false -- to prevent relative numbers in multiple splits when started with -o/-O
au({ "BufEnter", "InsertLeave", "WinEnter", "FocusGained" }, { command = "if &nu | setlocal rnu" })
au({ "BufLeave", "InsertEnter", "WinLeave", "FocusLost" },   { command = "setlocal nornu" })
au("TermOpen", { command = "setlocal nonu nornu" })

-- fallback commentstring
au("BufEnter", { command = "if empty(&cms) | setlocal cms=#\\ %s" })

-- lsp diagnostic text
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	signs = {
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
			[vim.diagnostic.severity.WARN]  = "DiagnosticLineNrWarn",
		},
	},
})

-- load lsp servers' confs
vim.lsp.config("*", { root_markers = { ".git" }})
for name, _ in vim.fs.dir(vim.fn.stdpath("config") .. "/lsp/") do
	vim.lsp.enable({ name:match("(.+)%.lua$") })
end

-- enable lsp completion (snippets etc)
au("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
	end,
})

-- yank ring
-- last yanked/deleted text goes to "1, the previous contents of "2 go to "3 and so on
au("TextYankPost", {
	callback = function()
		local evt = v.event
		for i = 9, 2, -1 do
			local prev = tostring(i - 1)
			vim.fn.setreg(tostring(i), vim.fn.getreg(prev), vim.fn.getregtype(prev))
		end
		vim.fn.setreg("1", evt.regcontents, evt.regtype)
	end,
})

-- cmdline autocompletion
au("CmdlineChanged", { pattern = ":", command = "call wildtrigger()" })
o.wildmode = "noselect:lastused,full"
o.wildoptions = "pum"

-- experimental new command-line features
require("vim._extui").enable({})

-- interactive textual undotree
vim.cmd.packadd("nvim.undotree")

-- tab line
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

-- fold appearence
function MyFoldText()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_buf_get_lines(bufnr, v.foldstart - 1, v.foldstart, false)[1]
	local ts = bo[bufnr].tabstop or 8
	local expanded = line:gsub("\t", string.rep(" ", ts))
	return expanded .. " ⋅⋅⋅ (" .. v.foldend - v.foldstart + 1 .. " lines) "
end
o.foldtext = "v:lua.MyFoldText()"

-- quickfix list appearence
function my_qftf(info)
  local out = {}
  local items = vim.fn.getqflist()
  for i, item in ipairs(items) do
    local filename = item.filename
    if (not filename or filename == '') and item.bufnr and tonumber(item.bufnr) ~= 0 then
      filename = vim.fn.bufname(item.bufnr)
    end
    filename = filename ~= '' and filename or "[NoFile]"
    local lnum = item.lnum or 0
    local msg = item.text or item.pattern or ''
    table.insert(out, string.format("%s|%d| %s", filename, tonumber(lnum), msg))
  end
  return out
end
o.qftf = "v:lua.my_qftf"
