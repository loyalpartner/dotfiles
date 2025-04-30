" vim: set sw=2 ts=2 sts=2 et tw=78:

command! -nargs=+ GN :call s:gn(<q-args>)

function! s:gn(args)
  let command = "gn " . a:args . " --as=buildfile"

  let refs = systemlist(command)
  
  let loclist = []
  for r in refs
    call insert(loclist, {
          \ 'filename': r,
          \ 'lnum': 0,
          \ 'col': 0,
          \ 'text': r
          \ })
  endfor
  call setloclist(0, loclist, 'r')
  exe 'lopen'
endfunction
