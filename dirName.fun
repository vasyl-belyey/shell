# dirName.fun
dirName() {
	local zDir=$(pwd) aDir=$1 retCode=0
	local retVal=$zDir
	if [ -z "$aDir" ]; then
		aDir=$zDir
	else
		if [ "$aDir" != "$zDir" ]; then
			if [ -f "$aDir" ]; then aDir=$(dirname "$aDir"); fi
			cd "$aDir" 2>/dev/null
			retCode=$?
			if [ $retCode -eq 0 ]; then
				retVal=$(pwd)
				cd "$zDir"
			fi
		fi
	fi
	#
	echo "$retVal"
	return $retCode
}
# eof
