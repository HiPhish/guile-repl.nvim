nnoremap <silent> <Plug>(GuileReplSend)      :set opfunc=<SID>send_to_repl<CR>g@
nnoremap <silent> <Plug>(GuileReplSendLine)  :set opfunc=<SID>send_to_repl<CR>g@_

vnoremap <silent> <Plug>(GuileReplSend)      :<C-U>call Send_to_repl(visualmode(), 1)<CR>

function! Send_to_repl(type, ...)
	if a:0
		call s:send_to_repl(a:type, a:0)
	else
		call s:send_to_repl(a:type)
	endif
endfunction

function! s:send_to_repl(type, ...) range
	if a:0
		let l:visualmode = visualmode()
		if l:visualmode == 'v'
			let l:text = s:range_selection( "`<",  "`>", 'v')
		elseif l:visualmode == 'V'
			let l:text = s:range_selection( "'<",  "'>", 'V')
		else
			let l:text = s:range_selection( "`<",  "`>", 'v')
		endif
	elseif a:type == 'line'
		let l:text = s:range_selection( "'[",  "']", 'V')
	elseif a:type == 'char'
		let l:text = s:range_selection( "`[",  "`]", 'v')
	endif

	if empty(g:guile_repl.instances)
		Guile
	endif

	call jobsend(g:guile_repl.instances[0].job_id, l:text)
	Guile
	startinsert
endfunction


function! s:range_selection(lower, upper, mod)
	let l:reg = getreg('"')
	let l:regtype = getregtype('"')

	silent execute "normal! ".a:lower.a:mod.a:upper.'y'

	let l:text = @"

	call setreg('"', l:reg, l:regtype)

	return l:text
endfunction
