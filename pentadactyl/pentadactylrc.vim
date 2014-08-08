set go=bCsm

" 设置上一页，下一页跳转
set nextpattern=下一章,下一篇,下一张,下一节,下一版,下一页,下一頁,下页,后页,\bnext,^>$,^(>>|»)$,^(>|»),(>|»)$,\bmore\b
set previouspattern=上一章,上一篇,上一张,上一节,上一版,上一页,上一頁,上页,前页,\bprev|previous\b,^<$,^(<<|«)$,^(<|«),(<|«)$ 

" 设置配色
" https://code.google.com/p/dactyl/issues/list?can=2&q=label:project-pentadactyl+label:type-colorscheme
"colorscheme vimium
highlight Hint color:green; background:white; border:2px solid pink; border-radius: 4px; padding:2px 3px; margin:-15px; width:14px; text-align:center; opacity: .7;
highlight HintElem border-radius: 8px; background:white; color:green; opacity: .7;
highlight HintActive border-radius: 8px; background:red;

set hintkeys=aoeuhtnl

map -ex <A-t> :set showtabline!=always,never
map -ex <A-u> :set guioptions!=T

cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

noremap ; :
noremap : ;
noremap ,s :source ~/.pentadactylrc<CR>
noremap ,h :help<CR>
noremap ,S -s :!gvim --remote-tab ~/.pentadactylrc<CR>
noremap ,p :preferences<CR>
noremap ,d :downloads<CR>
noremap ,t :tabmove 
abbr loy loyalpartner@163.com
abbr leo charlseleo
abbr lee charlselee

"用户自定义命令格式
command! -nargs=? foo echo 'Same as above but simpler' + <q-args>
"vim: set ft=vim
