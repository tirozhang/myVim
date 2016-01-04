" 文 件 名：      setlocal.vim<br />
" 文件描述：      setlocal的插件文件<br />
" 文件目的：      为每个目录或者每个问题设定vim风格<br />
" 创建时间：      2010-08-17 20:47:37<br />
" 修改历史：      <br />
" @link           lifei@kuxun.cn
" @copyright      2001-2010 北京酷讯互动科技有限公司.
" @author         Li Fei (mn), lifei@kuxun.cn
" @package        setlocal
" @version        1.0

if exists('loaded_setlocal')
    finish
endif

let loaded_setlocal = 'yes'

function <SID>EditLocalFile()
    let f = expand('%:f')
    let dir = expand('%:p:h')
    let filename = dir . "/." . f . ".vim"

    if filereadable(filename)
        exec "e ".filename
    else
        exec "e ".filename
        let fte = substitute(f, "\\.", "_", "g")
        call append("g", "let load_setlocal_".fte."='yes'")
        call append("g", "endif")
        call append("g", "\tfinish")
        call append("g", "if exists('loaded_setlocal_".fte."')")
        call append("$", "")
        call append("$","\" vim600:ts=4 st=4 foldmethod=marker foldmarker=<<<,>>>")
        call append("$","\" vim600:syn=vim encoding=".&enc." commentstring=\"\\ %s")
        :5
    endif
endf
command! -nargs=0 -bar EditLocalFile call <SID>EditLocalFile()

function <SID>SetLocalFile() 
    let f = expand('%:f')
    let dir = expand('%:p:h')

    let filename = dir . "/.vim"
    if filereadable(filename)
        exec "so ".filename
    endif

    let filename = dir . "/." . f . ".vim"
    if filereadable(filename)
        exec "so ".filename
    endif

endf

autocmd BufNewFile,BufReadPre * call <SID>SetLocalFile()
command! -nargs=0 -bar SetLocalFile call <SID>SetLocalFile()
