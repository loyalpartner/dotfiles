function! MyStatusLine()
  return s:GetPaste()
        \. "%{winnr()} "
        \. "%4*%{MyStatusGit()}%*"
        \. "%5*%{MyStatusGitChanges()}%* %{MyStatusCoc()} "
        \. "%6*%*"
        \. " %f %{MyStatusModifySymbol()}"
        \. " %{MyStatusReadonly()}"
        \. "%=%-{&ft} %l,%c %P "
"%{&fenc}
endfunction

function! s:IsTempFile()
  if !empty(&buftype) | return 1 | endif
  if &previewwindow | return 1 | endif
  let filename = expand('%:p')
  if filename =~# '^/tmp' | return 1 | endif
  if filename =~# '^fugitive:' | return 1 | endif
  return 0
endfunction

function! s:GetPaste()
  if !&paste | return '' |endif
  return "%#MyStatusPaste# paste %*"
endfunction

function! MyStatusReadonly()
  if !&readonly | return '' |endif
  return "  "
endfunction

function! MyStatusCoc()
  return ''
endfunction

function! MyStatusModifySymbol()
  return &modified ? '⚡' : ''
endfunction

function! MyStatusGitChanges() abort
  if s:IsTempFile() | return '' | endif
  return exists('*FugitiveStatusline') ? FugitiveStatusline() : ''
endfunction

function! MyStatusGit(...) abort
  let head = exists('*FugitiveHead') ? FugitiveHead() : ''
  return empty(head) ? '' : '  '.head.' '
endfunction

function! SetStatusLine()
  if &previewwindow | return | endif
  if s:IsTempFile() | return | endif
  setl statusline=%!MyStatusLine()
  hi User6         guifg=#fe8019 guibg=#282828 gui=none
  hi User3         guifg=#e03131 guibg=#111111    gui=none
  hi MyStatusPaste guifg=#F8F8F0 guibg=#FF5F00 gui=none
  hi MyStatusPaste ctermfg=202   ctermbg=16    cterm=none
  hi User4 guifg=#f8f8ff guibg=#000000
  hi User5 guifg=#f8f9fa guibg=#343a40
endfunction

" augroup statusline
"   autocmd!
  " autocmd BufEnter,BufNewFile,BufReadPost,ShellCmdPost,BufWritePost * call SetStatusLine()
  " autocmd FileChangedShellPost,ColorScheme * call SetStatusLine()
" augroup end
