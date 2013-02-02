"This does not work completely when used in the first column!

" Set this to 1 in your vimrc to have Semi always on
let g:Semi_On = 0



command! SemiToggle call SemiToggle()

command! Semi :call Semicolon()
command! BS :call Backspace()
inoremap <silent> <expr> ; SemiOn() ? "\<ESC>:Semi\<CR>" : ";"
inoremap <silent> <expr> <BS> BSFlagSet() ? "\<ESC>:BS\<CR>" : "\<BS>"

let s:bs_flag = 0
let s:set_pos = [0,0,0,0]

fun! SemiToggle()
	let g:Semi_On = !g:Semi_On
endf

fun! SemiOn()
	return g:Semi_On
endf

fun! BSFlagSet()
	if s:bs_flag && g:Semi_On
		if col(".") == col("$")
			if getline(".")[getpos(".")[2]-2] == ";"
				return 0
			else
				return s:set_pos[2]+2 == getpos(".")[2]
			endif
		else
			return s:set_pos[2]+1 == getpos(".")[2]
		endif
	else 
		return 0
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
	let s:set_pos = getpos(".")
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
