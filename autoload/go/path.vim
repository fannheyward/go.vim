" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" initial_go_path is used to store the initial GOPATH that was set when Vim
" was started. It's used with :GoPathClear to restore the GOPATH when the user
" changed it explicitly via :GoPath. Initially it's empty. It's being set when
" :GoPath is used
let s:initial_go_path = ""

" Default returns the default GOPATH. If GOPATH is not set, it uses the
" default GOPATH set starting with Go 1.8. This GOPATH can be retrieved via
" 'go env GOPATH'
function! go#path#Default() abort
  return go#util#env("gopath")
endfunction

" BinPath returns the binary path of installed go tools.
function! go#path#BinPath() abort
  " check if our global custom path is set, if not check if $GOBIN is set so
  " we can use it, otherwise use default GOPATH
  if $GOBIN != ""
    let bin_path = $GOBIN
  else
    let go_paths = split(go#path#Default(), go#util#PathListSep())
    if len(go_paths) == 0
      return "" "nothing found
    endif
    let bin_path = expand(go_paths[0] . "/bin/")
  endif

  return bin_path
endfunction

" CheckBinPath checks whether the given binary exists or not and returns the
" path of the binary, respecting the go_bin_path and go_search_bin_path_first
" settings. It returns an empty string if the binary doesn't exist.
function! go#path#CheckBinPath(binpath) abort
  " remove whitespaces if user applied something like 'goimports   '
  let binpath = substitute(a:binpath, '^\s*\(.\{-}\)\s*$', '\1', '')

  " save original path
  let old_path = $PATH

  " check if we have an appropriate bin_path
  let go_bin_path = go#path#BinPath()
  if !empty(go_bin_path)
    let $PATH = go_bin_path . go#util#PathListSep() . $PATH
  endif

  " if it's in PATH just return it
  if executable(binpath)
    if exists('*exepath')
      let binpath = exepath(binpath)
    endif
    let $PATH = old_path

    return binpath
  endif

  " just get the basename
  let basename = fnamemodify(binpath, ":t")
  if !executable(basename)
    call go#util#EchoError(printf("could not find '%s'.", basename))

    " restore back!
    let $PATH = old_path
    return ""
  endif

  let $PATH = old_path

  return go_bin_path . go#util#PathSep() . basename
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
