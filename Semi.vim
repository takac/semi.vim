"This does not work completely when used in the first column!

" Set this to 1 in your vimrc to have Semi always on
let g:Semi_On = 0



command! SemiToggle call SemiToggle()

command! Semi :call Semicolon()
command! BS :call Backspace()
inoremap <silent> <expr> ; SemiOn() ? "\<ESC>:Semi\<CR>" : ";"
inoremap <silent> <expr> <BS> BSFlagSet() && g:Semi_On ? "\<ESC>:BS\<CR>" : "\<BS>"

let s:bs_flag = 0

fun! SemiToggle()
	let g:Semi_On = !g:Semi_On
endf

fun! SemiOn()
	return g:Semi_On
endf

fun! BSFlagSet()
    return s:bs_flag 
endf

fun! Backspace()
	" Ready to move semicolon from end to cursor
	let cur_line = getline(".")
	let start_pos = getpos(".")
	if s:bs_flag && cur_line =~ "\\s*;\\s*$"
		let new_line = substitute(cur_line, ";\\(\\s*\\)$", "\\1", "")
		let x = getpos(".")
		call setline(".", strpart(new_line, 0, x[2]) . ";" . strpart(new_line, x[2]))
		let x[2] = col(".") + 2
		call setpos(".", x)
		if start_pos[2]+1 == col("$")
			startinsert!
		else
			startinsert
		endif
	endif
	let s:bs_flag = 0
endf

fun! Semicolon()
	let s:bs_flag = 0
	let line = getline(".")
	let x = getpos(".")
	" If in last column
	if col(".")+1 == col("$")
		if line =~ ';\s*$'
			call setline(".", substitute(line, "$", ";", "")) 
		else
			call setline(".", substitute(line, "\\s*$", ";\\0", "")) 
			let s:bs_flag = 1        
		endif
		startinsert!
	"If line ends in ;
	elseif line =~ ';\s*$'
		call setline(".", strpart(line, 0, x[2]) . ";" . strpart(line, x[2]))
		let x[2] = col(".") + 2 
		call setpos(".", x)
		startinsert
	else
		let s:bs_flag = 1        
		call setline(".", substitute(line, "\\s*$", ";\\0", ""))
		let x[2] = col(".") + 1
		call setpos(".", x)
		startinsert
		"echo "oether"
	endif
endf
