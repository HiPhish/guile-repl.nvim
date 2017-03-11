.. default-role:: code

#################################################
 Guile-REPL.nvim - The Poor Man's GNU Guile REPL
#################################################

Guile-REPL.nvim wraps around Nvim's built-in terminal emulator to create a REPL
buffer for  GNU Guile.  While not  as perfect as  a native  REPL buffer,  it is
functional and gets the job done.


Getting started
###############


Installation
============

You need a working copy of GNU  Guile first. Install this plugin like you would
any other Nvim plugin.  You can set  the Guile  binary by setting  the variable
`guile-repl['binary']`.   See  the   configuration  section   below  for   more
information or read the documentation.


Starting a REPL
===============

A new REPL window  is created by running the `:Guile` command.  You can use the
same arguments you can also use with your Guile binary. Example:

.. code-block:: vim

   " Add the current working directory to the load path
   :Guile -l my-file.scm

   " Evaluate an expression and exit
   :Guile -c '(display "Hello from Guile")'

By default the working  directory is added to the load path  by passing the `-L
.` argument to the binary. See below for how to set the default arguments. The
`:Guile` command also accepts the usual modifiers like `:vert`:

.. code-block:: vim

   " Open the REPL in a vertical split
   :vert Guile -l my-file.scm


Configuration
=============

All configuration is  held within  the `g:guile_repl` dictionary.  You can read
the documentation  for details;  here is what  the default  configuration looks
like:

.. code-block:: vim

   let g:guile_repl = {'binary': 'guile', 'args': ['-L', '.'], 'syntax': 'scheme'}


Shortcomings
############

Since Guile-REPL.nvim is  implemented on top of Nvim's terminal  emulator it is
also bound to the same interface.  You cannot use Vim's  commands to edit text,
you  instead have  to enter  terminal mode  (insert mode  for the  terminal) to
modify text.

Syntax highlighting uses  Vim's Scheme highlighting,  but this might not always
be adequate.  Highlighting the  prompt or  the backtrace as  if it  was regular
Scheme code is wrong.


License
#######

Guile-REPL.nvim  is  release under  the  terms  of  the  MIT license.  See  the
`LICENSE.rst`_ file for details.

.. _LICENSE.rst: LICENSE.rst
