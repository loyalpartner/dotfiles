"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                初始配置                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
func! Init() "{{{
  set nocompatible               " be iMproved
  filetype off                   " required!

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()

  " let Vundle manage Vundle
  " required! 
  Bundle 'gmarik/vundle'

  " My Bundles here:
  "
  " original repos on github
  "Bundle 'tpope/vim-fugitive'
  "Bundle 'Lokaltog/vim-easymotion'
  "Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
  "Bundle 'tpope/vim-rails.git'
  " vim-scripts repos
  "Bundle 'L9'
  "Bundle 'FuzzyFinder'
  " non github repos
  "Bundle 'git://git.wincent.com/command-t.git'
  " ...

  Bundle 'https://github.com/plasticboy/vim-markdown.git'
  Bundle 'https://github.com/Lokaltog/vim-powerline.git'
  Bundle 'https://github.com/vim-scripts/UltiSnips.git'
  Bundle 'https://github.com/vim-scripts/auto_mkdir.git'
  Bundle 'https://github.com/tpope/vim-surround.git'
  Bundle 'https://github.com/tpope/vim-repeat.git'
  Bundle 'https://github.com/git-mirror/vim-l9.git'
  Bundle 'https://github.com/scturtle/vim-instant-markdown-py.git'
  Bundle 'https://github.com/tsaleh/vim-align.git'
  Bundle 'https://github.com/nathanaelkane/vim-indent-guides.git'
  Bundle 'https://github.com/vim-scripts/doxygen-support.vim.git'
  Bundle 'https://github.com/mattn/zencoding-vim.git'
  Bundle 'https://github.com/scrooloose/nerdcommenter.git'
  Bundle 'https://github.com/kien/ctrlp.vim.git'
  Bundle 'https://github.com/Valloric/YouCompleteMe.git'
  Bundle 'https://github.com/scrooloose/syntastic.git'
  Bundle 'https://github.com/lilydjwg/colorizer.git'
  Bundle 'https://github.com/tpope/vim-fugitive.git'
  Bundle 'https://github.com/Valloric/vim-operator-highlight.git'
  Bundle 'https://github.com/Valloric/ListToggle.git'
  "Bundle 'https://github.com/myusuf3/numbers.vim.git'
  Bundle 'https://github.com/tsaleh/vim-matchit.git'
  Bundle 'https://github.com/vim-scripts/TaskList.vim.git'
  Bundle 'https://github.com/klen/python-mode.git'
  Bundle 'https://github.com/sjl/gundo.vim.git'
  Bundle 'https://github.com/majutsushi/tagbar.git'
  Bundle 'https://github.com/vim-scripts/fcitx.vim.git'
  Bundle 'https://github.com/vim-scripts/AutoClose.git'
  Bundle 'https://github.com/tpope/vim-unimpaired.git'
  Bundle 'https://github.com/c9s/colorselector.vim.git'
  Bundle 'https://github.com/ap/vim-css-color.git'
  Bundle 'https://github.com/michaeljsmith/vim-indent-object.git'
  Bundle 'https://github.com/tomtom/viki_vim.git'
  Bundle 'https://github.com/tomtom/tlib_vim.git'
  Bundle 'https://github.com/Valloric/MatchTagAlways.git'
  Bundle 'git@github.com:loyalpartner/mystyle.vim.git'

  filetype plugin indent on     " required!
  "
  " Brief help
  " :BundleList          - list configured bundles
  " :BundleInstall(!)    - install(update) bundles
  " :BundleSearch(!) foo - search(or refresh cache first) for foo
  " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
  "
  " see :h vundle for more details or wiki for FAQ
  " NOTE: comments after Bundle command are not allowed..
endfunc
"}}}

""判定当前操作系统类型
if(has("win32") || has("win95") || has("win64") || has("win16")) 
  let g:iswindows=1
else
  let g:iswindows=0
endif

