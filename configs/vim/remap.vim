" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldmethod=marker:

" basic {{
  " nnoremap ; :
  " nnoremap : ;
  " vnoremap ; :
  " vnoremap : ;

  inoremap hh <Esc>
  xnoremap J :m '>+1<CR>gv=gv
  xnoremap K :m '<-2<CR>gv=gv
  nnoremap Q <Nop>
  xnoremap < <gv
  xnoremap > >gv
  inoremap <C-v> <C-o>"+]p
  xnoremap <C-c> "+y
  nnoremap <expr> n  'Nn'[v:searchforward]
  nnoremap <expr> N  'nN'[v:searchforward]
  nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
  nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'
  nnoremap Y y$
  " no overwrite paste
  " xnoremap p "_dP
  " clear highlight update diff
  nnoremap <silent> <C-l> :let @/=''<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
  " some shortcut for git
  " nnoremap gci :Gcommit -v<CR>
  " nnoremap gca :Gcommit -a -v<CR>
  " nnoremap gcc :Gcommit -v -- <C-R>=expand('%')<CR><CR>
  \" nnoremap gP :CocCommand git.push<CR>
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" }}

" vimdiff {{
  if &diff
    map <leader>1 :diffget LOCAL<CR>
    map <leader>2 :diffget BASE<CR>
    map <leader>3 :diffget REMOTE<CR>
  endif
" }}

" insert keymap like emacs {{
  "inoremap <C-w> <C-[>diwa
  inoremap <C-h> <BS>
  inoremap <C-d> <Del>
  inoremap <C-b> <Left>
  inoremap <C-f> <Right>
  inoremap <C-u> <C-G>u<C-U>
  inoremap <C-a> <Home>
  inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"

" command line alias {{
  cnoremap w!! w !sudo tee % >/dev/null
  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>
  cnoremap <C-j> <Left>
  cnoremap <C-k> <Right>
  cnoremap <C-b> <S-Left>
  cnoremap <C-f> <S-Right>
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-d> <Del>
  cnoremap <C-h> <BS>
  cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>
" }}

" meta keys {{
  vnoremap <M-c> "+y
  inoremap <M-v> <C-o>"+]p
  nnoremap <M-q> :qa!<cr>
  nnoremap <M-s> :silent! wa<cr>
  inoremap <M-s> <C-o>:w<cr>
  nnoremap <M-1> 1gt
  nnoremap <M-2> 2gt
  nnoremap <M-3> 3gt
  nnoremap <M-4> 4gt
  nnoremap <M-5> 5gt
  inoremap <M-1> <C-o>1gt
  inoremap <M-2> <C-o>2gt
  inoremap <M-3> <C-o>3gt
  inoremap <M-4> <C-o>4gt
  inoremap <M-5> <C-o>5gt
" }}

