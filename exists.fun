exists() {
        local flag="$1"
        local what="$2"
        local silent=0
	local sPrefix="File"
	if [ "$flag" = "-d" ]; then sPrefix="Directory"; fi
	if [ $# -gt 2 ]; then silent=1; fi
        if [ "$flag" "$what" ]; then
		if [ $silent -eq 0 ]; then
                	printColored.bash green "\t""$sPrefix"" '""$flag""' '""$what""' exists.\n"
		fi
                return 0
        else
		if [ $silent -eq 0 ]; then
                	printColored.bash red "\t""$sPrefix"" '""$flag""' '""$what""' does not exist.\n"
		fi
                return 113
        fi
}
