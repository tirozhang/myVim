#!/bin/bash
find . -name "*.go" |grep -v 'cmd'|grep -v 'test'| xargs ctags-exuberant -f go.tags \
-h ".go" -R \
--exclude="\.git" \
--totals=yes \
--tag-relative=yes \
--GO-kinds=+cf \
--regex-GO='/abstract class ([^ ]*)/\1/c/' \
--regex-GO='/interface ([^ ]*)/\1/c/' \
--regex-GO='/func ([^ (]*)/\2/f/'
cat go.tags |grep '/^func' > tags
mv tags go.tags
