printFile() {
	local usageLine="printFile aFileName [firstLine=1 [lastLine]]"
	# local aFile="./ASI_SDK.www/lib/README.txt"
	local aFile="$1"
	local n0="$2"
	if [ "$n0" = "" ]; then n0=1; fi
	local n1="$3"
	if [ "$n1" = "" ]; then n1=0; fi
	if [ -f "$aFile" ]; then
		if ! isInteger.bash "$n0"; then
			printUsage.bash "$usageLine" "Non-integer firstLine = '""$n0""'."
			return 13
		fi
		if ! isInteger.bash "$n1"; then
			printUsage.bash "$usageLine" "Non-integer lastLine = '""$n1""'."
			return 13
		fi
		if [ $n1 -ne 0 ]; then
			printColored.bash yellow "\tSee '""$aFile""': lines ""$n0"" to ""$n1""\n"
		else
			printColored.bash yellow "\tSee '""$aFile""': lines ""$n0"" to ""the EOF""\n"
		fi
		printColored.bash yellow "\t.............\n"
	else
		printUsage.bash "$usageLine" "File '""$aFile""' not found."
		return 13
	fi
	local n=0
	local aLine
	#
	while IFS='' read -r aLine || [[ -n $aLine ]]; do
		n=$((n + 1))
		if [ $n -ge $n0 ]; then
			printColored.bash magenta "$n""\t""$aLine""\n"
		fi
		if [ $n1 -gt 0 ]; then
			if [ $n -ge $n1 ]; then
				break
			fi
		fi
	done < "$aFile"
	printColored.bash yellow "\t.............\n\n\n"
	return 0
}
