" 切换编码
nmap  <unique>  <silent> <F8>            :call ChangeEncoding()<CR>

" 打开模板
nmap  <unique>  <silent> <leader>`       :call ShowTemplate()<CR>
nmap  <unique>  <silent> \            :call ShowTemplate()<CR>
"
" buffer下的打开模板
silent! iunmap  <buffer> <F11>
inoremap <buffer> <F11> <esc>:call ShowTemplate()<cr>

" 重新生成模板
nmap  <unique>  <silent> <leader><F12>   :call C_RebuildTemplates()<CR>

" 查看自动补全
nmap  <unique>  <silent> <leader><F1>   :call ShowHelp()<CR>

" 
exec "nmap  <unique>  <silent>  <leader><F10>   :e ".s:C_GlobalTemplateFile."<CR>"
exec "nmap  <unique>  <silent>  <leader><F9>   :e ".s:C_GlobalTemplateDir."<CR>"

" 去除掉Tags标记，保留默认值
nnoremap  <unique>  <silent>   ~  :call DeleteTags()<CR><ESC>

" 移动到下一个Tags标记处，不保留
nnoremap  <silent>   <tab>   :call SwitchTags()<CR>

silent! iunmap  <buffer> <tab>
silent! iunmap  <expr> <tab>
inoremap <expr> <tab>  pumvisible()?"\<C-N>":"\<c-r>=CodeComplete()\<cr>"
inoremap <expr> `        pumvisible()?"\<C-P>":"`"
inoremap <expr> (        "\<C-R>=EchoFunc()\<CR>"

nmap <silent> <leader>gv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>gv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>zo zO

" 清除高亮
map <F2> :%s/\s*$//g<cr>:noh<cr>

map <silent> <leader>gg :Grep<cr>
map <silent> <leader>gr :Rgrep<cr>
map <silent> <leader>gf :Fgrep<cr>
map <silent> <leader>ga :Agrep<cr>

" 粘贴循环
map <leader>yr :YRShow<cr>

map <leader>1 :set syntax=c<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

map <space> :!
map <leader>bd :Bclose<cr>
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>
map <silent> <leader>cd :cd %:p:h<cr>
map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
map <backspace> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
noremap <Leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm
nnoremap ; :
nnoremap <leader>' '
nnoremap ' :b

vnoremap ' "+y
nnoremap ] :bn<cr>
nnoremap [ :bp<cr>
nnoremap m @1

nnoremap <F9> <C-W>h
nnoremap <F10> <C-W>j
nnoremap <F11> <C-W>k
nnoremap <F12> <C-W>l

" 代码树
nmap <silent> <leader>tl :Tlist<cr>

" 第一个窗口
nmap <silent> <leader>w1 :FirstExplorerWindow<cr>
nmap <silent> <leader>w2 :BottomExplorerWindow<cr>
" 第二个窗口
nmap <silent> <leader>wm :WMToggle<cr>
nmap <silent> <leader>fe :Sexplore!<cr>

nmap <silent> <leader>ww :w<cr>
nmap <silent> <leader>wa :wa<cr>
nmap <silent> <leader>wf :w!<cr>
nmap <silent> <leader>qw :wq<cr>
nmap <silent> <leader>qf :q!<cr>
nmap <silent> <leader>qq :q<cr>
nmap <silent> qq :Q<cr>
nmap <silent> Q :Q<cr>
nmap <silent> <leader>qa :qa<cr>
nmap <silent> <leader><cr> :noh<cr>
nmap <silent> <leader>rr :redraw!<cr>
nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>
nmap <silent> <leader>zo zO
nmap <silent> ? :LUWalk<cr>
nmap <leader>cc :cc<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr>
nmap <leader>cb :botright lw 10<cr>
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

