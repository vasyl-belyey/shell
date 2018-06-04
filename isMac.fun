isMac() {
	local retVal="$(uname -s)"
	local retCode
	if [[ "$retVal" =~ "Darwin" ]]; then retCode=0; else retCode=13; fi
	#
	echo "$retVal"
	return $retCode
}
