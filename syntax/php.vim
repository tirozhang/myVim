syn match FoldMarker '<?\(\s\+\)*\/\/\(\s\+\)*\(<<<\|>>>\)\(\s\+\)*?>' 
syn match FoldMarker '<?php\(\s\+\)*\/\/\(\s\+\)*\(<<<\|>>>\)\(\s\+\)*?>'
syn match FoldMarker '\(\s\+\)*<<<\(\s\+\)*' containedin=phpComment contained
syn match FoldMarker '//\(\s\+\)*<<<\(\s\+\)*' containedin=phpComment contained
syn match FoldMarker '\/\/.\+>>>\(.\+\)*$' containedin=phpComment contained
highlight def link FoldMarker  Ignore
syn match phpDocTag '@\w\+' containedin=phpComment contained
highlight def link phpDocTag  String
syn keyword ToDo 'TODO:' containedin=phpComment contained
highlight def link ToDo ToDo
syn match NextTpl '`<.\+>`' containedin=ALL contained
highlight def link NextTpl ErrorMsg 
highlight def link phpBacktick ErrorMsg 
