if v:version < 700
    echohl WarningMsg | echo 'The plugin lifei.vim needs Vim version >= 7 .'| echohl None
    finish
endif
"
" Prevent duplicate loading: 
" 
if exists("g:C_Version") || &cp
    finish
endif
let g:C_Version= "5.1"  							" version number of this script; do not change
"        
"###############################################################################################
"
"  Global variables (with default values) which can be overridden.
"          
" Platform specific items:  {{{1
" - root directory
" - characters that must be escaped for filenames
" 
let	s:MSWIN =		has("win16") || has("win32") || has("win64") || has("win95")

if	s:MSWIN
    let s:escfilename      = ''
else
    let s:escfilename 	= ' \%#[]'
endif
" {{{

let s:plmap = [ $HOME.'/.vim/', $VIM.'\vimfiles\', $HOME.'\vimfiles\']

let i = 0

let s:plugin_dir  = $HOME.'/.vim/'
while s:plmap[i] != ''
    if filereadable(s:plmap[i].'lifei/templates/Templates')
        let s:plugin_dir  = s:plmap[i]
        break
    endif
    let i = i + 1
endw

" }}}
"  Use of dictionaries  {{{1
"  Key word completion is enabled by the filetype plugin 'c.vim'
"  g:C_Dictionary_File  must be global
"          
if !exists("g:C_Dictionary_File")
    let g:C_Dictionary_File = s:plugin_dir.'lifei/wordlists/c-c++-keywords.list,'.
                \                   s:plugin_dir.'lifei/wordlists/k+r.list,'.
                \                   s:plugin_dir.'lifei/wordlists/stl_index.list'
endif
"
let s:FileExtension     			= &filetype              " C file extension; everything else is C++
let s:C_Printheader           = "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
"
let s:C_GlobalTemplateFile    = s:plugin_dir.'lifei/templates/Templates'
let s:C_GlobalTemplateDir     = fnamemodify( s:C_GlobalTemplateFile, ":p:h" ).'/'
let s:C_TemplateOverwrittenMsg= 'no'
"
let s:C_FormatDate						= '%Y-%m-%d'
let s:C_FormatTime						= '%H:%M:%S'
let s:C_FormatYear						= '%Y'
"
"------------------------------------------------------------------------------
"
"  Look for global variables (if any), to override the defaults.
"  
function! <SID>C_CheckGlobal ( name )
    if exists('g:'.a:name)
        exe 'let s:'.a:name.'  = g:'.a:name
    endif
endfunction    " ----------  end of function <SID>C_CheckGlobal ----------
"
call <SID>C_CheckGlobal('C_FormatDate             ')
call <SID>C_CheckGlobal('C_FormatTime             ')
call <SID>C_CheckGlobal('C_FormatYear             ')
call <SID>C_CheckGlobal('C_GlobalTemplateFile     ')
call <SID>C_CheckGlobal('C_ObjExtension           ')
call <SID>C_CheckGlobal('C_Printheader            ')
call <SID>C_CheckGlobal('C_TemplateOverwrittenMsg ')
call <SID>C_CheckGlobal('C_XtermDefaults          ')
"
"------------------------------------------------------------------------------
"  Control variables (not user configurable)
"------------------------------------------------------------------------------
let s:Attribute                = { 'below':'', 'above':'', 'start':'', 'append':'', 'insert':'' }
let s:C_Attribute              = {}
let s:C_ExpansionLimit         = 10
let s:C_FileVisited            = []
let s:C_Item                   = []
let s:C_Output = ''
"
let s:C_MacroNameRegex         = '\([^:|]\+\)'
let s:C_MacroLineRegex				 = '^\s*|'.s:C_MacroNameRegex.'|\s*=\s*\(.*\)'
let s:C_MacroCommentRegex      = '^\$'
let s:C_ExpansionRegex				 = '|?'.s:C_MacroNameRegex.'\(:[^|]*\)\?|'
let s:C_NonExpansionRegex			 = '|'.s:C_MacroNameRegex.'\(:[^|]*\)\?|'
"
let s:C_TemplateNameDelimiter  = '-+_,\. '
let s:C_TemplateLineRegex			 = '^==\s*\([a-zA-Z][0-9a-zA-Z'.s:C_TemplateNameDelimiter
let s:C_TemplateLineRegex			.= ']\+\)\s*==\s*\([a-z]\+\s*==\)\?'
"
"let s:C_TemplateNameDelimiter  = '-+_,\. '
"let s:C_TemplateLineRegex			 = '^==\s*\([a-zA-Z][0-9a-zA-Z'.s:C_TemplateNameDelimiter
"let s:C_TemplateLineRegex			.= ']\+\)\s*==\s*\([a-z]\+\s*==\)\?'
let s:C_TemplateLineRegex			 = '^==\s*\([^\s][^=]\+\)\s*==\s*\([a-z]\+\s*==\)\?'
"
let s:C_ExpansionCounter       = {}
let s:C_Template               = {}
let s:C_Macro                  = {'|AUTHOR|'         : 'first name surname', 
            \						'|AUTHORREF|'      : '',
            \						'|EMAIL|'          : '',
            \						'|COMPANY|'        : '',
            \						'|PROJECT|'        : '',
            \						'|COPYRIGHTHOLDER|': '' 
            \						}
let	s:C_MacroFlag								= {	':l' : 'lowercase'			, 
            \							':u' : 'uppercase'			, 
            \							':c' : 'capitalize'		, 
            \							':L' : 'legalize name'	, 
            \						}

"
"------------------------------------------------------------------------------
"  <SID>C_Input: Input after a highlighted prompt     {{{1
"------------------------------------------------------------------------------
function! <SID>C_Input ( promp, text )
    echohl Search																					" highlight prompt
    call inputsave()																			" preserve typeahead
    let	retval=input( a:promp, a:text )										" read input
    call inputrestore()																		" restore typeahead
    echohl None																						" reset highlighting
    let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
    let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
    return retval
endfunction    " ----------  end of function <SID>C_Input ----------
"
"-------------------------------------------------------------------------------
"   <SID>C_LegalizeName : replace non-word characters by underscores
"   - multiple whitespaces
"   - multiple non-word characters
"   - multiple underscores
"-------------------------------------------------------------------------------
function! <SID>C_LegalizeName ( name )
    let identifier = substitute(     a:name, '\s\+',  '_', 'g' )
    let identifier = substitute( identifier, '\W\+',  '_', 'g' ) 
    let identifier = substitute( identifier, '_\+', '_', 'g' )
    return identifier
endfunction    " ----------  end of function <SID>C_LegalizeName  ----------

"------------------------------------------------------------------------------
"  <SID>C_RebuildTemplates
"  rebuild commands and the menu from the (changed) template file
"------------------------------------------------------------------------------
function! <SID>C_RebuildTemplates ()
    let s:C_Template     = {}
    let s:C_FileVisited  = []
    call <SID>C_ReadTemplates(s:C_GlobalTemplateFile)
    echomsg "templates rebuilt from '".s:C_GlobalTemplateFile."'"
    let s:C_Output = ''
endfunction    " ----------  end of function <SID>C_RebuildTemplates  ----------

"------------------------------------------------------------------------------
"  <SID>C_ReadTemplates
"  read the template file(s), build the macro and the template dictionary
"
"------------------------------------------------------------------------------
function! <SID>C_ReadTemplates ( templatefile )

    if !filereadable( a:templatefile )
        echohl WarningMsg
        echomsg "C/C++ template file '".a:templatefile."' does not exist or is not readable"
        echohl None
        return
    endif

    let	skipmacros	= 0
    let s:C_FileVisited  += [a:templatefile]

    "------------------------------------------------------------------------------
    "  read template file, start with an empty template dictionary
    "------------------------------------------------------------------------------

    let item  = ''
    for line in readfile( a:templatefile )
        " if not a comment :
        if line !~ s:C_MacroCommentRegex
            "
            " macros and file includes
            "
            let string  = matchlist( line, s:C_MacroLineRegex )
            if !empty(string) && skipmacros == 0
                let key = '|'.string[1].'|'
                let val = string[2]
                let val = substitute( val, '\s\+$', '', '' )
                let val = substitute( val, "[\"\']$", '', '' )
                let val = substitute( val, "^[\"\']", '', '' )
                "
                if key == '|includefile|' && count( s:C_FileVisited, val ) == 0
                    let path   = fnamemodify( a:templatefile, ":p:h" )
                    call <SID>C_ReadTemplates( path.'/'.val )    " recursive call
                else
                    let s:C_Macro[key] = val
                endif
                continue                                            " next line
            endif
            "
            " single template header
            "
            let name  = matchstr( line, s:C_TemplateLineRegex )
            "
            if name != ''
                let part  = split( name, '\s*==\s*')
                let item  = part[0]
                if has_key( s:C_Template, item ) && s:C_TemplateOverwrittenMsg == 'yes'
                    echomsg "existing template '".item."' overwritten"
                endif
                let s:C_Template[item] = ''
                let skipmacros	= 1
                "
                let s:C_Attribute[item] = 'below'
                if has_key( s:Attribute, get( part, 1, 'NONE' ) )
                    let s:C_Attribute[item] = part[1]
                endif
            else
                if item != ''
                    let s:C_Template[item] = s:C_Template[item].line."\n"
                endif
            endif
        endif
        "
    endfor	" ---------  read line  ---------

    let keys = keys(s:C_Template)
    if len(s:C_Item) != len(keys)
        let s:C_Item = sort(keys)
    endif
endfunction    " ----------  end of function <SID>C_ReadTemplates  ----------

"------------------------------------------------------------------------------
"  <SID>C_InsertTemplate
"  insert a template from the template dictionary
"  do macro expansion
"------------------------------------------------------------------------------
function! <SID>C_InsertTemplate ( key, ... )

    if !has_key( s:C_Template, a:key )
        echomsg "Template '".a:key."' not found. Please check your template file in '".s:C_GlobalTemplateDir."'"
        return
    endif

    "------------------------------------------------------------------------------
    "  insert the user macros
    "------------------------------------------------------------------------------

    " use internal formatting to avoid conficts when using == below
    "
    let	equalprg_save	= &equalprg
    set equalprg= 

    let mode  = s:C_Attribute[a:key]

    " remove <SPLIT> and insert the complete macro
    "
    if a:0 == 0
        let val = <SID>C_ExpandUserMacros (a:key)
        if val	== ""
            return
        endif
        let val	= <SID>C_ExpandSingleMacro( val, '<SPLIT>', '' )

        if mode == 'below'
            let pos1  = line(".")+1
            put  =val
            let pos2  = line(".")
            " proper indenting 
            exe ":".pos1
            let ins	= pos2-pos1+1
            exe "normal ".ins."=="
        endif

        if mode == 'above'
            let pos1  = line(".")
            put! =val
            let pos2  = line(".")
            " proper indenting 
            exe ":".pos1
            let ins	= pos2-pos1+1
            exe "normal ".ins."=="
        endif

        if mode == 'start'
            normal gg
            let pos1  = 1
            put! =val
            let pos2  = line(".")
            " proper indenting 
            exe ":".pos1
            let ins	= pos2-pos1+1
            exe "normal ".ins."=="
        endif

        if mode == 'append'
            let pos1  = line(".")
            put =val
            let pos2  = line(".")-1
            exe ":".pos1
            :join!
            " reformat only multiline inserts
            if pos2-pos1 > 0
                exe ":".pos1
                let ins	= pos2-pos1+1
                exe "normal ".ins."=="
            end
        endif

        if mode == 'insert'
            let val   = substitute( val, '\n$', '', '' )
            if match(val, '<CURSOR>') < 0
                let val .= '<CURSOR>'
            endif
            let pos1  = line(".")
            let pos2  = pos1 + count( split(val,'\zs'), "\n" ) 
            " assign to the unnamed register "" :
            let @"=val
            " modified by 李飞(IT研发) at 2010-12-02 21:44:39:
            " 如果是一行的最后，则应该是p而不能再使用P
            if 1 == col('$') - col('.') && exists("b:lastchar") && b:lastchar
                normal p
            else
                normal P
            end
            " reformat only multiline inserts
            if pos2-pos1 > 0
                exe ":".pos1
                let ins	= pos2-pos1+1
                exe "normal ".ins."=="
            end
        endif
        "
    else
        "
        " =====  visual mode  ===============================
        "
        if  a:1 == 'v'
            let val = <SID>C_ExpandUserMacros (a:key)
            if val	== ""
                return
            endif

            let part	= split( val, '<SPLIT>' )
            if len(part) < 2
                let part	= [ "" ] + part
                echomsg 'SPLIT missing in template '.a:key
            endif

            "
            " 'visual' and mode 'insert': 
            "   <part0><marked area><part1>
            " part0 and part1 can consist of several lines
            "
            if mode == 'insert'
                let pos1  = line(".")
                let pos2  = pos1
                let	string= @*
                let replacement	= part[0].string.part[1]
                " remove trailing '\n'
                let replacement   = substitute( replacement, '\n$', '', '' )
                exe ':s/'.string.'/'.replacement.'/'
            endif

            "
            " 'visual' and mode 'below': 
            "   <part0>
            "   <marked area>
            "   <part1>
            " part0 and part1 can consist of several lines
            "
            if mode == 'below'

                :'<put! =part[0]
                :'>put  =part[1]

                let pos1  = line("'<") - len(split(part[0], '\n' ))
                let pos2  = line("'>") + len(split(part[1], '\n' ))
                ""			echo part[0] part[1] pos1 pos2
                "			" proper indenting 
                exe ":".pos1
                let ins	= pos2-pos1+1
                exe "normal ".ins."=="
            endif

            "
        endif
    endif

    " restore formatter programm
    let &equalprg	= equalprg_save

    "------------------------------------------------------------------------------
    "  position the cursor
    "------------------------------------------------------------------------------
    exe ":".pos1
    let mtch = search( '<CURSOR>', "c", pos2 )
    if mtch != 0
        if  matchend( getline(mtch) ,'<CURSOR>') == match( getline(mtch) ,"$" )
            normal 8x
            :startinsert!
        else
            normal 8x
            :startinsert
        endif
    else
        " to the end of the block; needed for repeated inserts
        call search( '`<.\+>`', 'W', pos2 )
    endif

endfunction    " ----------  end of function <SID>C_InsertTemplate  ----------

"------------------------------------------------------------------------------
"  <SID>C_ExpandUserMacros
"------------------------------------------------------------------------------
function! <SID>C_ExpandUserMacros ( key )

    let template 								= s:C_Template[ a:key ]
    let	s:C_ExpansionCounter		= {}										" reset the expansion counter

    "------------------------------------------------------------------------------
    "  renew the predefined macros and expand them
    "  can be replaced, with e.g. |?DATE|
    "------------------------------------------------------------------------------
    let	s:C_Macro['|BASENAME|']	= toupper(expand("%:t:r"))
    let s:C_Macro['|DATE|']  		= <SID>C_InsertDateAndTime('d')
    let s:C_Macro['|FILENAME|'] = expand("%:t")
    let s:C_Macro['|PATH|']  		= expand("%:p:h")
    let s:C_Macro['|SUFFIX|'] 	= expand("%:e")
    let s:C_Macro['|TIME|']  		= <SID>C_InsertDateAndTime('t')
    let s:C_Macro['|YEAR|']  		= <SID>C_InsertDateAndTime('y')

    "------------------------------------------------------------------------------
    "  look for replacements
    "------------------------------------------------------------------------------
    while match( template, s:C_ExpansionRegex ) != -1
        let macro				= matchstr( template, s:C_ExpansionRegex )
        let replacement	= substitute( macro, '?', '', '' )
        let template		= substitute( template, macro, replacement, "g" )

        let match	= matchlist( macro, s:C_ExpansionRegex )

        if match[1] != ''
            let macroname	= '|'.match[1].'|'
            "
            " notify flag action, if any
            let flagaction	= ''
            if has_key( s:C_MacroFlag, match[2] )
                let flagaction	= ' (-> '.s:C_MacroFlag[ match[2] ].')'
            endif
            "
            " ask for a replacement
            if has_key( s:C_Macro, macroname )
                let	name	= <SID>C_Input( match[1].flagaction.' : ', <SID>C_ApplyFlag( s:C_Macro[macroname], match[2] ) )
            else
                let	name	= <SID>C_Input( match[1].flagaction.' : ', match[2][1:] )
            endif
            if name == ""
                return ""
            endif
            "
            " keep the modified name
            let s:C_Macro[macroname]  			= <SID>C_ApplyFlag( name, match[2] )
        endif
    endwhile

    "------------------------------------------------------------------------------
    "  do the actual macro expansion
    "  loop over the macros found in the template
    "------------------------------------------------------------------------------
    let index = 0
    while match( template, s:C_NonExpansionRegex, index ) != -1

        let index = match( template, s:C_NonExpansionRegex, index ) + 1
        let macro			= matchstr( template, s:C_NonExpansionRegex )
        let match			= matchlist( macro, s:C_NonExpansionRegex )

        if match[1] != ''
            let evalStr = macro
            let macroname	= '|'.match[1].'|'
    
            if evalStr =~ '<-'
                let evalStr = substitute(evalStr, '^|<-', '', '')
                let evalStr = substitute(evalStr, '|$', '', '')
                try
                    ":exec "call setwinvar('%','Template_Result',".evalStr.")"
                    "call confirm("call setwinvar('%','Template_Result',".evalStr.")")
                    "let g:Template_Result = getwinvar('%', 'Template_Result')
                    let s:Template_Result = eval(evalStr)
                    let template 		= substitute( template, macro, s:Template_Result, "g" )
                catch
                endtry
                continue
            endif

            if has_key( s:C_Macro, macroname ) 
                "-------------------------------------------------------------------------------
                "   check for recursion
                "-------------------------------------------------------------------------------
                if has_key( s:C_ExpansionCounter, macroname )
                    let	s:C_ExpansionCounter[macroname]	+= 1
                else
                    let	s:C_ExpansionCounter[macroname]	= 0
                endif
                if s:C_ExpansionCounter[macroname]	>= s:C_ExpansionLimit
                    echomsg " recursion terminated for recursive macro ".macroname
                    return template
                endif
                "-------------------------------------------------------------------------------
                "   replace
                "-------------------------------------------------------------------------------
                let replacement = <SID>C_ApplyFlag( s:C_Macro[macroname], match[2] )
                let template 		= substitute( template, macro, replacement, "g" )
            else
            endif
        endif

    endwhile

    return template
endfunction    " ----------  end of function <SID>C_ExpandUserMacros  ----------

"------------------------------------------------------------------------------
"  <SID>C_ApplyFlag
"------------------------------------------------------------------------------
function! <SID>C_ApplyFlag ( val, flag )
    "
    " l : lowercase
    if a:flag == ':l'
        return  tolower(a:val)
    end
    "
    " u : uppercase
    if a:flag == ':u'
        return  toupper(a:val)
    end
    "
    " c : capitalize
    if a:flag == ':c'
        return  toupper(a:val[0]).a:val[1:]
    end
    "
    " L : legalized name
    if a:flag == ':L'
        return  <SID>C_LegalizeName(a:val)
    end
    "
    " flag not valid
    return a:val			
endfunction    " ----------  end of function <SID>C_ApplyFlag  ----------
"
"------------------------------------------------------------------------------
"  <SID>C_ExpandSingleMacro
"------------------------------------------------------------------------------
function! <SID>C_ExpandSingleMacro ( val, macroname, replacement )
    return substitute( a:val, escape(a:macroname, '$' ), a:replacement, "g" )
endfunction    " ----------  end of function <SID>C_ExpandSingleMacro  ----------


"------------------------------------------------------------------------------
"  <SID>C_InsertMacroValue
"------------------------------------------------------------------------------
function! <SID>C_InsertMacroValue ( key )
    if col(".") > 1
        exe 'normal a'.s:C_Macro['|'.a:key.'|']
    else
        exe 'normal i'.s:C_Macro['|'.a:key.'|']
    end
endfunction    " ----------  end of function <SID>C_InsertMacroValue  ----------

"------------------------------------------------------------------------------
"  date and time
"------------------------------------------------------------------------------
function! <SID>C_InsertDateAndTime ( format )
    if a:format == 'd'
        return strftime( s:C_FormatDate )
    end
    if a:format == 't'
        return strftime( s:C_FormatTime )
    end
    if a:format == 'dt'
        return strftime( s:C_FormatDate ).' '.strftime( s:C_FormatTime )
    end
    if a:format == 'y'
        return strftime( s:C_FormatYear )
    end
endfunction    " ----------  end of function <SID>C_InsertDateAndTime  ----------

"------------------------------------------------------------------------------
"  READ THE TEMPLATE FILES
"------------------------------------------------------------------------------
call <SID>C_ReadTemplates(s:C_GlobalTemplateFile)

"
"=====================================================================================
" vim: tabstop=2 shiftwidth=2 foldmethod=marker 

let s:templateBufferID = -1
let s:mainBufferID = 0
let s:mainWindowID = ""
" 用来储存上次的
let s:lastLine = 0
let s:encoding=&encoding

function! <SID>TemplateClick()
    let key = getline(".")
    let list = strpart(key, 0, match(key, '\.'))

    if list != ''
        let key = s:C_Item[list]
        " Switch back to the original buffer
        if has_key(s:C_Template, key)
            let s:lastLine = line('.')
            exec 'bdelete '.bufnr("-TemplateExplorer-")
            exec s:mainWindowID . "wincmd w"
            call <SID>C_InsertTemplate(key)
            return ''
        endif
    endi

    if foldlevel('.') > 0
        norm za
        return ''
    endi

    return ''
endfunction

function! s:MoveToFileType()
    if s:lastLine == 0
        call  search("^".s:FileExtension."{")
        nohl
    else
        silent! exec "exec ".s:lastLine
    endif
    normal zo
endfunction

function! s:TemplateOpen(results)

    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim
    setlocal cpoptions-=a,A
    let win_size = 50

    if bufwinnr(s:templateBufferID) == -1
        let location = 'botright vertical'
        silent exec location. ' ' . win_size . 'split '
        exec ":e " . escape("-TemplateExplorer-", ' ')
        let s:templateBufferID = bufnr('%')
    else
        exec bufwinnr("-TemplateExplorer-") . "wincmd w"
    endif

    " Mark the buffer as scratch
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nowrap
    setlocal nonumber
    setlocal nobuflisted
    setlocal modifiable

    setlocal foldmethod=marker
    setlocal foldcolumn=0
    setlocal foldenable
    setlocal foldmarker={,}
    setlocal foldtext=MyFoldText()

    mapclear <buffer>
    nnoremap <buffer> <silent> <CR>          :call <SID>TemplateClick()<CR>
    vnoremap <buffer> <silent> <CR>          :call <SID>TemplateClick()<CR>
    nnoremap <buffer> <silent> <tab>            :call <SID>MoveToFileType()<CR>
    vnoremap <buffer> <silent> <tab>            :call <SID>MoveToFileType()<CR>
    nnoremap <buffer> <silent> <ESC>         :q<CR>
    nnoremap <buffer> <silent> q             :q<CR>
    nnoremap <buffer> <silent> <SPACE>       za

    " Highlight
    :syn on
    syntax match templateFileType "^[^\.]\+{" contains=templateFoldMarker
    syntax match templateFoldMarker '{'       contained 
    syntax match templateFoldMarker '}'
    syntax match templateId         "^\d\+."
    syntax match templateSubType    "\[[^\.^\[^\]]\+\]" nextgroup=templateKey
    syntax match templateKey        ".\+$" contained contains=templateMode
    syntax match templateMode       "([^(^)]\+)$" contained
    highlight def link templateFoldMarker      Ignore
    highlight def link templateFileType        Title 
    highlight def link templateId              Ignore
    highlight def link templateSubType         NonText
    highlight def link templateKey             Statement
    highlight def link templateMode            Question

    au BufLeave -TemplateExplorer- :call s:HideTemplate('-TemplateExplorer-')

    %delete _


    " Display the contents of the yankring
    silent! put =a:results

    " Move the cursor to the first line with an element
    exec 0 
    normal dd
    call search('^\d','W') 

    setlocal nomodifiable
    "
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions

endfunction

function! ShowHelp()

    if bufwinnr("__Help__") > -1
        exec bufwinnr("__Help__") . "wincmd w"
        hide
        return
    endif

    let output = "===========Auto complete keywords===============\n"
    let keys = keys(s:C_Template)
    let temp = ''

    for temp in sort(keys)
        if match(temp, 'AutoComplete') != -1
            let temp = substitute(temp, '\.AutoComplete\.', '\t', 'g')
            let output = output . temp . "\n"
        endif
    endfor

    set cpoptions&vim
    setlocal cpoptions-=a,A
    let win_size = 50

    let location = 'botright vertical'
    silent exec location. ' ' . win_size . 'split '
    exec ":e " . escape("__Help__", ' ')

    " Mark the buffer as scratch
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nowrap
    setlocal nonumber
    setlocal nobuflisted
    setlocal modifiable

    norm gg
    norm V
        setlocal foldenable foldmethod=marker foldmarker={,} commentstring=%s foldcolumn=0 nonumber noswapfile shiftwidth=1
        setlocal foldtext=ProjFoldText() nobuflisted nowrap
    norm G
    norm d
    silent! put = output
    norm gg

    setlocal nomodifiable
endfunction


func! s:HideTemplate(title)
    let winId = bufwinnr(a:title)
    if winId > -1
        exec winId . "wincmd w"
        hide
        let s:mainWindowID = bufwinnr(s:mainBufferID)
        exec s:mainWindowID . "wincmd w"
        exec "set encoding=".s:encoding
    endif
endf

function! <SID>ShowTemplate() 

    if bufwinnr("-TemplateExplorer-") > -1
        call s:HideTemplate('-TemplateExplorer-')
        return
    endif

    let s:mainBufferID      = bufnr('%')
    let s:mainWindowID      = winnr()
    let s:FileExtension    	= &filetype              " C file extension; everything else is C++

    let s:encoding = &encoding
    set encoding=utf-8
    " List is shown in order of replacement
    " assuming using previous yanks

    let iter = 1
    let keys = keys(s:C_Template)
    let temp = ''

    if len(s:C_Item) != len(keys) || s:C_Output == ''

        let s:C_Item = sort(keys)
        let filetype = ''
        let s:C_Output = ''

        let i = -1
        for key in s:C_Item
            let i += 1

            let list = split(key, '\.')

            if len(list) > 0 
                if filetype != list[0]
                    if filetype != ''
                        let s:C_Output .= "}\n"
                    endi
                    let filetype = list[0]
                    let s:C_Output .= "-[".filetype ."]{\n"
                endi
                if match(key, 'AutoComplete') > -1
                    let list[1] = '自动完成'
                endif

                if len(list) > 3
                    let s:C_Output .= i .'.['. list[1] .']'. list[2] . ' - ' . list[3] .' ('.s:C_Attribute[key]. ")\n"
                elseif len(list) == 3
                    let s:C_Output .= i .'.['. list[1] .']'. list[2] . ' ('.s:C_Attribute[key]. ")\n"
                elseif len(list) == 2
                    let s:C_Output .= i .'.[Global]'. list[1] . ' ('.s:C_Attribute[key]. ")\n"
                endi
            endi
        endfor
    endi

    call s:TemplateOpen(s:C_Output)
    call <SID>MoveToFileType()

endfunction

function! DeleteTags()
    if match(getline('.'), '`<.*>`')!=-1 || search('`<.\{-}>`')!=0
        let s = @"
        normal 0
        call search('`<','c',line('.'))
        normal v
        call search('`<','e',line('.'))
        if &selection == "exclusive"
            exec "norm " . "\<right>"
        endif
        normal d
        normal 0
        call search('>`','c',line('.'))
        normal v
        call search('>`','e',line('.'))
        if &selection == "exclusive"
            exec "norm " . "\<right>"
        endif
        normal d
        let @" = s
    endif
endfunction

function! SwitchTags()
    if match(getline('.'), '`<.*>`')!=-1 || search('`<.\{-}>`')!=0
        let s = @"
        normal 0
        call search('`<','c',line('.'))
        normal v
        call search('>`','e',line('.'))
        if &selection == "exclusive"
            exec "norm " . "\<right>"
        endif
        if col('.') == col('$') - 1
            let n = 0
        else
            let n = 1
        endif
        normal d
        let msg = '[Prompt] '.@"
        let msg = substitute(msg, "`<", "", 'g')
        let msg = substitute(msg, ">`", "", 'g')
        echomsg msg
        if n == 0
            :startinsert!
        else
            :startinsert
        endif
        let @" = s
    endif
endfunction
" function! FunctionComplete(fun) {{{ 
function! FunctionComplete(fun)
    let s:signature_list=[]
    let signature_word=[]
    let ftags=taglist('^'.escape(a:fun,'[\*~^').'$')
    if type(ftags)==type(0) || ((type(ftags)==type([])) && ftags==[])
        return ''
    endif
    let tmp=''
    for i in ftags
        "" 清理函数string {{{
        "if match(i.cmd,'^/\^.*\(\*'.a:fun.'\)\(.*\)\;\$/')>=0
            "if match(i.cmd,'(\s*void\s*)')<0 && match(i.cmd,'(\s*)')<0
                    "let tmp=substitute(i.cmd,'^/\^','','')
                    "let tmp=substitute(tmp,'.*\(\*'.a:fun.'\)','','')
                    "let tmp=substitute(tmp,'^[\){1}]','','')
                    "let tmp=substitute(tmp,';\$\/;{1}','','')
                    "let tmp=substitute(tmp,'\$\/','','')
                    "let tmp=substitute(tmp,';','','')
                    "let tmp=substitute(tmp,',',g:re.','.g:rs,'g')
                    "let tmp=substitute(tmp,'(\(.*\))',g:rs.'\1'.g:re.')','g')
            "else
                    "let tmp=''
            "endif
        "endif
        "if tmp==''&&has_key(i,'kind') && has_key(i,'name') && has_key(i,'signature')
            "if (i.kind=='p' || i.kind=='f') && i.name==a:fun  " p is declare, f is definition
                "if match(i.signature,'(\s*void\s*)')<0 && match(i.signature,'(\s*)')<0
                    "let tmp=substitute(i.signature,',',g:re.','.g:rs,'g')
                    "let tmp=substitute(tmp,'(\(.*\))',g:rs.'\1'.g:re.')','g')
                "else
                    "let tmp=''
                "endif
            "endif
        "endif
        "" }}}

        if i.kind=='p'||i.kind=='f'

            let tmp = matchstr(i.cmd, '([^)]\+)')
            let tmp = substitute(tmp,'^(\|)$', '','g')
            let params = split(tmp, ',')

            if len(params) > 0
                let s:index = 0
                while s:index < len(params)
                    let params[s:index] = '`<' . params[s:index] . '>`'
                    let s:index = s:index + 1
                endwhile

                let tmp  = join(params, ',')
                let tmp .= ')'
                if (tmp != '') && (index(signature_word,tmp) == -1)
                    let signature_word+=[tmp]
                    let item={}
                    let item['word']=tmp
                    if strlen(tmp) > 50
                        let item['abbr']=strpart(tmp,0,50)
                    endif
                    let item['info']=i.name."(".tmp."\n".i.filename
                    let filename = i.filename
                    let filename = substitute(filename, "^.*/", "", "")
                    let filename = substitute(filename, "^.*\\", "", "")
                    let item['menu']=filename
                    let item['kind']='####'.i.kind
                    let s:signature_list+=[item]
                endif
            endif
        endif
    endfor
    if s:signature_list==[]
        return ')'
    endif
    if len(s:signature_list)==1
        return s:signature_list[0]['word']
    else
        call  complete(col('.'),s:signature_list)
        return ''
    endif
endfunction
" }}}
function s:AutoComplete(cword, key)
    " modified by 李飞(IT研发) at 2010-12-03 23:04:13:
    " 用来判断光标在最末尾和次末尾的
    if col('$') - col('.') == 0
        let b:lastchar = 1
    endif
    let copy = @"
    call search(a:cword,'b',line('.'))
    normal v
    call search(a:cword,'e',line('.'))
    normal d
   "if n == 0 && 1 == col('$') - col('.')
   "   let @" = " "
   "   norm p
   "endif
    call <SID>C_InsertTemplate(a:key)
    " modified by 李飞(IT研发) at 2010-12-03 23:07:58:
    " 用完后置回原状态
    if exists("b:lastchar")
        unlet b:lastchar
    endif
    let @"=copy
endfunction

function! ExpandTemplate(cword)

    if a:cword == '' || a:cword =~ '\s\+'
        return "\<tab>"
    endif

    let findKey = 1

    for dt in [0]
        if &ft != ''
            let key = &ft.'.AutoComplete.'.a:cword
            if has_key(s:C_Template, key)
                break
            endif
        endif
        let suffix = expand("%:e")
        if suffix != ''
            let key = suffix.'.AutoComplete.'.a:cword
            if has_key(s:C_Template, key)
                break
            endif
        endif
        let key = 'all.AutoComplete.'.a:cword
        if has_key(s:C_Template, key)
            break
        endif

        let filter = ''
        if &ft == ''
            let filter = "v:key=~'^all\.AutoComplete\.".a:cword ."[.]'"
        else
            let filter = "v:key=~'^all\.AutoComplete\.".a:cword ."[.]' || v:key=~'^".&ft."\.AutoComplete\.".a:cword ."[.]'"
        endif
        let t = filter(copy(s:C_Template), filter)
        if len(t) > 0
            if len(t) > 1
                let t1 = filter(copy(t), "v:key=~'^".&ft."\.AutoComplete\.".a:cword ."'")
                if len(t1) > 0
                    let key = keys(t1)[0]
                else
                    let key = keys(t)[0]
                endif
            else
                let key = keys(t)[0]
            endif
            break
        endif

        let findKey = 0
    endfor

    if findKey 
        call s:AutoComplete(a:cword, key)
        return ''
    endif

    return "\<C-N>\<C-R>=MoveUp()\<CR>"
endfunction

function! MoveUp()
    return pumvisible()?"\<C-P>":""
endfunction

function! CodeComplete()
   "if getline('.')[(col('.')-2):(col('.')-2)] == '(' && &ft == 'java' && exists(':Vjdei')
   "    norm "\<esc>"
   "    norm b
   "    :Vjdei
   "    norm f(
   "    return "\<DEL>("
   "endif

    " 函数提示
    let function_name = matchstr(getline('.')[:(col('.')-2)],'\zs\w*\ze\s*(\s*$')
    if function_name != ''
        let funcres = FunctionComplete(function_name)
        call EchoFunc()
        return funcres
    endif
    let template_name = substitute(getline('.')[:(col('.')-2)],'\zs.*\W\ze\w*$','','g')
    return ExpandTemplate(template_name)
endfunction
" {{{ ChangeEncoding
function! ChangeEncoding()
    if &encoding=='utf-8'
        :set encoding=cp936
    else
        :set encoding=utf-8
    endif
endfunction
" }}}

" {{{ Mapping
function! Mapping()
    nnoremap  0 ^
    nnoremap  - $
    vnoremap  - $h
    vnoremap  0 ^
    nnoremap  { <c-o>
    nnoremap  } <c-i>
    if &omnifunc == "" 
        setlocal omnifunc=syntaxcomplete#Complete 
    endif

    if filereadable(".vjde")
        :source .vjde
    endif

    call SetTags()

    syntax match xTag '`<.\+>`'
    highlight def link xTag Error

endfunction

function SetTags()
    let i = 0
    let s:tags = []
    let s:tagfile = &ft.'.tags'
    let s:curdir = "%:p:h"
    while i < 5
        let s:ff = expand(s:curdir)."/".s:tagfile
        let s:ff = substitute(s:ff, '//', '/', 'g')
        if filereadable(s:ff)
            let s:tags += [s:ff]
        endif
        let i = i + 1
        let s:curdir = s:curdir.":h"
    endwhile
    if len(s:tags) > 0
        exec 'setlocal tags+='.join(s:tags, ',')
    endif
    let s:tagspath = s:plugin_dir.'lifei/tags/'.&ft.'.tags'
    if filereadable(s:tagspath)
        exec 'setlocal tags+='.s:tagspath
    endif
endfunc
" }}}

" ==========================================
"               菜单
" ==========================================
" {{{ 帮助菜单
let s:C_MenuTipsFile          = s:plugin_dir.'lifei/menulist'
" {{{ function! <SID>C_ReadMenuTips ( templatefile )
function! <SID>C_ReadMenuTips ( templatefile )

    if !filereadable( a:templatefile )
        echohl WarningMsg
        echomsg "Menu tips file '".a:templatefile."' does not exist or is not readable"
        echohl None
        return
    endif

    let	skipmacros	= 0
    let s:C_FileVisited  += [a:templatefile]

    "------------------------------------------------------------------------------
    "  read template file, start with an empty template dictionary
    "------------------------------------------------------------------------------

    let s:C_MenuItem  = []
    for line in readfile( a:templatefile )
        " if not a comment :
        if line !~ s:C_MacroCommentRegex
            "
            " macros and file includes
            "
            let string  = matchlist( line, s:C_MacroLineRegex )
            if !empty(string) && skipmacros == 0
                let key = '|'.string[1].'|'
                let val = string[2]
                let val = substitute( val, '\s\+$', '', '' )
                let val = substitute( val, "[\"\']$", '', '' )
                let val = substitute( val, "^[\"\']", '', '' )
                "
                if key == '|includefile|' && count( s:C_FileVisited, val ) == 0
                    let path   = fnamemodify( a:templatefile, ":p:h" )
                    call <SID>C_ReadMenuTips( path.'/'.val )    " recursive call
                endif
                continue                                            " next line
            endif

            let key = split(line, '|')
            if(len(key) == 3)
                let type       = substitute(key[0], '\s\+$', '', 'g')
                let command    = substitute(key[1], '\s\+$', '', 'g')
                let info       = substitute(key[2], '\s\+$', '', 'g')

                let item = {'type':type, 'info':info, 'comm':command, 'id':len(s:C_MenuItem)}
                let s:C_MenuItem += [item]
            endi
        endi
        "
    endfor	" ---------  read line  ---------
endfunction    
" }}}
" {{{ func! <SID>C_ShowMenuTips()
func! <SID>C_ShowMenuTips()
    if bufwinnr("--MenuTips--") > -1
        exec bufwinnr("--MenuTips--") . "wincmd w"
        hide
        return
    endif

    let output = ''
    let filetype = ''

    for temp in s:C_MenuItem
        if filetype != temp['type']
            if filetype != ''
                let output .= "}\n"
            endi
            let filetype = temp['type']
            let output .= '-['.filetype ."]{\n"
        endi
        let output .= temp['id'].'.['.temp['type'].']'.temp['info'].'('.temp['comm'].')'."\n" 
    endfor

    let s:bufId = bufnr('%')
    
    set cpoptions&vim
    setlocal cpoptions-=a,A
    let win_size = 100

    let location = 'botright vertical'
    silent exec location. ' ' . win_size . 'split '
    exec ":e " . escape("--MenuTips--", ' ')

    let s:mainWindowID = bufwinnr(s:bufId)

    " Mark the buffer as scratch
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nowrap
    setlocal nonumber
    setlocal nobuflisted
    setlocal modifiable

    setlocal foldmethod=marker
    setlocal foldenable
    setlocal foldmarker={,}
    setlocal foldtext=MyFoldText()

    mapclear <buffer>
    nnoremap <buffer> <silent> <CR>          za
    vnoremap <buffer> <silent> <CR>          za
    nnoremap <buffer> <silent> <ESC>         :q<CR>
    nnoremap <buffer> <silent> q             :q<CR>
    nnoremap <buffer> <silent> <SPACE>       za

    " Highlight
    :syn on
    syntax match templateFileType "^[^\.]\+{" contains=templateFoldMarker
    syntax match templateFoldMarker '{'       contained 
    syntax match templateFoldMarker '}'
    syntax match templateId         "^\d\+."
    syntax match templateSubType    "\[[^\.^\[^\]]\+\]" nextgroup=templateKey
    syntax match templateKey        ".\+$" contained contains=templateMode
    syntax match templateMode       "([^(^)]\+)$" contained
    highlight def link templateFoldMarker      Ignore
    highlight def link templateFileType        Title 
    highlight def link templateId              Ignore
    highlight def link templateSubType         NonText
    highlight def link templateKey             Statement
    highlight def link templateMode            Question

    au BufLeave --MenuTips-- :call s:HideTemplate('--MenuTips--')

    %delete _
    silent! put = output
    norm ggddzo

    setlocal nomodifiable
endf
" }}}

call <SID>C_ReadMenuTips(s:C_MenuTipsFile)
nmap <F1> :call <SID>C_ShowMenuTips()<cr>
" }}}

" {{{ function! MyFoldText() 供Template和菜单窗口使用
function! MyFoldText()
    let line=substitute(getline(v:foldstart),'^-*\([ \t#]*[^=]*\).*', '\1', '')
    let line=substitute(line, "{", "", "")
    return "+ ".line.'                                                                    '
endfunction 
" }}}

" {{{ 按键映射
" 切换编码
nmap  <unique>  <silent> <F8>            :call ChangeEncoding()<CR>

" 打开模板
nmap  <unique>  <silent> <leader>`       :call <SID>ShowTemplate()<CR>
nmap  <unique>  <silent> \\            :call <SID>ShowTemplate()<CR>
vmap  <unique>  <silent> \\            s<esc>:call <SID>ShowTemplate()<CR>
"
" 重新生成模板
nmap  <silent> <F12>   :call <SID>C_RebuildTemplates()<CR>

" 查看自动补全
nmap  <silent> <F11>   :call ShowHelp()<CR>

" 
exec "nmap <unique> <silent>  <F10>   :vs ".s:C_GlobalTemplateFile."<CR>"
"exec "nmap <unique> <silent>  <F9>   :e ".s:C_GlobalTemplateDir."<CR>"

" 去除掉Tags标记，保留默认值
nnoremap  <unique>  <silent>   ~  :call DeleteTags()<CR><ESC>

" 移动到下一个Tags标记处，不保留
nnoremap  <silent>   <tab>   :call SwitchTags()<CR>

silent! iunmap  <expr> <tab>
inoremap <expr> <tab>  pumvisible()?"\<c-n>":"\<c-r>=CodeComplete()\<cr>"
inoremap <expr> `        pumvisible()?"\<C-P>":"`"
inoremap <expr> j        pumvisible()?"\<PageDown>":"j"
inoremap <expr> k        pumvisible()?"\<PageUp>":"k"
inoremap <expr> (        "\<C-R>=EchoFunc()\<CR>"
" }}}

autocmd BufEnter * :inoremap <expr> <tab>  pumvisible()?"\<C-N>":"\<c-r>=CodeComplete()\<cr>"
autocmd BufReadPost,BufNewFile * :call Mapping()


" {{{ function! <SID>PressBackspace()
"""""""""""""""""""""""""""""""""""""""""""
"         \回退键打开Tags生成             "
"""""""""""""""""""""""""""""""""""""""""""
function! <SID>PressBackspace()
    if confirm('Do you want to build the tags index?', "&No\n&OK", 1) == 2
        ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
        let type = &syn
        if &syn == 'groovy'
            let type='c++'
        endif
        exec "!find . -name '*.".&ft."'|xargs -x ctags -f ".&ft.".tags --format=2 --excmd=pattern --fields=+iaS --extra=+q --c++-kinds=+p --sort=yes  --language-force=".type
    endif
endf
map \<del> :call <SID>PressBackspace()<cr>
" }}}
" vim600: ts=4 st=4 foldmethod=marker foldmarker={{{,}}} syn=vim 
" vim600: encoding=utf-8 commentstring="\ %s
