. "indexOf.fun"
parseOption() {
	local usageLine="parseOption optionPrefix argList (usually=\$*)""\n\t Returns 0 if the optionPrefix foung in argList."
	local caller="$0"
	local theOpt="$1"
	local iIndex=-1
	local cArg=""
	local retCode=13
	local retVal=""
	if [ "$1" = "-" ]; then
		printUsage.bash "$usageLine"
		if [ "$caller" = "bash" ]; then return $retCode; else exit $retCode; fi
	fi
	# checks:
	if [ $# -lt 1 ]; then
		printUsage.bash "$usageLine" "Too few arguments"
		if [ "$caller" = "bash" ]; then return $retCode; else exit $retCode; fi
	fi
	#
	retCode=1
	shift
	while [ ! -z "$1" ]; do
		cArg="$1"
		iIndex="$(indexOf "$1" "$theOpt")"
		if [ $iIndex -ge 0 ]; then
			if [ ${#cArg} -eq ${#theOpt} ]; then
				retVal="$2"
			else
				retVal="${cArg:${#theOpt}:$((${#cArg} - ${#theOpt}))}"
			fi
			retCode=0
			break
		fi
		#
		shift
	done
	#
	echo "$retVal"
	return $retCode
}