" plugins {{
  " buftabline
  nnoremap <leader>1 1gt
  nnoremap <leader>2 2gt
  nnoremap <leader>3 3gt
  nnoremap <leader>4 4gt
  nnoremap <leader>5 5gt
  nnoremap <leader>6 6gt
  nnoremap <leader>7 7gt
  nnoremap <leader>8 8gt

  " vim-exchange
  "xmap gx <Plug>(Exchange)

  " vim-lsp float scroll
  " Float window scrolling is handled differently in vim-lsp
  " Use default <C-f> and <C-b> for now

  " Removed coc-specific mapping
  nmap <silent> [j :cn<CR>
  nmap <silent> [k :cp<CR>
  nmap <silent> [J :colder<CR>
  nmap <silent> [K :cafter<CR>
  " vim-gitgutter mappings
  nmap [g <Plug>(GitGutterPrevHunk)
  nmap ]g <Plug>(GitGutterNextHunk)
  nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
  nmap <Leader>hs <Plug>(GitGutterStageHunk)
  nmap <Leader>hu <Plug>(GitGutterUndoHunk)
  
  nmap <silent><nowait> gs       :<C-u>Vista!!<cr>
  
  " Note: LSP mappings (gd, gi, gr, K, [c, ]c) are defined in lsp.vim
  " Completion mappings are handled by asyncomplete.vim
  " See asyncomplete.vim for <Tab>, <S-Tab>, <CR> mappings
  
  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Float window scrolling will use default vim behavior

  " Text objects for git hunks (vim-gitgutter)
  omap ih <Plug>(GitGutterTextObjectInnerPending)
  omap ah <Plug>(GitGutterTextObjectOuterPending)
  xmap ih <Plug>(GitGutterTextObjectInnerVisual)
  xmap ah <Plug>(GitGutterTextObjectOuterVisual)

  autocmd FileType info nmap <buffer> gu <Plug>(InfoUp)
        \ | nmap <buffer> gn <Plug>(InfoNext)
        \ | nmap <buffer> gp <Plug>(InfoPrev)
        \ | nmap <buffer> gg :GotoNode 

" }}

" visual search {{
  "  In visual mode when you press * or # to search for the current selection
  xnoremap    <silent> * :call <SID>visualSearch('f')<CR>
  xnoremap    <silent> # :call <SID>visualSearch('b')<CR>
" }}

" functions {{
function! s:visualSearch(direction)
  let       l:saved_reg = @"
  execute   'normal! vgvy'
  let       l:pattern = escape(@", '\\/.*$^~[]')
  let       l:pattern = substitute(l:pattern, "\n$", '', '')
  if        a:direction ==# 'b'
    execute 'normal! ?' . l:pattern . "\<cr>"
  elseif    a:direction ==# 'f'
    execute 'normal! /' . l:pattern . '^M'
  endif
  let       @/ = l:pattern
  let       @" = l:saved_reg
endfunction
" }}

" list {{
  nnoremap <silent> \r                     :<C-u>History<cr>
  nnoremap <silent><nowait> <space>h       :<C-u>Helptags<cr>
  nnoremap <silent><nowait> <space>gs      <Plug>(GitGutterStageHunk)
  nnoremap <silent><nowait> <space>gu      <Plug>(GitGutterUndoHunk)
  nnoremap <silent><nowait> <space>gg      :<C-u>G<CR>
  nnoremap <silent><nowait> <space>t       :<C-u>Buffers<cr>
  nnoremap <silent><nowait> <space>n       :V<cr>
  nnoremap <silent><nowait> <space>N       :VL<cr>
  nnoremap <silent><nowait> <space>y       :<C-u>reg<cr>
  nnoremap <silent><nowait> <space>u       :<C-u>UltiSnipsEdit<cr>
  " Removed coc-specific list commands
  nnoremap <silent><nowait> <space>lb      :<C-u>CtrlPBuffer<CR>
  nnoremap <silent><nowait> <leader>b      :<C-u>CtrlPBuffer<CR>
  " Removed coc extensions and gist
  nnoremap <silent><nowait> <space>lt      :<C-u>Tags<CR>
  nnoremap <silent><nowait> <leader>lt      :<C-u>Tags<CR>
  nnoremap <silent><nowait> <space>q       :<C-u>copen<CR>
  nnoremap <silent><nowait> <space>a       :<C-u>LspDocumentDiagnostics<cr>
  nnoremap <silent><nowait> <space>c       :<C-u>Commands<cr>
  nnoremap <silent><nowait> <space>o       :<C-u>Vista!!<cr>
  nnoremap <silent><nowait> <space>o       :<C-u>LspWorkspaceSymbolSearch<cr>
  nnoremap <silent><nowait> <space>r       :<C-u>History<cr>
  nnoremap <silent><nowait> <space>lr       :<C-u>History<cr>
  " nnoremap <silent><nowait> <space>R       :<C-u>LeaderfMru<cr>
  " nnoremap <silent><nowait> <space>ff      :<C-u>call <SID>open_files()<cr>
  " nnoremap <silent><nowait> <space><space> :<C-u>call <SID>open_files()<cr>
  " nnoremap <silent><nowait> <C-p> :<C-u>:Files <cr>
  " nnoremap <silent><nowait> <C-p>       :<C-u>CocList files<cr>
  nnoremap <silent><nowait> <space><space> :<C-u>:RG <cr>
  nnoremap <silent><nowait> g/ :<C-u>:RG <cr>
  vnoremap <silent><nowait> g/ :<C-u>:RG <cr>
  nnoremap <silent><nowait> <space>fy      :<C-u>let @+="%"<CR>
  nnoremap <silent><nowait> <space>ff      :<C-u>Files %:h<CR>
  " nnoremap <silent><nowait> <space>fa      :<C-u>LeaderfFile chrome/browser/<cr>
  nnoremap <silent><nowait> <space>fa      :<C-u>call CscopeFindInteractive(expand('<cword>'))<cr>
  nnoremap <silent><nowait> <space>fc      :<C-u>call CscopeFind('c', expand('<cword>'))<cr>
  nnoremap <silent><nowait> <space>fg      :<C-u>call CscopeFind('g', expand('<cword>'))<cr>
  nnoremap <silent><nowait> <space>fl      :<C-u>call ToggleLocationList()<cr>
  nnoremap <silent><nowait> <space>j       :<C-u>lnext<CR>
  nnoremap <silent><nowait> <space>k       :<C-u>lprev<CR>
  nnoremap <silent><nowait> <space>m       :<C-u>Maps<cr>
  nnoremap <silent><nowait> <space>ve      :<C-u>Vexplore<Cr>
  nnoremap <silent><nowait> <space>vv      :<C-u>e ./<Cr>

  \" Removed coc-specific file search function
" }}
" debug {{

let g:is_debug_mode = 0
map <expr> <F2> <SID>toggle_debug_mode()
autocmd! User VimspectorUICreated call s:setup_mappings()
autocmd! User VimspectorDebugEnded call s:setdown_mappings()

function s:toggle_debug_mode()
  let g:is_debug_mode = !g:is_debug_mode
  if g:is_debug_mode
    echo "enable debug mode"
    call s:setup_mappings()
  else
    echo "disable debug mode"
    call s:setdown_mappings()
  endif
endfunction

function s:setup_mappings()
  let g:is_debug_mode = 1
  nmap c  <Plug>VimspectorContinue
  nmap bb <Plug>VimspectorToggleBreakpoint
  nmap bc <Plug>VimspectorToggleConditionalBreakpoint
  nmap bf <Plug>VimspectorAddFunctionBreakpoint
  nmap t  <Plug>VimspectorRunToCursor
  nmap n  <Plug>VimspectorStepOver
  nmap s  <Plug>VimspectorStepInto
  nmap o  <Plug>VimspectorStepOut
  nmap K  <Plug>VimspectorBalloonEval
	nmap u  <Plug>VimspectorUpFrame
	nmap d  <Plug>VimspectorDownFrame
	nmap B  <Plug>VimspectorBreakpoints
	nmap D  <Plug>VimspectorDisassemble
  nmap <nowait><silent> q :<C-u>call <SID>kill_debugger()<CR>
endfunction

function s:kill_debugger()
  call <SID>setdown_mappings()
  silent execute 'VimspectorReset'
endfunction

function s:setdown_mappings()
  if g:is_debug_mode == 0
    return
  endif
  let g:is_debug_mode = 0
  unmap c
  unmap bb
  unmap bc
  unmap bf
  unmap t
  unmap n
  unmap s
  unmap o
  unmap K
	unmap u
	unmap d
	unmap B
	unmap D
	unmap q
endfunction
" }}
" gdb {{
au User TermdebugStartPost call s:setup_gdb_mappings()
au User TermdebugStopPre  call s:setdown_gdb_mappings()

let g:is_gdb_mode = 0
map <expr> <F4> <SID>toggle_gdb_mode()

function s:toggle_gdb_mode()
  let g:is_gdb_mode = !g:is_gdb_mode
  if g:is_gdb_mode
    echo "enable gdb mode"
    call s:setup_gdb_mappings()
  else
    echo "disable gdb mode"
    call s:setdown_gdb_mappings()
  endif
endfunction

function s:setup_gdb_mappings()
  let g:is_gdb_mode = 1
  map <C-_> :<C-u>Gdb<CR>
  tmap <C-_> <Cmd>Source<CR>
endfunction

function s:setdown_gdb_mappings()
  let g:is_gdb_mode = 0
  unmap <C-_>
  tunmap <C-_>
endfunction
" }}
