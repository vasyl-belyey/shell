# . "$(vbShellDir.bash)""/isInteger.fun"
maxOf() {
	local retVal arg1="$1"
	while [ ! -z "$arg1" ]; do
		if isInteger "$arg1"; then
			if [ -z "$retVal" ]; then
				retVal=$arg1
			else
				if [ $arg1 -lt $retVal ]; then retVal=$arg1; fi
			fi
		fi
		shift
		arg1="$1"
	done
	#
	echo "$retVal"
}
