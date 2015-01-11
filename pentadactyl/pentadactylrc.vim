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

    " 样式
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

    "noremap -c D <count>d

    " Tabularize /:/l1c0l0
    noremap -ex ,s :source ~/.pentadactylrc
    noremap -ex ,S :silent !gvim --remote ~/.pentadactylrc
    noremap -ex ,da  :dialog addons
    noremap -ex ,dc  :dialog cookies
    noremap -ex ,dss :source ~/.pentadactylrc
    noremap -ex ,dsg :silent !gvim --remote ~/.pentadactylrc
    noremap -ex ,dh  :help
    noremap -ex ,dp  :preferences
    noremap -ex ,dd  :dialog downloads
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

" 方法和命令"{{{

    " 用户自定义命令格式
    command! -nargs=? foo echo 'Same as above but simpler' + <q-args>

javascript <<EOF

    //
    // <count>gT 跳转到倒数第<count>个选项卡，如果不带数字则跳到前一个选项卡
    //   在打开的选项卡很多的时候非常有用
    //
    // 在 javascript Pentadactl 命令
    // commands.execute("pin")
    //
    function GotoRevertTabpage(index){
      if(index){
        config.tabbrowser.selectTabAtIndex(0-index);
      }else{
        config.tabbrowser.selectTabAtIndex(config.tabbrowser.selectedTab._tPos-1);
      }
    }

    //
    // Pentadactl <count>d 向下删除 <count> 个 tab，然后跳到下一个 tab
    //            <count>D 向上删除 <count> 个 tab，然后跳到上一个 tab
    // 我觉得有点反人类，所以重新定义 d，D 键的行为
    //
    // 改成       <count>d 向下删除 <count> 个 tab，然后跳到上一个 tab
    //            <count>D 向上删除 <count> 个 tab，然后跳到下一个 tab
    //
    // 关闭 tab
    // @params direction d 代表向右，D 代表向左
    // @params count 关闭 tab 的数量
    //
    function CloseTab(direction, count){


        var currentTabNo = tabs.getTab().dactylOrdinal;
        var tabCount     = tabs.allTabs.length;
        var dir_r        = (direction == 'd'); //删除的方向

        // 批量关闭
        var closedCount = dir_r ? Math.min(count, tabCount - currentTabNo + 1) : Math.min(count, currentTabNo)
        for (var i=0; i < closedCount; ++i) {
            commands.execute("tabclose " + (currentTabNo + i * (dir_r ? 0 : -1)));
        }

        var targetTabNo = currentTabNo;
        if(dir_r){
            targetTabNo = currentTabNo > 1 ? currentTabNo - 1 : 1;
        }else{
            targetTabNo = currentTabNo < tabCount ? (currentTabNo - closedCount) + 1 : tabs.allTabs.length;
        }
        commands.execute("tabnext " + targetTabNo);
    }

    function TabStyle(){
        tabs.allTabs.forEach(function(tab){
            if(!tab.pinned) tab.setAttribute("pinned", true);
        });
        // tabs.getTab().removeAttribute("pinned");
    }

    //
    // Pentadactl 的 u 键也有点反人类，重新定义其行为
    //
    //  <count>u undo <count> 次
    //
    function UndoTab(count) {
        for (var i=0; i < count; ++i) {
            commands.execute("undo")
        }
    }
EOF

    nnoremap -b -c -ex gT :execute GotoRevertTabpage("<count>" == "" ? 0 : parseInt("<count>"))
    nnoremap -b -c -ex d :execute CloseTab("d", "<count>" == "" ? 1 : parseInt("<count>"))
    nnoremap -b -c -ex D :execute CloseTab("D", "<count>" == "" ? 1 : parseInt("<count>"))
    nnoremap -b -c -ex u :execute UndoTab("<count>" == "" ? 1 : parseInt("<count>"))
"}}}

autocmd! LocationChange * execute TabStyle()
autocmd! LocationChange www.hnradio.com :set encoding=gbk
autocmd! LocationChange www.0735.com :set encoding=gbk

noremap -ex c :tabclose
