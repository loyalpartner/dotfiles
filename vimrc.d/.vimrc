let g:local = expand('~/vim-dev/')

let s:company_path = $HOME . '/company/settings.vim'
let s:at_company = filereadable(s:company_path)

set runtimepath^=~/vim-dev/plug.nvim
call plug#begin()
" Plug 'chrisbra/unicode.vim'
" Plug 'loyalpartner/chromium-vim'
" Plug 'loyalpartner/protols',  {'do': 'yarn install --frozen-lockfile'}
" Plug 'tpope/vim-vinegar'
Plug '907th/vim-auto-save'
Plug 'altercation/vim-colors-solarized'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'bagrat/vim-buffet'
" Plug 'blindFS/vim-taskwarrior'
Plug 'brookhong/cscope.vim'
Plug 'dhruvasagar/vim-zoom'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'google/vim-jsonnet'
Plug 'hardselius/warlock'
Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' }
Plug 'heavenshell/vim-pydocstring'
" Plug 'HiPhish/info.vim'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'lambdalisue/gina.vim'
Plug 'lambdatoast/elm.vim'
Plug 'leafgarland/typescript-vim'
Plug 'liuchengxu/vista.vim'
" Plug 'loyalpartner/coc-gn',  {'do': 'yarn install --frozen-lockfile'}
" Plug 'loyalpartner/coc-lists',  {'do': 'yarn install --frozen-lockfile'}
Plug 'loyalpartner/info.vim'
Plug 'loyalpartner/termdebug-go'
Plug 'loyalpartner/vim-rfc'
" Plug 'loyalpartner/yac.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'mzlogin/vim-markdown-toc'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'othree/xml.vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'posva/vim-vue'
" Plug 'puremourning/vimspector'
Plug 'Raimondi/delimitMate'
Plug 'romainl/vim-cool'        " search improve
Plug 'rust-lang/rust.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'simnalamburt/vim-mundo'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-abolish'       " enhancement
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'        " database
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist' " project   settings
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'       " hub
Plug 'tpope/vim-scriptease'    " vimscript enhancement
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'         " tmux
Plug 'tpope/vim-unimpaired'    " enhancement
Plug 'tweekmonster/helpful.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/gtags.vim'
Plug 'vim-utils/vim-man'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif

Plug 'https://chromium.googlesource.com/chromium/src/tools/vim', {
      \'rtp': 'mojom'
      \}
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }
Plug 'https://github.com/webosose/chromium-v8', {
      \'rtp': 'tools/torque/vim-torque'
      \}

if v:version >= 900
  " Plug 'Exafunction/codeium.vim'
  Plug 'github/copilot.vim'
endif

packadd! termdebug

call plug#end()
filetype plugin on
syntax on

" vimrc files
for s:path in split(glob('~/.vim/vimrc.d/*.vim'), "\n")
  exe 'source ' . s:path
endfor

if s:at_company
  exe 'source' . s:company_path
endif
