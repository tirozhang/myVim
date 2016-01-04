if exists('b:load_java')
    finish
endif
let b:load_java=1

au BufRead,BufNewFile *.java setlocal filetype=java
au BufNewFile *.java call <SID>append_setting()
au BufRead,BufNewFile *.java call <SID>enterbuffer()

function <SID>append_setting()
call append("g", "")
call append("$", "")
call append("$", "")
call append("$","// vim600:ts=4 st=4 foldmethod=marker foldmarker=<<<,>>>")
call append("$","// vim600:syn=java commentstring=//%s")
:1
endf

function <SID>setting() 
    setlocal omnifunc=javacomplete#Complete 
    if &completefunc == ''
        setlocal completefunc=javacomplete#CompleteParamsInfo 
    endif
    setlocal foldmethod=marker
    setlocal commentstring=//\ %s
endf

function <SID>setmapping()
    noremap <buffer> <leader><del> :call <sid>buildtags()<cr>
    noremap <buffer> <F7> :w!<CR>:!javac %<CR>
endf

function <SID>enterbuffer()
    call <SID>setmapping()
    call <SID>setting()
endf

