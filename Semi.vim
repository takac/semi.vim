command! Semi :call Semicolon()
inoremap ; <ESC>:Semi<CR>
command! BS :call Backspace()
inoremap <BS> <ESC>:BS<CR>

let s:bs_flag = 0
let s:pos = [0,0]

fun! Backspace()
	if s:bs_flag
		if col(".")+1 == col("^")
			call setline(".", substitute(getline("."), ";$", "", ""))
			let x = getpos(".")
			let x[2] = col(".") + 2
			norm! a;
			call setpos(".", x)
			startinsert
			echo "hit!"
		else
			call setline(".", substitute(getline("."), ";$", "", ""))
			let x = getpos(".")
			let x[2] = col(".") + 2
			norm! a;
			call setpos(".", x)
			startinsert
			echo "hit!"
		endif
	else
		if col(".")+1 == col("$") 
			norm! x
			startinsert!	
			echo "muss"
		elseif col(".") == 1
			norm! x
			startinsert
			echo "mooose"
		else
			norm! x
			startinsert
			echo "miss"
		endif
	endif
	let s:bs_flag = 0
endf

fun! Semicolon()
	let s:bs_flag = 0
	let line = getline(".")
	if col(".")+1 == col("$")
		call setline(".", substitute(getline("."), "$", ";", ""))
		startinsert!
		echo "end"
	elseif line =~ ';\s*$'
		norm! a;
		let x = getpos(".")
		let x[2] = col(".") + 1 
		call setpos(".", x)
		startinsert
	else
		let s:bs_flag = 1
		if col(".") == 1
			echo "start"
			let x = getpos(".")
			let x[2] = 1
			call setline(".", substitute(getline("."), "$", ";", ""))
			call setpos(".", x)
			echo "start"
			startinsert
		else
			let x = getpos(".")
			let x[2] = col(".") + 1 
			call setline(".", substitute(getline("."), "$", ";", ""))
			call setpos(".", x)
			startinsert
		endif
	endif
endf
