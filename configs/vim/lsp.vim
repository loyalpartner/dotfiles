" vim-lsp configuration

" Enable LSP diagnostics
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 0

" Configure sign column
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '⚠'}
let g:lsp_diagnostics_signs_information = {'text': 'ℹ'}
let g:lsp_diagnostics_signs_hint = {'text': '💡'}

" Enable highlighting references
let g:lsp_highlight_references_enabled = 1

" Format on save for specific file types
let g:lsp_format_sync_timeout = 1000

" Configure hover
let g:lsp_hover_ui = 'float'

" Configure completion
let g:lsp_completion_documentation_enabled = 1

" Enable inlay hints
let g:lsp_inlay_hints_enabled = 1

" Custom LSP servers configuration
if executable('mojom-lsp')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'mojom-lsp',
        \ 'cmd': {server_info->['mojom-lsp']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git'))},
        \ 'whitelist': ['mojom'],
        \ })
endif

if executable('pls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'proto-lsp',
        \ 'cmd': {server_info->['pls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git'))},
        \ 'whitelist': ['proto'],
        \ })
endif

if executable('jsonnet-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'jsonnet-lsp',
        \ 'cmd': {server_info->['jsonnet-language-server', '-t']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git'))},
        \ 'whitelist': ['jsonnet', 'libsonnet'],
        \ })
endif

if executable('Swift-MesonLSP')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'meson-lsp',
        \ 'cmd': {server_info->['Swift-MesonLSP', '--lsp']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'meson.build'))},
        \ 'whitelist': ['meson'],
        \ })
endif

" Configure clangd arguments
if executable('clangd')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--clang-tidy']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \ })
endif

" Auto commands
augroup lsp_install
  au!
  " Format on save for specific file types
  autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx,*.py,*.go,*.rs call execute('LspDocumentFormatSync')
  
  " Show hover information on cursor hold
  autocmd CursorHold * silent! call lsp#ui#vim#hover#get_hover_under_cursor()
augroup END

" Key mappings for LSP
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  
  " Navigation
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <C-w>gd <plug>(lsp-peek-definition)
  nmap <buffer> gD <plug>(lsp-declaration)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> gr <plug>(lsp-references)
  
  " Diagnostics
  nmap <buffer> [c <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]c <plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>di <plug>(lsp-document-diagnostics)
  
  " Actions
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>rf <plug>(lsp-code-action-float)
  nmap <buffer> <leader>a <plug>(lsp-code-action)
  nmap <buffer> <leader>f <plug>(lsp-document-format)
  xmap <buffer> <leader>f <plug>(lsp-document-range-format)
  
  " Documentation
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>sh <plug>(lsp-signature-help)
  
  " Workspace
  nmap <buffer> <leader>wa <plug>(lsp-workspace-symbol)
  nmap <buffer> <leader>wd <plug>(lsp-document-symbol)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END