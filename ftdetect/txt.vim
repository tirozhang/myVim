if exists('b:load_txt')
    finish
endif
let b:load_txt=1

augroup TXT_SETTING
    autocmd!
    autocmd BufRead,BufNewFile *.txt setlocal filetype=txt
augroup END 
