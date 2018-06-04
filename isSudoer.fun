isSudoer() {
	local usageLine="isSudoer [username=$USER]""\n\tReturns 0 on success"
	if [ "$1" = "-" ]; then echo "$usageLine"; return 13; fi
	local retCode=13; local retVal; local aColor="green"
	if [ -z "$1" ]; then
		retVal="$(sudo -v 2>&1)"
	else
		retVal="$(sudo -v -u "$1" 2>&1)"
	fi
	retCode=$?
	#
	if [ $retCode -ne 0 ]; then aColor="red"; fi
	if [ ! -z "$retVal" ]; then
		printColored $aColor "\n\t""$retVal""\n"
	fi
	#
	return $retCode
}
