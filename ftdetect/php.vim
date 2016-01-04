if exists('b:load_php')
    finish
endif
let b:load_php=1

augroup PHP_SETTING
    autocmd!
    autocmd BufRead,BufNewFile *.php setlocal filetype=php
    autocmd BufNewFile *.php call <SID>append_setting()
    autocmd BufRead,BufNewFile *.php call <SID>enterbuffer()
augroup END

function <SID>append_setting()
call append("g", "<?php")
call append("$", "")
call append("$", "")
call append("$","// vim600:ts=4 st=4 foldmethod=marker foldmarker=<<<,>>>")
call append("$","// vim600:syn=php commentstring=//%s")
:2
endf

function <SID>buildtags()
    if confirm('Do you want to build the tags index?', "&No\n&OK", 1) == 2
        exec "!".$HOME."/.vim/lifei/bin/build_php_tags.sh"
    endif
endf

function <SID>setmapping()
    noremap <buffer> <cr> za
    noremap <buffer> <leader><del> :call <sid>buildtags()<cr>
    noremap <buffer> <F5> :w!<CR>:!php %<CR>
    noremap <buffer> <F6> :w!<CR>:!php -l %<CR>
endf

function <SID>readtags()
    let i = 0
    let s:tags = []
    let s:tagfile = &ft.'.tags'
    while i < 5
        if filereadable(s:tagfile)
            let s:tags += [s:tagfile]
        endif
        let i = i + 1
        let s:tagfile = '../' . s:tagfile
    endwhile
    if len(s:tags) > 0
        exec 'setlocal tags='.join(s:tags, ',')
    endif
    let s:tagspath = $HOME.'/.vim/lifei/tags/'.&ft.'.tags'
    if filereadable(s:tagspath)
        exec 'setlocal tags+='.s:tagspath
    endif
endf

function <SID>setting() 
    setlocal foldmethod=marker
    setlocal omnifunc=phpcomplete#CompletePHP
    setl runtimepath+=$HOME/.vim/lifei
    set keywordprg="help"
    setl commentstring=//\ %s
    setl foldmethod=marker
    setl foldmarker=<<<,>>>
endf
function <SID>enterbuffer()
    call <SID>setmapping()
    call <SID>readtags()
    call <SID>setting()
endf

