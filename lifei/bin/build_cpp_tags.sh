#!/bin/bash
find . -name "*.h" -o -name "*.cpp" | xargs ctags-exuberant -f cpp.tags -R \
--exclude="\.git" \
--totals=yes \
--tag-relative=yes \
--fields=+iaS --extra=+q --c++-kinds=+p --sort=yes 
