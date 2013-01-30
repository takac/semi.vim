inoremap ; <ESC>:call Semicolon()<CR>s
inoremap <BS> <ESC>:call Backspace()<CR>s

let s:bs_flag = 0
let s:pos = [0,0]

fun! Backspace()
	if s:bs_flag && s:pos == getpos(".")
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
			normal! a;p
			echo "end"
		elseif line =~ '^[ \t]*for'
			normal! a;p
		elseif line =~ ';[ \t]*$'
			normal! a;p
		else
			let a = @a
			let s:bs_flag = 1
			let s:pos = getpos(".")
			normal! maA;
			normal! `aap
			let @a = a
			echo "other"
		endif
endf
