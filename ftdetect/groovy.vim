if exists('b:load_ftdetect_groovy')
    finish
endif
let b:load_ftdetect_groovy=1

augroup GROOVY_SETTING
    autocmd!
    autocmd BufNewFile *.groovy call <SID>append_setting()
    autocmd BufRead,BufNewFile *.groovy call <SID>enterbuffer()
augroup END

function <SID>append_setting()
call append("g", "")
call append("$", "")
call append("$", "")
call append("$","// vim600:ts=4 st=4 foldmethod=marker foldmarker=<<<,>>>")
call append("$","// vim600:syn=groovy commentstring=//\\ %s")
:1
endf

function <SID>setting() 
    setlocal filetype=groovy
    setlocal omnifunc=javacomplete#Complete 

    if exists("*eclim#java#complete#CodeComplete")
        setlocal completefunc=eclim#java#complete#CodeComplete
    else
        setlocal completefunc=javacomplete#CompleteParamsInfo 
    endif

    setlocal foldmethod=marker
    setlocal commentstring=//\ %s
    setlocal indentexpr=GetGroovyIndent()

    if(!exists("g:EclimDisabled")) 
        runtime ../eclim/ftplugin/groovy/eclim.vim
    endif
endf

function <SID>buildtags()
    if confirm('Do you want to build the tags index using Groovy?', "&No\n&OK", 1) == 2
        exec "!".$HOME."/.vim/lifei/bin/build_groovy_tags.sh"
    endif
endf

function <SID>setmapping()
    silent! noremap <buffer> <leader><del> :call <sid>buildtags()<cr>
    silent! noremap <buffer> <F5> :w!<CR>:!source ~/.profile;clear;groovy %<CR>
    silent! noremap <buffer> <F7> :w!<CR>:!clear;groovyc %<CR>
endf

function <SID>enterbuffer()
    call <SID>setmapping()
    call <SID>setting()
endf
