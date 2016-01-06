"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is based on the vimrc by Amix - http://amix.dk/
" You can find the latest version on:
"       http://blog.csdn.net/easwy
"
" Maintainer: LiFei
" Version: 0.1
" Last Change: 31/05/07 09:17:57
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
filetype indent on
"syntax enable
syntax on 

" {{{ SET
set nocompatible
"设置用于GUI图形用户界面的字体列表。
set guifont=Courier_New:h12:cANSI
"设定文件浏览器目录为当前目录
set bsdir=buffer
set autochdir

" <<< 设置编码
set enc=utf8
"设置文件编码检测类型及支持格式
set fileencodings=ucs-bom,chinese,taiwan,japan,korea,gb18030,latin1,utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
if v:lang =~ "^zh_CN$"
    set termencoding=chinese
endif
if v:lang =~ "^zh_CN.UTF-8"
    set termencoding=utf8
endif
" >>>


"指定菜单语言
set langmenu=en_US.UTF8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"帮助语言
set helplang=en
set iskeyword+=

set grepprg=grep\ -nH\ $*
set nocompatible
set history=100
set autoread
set mouse=a
set completeopt=menu
set complete-=u
set complete-=i
set ffs=unix,dos
set so=7
set wildmenu
set ruler
set cmdheight=2
set showcmd
set textwidth=160
set nu
set lz
set hid
set backspace=eol,start,indent
set whichwrap+=<,>
set incsearch
set hlsearch
set magic
set noerrorbells
set novisualbell
set t_vb=
set showmatch
set mat=2
set laststatus=2
set viminfo='10,\"100,:20,n~/.viminfo
set sessionoptions-=curdir
set sessionoptions+=sesdir
set nobackup
set nowb
set noswapfile
set fen
set fdl=0
set expandtab
set ai
set si
set wrap
set diffopt+=vertical
set pastetoggle=<F3>
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent        "always set autoindenting on
set smartindent       "set smart indent
set smarttab          "use tabs at the start of a line, spaces elsewhere
set lbr
set tw=200
set foldcolumn=3
set foldmarker=<<<,>>>
" }}}
""""""""""""""""""""""""""""""
" Plugin Setting
""""""""""""""""""""""""""""""
let g:EclimDisabled = 1
" {{{ for netrw
let g:netrw_winsize = 30
let g:netrw_winsize = 50
let g:netrw_quiet = 0
let g:netrw_scp_cmd = '/usr/bin/scp -q'
" }}}
" {{{ for explorer
let g:explVertical=1
let g:explWinSize=25
let g:explSplitLeft=1
let g:explSplitBelow=1
let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'
let g:explDetailedHelp=0
" }}}
" {{{ for Tlist
let Tlist_Compact_Format = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Display_Prototype = 0
let Tlist_Display_Tag_Scope = 0
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
" }}}
" {{{ for OmniCpp
let OmniCpp_GlobalScopeSearch = 1  " 0 or 1
let OmniCpp_NamespaceSearch = 1   " 0 ,  1 or 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
" }}}
" {{{ for gdb
let g:vimgdb_debug_file = ""
run macros/gdb_mappings.vim
" }}}
" {{{ for LookupFile
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
let g:LookupFile_MinPatLength = 1
let g:LookupFile_PreserveLastPattern = 0
let g:LookupFile_PreservePatternHistory = 0
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles = 0
let g:LookupFile_DisableDefaultMap = 1
" }}}
" {{{ for syntax
let xml_use_xhtml = 1
let html_use_css = 1
let html_number_lines = 0
let use_xhtml = 1
" }}}
" {{{ for Tex
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf='xpdf'
" }}}
" {{{ for Windwo Manager
let g:winManagerWindowLayout = "FileExplorer|TagList"
let g:winManagerWidth = 30
" }}}
" {{{ for BufExplorer
let g:defaultExplorer = 1
let g:bufExplorerDefaultHelp=1       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 40  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
let g:bufExplorerMaxHeight=20        " Max height
" }}}
" {{{ for miniBufExplorer
let g:miniBufExplorerMoreThanOne = 2   " Display when more than 2 buffers
let g:miniBufExplSplitToEdge = 1       " Always at top
let g:miniBufExplMaxSize = 3           " The max height is 3 lines
let g:miniBufExplMapWindowNavVim = 1   " map CTRL-[hjkl]
let g:miniBufExplUseSingleClick = 1    " select by single click
let g:miniBufExplModSelTarget = 1      " Dont change to unmodified buffer
let g:miniBufExplorerDebugLevel = 0
"let g:miniBufExplForceSyntaxEnable = 1 " force syntax on
" }}}
" {{{ for Echo Function
let g:EchoFuncKeyPrev = "<C-C>"
let g:EchoFuncKeyNext = "<C-V>"
" }}}
" {{{ for SuperTab
let g:SuperTabDefaultCompletionType = "<C-X><C-O><C-N>"
let g:SuperTabRetainCompletionType = 2
" }}}
let g:vimrc_loaded = 1
let g:C_Dictionary_File = 1
let g:vjde_lib_path = "$CLASSPATH"
let s:ShowMode=&showmode
let s:CmdHeight=&cmdheight

