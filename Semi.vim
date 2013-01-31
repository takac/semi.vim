let s:bs_flag = 0

command! Semi :call Semicolon()
inoremap ; <ESC>:Semi<CR>
command! BS :call Backspace()
inoremap <expr> <BS> BSFlagSet() ? "\<ESC>:BS\<CR>" : "\<BS>"

fun! BSFlagSet()
    return (s:bs_flag == 1)
endf

"This does not work completely when used in the first column!

"If <BS> flag is set, move semi colon to the cursor position, otherwise emulate
"<BS>
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
