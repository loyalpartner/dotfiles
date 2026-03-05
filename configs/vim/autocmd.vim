" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldmethod=marker foldlevel=0:
" common file autocmd {{
augroup common
  autocmd!
  "autocmd BufEnter * call EmptyBuffer()
  "autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd FocusGained * checktime
  autocmd BufReadPost *.log normal! G
  autocmd BufWinEnter * call s:OnBufEnter()
  autocmd ColorScheme * call s:Highlight()
  autocmd FileType * call s:OnFileType(expand('<amatch>'))
  "autocmd User CocOpenFloat call s:CloseOthers()
  if exists('##DirChanged')
    autocmd DirChanged,VimEnter * let &titlestring = pathshorten(substitute(getcwd(), $HOME, '~', ''))
  endif
  autocmd BufNewFile,BufReadPost *.ejs setf html
  autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
  "autocmd BufNewFile,BufRead *.jsx setlocal filetype=javascript.jsx
  autocmd BufNewFile,BufRead *.re setlocal filetype=reason
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#cc241d
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
  "autocmd FileType vim if bufname('%') == '[Command Line]' | let b:coc_suggest_disable = 1 | endif
  "autocmd FileType txt call PlainText()
  "autocmd CursorMoved * if &previewwindow != 1 | pclose | endif
  "autocmd User CocQuickfixChange :call fzf_quickfix#run()
  " set up default omnifunc
  autocmd FileType *
        \ if &omnifunc == "" |
        \    setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType typescript.tsx setl iskeyword-=58

  autocmd FileType javascript,html setlocal includeexpr=ExprWeb(v:fname)
  autocmd FileType markdown setlocal includeexpr=ExprMarkdown(v:fname)
augroup end

function! ExprWeb(fname) abort
  "if a:fname =~# "^chrome://"
  "  return fnamemodify(a:fname, ":t")
  "endif
  return substitute(a:fname, '^//\|^/', '', '')
endfunction

function! ExprMarkdown(fname)
  return substitute(a:fname, '^//\|^/', '', '')
endfunction

function! EmptyBuffer()
  if @% ==# ""
    setfiletype txt
  endif
endfunction

function! s:Highlight() abort
  if !has('gui_running') | hi normal guibg=NONE | endif
  call matchadd('ColorColumn', '\%81v', 100)
  hi ColorColumn ctermbg=magenta ctermfg=0 guibg=#333333
  hi HighlightedyankRegion term=bold ctermbg=0 guibg=#13354A
  hi CursorLineNr  ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE
  hi link MsgSeparator    MoreMsg
endfunction

function! s:OnFileType(filetype)
endfunction

function! s:OnBufEnter()
  let name = bufname(+expand('<abuf>'))
  " quickly leave those temporary buffers
  if &previewwindow || name =~# '^term://' || &buftype ==# 'nofile' || &buftype ==# 'help'
    if !mapcheck('q', 'n')
      nnoremap <silent><buffer> q :<C-U>bd!<CR>
    endif
  elseif name =~# '/tmp/'
    setl bufhidden=delete
  endif
  unlet name
endfunction

" }}

function! s:insert_gates()
  let gatename = substitute(toupper(expand("%")), "\\.\\|/\\|$", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif // " . gatename . ""
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" if executable("fcitx5-remote")
"   autocmd! InsertLeavePre * call <SID>toggleInput(mode())
"   autocmd! InsertEnter * call <SID>toggleInput(mode())
"   " 0 close 1 inactive 2 active
"   let g:insert_mode_input_state = 0
"   function! s:inputState() abort
"     silent return system("fcitx5-remote")
"   endfunction
"   function s:rememberInsertModeInputState() abort
"     let g:insert_mode_input_state = s:inputState()
"   endfunction
"   function! s:toggleInput(from) abort
"     if a:from == "i"
"       call s:rememberInsertModeInputState()
"       silent call system("fcitx5-remote -c")
"     elseif a:from == 'n' && g:insert_mode_input_state == 2
"       silent call system("fcitx5-remote -o")
"     endif
"   endfunction
" endif

augroup auto_read
  autocmd!

  autocmd FileChangedShellPost * echohl WarningMsg | echo "文件已经被其他程序修改" | echohl None
augroup END

