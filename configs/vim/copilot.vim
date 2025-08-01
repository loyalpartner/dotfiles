" GitHub Copilot configuration

" Enable Copilot for specific filetypes
let g:copilot_filetypes = {
    \ '*': v:true,
    \ 'gitcommit': v:false,
    \ 'gitrebase': v:false,
    \ }

" Key mappings for Copilot
" Use Tab to accept suggestion (this is the default)
imap <silent><script><expr> <Tab> copilot#Accept()

" Alternative mappings for navigation
imap <M-]> <Plug>(copilot-next)
imap <M-[> <Plug>(copilot-previous)
imap <C-\> <Plug>(copilot-suggest)

" Disable default Tab mapping to ensure our explicit mapping works
let g:copilot_no_tab_map = v:true