local o = vim.opt
local g = vim.g
local l = vim.opt_local
local au = vim.api.nvim_create_autocmd

vim.cmd("filetype plugin on")

o.smartindent = true
o.fileencoding = "utf-8"

-- set window title
o.title = true

-- show statusline automatically when coding, else only on multiple splits
o.laststatus = 1
au("LspAttach", { command = "set laststatus=2", })

-- unncessary since we're using lightline plugin
o.ruler = false
o.showmode = false

-- reserved number of lines from top and bottom of viewport
o.scrolloff = 1

-- don't wrap long lines
o.wrap = false

-- Splits open at the bottom and right
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
o.completeopt = "fuzzy,menuone,noselect,popup,preview"
o.pumheight = 7
o.pummaxwidth = 80
o.shortmess:prepend("c") -- avoid having to press enter on snippet completion

-- indentation settings
o.cinoptions:append({ ":0", "g0", "N-s" })
o.cinkeys:remove("0#")

-- hide end-of-buffer tildes
o.fillchars:append({ eob = " " })

-- Automatically deletes all trailing whitespace and newlines at end of file on save
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
o.sessionoptions:remove("blank")

-- briefly highlight yanked region
au("TextYankPost", { callback = function() vim.highlight.on_yank() end, })

-- disable dumb bloat
o.signcolumn = "no"

-- .h files are C not C++
g.c_syntax_for_h = 1

-- these are just better/more concise in vimscript
vim.cmd([[
" hybrid numbers - relative in normal mode, absolute in insert mode
set nu rnu
au BufEnter,InsertLeave,WinEnter,FocusGained * if &nu && mode() != "i" | set rnu   | endif
au BufLeave,InsertEnter,WinLeave,FocusLost   * if &nu                  | set nornu | endif
au TermOpen * setlocal nonu nornu

" <c-x><c-f> complete menu stays open as long as you accept tokens
au CompleteDone * if v:event.complete_type ==# "files" && v:event.reason ==# "accept"
	\ | call feedkeys("\<c-x>\<c-f>", "n")

" fallback commentstring
au BufEnter * if empty(&commentstring) | setlocal commentstring=\#\ %s
]])
