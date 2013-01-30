command! Semi :call Semicolon()
inoremap ; <ESC>:Semi<CR>
command! BS :call Backspace()
inoremap <BS> <ESC>:BS<CR>

let s:bs_flag = 0

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
	else " EMULATE BS
		"last col
		if col(".")+1 == col("$") 
			norm! x
			startinsert!
		"first col
		elseif col(".") == 1
			exec "norm! a\<BS>"
			startinsert
			" echo "mooose"
		"other cols
		else
			norm! x
			startinsert
			"echo "miss"
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
