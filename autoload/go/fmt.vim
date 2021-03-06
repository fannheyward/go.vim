" Copyright 2011 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
if exists("b:did_ftplugin_go_fmt")
  finish
endif

if !exists("g:go_fmt_command")
  let g:go_fmt_command = "gofmt"
endif

function! go#fmt#Format()
  let view = winsaveview()
  silent execute "%!" . g:go_fmt_command
  if v:shell_error
    let errors = []
    for line in getline(1, line('$'))
      let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
      if !empty(tokens)
        call add(errors, {"filename": @%,
              \"lnum":     tokens[2],
              \"col":      tokens[3],
              \"text":     tokens[4]})
      endif
    endfor
    if empty(errors)
      % | " Couldn't detect gofmt error format, output errors
    endif
    undo
    if !empty(errors)
      call setqflist(errors, 'r')
    endif
    echohl Error | echomsg "Gofmt returned error" | echohl None
  endif
  call winrestview(view)
endfunction

let b:did_ftplugin_go_fmt = 1

" vim:ts=2:sw=2:et
