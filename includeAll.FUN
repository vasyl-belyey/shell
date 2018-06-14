#! /bin/bash
#
# Main:
dirINC=""
dirINC=$(dirname `which includeAll.FUN`) || return 13
listfun=( $(ls ${dirINC}/*.fun) ) || return 17
for((iItem=0; iItem<${#listfun[*]}; iItem++)); do
        # echo "ADDING '${listfun[$iItem]}'"
        . "${listfun[$iItem]}" || return 19
done
#
# END
# eof
