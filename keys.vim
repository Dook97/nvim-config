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

function! SmartQuit()
	" 1. If there's only one listed buffer and one window, quit Neovim
	if len(getbufinfo({'buflisted':1})) == 1
		quit!
		return
	endif

	" 2. If current buffer is shown in more than one window, close just the window
	let buf = bufnr('%')
	let win_count = 0
	for w in range(1, winnr('$'))
		if winbufnr(w) == buf
			let win_count += 1
		endif
	endfor
	if win_count > 1
		close!
		return
	endif

	" 3. Otherwise, wipe the buffer and close the window
	bdelete!
endfunction
nnoremap <leader>q :call SmartQuit()<CR>


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

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

" smmoth scrolling binds
nnoremap <C-d> <cmd>call smoothie#do("\<C-D>")<CR>
vnoremap <C-d> <cmd>call smoothie#do("\<C-D>")<CR>
nnoremap <C-u> <cmd>call smoothie#do("\<C-u>")<CR>
vnoremap <C-u> <cmd>call smoothie#do("\<C-u>")<CR>

" lsp keybindings
lua <<EOF
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.setloclist({severity="error"})<CR>', { buffer = ev.buf })
    vim.keymap.set('n', '<space>E', vim.diagnostic.setloclist, { buffer = ev.buf })
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = ev.buf })
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = ev.buf })
  end
})
EOF

" comment below/above/at the end of current line
nnoremap gco o<c-r>=&commentstring<cr><esc>$F%c2l
nnoremap gcO O<c-r>=&commentstring<cr><esc>$F%c2l
nnoremap gcA A<space><esc>"=&commentstring<cr>p$F%c2l

" keep cursor in place when joining lines
nnoremap J mzJ`z:delmarks z<CR>

" open lsp token definiton in vertical split
nnoremap <c-w>[ :vsplit<cr>:lua vim.lsp.buf.definition()<cr>

" autocompletion accept/reject
inoremap <c-j> <c-y>
inoremap <c-l> <c-e>
