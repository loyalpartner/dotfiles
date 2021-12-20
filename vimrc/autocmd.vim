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
  autocmd User CocQuickfixChange :CocList --normal quickfix
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd CursorHold * silent! call CocActionAsync('highlight')
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
  autocmd FileType typescript,python setl formatexpr=CocAction('formatSelected')
  autocmd FileType typescript let b:coc_pairs_disabled = ['<']
  autocmd FileType typescript.tsx setl iskeyword-=58

  "autocmd filetype gn,javascript,html setlocal includeexpr=Html_includeexpr()
augroup end

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
  hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
  hi CursorLineNr  ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE
  hi CocErrorFloat   guifg=#fb4934 guibg=#504945
  hi CocWarningFloat guifg=#fabd2f guibg=#504945
  hi CocInfoFloat    guifg=#d3869b guibg=#504945
  hi CocHintFloat    guifg=#83a598 guibg=#504945
  hi CocMenuSel      ctermbg=237 guibg=#504945
  hi link CocErrorSign    GruvboxRedSign
  hi link CocWarningSign  GruvboxYellowSign
  hi link CocInfoSign     GruvboxPurpleSign
  hi link CocHintSign     GruvboxBlueSign
  hi link CocFloating     Pmenu
  hi link MsgSeparator    MoreMsg
endfunction

function! s:OnFileType(filetype)
  if index(['xml', 'wxml', 'html', 'wxss', 'css', 'scss', 'less'], a:filetype) >=0
    let b:coc_additional_keywords = ['-']
  endif
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

function Html_includeexpr() abort
  if v:fname =~# "^//"
    return substitute(v:fname, "^//", "", '')
  elseif v:fname =~# '^/'
    return substitute(v:fname, "^", expand("%:h"), '')
  endif
endfunction
" }}

function! s:CloseOthers() abort
  if exists('g:coc_last_float_win')
    for i in range(1, winnr('$'))
      if getwinvar(i, 'float')
        let winid = win_getid(i)
        if winid != g:coc_last_float_win
          call coc#util#close_win(winid)
        endif
      endif
    endfor
  endif
endfunction

function! s:insert_gates()
  let gatename = substitute(toupper(expand("%")), "\\.\\|/\\|$", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif // " . gatename . ""
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

if executable("fcitx5-remote")
  autocmd! InsertLeavePre * call <SID>toggleInput(mode())
  autocmd! InsertEnter * call <SID>toggleInput(mode())
  " 0 close 1 inactive 2 active
  let g:insert_mode_input_state = 0
  function! s:inputState() abort
    return system("fcitx5-remote")
  endfunction
  function s:rememberInsertModeInputState() abort
    let g:insert_mode_input_state = s:inputState()
  endfunction
  function! s:toggleInput(from) abort
    if a:from == "i"
      call s:rememberInsertModeInputState()
      call system("fcitx5-remote -c")
    elseif a:from == 'n' && g:insert_mode_input_state == 2
      call system("fcitx5-remote -o")
    endif
  endfunction
endif
