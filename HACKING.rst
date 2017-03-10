.. default-role:: code


#############################################
 Working on the Guile REPL plugin for Neovim
#############################################

This plugin is pretty simple, so there are only a few rules to keep in mind.


Adding a new setting
####################

All settings are  encapsulated inside the `g:guile_repl`  dictionary. A setting
is identified  by its key,  such as `binary` for  the guile binary  to execute.
When adding a  new setting follow what  the code does: Add a  new if-block that
checks whether the setting exists and only sets the default if it doesn't.

   .. code-block:: vim

      " binary : Which Guile binary to execute
      let s:guile_repl = {
	      \ 'binary': 'guile',
	   \ }

This ensures  that the user  can set some  options in their  own `g:guile_repl`
without interfering  with the other defaults.  Add a short  explanation comment
above  the dictionary  like in  this example  (We cannot  have comments  inside
the dictionary).  When  using  a  setting from  inside  the `s:guile`  function
always  use the  local variant  of  a setting,  i.e use  `l:binary` instead  of
`g:guile_repl['binary']`.

Don't worry about local settings, as long as there is a global value Guile-REPL
will sort out local settings on its own.


Testing
#######

We use Vader_ for testing.  All tests are stored under `test/`.  If you fixed a
bug please  add a test case  for the bug so  it never comes back again.  If you
added  a new  feature add  tests  for it  so  it remains  functional.  To avoid
depending on an installed Guile interpreter we  set the binary first to a shell
script which will serve as a mock interpreter.

.. code-block:: vader

   Before (Store old info binary so it can be restored):
     let g:guile_repl['binary'] = 'sh test/test.sh'


.. _Vader: https://github.com/junegunn/vader.vim/
