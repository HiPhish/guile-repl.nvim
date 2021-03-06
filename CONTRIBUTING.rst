.. default-role:: code

#################################
 Contributing to Guile-REPL.nvim
#################################

There are a number of ways you can help with this project:

Report bugs
   You know  the drill: what  is the problem, how  do you reproduce  it? Please
   provide a  minimum (non-)working example to  tell me what Info  document you
   are having trouble and what line.

Submit merge requests
   Read  the `HACKING`  file first  to understand  the code,  then submit  your
   improvements. Unless  it's a pure  fix you should  open an issue  to discuss
   your idea so you don't end up wasting your time for nothing.

Please note  that the main  repository is on GitLab,  not GitHub, so  only send
merge requests  there. Issues on  GitHub are  OK if you  don't want to  sign up
there, but I  would prefer GitLab for  that as well just to  have everything in
one place.


Style guide
###########

There is not much  in the way of style, but there are  some basic guidelines to
follow:

- Use  tabs for indentation in  VimScript files, spaces everywhere  else. Three
  spaces in reStructuredText.

- Justify text in reStructuredText files.  I use `par -w79j`  as my `formatprg`
  option.  Do not put extra spaces in inline `code literals` and do not justify
  code blocks.

For everything else use your best judgment and imitate the existing style.
