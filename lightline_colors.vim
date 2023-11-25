" Dook's version of powerline with transparent tabs and colorful normal mode "

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

let s:p.tabline.left = [ [ 'gray9', 'none', 'none', 'none' ] ]
let s:p.tabline.tabsel = [ [ '117', '24', '117', '24' ] ]
let s:p.tabline.middle = [ [ 'none', 'none', 'none', 'none' ] ]
let s:p.tabline.right = [ [ 'none', 'none' ] ]

let s:p.inactive.right = [ ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.middle = s:p.visual.middle
let s:p.inactive.left = s:p.inactive.right[1:]

let g:lightline#colorscheme#dook#palette = lightline#colorscheme#fill(s:p)
