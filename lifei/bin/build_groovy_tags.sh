#!/bin/bash
find . -name "*.groovy" | xargs ctags-exuberant -f groovy.tags \
-h ".groovy" -R \
--exclude="\.git" \
--totals=yes \
--tag-relative=yes \
--langdef=groovy \
--langmap=groovy:.groovy \
--groovy-kinds=+vcf \
--regex-groovy='/(public |static |abstract |protected |private |void |def )([^(]*)/\3/f/' \
--regex-groovy='/(public |static |abstract |protected |private |def )([^=$;]*)/\1/v/'
