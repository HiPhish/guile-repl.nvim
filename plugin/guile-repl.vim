" Author: Alejandro "HiPhish" Sanchez
" License:  The MIT License (MIT) {{{
"    Copyright (c) 2017 HiPhish
" 
"    Permission is hereby granted, free of charge, to any person obtaining a
"    copy of this software and associated documentation files (the
"    "Software"), to deal in the Software without restriction, including
"    without limitation the rights to use, copy, modify, merge, publish,
"    distribute, sublicense, and/or sell copies of the Software, and to permit
"    persons to whom the Software is furnished to do so, subject to the
"    following conditions:
" 
"    The above copyright notice and this permission notice shall be included
"    in all copies or substantial portions of the Software.
" 
"    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
"    NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
"    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
"    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
"    USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('g:loaded_guile_repl')
  finish
endif
let g:loaded_guile_repl = 1

" ----------------------------------------------------------------------------
" The default settings
" ----------------------------------------------------------------------------
" binary : Which Guile binary to execute
" args   : Arguments to pass to every execution, come before user arguments
" syntax : Syntax highlighting to use for the REPL buffer
" title  : Value of b:term_title
" ----------------------------------------------------------------------------
let s:guile_repl = {
	\ 'binary': 'guile',
	\ 'args'  : '-L .',
	\ 'syntax': 'scheme',
	\ 'title' : 'Guile REPL',
	\ 'instances' : [],
\ }


" Build a dictionary to hold global setting if there is none
if !exists('g:guile_repl')
	let g:guile_repl = {}
endif

" Assign the default options, respect user settings
for s:option in keys(s:guile_repl)
	if !exists('g:guile_repl["'.s:option.'"]')
		silent execute 'let g:guile_repl["'.s:option.'"] = s:guile_repl["'.s:option.'"]'
	endif
endfor



" The Guile command is the public interface for end users. The user can pass
" any number of command-line arguments, they will be appended as one string
" after the default arguments.
command -nargs=? Guile call <SID>guile(<q-mods>, <q-args>)

function! s:guile(mods, args)
	" The actual option values to use are determined at runtime. Global
	" settings take precedence, so we loop over the global dictionary and
	" create local variants of every setting.
	"
	" After a local variable has been initialised with the global default we
	" loop over the lower scopes in a given order. If we encounter the same
	" setting it overwrites the previous values. The scopes are ordered by
	" ascending significance, with the most significant being last.
	for l:key in keys(g:guile_repl)
		silent execute 'let l:'.l:key.' = g:guile_repl["'.key.'"]'
		for l:scope in ['t', 'w', 'b']
			let l:entry = l:scope.':guile_repl["'.l:key.'"]'
			if exists(l:entry)
				silent execute 'let l:'.l:key.' = '.l:entry
			endif
		endfor
	endfor

	silent execute a:mods 'new'
	silent execute 'terminal' l:binary l:args a:args
	silent execute 'set syntax='.l:syntax
	silent let b:term_title = l:title

	" Collect information about this REPL instance
	let b:guile_repl = {
		\ 'instance': {
			\ 'binary' : l:binary,
			\ 'buffer' : bufnr('%'),
			\ 'job_id': b:terminal_job_id,
			\ 'args' : split(l:args, '\v\s') + split(a:args, '\v\s'),
		\ }
	\ }

	" Add This instance to the top of the list of instances
	call insert(g:guile_repl['instances'], b:guile_repl['instance'])

	" Hook up autocommand to clean up after the REPL terminates; the
	" autocommand is not guaranteed to have access to the b:guile_repl
	" variable, that's why we instead use the literal job-id to identify this
	" instance.
	silent execute 'au BufDelete <buffer> call <SID>remove_instance('.b:guile_repl['instance']['job_id'].')'
endfunction

" Remove an instance from the global list of instances
function! s:remove_instance(job_id)
	for i in range(len(g:guile_repl['instances']))
		if g:guile_repl['instances'][i]['job_id'] == a:job_id
			call remove(g:guile_repl['instances'], i)
			break
		endif
	endfor
endfunction
