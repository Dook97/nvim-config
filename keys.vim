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

" kill buffer
function! Qkey_func()
	if len(getbufinfo({'buflisted':1})) == 1
		quit!
	else
		bdelete!
	endif
endfunction
nnoremap <leader>q :call Qkey_func()<CR>

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

" switch to next buffer
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

" unfuck python commenting
au FileType python nnoremap gco o#<space>
au FileType python nnoremap gcO O#<space>

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

" <c-x><c-f> complete menu stays open as long as you accept tokens
" no need to reopen it for every directory when completing longer paths
lua <<EOF
local function simulate_keypress(key)
  local termcodes = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(termcodes, 'm', false)
end

vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    if vim.v.event.complete_type == "files" and vim.v.event.reason == "accept" then
        simulate_keypress('<c-x>')
        simulate_keypress('<c-f>')
    end
  end
})
EOF
