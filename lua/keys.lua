vim.g.mapleader = " "

local map  = vim.keymap.set
local nmap = function(...) map("n", ...) end
local imap = function(...) map("i", ...) end
local vmap = function(...) map("v", ...) end
local cmap = function(...) map("c", ...) end
local omap = function(...) map("o", ...) end
local ucmd = vim.api.nvim_create_user_command

-- Alternate way to save
nmap("<leader>w", ":up<cr>")

-- Make some backward-jumping operators inclusive
omap("F", "vF")
omap("T", "vT")
omap("b", "vb")
omap("B", "vB")
omap("^", "v^")
omap("0", "v0")

-- Parens auto-close
imap("(", "()<Left>")
imap("{", "{}<Left>")
imap("[", "[]<Left>")
imap('"', '""<Left>')
imap("`", "``<Left>")

nmap("<leader>q", function()
	-- 1. if there's only a single window in a single tab, quit
	if vim.fn.winnr("$") == 1 and vim.fn.tabpagenr("$") == 1 then
		vim.cmd("qa!")
		return
	end
	-- 2. If current buffer is shown in more than one window, close just the window
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
	-- 3. Otherwise, delete the buffer and close the window
	vim.cmd("bdelete!")
end)

-- kill all buffers
nmap("<leader>Q", ":qa!<cr>")

-- quickly switch/delete/... buffers
nmap("<c-b>", "<cmd>buffers<cr>:b")

-- format
nmap("Q", "gqq")
vmap("Q", "gq")

-- Better tabbing
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

-- Save file as sudo on files that require root permission
cmap("w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")

-- tabular plugin shortcut
map({ "n", "v" }, "<c-t>", ":Tab /")

-- extended regex in searches
map({ "n", "v" }, "/", "/\\v")

-- Telescope
local tscope = require("telescope.builtin")
nmap("<leader>Ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nmap("<leader>gs", "<cmd>Telescope git_status<cr>")
nmap("<leader>gb", "<cmd>Telescope git_branches<cr>")
nmap("<leader>gc", "<cmd>Telescope git_commits<cr>")
nmap("<leader>man", function() tscope.man_pages({ sections = { "ALL" } }) end)
nmap("<leader>help", tscope.help_tags)
nmap("<leader>ff", function()
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
	if is_git_repo then
		tscope.git_files({ show_untracked = true })
	else
		tscope.find_files()
	end
end)

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
	vim.fn.feedkeys(move .. lhs .. rhs .. shiftstr)
end
-- comment below/above/at the end of current line
nmap("gco", function() comment("o") end)
nmap("gcO", function() comment("O") end)
nmap("gcA", function() comment("A ") end)

-- keep cursor in place when joining lines
nmap("J", "mzJ`z:delmarks z<cr>")

-- autocompletion accept/reject
imap("<c-j>", "<c-y>")
imap("<c-k>", "<c-e>")

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
