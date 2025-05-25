let mapleader=" "

" Alternate way to save
nnoremap <leader>w :up<CR>

" make some backward-jumping operators inclusive (include character under cursor)
onoremap F vF
onoremap T vT
onoremap b vb
onoremap B vB
onoremap ^ v^
onoremap 0 v0

" Parens auto-close
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

lua <<EOF
local function SmartQuit()
	-- 1. if there's only a single window in a single tab, quit
	if vim.fn.winnr('$') == 1 and vim.fn.tabpagenr('$') == 1 then
		vim.cmd('qa!')
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
		vim.cmd('close!')
		return
	end

	-- 3. Otherwise, delete the buffer and close the window
	vim.cmd('bdelete!')
end
vim.keymap.set('n', '<leader>q', SmartQuit, { noremap = true, silent = true })
EOF

" kill all buffers
nnoremap <leader>Q :qa!<CR>

" quickly switch/delete/... buffers
noremap <c-b> :buffers<CR>:b

" format
nnoremap Q gqq
vnoremap Q gq

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" vertical split shortcut
nnoremap <C-w>v :vsplit<CR>

" copy to system clipboard
noremap Y "+y
nnoremap YY "+yy

" netrw (file explorer)
nnoremap <leader>n :Explore<CR>

" paste over a selection without changing contents of the unnamed register
vnoremap <leader>p "_dP

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" tabular plugin shortcut
nnoremap <c-t> :Tab /
vnoremap <c-t> :Tab /

" extended regex in searches
nnoremap / /\v
vnoremap / /\v

" Telescope bindings
lua <<EOF
local builtin = require('telescope.builtin')
local function smart_find_files()
  local is_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null') == 'true\n'
  if is_git_repo then
    builtin.git_files({ show_untracked = true })
  else
    builtin.find_files()
  end
end
vim.keymap.set('n', '<leader>ff', smart_find_files, {noremap=true})
EOF
nnoremap <leader>Ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>man <cmd>lua require('telescope.builtin').man_pages({sections={"ALL"}})<cr>
nnoremap <leader>help <cmd>lua require('telescope.builtin').help_tags({})<cr>

" smmoth scrolling binds
nnoremap <C-d> <cmd>call smoothie#do("\<C-D>")<CR>
vnoremap <C-d> <cmd>call smoothie#do("\<C-D>")<CR>
nnoremap <C-u> <cmd>call smoothie#do("\<C-u>")<CR>
vnoremap <C-u> <cmd>call smoothie#do("\<C-u>")<CR>

" lsp bindings
nnoremap grd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap grD <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap grr <cmd>lua require('telescope.builtin').lsp_references({show_line=false})<cr>
nnoremap gre <cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<cr>
nnoremap <c-w>[ :vsplit<cr>:lua vim.lsp.buf.definition()<cr>

" comment below/above/at the end of current line
nnoremap gco o<c-r>=&commentstring<cr><esc>$F%c2l
nnoremap gcO O<c-r>=&commentstring<cr><esc>$F%c2l
nnoremap gcA A<space><esc>"=&commentstring<cr>p$F%c2l

" keep cursor in place when joining lines
nnoremap J mzJ`z:delmarks z<CR>

" autocompletion accept/reject
inoremap <c-j> <c-y>
inoremap <c-l> <c-e>

nnoremap <Space> <Nop>
vnoremap <Space> <Nop>