" 映射Alt
" mode    : map,noremap ....
" key     : a-z0-9
" command : 命令的字符串模式
func! Alt(mode, key, command)
  let l:key =has('gui_running') ? "<M-". a:key . ">" : "" . a:key
  let l:command = a:mode . ' '. l:key . ' ' . escape(a:command, '\')
  exec l:command
endfunc 
command! -nargs=* Alt call Alt(<f-args>)

" 直接source会导致当前的文档的fold丢失,为了避免这个情况,可以在另外的窗口执行source
augroup ReloadVimrc
  au!
  au BufWritePost .vimrc let s:currenttab = tabpagenr() | exec 'tabnew' | source $MYVIMRC | exec 'bd' | exec "tabnext ".s:currenttab | set timeoutlen=3000
augroup END

augroup Unmap
  au!
  au vimenter * unmap <leader>w=
  au vimenter * unmap <leader>rwp
augroup End

" 自动保存视图"
augroup ReloadView
  au!
  "au BufWinEnter *.* loadview
  "au BufWinLeave *.* mkview
  au BufRead * loadview
  au BufWrite * mkview
augroup End

if !exists('s:plugin_loaded') || s:plugin_loaded == 0
  let s:plugin_loaded = 1
  call Init()
  " 设置主题
  colorscheme valloric
  syntax enable
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              大众化的vimrc                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

"set nu
"set colorcolumn=80


" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" 手速不行，所以时间条长点 囧
set timeout timeoutlen=3000 ttimeoutlen=-1
augroup setTimeoutLen
  au!
  au CmdWinEnter * set timeoutlen=500
  au CmdWinLeave * set timeoutlen=3000
  au InsertEnter * set timeoutlen=500
  au InsertLeave * set timeoutlen=3000
augroup END

" Fast saving
"au vimenter * unmap <leader>w=
noremap <leader>w :w!<cr>
noremap <leader>W :w!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocp

set t_Co=256

" Set 4 lines to the cursor - when moving vertically using j/k
set so=4

" Turn on the WiLd menu
set wildmenu

" 来指定一些不太重要的文件，并让它们出现在文件列表末尾。 
"set suffixes

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" 隐藏菜单,滚动条等
set guioptions=gte

" 显示当前行,列,只在当前窗口显示
"set cursorline

"set hidden

"set mouse=a

" 设置显示按键提示
set showcmd

" 自动补全 --> 不选中第一项
" ycm 会自动设置
"set completeopt=longest,menu,menuone,preview
"set complete=.,w,b,k "设置补全提示项

set foldlevel=100

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
"set showmatch

" How many tenths of a second to blink when matching brackets
"set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set list
noremap <leader>ls :set list!<cr>
set listchars=tab:▸\ ,eol:¬

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions+=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
noremap j gj
noremap k gk

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
noremap <C-l> <C-W>w

" Close the current buffer
noremap <leader>bd :Bclose<cr>

" Close all the buffers
noremap <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>

noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove<space>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
noremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
noremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Remember info about open buffers on close
set viminfo=%,'1000,<500,s100,h,:1000

" Return to last edit position when opening files (You want this!)
"au BufReadPost *
      "\ if line("'\"") > 0 && line("'\"") <= line("$") |
      "\   exe "normal! g`\"" |
      "\ endif

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Space> :
vnoremap <Space> :
sunmap <space>

cabbr qa qa!

" Remap VIM 0 to first non-blank character
noremap 0 ^

Alt noremap\ <silent> l :tabnext<cr>
Alt noremap\ <silent> h :tabprevious<cr>
Alt noremap\ <silent> a :tabfirst<cr>
Alt noremap\ <silent> e :tablast<cr>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac {{{
Alt noremap\ <silent> j mz:m+<cr>`z
Alt noremap\ <silent> k mz:m-2<cr>`z
Alt vnoremap\ <silent> j :m'>+<cr>`<my`>mzgv`yo`z
Alt vnoremap\ <silent> k :m'<-2<cr>`>my`<mzgv`yo`z  
"}}}

if has("mac") || has("macunix")
  nnoremap <D-j> <M-j>
  noremap <D-k> <M-k>
  vnoremap <D-j> <M-j>
  vnoremap <D-k> <M-k>
endif

" CTRL-U and CTRL-W in insert mode cannot be undone.  Use CTRL-G u to first
" break undo, so that we can undo those changes after inserting a line break.
" For more info, see: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

augroup DeleteTrailing
  au!
  au BufWrite *.py :call DeleteTrailingWS()
  au BufWrite *.coffee :call DeleteTrailingWS()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
noremap <leader>g :vimgrep //g **/*.<Home><right><right><right><right><right><right><right><right><right>
noremap <S-F3> :vimgrep /<c-r>=expand("<cword>")<cr>/j **/*.

" Vimgreps in the current file
noremap <leader><space> :vimgrep //j <C-R>%<C-A><Home><right><right><right><right><right><right><right><right><right>
noremap <F3> :vimgrep /<c-r>=expand("<cword>")<cr>/j <C-R>%<C-A><cr><Esc>:copen<cr>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>R :call VisualSelection('replace')<CR>
nnoremap <silent> <leader>R viw:call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
"noremap <leader>cc :botright cope<cr>
noremap <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
noremap <leader>sa zg
noremap <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
"noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
noremap <leader>qe :e ~/buffer<cr>

" Toggle paste mode on and off
noremap <leader>PP :setlocal paste!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
"function! HasPaste()
  "if &paste
    "return 'PASTE MODE  '
  "en
  "return ''
"endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                按键配置                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
"{{{ 显示行号
func! ToggleNumber() 
  if &nu == 1
    set rnu 
  elseif &rnu == 1
    set nornu
  else
    set nu
  endif
endfunc 
nmap <silent> <F6> :call ToggleNumber()<cr>
"}}}

" 复制粘贴
nnoremap <leader>yp "+p
nnoremap <leader>yy "+yy
vnoremap <leader>yy "+y

cnoremap ,(( \(\)<left><left>
cnoremap ,{{ \{\}<left><left>
cnoremap ,<< \<\><left><left>


nnoremap f za
nnoremap <silent> F :1,$foldc<cr>

" ]<space>是插件的快捷键"
nmap t ]<space>
nmap T [<space>

"编辑配置文件
Alt nnoremap 1 :tabnew!\ $MYVIMRC<cr>
Alt nnoremap 2 :tabnew!\ $HOME/.zshrc<cr>
Alt nnoremap 3 :tabnew!\ $HOME/.tmux.conf<cr>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

"" 切换缓冲"{{{
"noremap L :bnext<cr>
"noremap H :bprevious<cr>
"noremap A :bfirst<cr>
"noremap E :blast<cr>
""}}}

" 切换选项卡"{{{
noremap <c-w>1 :tabnext 1<cr>
noremap <c-w>2 :tabnext 2<cr>
noremap <c-w>2 :tabnext 2<cr>
noremap <c-w>3 :tabnext 3<cr>
noremap <c-w>4 :tabnext 4<cr>
noremap <c-w>5 :tabnext 5<cr>
noremap <c-w>6 :tabnext 6<cr>
noremap <c-w>7 :tabnext 7<cr>
noremap <c-w>8 :tabnext 8<cr>
noremap <c-w>9 :tabnext 9<cr>
"}}}

" 转换大小写"{{{
nnoremap <C-k><C-u> <esc>gUawea
inoremap <C-k><C-u> <esc>gUawea
nnoremap <C-k><C-l> <esc>guawea
inoremap <C-k><C-l> <esc>guawea
nnoremap <C-k><C-t> <esc>b~ea
inoremap <C-k><C-t> <esc>b~ea
"}}}

" Repeat previous command with a bang(直接的)
nnoremap <leader>. q:k<CR>

" easy indent/outdent"{{{
nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv
sunmap <
"}}}

nnoremap <c-c> <esc>
imap <c-\> <plug>NERDCommenterInsert

noremap H ^
noremap L $

map Y y$

"" 强制保存
cabbr w!! w !sudo tee % >/dev/null

nnoremap <leader>S mz^vg_y:execute @@<CR>`z
vnoremap <leader>S mzy:execute @@<CR>`z

nnoremap <silent> ,gf :vertical botright wincmd f<CR>
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 我的插件                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{

"{{{
if exists("+showtabline")

  "let g:header = '⡇⡇ ❐ Tabs/Now：' . tabpagenr('$') . '/' . tabpagenr().' ⡇ ' 
  let g:min_tabs = 3
  let g:tail   = ' ⡇ 哈哈 ❐ ⡇⡇'
  let g:plugin = ''
  let g:no_ext_list = ['coffee']

  "{{{ MyTab_GetHeader
  func! MyTab_GetHeader()
    return '⡇⡇ ❐ Tabs-Now：' . tabpagenr('$') . '-' . tabpagenr().' ⡇ ' 
  endfunc
  "}}}
  "{{{ MyTab_List
  func! MyTab_List()
    let l:tablist = []

    let l:index = 1
    while l:index <= tabpagenr('$')
      let l:bufnr = tabpagebuflist(l:index)[tabpagewinnr(l:index) - 1]
      let l:bufname = bufname(l:bufnr)
      let l:bufname = (l:bufname == ''? 'noname' :fnamemodify(l:bufname, ':p:t'))
      call add(l:tablist, l:bufname)
      let l:index+=1
    endw
    return l:tablist
  endfunc 
  "}}}
  "{{{ MyTab_ItemStr
  func! MyTab_ItemStr( index, file ) 
    let l:item = ' '.a:index.' '
    let l:file = a:file
    let l:file = (l:file == '' ? 'noname' : l:file)
    if index(g:no_ext_list, &ft) > 0
      let l:file = fnamemodify(l:file, ':p:t:r')
    else
      let l:file = fnamemodify(l:file, ':p:t')
    endif
    let l:item .= file. ' '
    return l:item
  endfunc 
  "}}}
  "{{{ MyTab_Tabs
  func! MyTab_Tabs( tablist, rest, p ) 

    let l:index = 0
    let l:tabidx = tabpagenr() -1
    let l:start = l:index
    let l:str = ''

    while l:index <= tabpagenr('$') - 1

      let l:item = MyTab_ItemStr( l:index+1, a:tablist[l:index] )

      if l:index != tabpagenr('$') - 1 
        let l:item .= ' '
      endif

      let l:str = l:str . l:item

      " 显示的字符串长度小于预留的长度
      if strdisplaywidth( l:str ) <= a:rest

        if l:index == tabpagenr('$') - 1
          return [l:tabidx - l:start, l:start , a:tablist[ l:start :l:index]]
        endif

        let l:index += 1

        " 显示的字符串长度大于预留的长度
      elseif strdisplaywidth( l:str ) > a:rest

        if l:index == 1
          return [0,a:tablist[0:0]]
        elseif l:index <= l:tabidx
          let l:str = ''
          let l:start = l:index
        elseif l:index > l:tabidx
          return [l:tabidx - l:start, l:start ,a:tablist[ l:start :l:index - 1]]
        endif
      endif
    endw
  endfunc 
  "}}}
  "{{{ MyTab_Preview
  func! MyTab_Preview(tabs, tidx, base, flag) 
    let l:str = ''
    let i = 0
    while i <= len(a:tabs) -1
      let l:item = MyTab_ItemStr( a:base + i+1, a:tabs[i] )

      if i != tabpagenr('$') - 1 
        let l:item .= (a:flag == 1 ? '%#TabLineFill# ' : ' ')
      endif

      let l:item = (a:flag == 1 ? (i == a:tidx ? '%#TabLineSel#' : '%#TabLine#') . l:item : l:item)
      let l:str .= l:item
      let i += 1
    endw
    if a:flag == 0
      return MyTab_GetHeader() .l:str . g:tail . g:plugin
    else
      let spacecount = &columns - strdisplaywidth(MyTab_Preview(a:tabs, a:tidx, a:base, 0))
      return MyTab_GetHeader() . l:str . "%#TabLineFill#" . repeat(' ', spacecount) . g:tail . g:plugin
    endif
  endfunc 
  "}}}
  "{{{ MyTab_Line2
  func! MyTab_Line2()

    let tabs =  MyTab_List()
    let restlength = &columns - strdisplaywidth(MyTab_GetHeader().g:tail.g:plugin)
    let result = MyTab_Tabs(tabs, restlength,1)
    return MyTab_Preview(result[2], result[0], result[1], 1)
  endfunc
  "}}}
  set stal=2
  set tabline=%!MyTab_Line2()
endif
"}}}

"autocmd BufRead *.py,*.c,*.sh,*.coffee map <silent> <leader><F5> :call Debug()<CR>
autocmd FileType c,python,sh,coffee noremap <buffer> <leader>r :call Run()<CR>
autocmd BufRead *.py noremap <buffer> <silent> <leader>bp :call SetBP()<CR>

func! Run() "{{{"
  exec "w"
  "我觉得运行需要分2种情况:
  "1. 不需要输入参数
  "2. 需要输入参数"
  if &ft == "c"
    "使用system执行gcc"
    call system("gcc ".expand("%:p")." -g -o ".expand("%:p:r"))
    echo "gcc ".expand("%:p")." -g -o ".expand("%:p:r")
    echo system(expand('%:p:r'))
  elseif &ft == "sh"
    call system("chmod +x ".expand('%:p'))
    echo system(expand('%:p'))
    "exec "!" . expand("%:p")
  elseif &ft == "python"
    exec "!python ".expand("%:p")
  elseif &ft == "coffee"
    echo system("coffee -s", join(getline(1,"$"),"\n"))
  endif
endfunc "}}}"

func! Debug() "{{{"
  exec "w"
  if expand("%:p:e") == "c"
    exec "!gcc ".expand("%:p")." -g -o ".expand("%:p:r")
    exec "!gdb ".expand("%:p:r")
  elseif expand("%:p:e") == "sh"
    exec "!bashdb " . expand("%:p")
  elseif expand("%:p:e") == "py"
    exec "!python ".expand("%:p")
  endif
endfunc "}}}"

func! SetBP() "{{{"
  let bp_flag = "import pdb; pdb.set_trace()  # XXX BREAKPOINT"
  if getline(".") == bp_flag
    exec "normal dd"
  else
    call append(line(".")-1, bp_flag)
  endif
endfunc "}}}"

" 结合 .,n,p可以实现快速替换{{{
nnoremap <silent> <c-d> :call Mark()<cr>
func! Mark() 

  let l:saved_reg = @"
  let l:colstr =  getline(".")[wincol()-1]

  if match(l:colstr, '\s') == -1

    exec "normal mzgew"
    let l:start =  wincol()
    
    exec "normal g`z"
    let l:offset = wincol() - l:start
    let l:word = expand('<cword>')

    if l:offset == 0
      let @/="\\<" . expand('<cword>') . "\\>"
    else
      let @/ = "\\(\\<". l:word[0:(l:offset - 1)] ."\\)\\@<=" . l:word[(l:offset):] ."\\>"
    endif 
  endif
  let @"=l:saved_reg
