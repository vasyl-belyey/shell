getWord() {
	local retVal="" n
	if [ $# -ge 2 ]; then
		n=$1
		shift
		retVal="$*"
		#
			while [ "${retVal:0:1}" = " " ]; do
				retVal="${retVal:1}"
			done
		#
		for((i = 0; i < n; i++)); do
			while [ "${retVal:0:1}" != " " ]; do
				retVal="${retVal:1}"
			done
			while [ "${retVal:0:1}" = " " ]; do
				retVal="${retVal:1}"
			done
		done
		local src="$retVal"
		retVal=""
			while [ "${src:0:1}" != " " ]; do
				retVal="$retVal""${src:0:1}"
				src="${src:1}"
			done
	fi
	#
	printf "$retVal""\n"
}
