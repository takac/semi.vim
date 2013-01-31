let s:bs_flag = 0

command! Semi :call Semicolon()
inoremap ; <ESC>:Semi<CR>
command! BS :call Backspace()
inoremap <expr> <BS> BSFlagSet() ? "\<ESC>:BS\<CR>" : "\<BS>"

fun! BSFlagSet()
    return (s:bs_flag == 1)
endf

"THIS DOES NOT WORK COMPLETELY WHEN USED IN THE FIRST COLUMN!

"If <BS> flag is set, move semi colon to the cursor position, otherwise emulate
"<BS>
fun! Backspace()
	" Ready to move semicolon from end to cursor
	if s:bs_flag
		call setline(".", substitute(getline("."), ";\\(\\s*\\)$", "\\1", ""))
		let x = getpos(".")
		"first column
		if col(".")+1 == 1
			let x[2] = col(".") + 2
			norm! a;
			call setpos(".", x)
			startinsert
			"echo "hit!"
		else
			let x[2] = col(".") + 2
			norm! a;
			call setpos(".", x)
			startinsert
			"echo "hit!"
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
		call setline(".", substitute(getline("."), "\\s*$", ";\\0", ""))
		startinsert!
		"echo "end"
	"If line ends in ;
	elseif line =~ ';\s*$'
		norm! a;
		let x[2] = col(".") + 1 
		call setpos(".", x)
		startinsert
		" If in first column
	elseif col(".") == 1
		"echo "start"
		let x[2] = 1
		let s:bs_flag = 1
		call setline(".", substitute(getline("."), "\\s*$", ";\\0", ""))
		call setpos(".", x)
		"echo "start"
		startinsert
	else
		let x[2] = col(".") + 1 
		let s:bs_flag = 1
		call setline(".", substitute(getline("."), "\\s*$", ";\\0", ""))
		call setpos(".", x)
		startinsert
		"echo "oether"
	endif
endf
