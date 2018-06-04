isMac() {
	local retVal="$(uname -s)"
	local retCode
	if [[ "$retVal" =~ "Darwin" ]]; then retCode=0; else retCode=13; fi
	#
	if [ $# -gt 0 ]; then echo "$retVal"; fi
	return $retCode
}
