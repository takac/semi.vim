inoremap ; <ESC>:call Semicolon()<CR>
inoremap <BS> <ESC>:call Backspace()<CR>s

let s:bs_flag = 0
let s:pos = [0,0]

fun! Backspace()
	if s:bs_flag
		let a = @a
		normal! ma$x
		normal! `aa;p
		let @a = a
		let s:bs_flag = 0
		echo "hit!"
	else
		if col(".") == 1
			exec "normal! i" . "\<BS>p"
		else
			exec "normal! a" . "\<BS>p"
		endif
		let s:bs_flag = 0
		echo "miss"
	endif
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
			if col(".") == 1
				echo "start"
				let s:bs_flag = 1
				let x = 0
				call setline(".", substitute(getline("."), "$", ";", ""))
				call setpos(".", x)
				echo "start"
				startinsert
			else
				let s:bs_flag = 1
				let x = getpos(".")
				let x[2] = col(".") + 1 
				call setline(".", substitute(getline("."), "$", ";", ""))
				call setpos(".", x)
				startinsert
			endif
		endif
endf
