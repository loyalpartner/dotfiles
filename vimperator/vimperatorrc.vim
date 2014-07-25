" 设置上一页，下一页跳转
set nextpattern=下一章,下一篇,下一张,下一节,下一版,下一页,下一頁,下页,后页,\bnext,^>$,^(>>|»)$,^(>|»),(>|»)$,\bmore\b
set previouspattern==上一章,上一篇,上一张,上一节,上一版,上一页,上一頁,上页,前页,\bprev|previous\b,^<$,^(<<|«)$,^(<|«),(<|«)$ 

" 设置f指示器使用字符
set hintchars=aoeuhtsrl

" 设置配色
highlight Hint color:green; background:white; border-bottom-right-radius:30px; border-bottom-left-radius:30px; border:4px solid pink; padding:2px 3px; margin:-15px; width:14px; text-align:center;
highlight HintElem border-radius: 8px; background:white; color:green;
highlight HintActive border-radius: 8px; background:red;

"可以直接先输入网站名,再用<CTRL>+<ENTER>快捷输入.com/.net
cnoremap<S-Return> <End>.org<Home><C-Right>www.<CR>
cnoremap<C-Return> <End>.com<Home><C-Right>www.<CR>

noremap ,s :source ~/.vimperatorrc<CR>
noremap ,p :preferences<CR>
noremap ,d :downloads<CR>
iabbrev loy loyalpartner@163.com

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <C-O> <Left><Right>
inoremap <C-O> <Left><Right>

" set ft=vim
