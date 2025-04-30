""" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldmethod=marker foldlevel=0 nofen:

" python {{
  let g:pymode_python = 'python'
" }}

" startify {{
  let g:startify_change_to_dir = 0
" }}"

" vimtex {{
  let g:vimtex_matchparen_enabled = 0
" }}

" vim-go {{
  let g:go_guru_scope = []
  let g:go_def_mapping_enabled = 0
  let g:go_doc_keywordprg_enabled = 0
  let g:go_fmt_autosave = 0
  let g:go_imports_autosave = 0
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_build_constraints = 1
  let g:go_decls_includes = "func"
  let g:go_auto_sameids = 0
  let g:go_metalinter_enabled = []
  " let g:go_metalinter_autosave = ['golangci-lint']
  let g:go_metalinter_command = "golangci-lint"
  let g:go_metalinter_autosave_enabled = []
  let g:go_debug_mappings = {
    \ '(go-debug-continue)': {'key': 'c', 'arguments': '<nowait>'},
    \ '(go-debug-stop)': {'key': 'q'},
    \ '(go-debug-print)': {'key': 'p'},
    \ '(go-debug-next)': {'key': 'n', 'arguments': '<nowait>'},
    \ '(go-debug-step)': {'key': 's'},
    \ '(go-debug-breakpoint)': {'key': 'b'},
    \ }
  let g:go_debug_preserve_layout = 1
  let g:go_debug_windows = {
            \ 'vars':       'leftabove 30vnew',
            \ 'stack':      'leftabove 20new',
            \ 'goroutines': 'botright 10new',
            \ 'out':        'botright 5new',
            \ }
" }}"

" vim-markdown {{
  let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'typescript', 'rust']
" }}"

" vim-run {{
  let g:vim_run_command_map = {
        \'typescript': 'ts-node',
        \'javascript': 'node',
        \'python': 'python3',
        \'go': 'go run',
        \'swift': 'swift'
        \}
" }}

" echodoc {{
  let g:echodoc_enable_at_startup = 1
" }}

" plug.nvim {{
  let g:plug_rebase = 1
" }}

" vim-highlightedyank {{
  let g:highlightedyank_highlight_duration = 100
" }}

" numdo.vim {{
  let g:mundo_prefer_python3 = 1
" }}

" vim-jsx-improve {{
  let javascript_plugin_jsdoc = 1
  let javascript_plugin_flow = 1
" }}

" xml.vim {{
  let g:xml_syntax_folding = 1
" }}

" Netrw {{
  let g:netrw_chgwin = 2
  "let g:netrw_banner=0
  let g:netrw_list_hide = ',\(^\|\s\s\)\zs\.\S\+'
  let g:netrw_winsize=20
  "let g:netrw_liststyle=3
  "let g:netrw_localrmdir='rmtrash'
  "let g:netrw_bufsettings = "noma nomod nonu nobl nowrap ro nornu buftype=nofile"
" }}

" vim-gitgutter {{
  let g:gitgutter_max_signs = 999
" }}

" emmet {{
  " https://raw.github.com/mattn/emmet-vim/master/TUTORIAL
  " <A-y>a Make anchor from URL
  " <A-y>A Make quoted text from URL
  let g:user_emmet_leader_key = '<C-y>'
  let g:user_emmet_expandabbr_key = '<M-y>'
  "内部全选
  let g:user_emmet_mode='a'
  let g:emmet_html5 = 0
  let g:user_emmet_settings = {
        \ 'javascript': {
        \   'extends': 'html',
        \   'attribute_name': {'class': 'className', 'for': 'htmlFor'},
        \   'empty_element_suffix': ' />',
        \ },
        \ 'wxss': {
        \   'extends': 'css',
        \ },
        \ 'wxml': {
        \   'extends': 'html',
        \   'aliases': {
        \     'div': 'view',
        \     'span': 'text',
        \   },
        \   'default_attributes': {
        \     'block': [{'wx:if': '{{somevalue}}'}],
        \     'navigator': [{'url': '', 'redirect': 'false'}],
        \     'scroll-view': [{'bindscroll': ''}],
        \     'swiper': [{'autoplay': 'false', 'current': '0'}],
        \     'icon': [{'type': 'success', 'size': '23'}],
        \     'progress': [{'precent': '0'}],
        \     'button': [{'size': 'default'}],
        \     'checkbox-group': [{'bindchange': ''}],
        \     'checkbox': [{'value': '', 'checked': ''}],
        \     'form': [{'bindsubmit': ''}],
        \     'input': [{'type': 'text'}],
        \     'label': [{'for': ''}],
        \     'picker': [{'bindchange': ''}],
        \     'radio-group': [{'bindchange': ''}],
        \     'radio': [{'checked': ''}],
        \     'switch': [{'checked': ''}],
        \     'slider': [{'value': ''}],
        \     'action-sheet': [{'bindchange': ''}],
        \     'modal': [{'title': ''}],
        \     'audio': [{'src': ''}],
        \     'video': [{'src': ''}],
        \     'image': [{'src': '', 'mode': 'scaleToFill'}],
        \   }
        \ },
        \}
" }}

" jsdoc settings {{
  let g:jsdoc_allow_input_prompt = 0
  let g:jsdoc_enable_es6 = 1
  let g:jsdoc_access_descriptions = 2
  let g:jsdoc_underscore_private = 1
  let g:jsdoc_custom_args_regex_only = 1
  let g:jsdoc_custom_args_hook = {
  \ '^\(callback\|cb\)$': {
  \   'type': ' {Function} ',
  \   'description': 'Callback function'
  \ },
  \ '\(err\|error\)$': {
  \   'type': '{Error}'
  \ },
  \ '^\(opt\|options\)$': {
  \   'type': '{Object}'
  \ },
  \ 'handler$': {
  \   'type': '{Function}'
  \ },
  \ '^\(n\|i\)$': {
  \   'type': ' {Number} '
  \ },
  \ '^i$': {
  \   'type': ' {Number} '
  \ },
  \ '^_\?\(is\|has\)': {
  \   'type': ' {Boolean} '
  \ },
  \ '^arr$': {
  \   'type': ' {Array} '
  \ },
  \ '^str$': {
  \   'type': ' {String} '
  \ },
  \ '^e$': {
  \   'type': ' {Event} '
  \ },
  \ 'el$': {
  \   'type': ' {Element} '
  \ },
  \ '^node$': {
  \   'type': ' {Element} '
  \ },
  \ '^o$': {
  \   'type': ' {Object} '
  \ },
  \ '^obj$': {
  \   'type': ' {Object} '
  \ },
  \ '^fn$': {
  \   'type': ' {Function} '
  \ },
  \}
" }}

" html5.vim {{
  let g:html5_event_handler_attributes_complete = 0
  let g:html5_rdfa_attributes_complete = 0
  let g:html5_microdata_attributes_complete = 0
  let g:html5_aria_attributes_complete = 0
" }}

" dash.vim {{
  let g:dash_map = {
  \ 'javascript': ['javascript', 'NodeJS'],
  \ 'html': ['html', 'svg'],
  \}
" }}

" vim-cool {{
  let g:CoolTotalMatches = 1
" }}

" macdown.vim {{
  let g:macdown_marked_programme = 'misaka'
" }}

" macnote.vim {{
  let g:macnote_unite_quickfix = 1
" }}

" coc.nvim {{
  if has('nvim') && !has('nvim-0.4.3')
    let g:coc_disable_startup_warning = 1
  endif
  "let g:coc_channel_timeout = 5
  "let g:coc_data_home = '~/.config/a/b/coc'
  "let g:coc_disable_startup_warning = 1
  "let g:coc_quickfix_open_command = 'copen|cfirst'
  let g:coc_config_home = '~/.vim/vimrc.d'
  " let g:node_client_debug = 1
  " let g:coc_node_args = ['--nolazy', '--inspect-brk=0.0.0.0:6045']
  " let g:coc_node_args += [ '-r', expand('~/.config/yarn/global/node_modules/source-map-support/register') ]
  let $NVIM_COC_LOG_LEVEL = 'trace'
  let g:coc_global_extensions = [
        \ 'coc-clangd',
        \ 'coc-db',
        \ 'coc-docker',
        \ 'coc-eslint',
        \ 'coc-git',
        \ 'coc-go',
        \ 'coc-html',
        \ 'coc-json',
        \ 'coc-lists',
        \ 'coc-marketplace',
        \ 'coc-prettier',
        \ 'coc-pyright',
        \ 'coc-rust-analyzer',
        \ 'coc-sh',
        \ 'coc-stylelint',
        \ 'coc-tsserver',
        \ 'coc-vimlsp',
        \ 'coc-yaml',
        \ '@hexuhua/coc-copilot',
        \ '@yaegassy/coc-nginx',
        \ ]
  let g:coc_watch_extensions = []
  "let g:coc_node_path = '/usr/local/bin/node'
  let g:coc_filetype_map = {
        \ 'html.swig': 'html',
        \ 'wxss': 'css',
        \ }
  "call coc#add_command('mundoToggle', 'MundoToggle', 'toggle mundo window')
  "call coc#add_command('tree', 'Vexplore', 'open netrw explorer')
  "call coc#add_command('translate', 'TranslateW', 'translate word')
" }}

" indentLine {{
  let g:vim_json_conceal=0
  let g:indentLine_fileTypeExclude = ['json', 'markdown']
  let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile']
  let g:indentLine_char = '│'
" }}

" vim-lion {{
  let g:lion_squeeze_spaces = 1
  let g:lion_create_maps = 1
" }}

" rename.nvim {{
  let g:rename_hl_guifg = '#ffffff'
  let g:rename_hl_guibg = '#b180a4'
  let g:rename_search_execute = 'rg'
" }}

" autosave {{
  let g:auto_save = 1
  let g:auto_save_silent = 1
  let g:auto_save_events = ["InsertLeave"]
" }}
"

" codesearch {{
  let g:codesearch_source_root = '~/Documents/work/dmpp/chromium/src'
" }}

" vimspector {{
  let g:vimspector_enable_mappings = 'HUMAN'
" }}

" vim-gutentags {{
  " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

  " 所生成的数据文件的名称
  "let g:gutentags_ctags_tagfile = '.tags'

  " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
  let s:vim_tags = expand('~/.cache/tags')
  let g:gutentags_cache_dir = s:vim_tags

  " 配置 ctags 的参数
  "let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  "let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  "let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

  " 检测 ~/.cache/tags 不存在就新建
  if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
  endif
" }}

" pydocstring.vim {{
  let g:pydocstring_doq_path = "~/.local/bin/doq"
" }}

" termdebug.vim {{
  " let let g:termdebug_map_K = 0
  let g:termdebug_config = {}
  let g:termdebug_config['variables_window'] = 1
" }}

" nvim-treesitter {{
  if has('nvim')
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set foldlevel=10
    exec 'source ' . expand('<sfile>:h') . '/treesitter.lua'
    " lua require('vimrc.treesitter')
  endif
" }}

" vim-commentary {{
  autocmd FileType json setlocal commentstring=//\ %s
" }}

" ctrlp {{
  if executable('fd') | let g:ctrlp_user_command = 'fd --full-path %s' | endif
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|.idea|target|target_check)$',
        \ 'file': '\v\.(exe|so|dll|a|o|pyc|swp)$'
        \ }
" }}

" vim-airline {{
  let g:airline_theme = 'hybrid'
  let g:airline_powerline_fonts = 1

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  " let g:airline#extensions#tabline#buffer_idx_mode = 1

" }}

" delimitMate.vim {{
  au FileType cpp let b:delimitMate_matchpairs = "(:),[:],{:}"

" }}
