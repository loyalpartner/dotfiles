let g:local = expand('~/vim-dev/')

let s:company_path = $HOME . '/company/settings.vim'
let s:at_company = filereadable(s:company_path)

set runtimepath^=~/vim-dev/plug.nvim
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
" Plug 'loyalpartner/coc-lists'
Plug 'loyalpartner/chromium-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'peitalin/vim-jsx-typescript'
Plug 'lambdatoast/elm.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'       " hub
Plug 'tpope/vim-unimpaired'    " enhancement
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-dadbod'        " database
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-tbone'         " tmux
Plug 'tpope/vim-projectionist' " project settings
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-scriptease'    " vimscript enhancement
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'dhruvasagar/vim-zoom'
Plug 'romainl/vim-cool'        " search improve
Plug 'mbbill/undotree'
Plug 'mattn/emmet-vim'
Plug 'whiteinge/diffconflicts'
Plug 'tommcdo/vim-exchange'
" Plug 'dag/vim-fish'
Plug 'fatih/vim-go'
Plug 'loyalpartner/vim-delve'
Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' }
Plug 'othree/xml.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tommcdo/vim-lion'
" Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'Yggdroot/indentLine'
Plug 'mzlogin/vim-markdown-toc'
Plug 'posva/vim-vue'
" Plug 'dart-lang/dart-vim-plugin'
Plug 'tweekmonster/helpful.vim'
" Plug 'lervag/vimtex'
" Plug 'derekwyatt/vim-scala'
Plug 'simnalamburt/vim-mundo'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'lambdalisue/gina.vim'
Plug '907th/vim-auto-save'
Plug 'puremourning/vimspector'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'vim-scripts/gtags.vim'
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-utils/vim-man'
" Plug 'kshenoy/vim-signature'
" Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-rfc'
Plug 'vim-scripts/genutils'
Plug 'vim-scripts/BreakPts'
Plug 'liuchengxu/vista.vim'
Plug 'junegunn/vader.vim'
Plug 'loyalpartner/termdebug-go'
Plug 'wellle/targets.vim'
Plug 'rust-lang/rust.vim'
Plug 'honza/vim-snippets'

if has('nvim')
  Plug 'github/copilot.vim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif

packadd termdebug

call plug#end()
filetype plugin on
syntax on

" vimrc files
for s:path in split(glob('~/.vim/vimrc/*.vim'), "\n")
  exe 'source ' . s:path
endfor

if s:at_company
  exe 'source' . s:company_path
endif