" {{{ gui setting
if has("gui_running")
	"set guioptions-=T
	"set guioptions-=m
	set guioptions-=L
  " 滚动条
	set guioptions+=r
	colorscheme torte_my
  "窗口最大化
  set lines=9999
  set columns=9999
else
    set encoding=utf-8
    set fileencodings=utf-8,gb18030,gb2312,gbk " 如果你要打开的文件编码不在此列，那就添加进去
    "使用 murphy 调色板
	colorscheme ron
    highlight Folded     ctermbg=Black ctermfg=lightblue
endif " has
" }}}


"==========================================
"    Mapping
"==========================================
let mapleader = ","
let g:mapleader = ","

cmap @vd vertical diffsplit
map <F2> :%s/\s*$//g<cr>:noh<cr>
" {{{ grep
map <silent> <leader>gg :Grep<cr>
map <silent> <leader>gr :Rgrep<cr>
map <silent> <leader>gf :Fgrep<cr>
map <silent> <leader>ga :Agrep<cr>
" }}}
map <leader>yr :YRShow<cr>
" {{{ syntax
map <leader>1 :set syntax=c<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>
" }}}
map <space> :wincmd \|<cr>:wincmd _<cr>
map ! :!
map m :bn<cr>
map M :bp<cr>
" {{{ for buffer 
map <leader>bd :Bclose<cr>
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>
" }}}
map <silent> <leader>cd :cd %:p:h<cr>

map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>

noremap <Leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm

nnoremap _ ,
nnoremap + ;

" 
nnoremap ; :
nnoremap ' :b

nnoremap <leader>' '
vnoremap ' "+y
" {{{ for Explorer
nmap <silent> <leader>tl :Tlist<cr>
nmap <silent> <leader>w1 :FirstExplorerWindow<cr>
nmap <silent> <leader>w2 :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>
nmap <silent> <leader>fe :Sexplore!<cr>
" }}}

" for increment.vim {{{
vnoremap <c-a> :Inc<CR>
" }}}
nmap zm zMzo

" 清楚高亮
nmap <silent> <leader><cr> :noh<cr>
" 重画
nmap <silent> <leader>rr :redraw!<cr>

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

nmap <silent> ? :LUWalk<cr>
" {{{
nmap <leader>cc :cc<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr>
nmap <leader>cb :botright lw 10<cr>
" }}}
" {{{
nmap <silent> <leader>gv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>gv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>
" }}}
" 自动补全热键 {{{
inoremap <expr> <F9>       pumvisible()?"\<PageDown>":""
inoremap <expr> <F10>      pumvisible()?"\<C-N>":""
inoremap <expr> <F11>      pumvisible()?"\<C-P>":""
inoremap <expr> <F12>      pumvisible()?"\<PageUp>":""
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"
inoremap <C-]>             <C-X><C-]>
inoremap <C-F>             <C-X><C-F>
inoremap <C-K>             <C-X><C-K>
inoremap <C-D>             <C-X><C-D>
inoremap <C-L>             <C-X><C-L>
" }}}

autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
autocmd FileType html,python,vim,javascript setl shiftwidth=4
autocmd FileType html,python,vim,javascript setl tabstop=4
autocmd FileType java,c setl shiftwidth=4
autocmd FileType java setl tabstop=4
autocmd FileType txt setl lbr
autocmd FileType txt setl tw=78
autocmd BufNewFile,BufRead *.todo so ~/vim_local/syntax/amido.vim
autocmd FileType vim set nofen
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>
autocmd FileType html set ft=xml
autocmd FileType html set syntax=html
autocmd FileType c,cpp  map <buffer> <leader><space> :make<cr>
autocmd FileType c,cpp  setl foldmethod=manual | setl fen
autocmd FileType tex map <silent><leader><space> :w!<cr> :silent! call Tex_RunLaTeX()<cr>
autocmd FileType tex inoremap $i \indent
autocmd FileType tex inoremap $* \cdot
autocmd FileType tex inoremap $i \item
autocmd FileType tex inoremap $m \[<cr>\]<esc>O
autocmd FileType template set encoding=utf-8
autocmd BufWinEnter \[Buf\ List\] setl nonumber
if has("autocmd") && exists("+omnifunc")
autocmd Filetype *.php
    \if &omnifunc == "" |
    \  setlocal omnifunc=syntaxcomplete#Complete |
    \endif
endif


function! MySys()
  if has("win16") || has("win32") || has("win64") || has("win95")
    return "windows"
  else
    return "linux"
endfunction


if MySys() == 'linux'
    "Fast reloading of the .vimrc
    map <silent> <leader>vs :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>ve :e ~/.vimrc<cr>
    "When .vimrc is edited, reload it
    autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    " Set helplang
    set helplang=cn
    "Fast reloading of the _vimrc
    map <silent> <leader>vs :source ~/_vimrc<cr>
    "Fast editing of _vimrc
    map <silent> <leader>ve :e ~/_vimrc<cr>
    "When _vimrc is edited, reload it
    autocmd! bufwritepost _vimrc source ~/_vimrc
endif

if MySys() == "windows"
    let Tlist_Ctags_Cmd = 'ctags.exe'
elseif MySys() == "linux"
    let Tlist_Ctags_Cmd = 'ctags'
endif

function! s:GetVisualSelection()
    let save_a = @a
    silent normal! gv"ay
    let v = @a
    let @a = save_a
    let var = escape(v, '\\/.$*')
    return var
endfunction
 
function! SmartTOHtml()
    TOhtml
    try
        %s/&quot;\s\+\*&gt; \(.\+\)</" <a href="#\1" style="color: cyan">\1<\/a></g
        %s/&quot;\(-\|\s\)\+\*&gt; \(.\+\)</" \&nbsp;\&nbsp; <a href="#\2" style="color: cyan;">\2<\/a></g
        %s/&quot;\s\+=&gt; \(.\+\)</" <a name="\1" style="color: #fff">\1<\/a></g
    catch
    endtry
    exe ":write!"
    exe ":bd"
endfunction

" For windows version
if MySys() == 'windows'
    "source $VIMRUNTIME/mswin.vim
    "behave mswin
    """""""""""""""""""""""""""""""""""""""""""
    "            菜单和工具栏                 "
    """""""""""""""""""""""""""""""""""""""""""
    "Toggle Menu and Toolbar
    set guioptions-=m
    set guioptions-=T
    set lines=9999
    set columns=9999
    map <silent> <F2> :if &guioptions =~# 'T' <Bar>
            \set guioptions-=T <Bar>
            \set guioptions-=m <bar>
            \set lines=9999
            \set columns=9999
        \else <Bar>
            \set guioptions+=T <Bar>
            \set guioptions+=m <Bar>
            \set lines=9999
            \set columns=9999
        \endif<CR>

    set diffexpr=MyDiff()
    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

"pydiction 1.2 python auto complete
filetype plugin on
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
"defalut g:pydiction_menu_height == 15
"let g:pydiction_menu_height = 20 

" python auto-complete code
" Typing the following (in insert mode):
"   os.lis<Ctrl-n>
" will expand to:
"   os.listdir(
" Python 自动补全功能，只需要反覆按 Ctrl-N 就行了
if has("autocmd")
      autocmd FileType python set complete+=k~/.vim/tools/pydiction
endif
"Project 配置
let g:proj_flags='imsg'
let g:proj_window_width=24
let g:proj_window_increment=90
nmap <silent> <Leader>P :Project<CR>

"let NERDTreeDirArrows=0
"nnoremap <silent> <F4> :NERDTreeMirror<CR>
"nnoremap <silent> <F4> :NERDTreeToggle<CR>
"" nerdtree mapping
map <F4> :NERDTreeToggle<CR>

