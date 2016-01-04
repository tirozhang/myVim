"   vim600: ts=4 st=4 foldmethod=marker foldmarker={{{,}}} syn=vim 
"   vim600: encoding=utf-8 commentstring=//\ %s
""""""""""""""""""""""""""""""""""""""""""
"        回车打开或关闭折叠              "
""""""""""""""""""""""""""""""""""""""""""
nnoremap <del>  :Pro<cr>

"""""""""""""""""""""""""""""""""""""""""""
"        ( ) 键实现修改表的跳转           "
"""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent><unique> ( g;
nnoremap <silent><unique> ) g,

"""""""""""""""""""""""""""""""""""""""""""
"               Q删除buffer               "
"""""""""""""""""""""""""""""""""""""""""""
" {{{
function! <SID>BufcloseCloseIt()
    " 如果当前窗口不可写，关掉
    if getwinvar(winnr(), "&modifiable") == 0
        :q
        return
    endif
    "
    " Switch to the previous window
    let l:count = winnr('$')
    let l:i = 0
    let l:big = 0
    let l:id = -1

    while l:i <= l:count
        let l:i = l:i + 1
        let l:a = winheight(l:i)*winwidth(l:i)
        if l:a > l:big
            let l:big = l:a
            let l:id = l:i
        endif
    endwhile

    if winnr() != l:id
        :q
        return
    endif

    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        qa
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
    UMiniBufExplorer
endfunction
command! Bclose call <SID>BufcloseCloseIt()
nnoremap qq  :Bclose<cr>
" }}}

"""""""""""""""""""""""""""""""""""""""""""
"            Shift - + 字符快捷           "
"""""""""""""""""""""""""""""""""""""""""""
nnoremap + ;
nnoremap _ ,
vnoremap + ;
vnoremap _ ,

"{{{
function <SID>SetStatusLine()
    if &ft == ''
        return
    endif

    if !&modifiable 
        return
    endif
    " Status line settings {{{
    setl ruler
    setl rulerformat=%15(%c%V\ %p%%%)
    " Display a status-bar.
    setl laststatus=2
    if has("statusline")
        setl statusline=%5*%{&fenc}\ %0*#%{bufnr('')}\ %<%f\ %3*%m%1*%r%0*\ %2*%y%4*%w%0*%=[%b\ 0x%B]\ \ %8l,%10([%c%V/%{strlen(getline(line('.')))}]%)\ %P
    endif
    " }}}
    
    " Colors {{{
    hi User2        term=bold         cterm=bold         ctermfg=Yellow
    hi User5        term=inverse,bold cterm=inverse,bold ctermfg=Red ctermbg=White
    "k }}}   
endf


augroup AutoSetStatusLine
    autocmd!
    autocmd Syntax * call <SID>SetStatusLine()
augroup END
"}}}


"""""""""""""""""""""""""""""""""""""""""""
"            FoldTextFunc                 "
"""""""""""""""""""""""""""""""""""""""""""
"{{{ 自定义FoldText
function! FoldTextFunc() 
    " 得到系统默认的foldtext
    " +-- 20 lines: 
    "   0123456789
    let line=foldtext()
    let line=substitute(line,'[+|-]', '', 'g')
    let line=substitute(line,'^ \+', '', 'g')
    " 补齐行数位数: '20' -> ' 20'
    let ipos=stridx(line, ":")
    while ipos < 9
        let line=' '.line
        let ipos=ipos+1
    endw
    " v:foldstart - 表示该fold开始的行数
    let sp=getline(v:foldstart)
    " 仅保留首行缩进, 其余用foldtext替换
    let line=substitute(sp,'[^ \t].\+$', ">> ".line, '')
    return line."                                                                                                                                                                                     "
endf

set foldtext=FoldTextFunc()
"}}}

"{{{ 自动创建不存在的目录
augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call <SID>EnsureDirExists()
augroup END
function! <SID>EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call <SID>AskQuit("Directory '" . required_dir . "' doesn't exist.", "&Create it?")

        try
            call mkdir( required_dir, 'p' )
        catch
            call <SID>AskQuit("Can't create '" . required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction

function! <SID>AskQuit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction

"}}}


" vim600: ts=4 st=4 foldmethod=marker foldmarker={{{,}}} syn=vim
" vim600: encoding=utf-8 commentstring="%s
