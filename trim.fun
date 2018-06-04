trim() {
	local retVal="$1"
	#
	while [ "${retVal:0:1}" = " " ]; do
       		retVal="${retVal:1}"
	done
	#
	echo "$retVal"
}
