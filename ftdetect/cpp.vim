if exists('b:load_ftdetect_cpp')
    finish
endif
let b:load_ftdetect_cpp=1

au BufNewFile *.cpp call <SID>append_setting()
au BufRead,BufNewFile *.cpp call <SID>enterbuffer()

function <SID>append_setting()
call append("g", "")
call append("$", "")
call append("$", "")
call append("$","// vim600:ts=4 st=4 foldmethod=marker foldmarker=<<<,>>>")
call append("$","// vim600:syn=cpp commentstring=//\\ %s")
:1
endf

function <SID>setting() 
    setlocal filetype=cpp
    setlocal foldmethod=marker
    setlocal commentstring=//\ %s
endf

function <SID>buildtags()
    if confirm('Do you want to build the tags index using Cpp?', "&No\n&OK", 1) == 2
        exec "!".$HOME."/.vim/lifei/bin/build_cpp_tags.sh"
    endif
endf

function <SID>setmapping()
    silent! noremap <buffer> <leader><del> :call <sid>buildtags()<cr>
endf

function <SID>enterbuffer()
    call <SID>setmapping()
    call <SID>setting()
endf