endfunc 
"}}}

"{{{ Help
au FileType help noremap <buffer> <c-m> <c-]>
au FileType help noremap <buffer> <leader>n :call SearchTag(1)<cr>
au FileType help noremap <buffer> <leader>p :call SearchTag(-1)<cr>
command! -nargs=0 NextTag call SearchTag(1)
func! SearchTag(direction) 
  let @/="|.\\{-}|"
  if a:direction == 1
    call search("|.\\{-}|")
  elseif a:direction == -1
    call search("|.\\{-}|",'b')
  endif
endfunc 
"}}}
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  插件设置                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  CtrlP                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 1
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/node_modules/*,~/.vim/bundle/*        " Linux/MacOSX
"let g:ctrlp_extensions = ['quickfix', 'dir', 'rtscript',
"\ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn|cache)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
      \ }

noremap ,,l :CtrlPLine<cr>
noremap ,,c :CtrlPChange <C-r>=expand("%:p")<cr><cr>
noremap ,,u :CtrlPUndo<cr>
noremap ,,r :CtrlPRTS<cr>
"noremap ,,t <esc>:tabs<cr>:tabs<space>
"noremap ,,b :CtrlPBuffer<cr>
nnoremap ,,b <esc>:ls<cr>:b<space>
noremap ,,p :CtrlP <C-r>=expand("%:p:h")<cr><cr>
noremap ,,m :CtrlPMRU<cr>
noremap ,,w :CtrlPClearCache<cr>
noremap ,,B :CtrlPBookmarkDir<cr>

let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
"hi IndentGuidesOdd  ctermbg=237 ctermfg=none
"hi IndentGuidesEven ctermbg=237 ctermfg=none

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                UltiSnips                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsSnippetsDir         = $HOME . '/dotfiles/vim/UltiSnips'
let g:UltiSnipsEditSplit           = "vertical"
let g:UltiSnipsListSnippets        = "<C-z>"
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
inoremap <S-tab> <Tab>
au FileType snippets setlocal comments=:# commentstring=#\ %s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               authorinfo                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimrc_author='loyalpartner' 
let g:vimrc_email='loyalpartner@163.com' 
let g:vimrc_homepage='http://www.none.cn' 
"nnoremap <F4> :AuthorInfoDetect<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   ycm                                   "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:ycm_extra_conf_globlist = ['/usr/include/c++/4.7.2/*']
let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_invoke_completion = '<C-L>'
"let g:ycm_filetype_blacklist = {
      "\ 'vim' : 1,
      "\}
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

"inoremap <Tab> <C-x><C-o>
"inoremap <S-Tab> <Tab>
let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::'],
      \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Powerline                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Powerline_symbols = 'fancy'
let g:Powerline_stl_path_style = 'full'
"let g:Powerline_mode_n = 'NORMAL'


"{{{ Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Syntastic                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=0
let g:syntastic_error_symbol='=>'
let g:syntastic_warning_symbol='!!'
let g:syntastic_python_checkers = ['flake8', 'pylint']
let g:syntastic_mode_map={'mode':'active',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': [] }
"\ 'passive_filetypes': ['python'] }
highlight SyntasticErrorLine guibg=red


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               easymotion                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_leader_key = '<Leader>e'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
"let g:EasyMotion_keys = 'asdfghjkl'
let g:EasyMotion_do_shade = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               ToggleList                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lt_location_list_toggle_map = '<leader>ll'
let g:lt_quickfix_list_toggle_map = '<leader>qq'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Align                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <leader>a= :Align = //
"vnoremap <leader>a= :Align = //
"{{{
func! VimAlign() 
  nnoremap <buffer> <leader>a= :Align = "
  vnoremap <buffer> <leader>a= :Align = "p0
endfunc 
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               python-mode                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:pymode              = 0
"let g:pymode_lint         = 0
"let g:pymode_lint_checker = " pyflakes"
let g:pymode_rope                          = 1
let g:pymode_rope_enable_autoimport        = 1
let g:pymode_rope_autoimport_generate      = 1
let g:pymode_rope_autoimport_underlineds   = 0
let g:pymode_rope_codeassist_maxfixes      = 10
let g:pymode_rope_sorted_completions       = 1
let g:pymode_rope_extended_complete        = 1
let g:pymode_rope_autoimport_modules       = ["os", "shutil","bs4"]
let g:pymode_rope_vim_completion           = 1
let g:pymode_rope_guess_project            = 1
let g:pymode_rope_goto_def_newwin          = "vnew"
let g:pymode_rope_always_show_complete_menu= 0

let g:pymode_lint_write                    = 0
let g:pymode_lint_cwindow                  = 0
let g:pymode_lint_onfly                    = 0
let g:pymode_lint_hold                     = 1
"au FileType python set omnifunc=RopeOmni
"au FileType python nnoremap <buffer> gd :RopeGotoDefinition<cr>
au FileType python nnoremap <buffer> <c-n>r :RopeRename<cr>
au FileType python nnoremap <buffer> <c-n>g :RopeGotoDefinition<cr>
au FileType python nnoremap <buffer> <c-n>d :RopeShowDoc<cr>
au FileType python nnoremap <buffer> <c-n>f :RopeFindOccurrences<cr>
au FileType python nnoremap <buffer> <c-n>i :RopeAutoImport<cr>
au FileType python nnoremap <buffer> gd :RopeGotoDefinition<cr>

"cabbr plc PyLintAuto
cnoremap ;pl PyLintAuto<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 number                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cabbr ;nt NumbersToggle
let g:enable_numbers = 0
cnoremap ;nt NumbersToggle<cr>
cnoremap ;nn set nu<cr>:set nonu<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              coffeescript                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coffee_linter = ''
"au BufNewFile,BufReadPost *.coffee setl foldmethod=marker nofoldenable
"au FileType * let b:match_words = b:match_words.',\sstruct:^\}'
"au FileType * let b:match_words += '^\{:^\}'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                zencoding                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:user_zen_leader_key = '<Leader><leader>'
let g:use_zen_complete_tag = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                TaskList                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>tl <Plug>TaskList
let g:tlWindowPosition = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Colorizer                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:colorizer_nomap = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                          gundo                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gundo_auto_preview = 0
nnoremap <leader>u :GundoToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 tagbar                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_width = 30
let g:tagbar_sort = 0
let g:tagbar_left = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                autopair                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autopair 有个bug,下面的映射可以避免"
inoremap <cr> <space>a<c-h><cr>
inoremap <c-b> <del>
"}}}

" vim: set foldmethod=marker tabstop=2 shiftwidth=2 softtabstop=2 expandtab:
