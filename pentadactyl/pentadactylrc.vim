"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set ft=vim tabstop=4 softtabstop=4 shiftwidth=4 foldmethod=marker:
" Pentadactl 配置文件
"
"   1. 基础设置
"   2. 快捷键设置
"   3. 定义方法和命令
"
" @author 李凯
" @date   2014-12-06 16:12
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 基础设置"{{{
  set go=mCsn

  " 设置上一页，下一页跳转
    set nextpattern=下一章,下一篇,下一张,下一节,下一版,下一页,下一頁,下页,后页,\b[Nn]ext,^>$,^(>>|»)$,^(>|»),(>|»)$,\bmore\b
    set previouspattern=上一章,上一篇,上一张,上一节,上一版,上一页,上一頁,上页,前页,\b[Pp]rev|previous\b,^<$,^(<<|«)$,^(<|«),(<|«)$ 

    " 设置配色
    " https://code.google.com/p/dactyl/issues/list?can=2&q=label:project-pentadactyl+label:type-colorscheme
    highlight Hint color:green; background:white; border:2px solid pink; border-radius: 4px; margin-left:-20px; width:14px; text-align:center;
    highlight HintElem border-radius: 4px; color:green;
    highlight HintActive border-bottom:1px red dotted;
    highlight StatusLineNormal background-color:transparent; opacity: .7; color: green;
    highlight StatusLineBroken background-color:transparent; opacity: .7; color: green;

    set hintkeys=aoeuidhtnlr
"}}}

" 快捷键{{{

    " Tabularize /:/l1c0l0
    noremap <Space> :
    map -ex <A-t>   :set showtabline!=always,never
    map -ex <A-u>   :set guioptions!=T

    noremap   <C-c>   <Esc>
    inoremap  <C-c>   <Esc>
    cnoremap  <C-c>   <Esc>
    inoremap  <C-x>q  <C-a>"<C-e>"

    cnoremap <C-e> <End>
    cnoremap <C-b> <Home>

    noremap d D
    noremap D d

    " Tabularize /:/l1c0l0
    noremap -ex ,da  :dialog addons
    noremap -ex ,dc  :dialog cookies
    noremap -ex ,dss :source ~/.pentadactylrc
    noremap -ex ,dsg :silent !gvim --remote ~/.pentadactylrc
    noremap -ex ,dh  :help
    noremap -ex ,dp  :preferences
    noremap -ex ,dd  :downloads
    noremap -ex ,ext :exttoggle YoukuAntiADs with player

    noremap ,t        :tabmove

    " 查单词
    noremap <C-s> :t cd <C-v><C-v><CR>
    "vmap <C-s> Y:t cd <C-v><C-v><CR>
    "unmap ,d
    noremap -arg ,dg :t echo <arg>

    " 缩写"{{{
        abbr leo    charlseleo
        abbr lee    charlselee
        abbr loy    loyalpartner
        abbr loy@   loyalpartner@163.com
    "}}}
"}}}

" 定义方法和命令"{{{

    " 用户自定义命令格式
    command! -nargs=? foo echo 'Same as above but simpler' + <q-args>

    "
    " <count>gT 跳转到倒数第<count>个选项卡，如果不带数字则跳到前一个选项卡
    "   在打开的选项卡很多的时候非常有用
    "
javascript <<EOF
    function GotoRevertTabpage(index){
      if(index){
        config.tabbrowser.selectTabAtIndex(0-index);
      }else{
        config.tabbrowser.selectTabAtIndex(config.tabbrowser.selectedTab._tPos-1);
      }
    }
EOF
    nnoremap -b -c -ex gT :execute GotoRevertTabpage("<count>"==""?0:parseInt("<count>"))
"}}}

    autocmd! LocationChange * :pin
    autocmd! LocationChange www.hnradio.com :set encoding=gbk
    autocmd! LocationChange www.0735.com :set encoding=gbk

