removeSlash() {
        local aStr="$*"
        local iLen=${#aStr}; iLen=$((iLen - 1))
        if [ $iLen -gt 0 ] && [ "${aStr:iLen:1}" = "/" ]; then
                aStr="${aStr:0:iLen}"
        fi
        echo "$aStr"
}