"ctrlP
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
"airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
"closetag
let g:closetag_html_style=1
"syntastic
let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1
let g:syntastic_python_checkers=['pyflakes'] " 使用pyflakes,速度比pylint快
let g:syntastic_javascript_checkers = ['jsl', 'jshint']
let g:syntastic_html_checkers=['tidy', 'jshint']
" 修改高亮的背景色, 适应主题
highlight SyntasticErrorSign guifg=white guibg=black
" to see error location list
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 5
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction
nnoremap <Leader>s :call ToggleErrors()<cr>
" nnoremap <Leader>sn :lnext<cr>
" nnoremap <Leader>sp :lprevious<cr>

"nerdcommenter
let g:NERDSpaceDelims=1
"vim-markdown
let g:vim_markdown_folding_disabled=1
"cscope
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif

nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"indentLine
nnoremap <Leader>l :IndentLinesToggle <cr>
let g:indentLine_enabled = 0

"Pathogen 
call pathogen#infect()
"vim-go
syntax enable
filetype plugin on
set number
let g:go_disable_autoinstall = 0


"auto add tags
function! AutoLoadCTagsAndCScope()
    let max = 10
    let dir = './'
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'GTAGS')
            execute 'cs add ' . dir . 'GTAGS ' . glob("`pwd`")
            let break = 1
        endif
        if filereadable(dir . 'cscope.out')
            execute 'cs add ' . dir . 'cscope.out'
            let break = 1
        endif
        if filereadable(dir . 'tags')
            execute 'set tags =' . dir . 'tags'
            let break = 1
        endif
        if break == 1
            execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
endf
nmap <F7> :call AutoLoadCTagsAndCScope()<CR>
" call AutoLoadCTagsAndCScope()
" http://vifix.cn/blog/vim-auto-load-ctags-and-cscope.html
" 快速查找
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr> 
" set paste
nmap <leader>sp :set paste<CR> 
nmap <leader>sn :set nopaste<CR> 
  
" other .vimrc
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" tags show
Plugin 'majutsushi/tagbar'
" syntax check
Plugin 'scrooloose/syntastic'
" fuzzy file finder
Plugin 'kien/ctrlp.vim'
" status line
Plugin 'Lokaltog/vim-powerline'
" directory list
Plugin 'scrooloose/nerdtree'
" code comment
Plugin 'scrooloose/nerdcommenter'
" show/strip trailing whitespace
Plugin 'ntpeters/vim-better-whitespace'
" language syntax support
Plugin 'rust-lang/rust.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'mxw/vim-jsx.git'
Plugin 'wavded/vim-stylus'
" colorschemes
Plugin 'nanotech/jellybeans.vim'
Plugin 'noahfrederick/vim-hemisu'
" surroundings
Plugin 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" make vim recognise .md file as markdown instead of modular2
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.hbs set filetype=html
autocmd FileType javascript,html,css,stylus setlocal sw=2 sts=2 et
autocmd FileType c,sh,python,rust setlocal sw=4 sts=4 et
autocmd FileType makefile setlocal sw=4 sts=4

set encoding=utf-8
set laststatus=2
set hlsearch
set incsearch
set number
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set cindent

" colorscheme setting
let hour=strftime('%H')
if hour<12 && hour>5
    set background=light
else
    set background=dark
endif
set t_Co=256 " terminal 256/16

colo jellybeans
let g:jellybeans_use_lowcolor_black = 0
" colo hemisu

" cursorline highlight, must set after colorscheme
set cursorline
"hi CursorLine term=bold cterm=bold

" shortcut to rapidly tobble `set list` \s
map <leader>s :set list!<CR>
" set list
set listchars=tab:»·,trail:·,nbsp:%,eol:¬,extends:>,precedes:<

"""""""""""""""""""""""""
""" Plugin Specific Config
"""""""""""""""""""""""""
"" tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>


"" vim-better-whitespace config
hi ExtraWhitespace ctermbg=red
map <F3> :StripWhitespace<CR>
" auto strip trailing white space on file saving
" let g:strip_whitespace_on_save=1

"" tagbar
let g:tagbar_type_rust = {
 \ 'ctagstype' : 'rust',
 \ 'kinds' : [
     \'T:types,type definitions',
     \'f:functions,function definitions',
     \'g:enum,enumeration names',
     \'s:structure names',
     \'m:modules,module names',
     \'c:consts,static constants',
     \'t:traits,traits',
     \'i:impls,trait implementations',
 \ ]
 \ }

"" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
