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

" easily generate sha256 hashes of random stuff
function! Hash()
	let @h = system("dd if=/dev/random bs=512 count=1 2>/dev/null | sha256sum | cut -d' ' -f1")
	let @h = substitute(strtrans(@h), '\^@', '', 'g')
	norm "hp
endfunction
nnoremap <leader>h :call Hash()<CR>

nnoremap / /\v
vnoremap / /\v

" repeat last macro unless in a special buffer
nnoremap <expr> <CR> empty(&buftype) ? '@@' : '<CR>'

" visual mode move lines with J & K
function! s:Move(address, at_limit)
  if !a:at_limit
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! Move_up() abort range
  let l:at_top=a:firstline == 1
  call s:Move("'<-2", l:at_top)
endfunction

function! Move_down() abort range
  let l:at_bottom=a:lastline == line('$')
  call s:Move("'>+1", l:at_bottom)
endfunction

xnoremap <silent> K :call Move_up()<CR>
xnoremap <silent> J :call Move_down()<CR>
