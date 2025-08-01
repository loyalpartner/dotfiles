" asyncomplete.vim configuration

" Basic settings
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 100
let g:asyncomplete_min_chars = 2

" Configure completion options for better UI
set completeopt=menuone,noinsert,noselect,preview
set pumheight=15  " Limit popup menu height
set pumwidth=60   " Set popup menu width

" Enable preview window with better formatting
let g:asyncomplete_enable_preview = 1
let g:asyncomplete_preview_delay = 200

" Improve popup menu appearance
let g:asyncomplete_matchfuzzy = 1  " Enable fuzzy matching
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_remove_duplicates = 1

" Configure sources priority
let g:asyncomplete_priority = {
    \ 'lsp': 10,
    \ 'necovim': 9,
    \ 'ultisnips': 8,
    \ 'tmux-complete': 6,
    \ 'buffer': 5,
    \ 'file': 3,
    \ }

" Register asyncomplete sources
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \ 'name': 'necovim',
    \ 'allowlist': ['vim'],
    \ 'priority': 9,
    \ 'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))

au User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'tmux-complete',
    \ 'allowlist': ['*'],
    \ 'priority': 6,
    \ 'completor': function('tmuxcomplete#completor'),
    \ })

" UltiSnips integration
if has('python3')
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

" Configure UltiSnips
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Key mappings for completion (avoid Tab conflict with Copilot)
inoremap <expr> <C-n>   pumvisible() ? "\<C-n>" : "\<C-n>"
inoremap <expr> <C-p>   pumvisible() ? "\<C-p>" : "\<C-p>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
inoremap <expr> <C-e>   pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

" Force refresh
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Auto close preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" tmux-complete configuration
let g:tmuxcomplete#trigger = 'omnifunc'  " Use as omnifunc completion
let g:tmuxcomplete#asyncomplete_source_options = {
    \ 'name': 'tmux-complete',
    \ 'allowlist': ['*'],
    \ 'priority': 6,
    \ }
