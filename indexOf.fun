indexOf() {
	local usageLine="indexOf srcString subStringToFind"
	local src="$1"
	local srcLen=${#src}
	local sub="$2"
	local subLen=${#sub}
	local retVal=-1
	#
	local n=$((srcLen - subLen + 1))
	if [ $n -gt 0 ]; then
		for((i = 0; i < n; i++)); do
		if [ "$sub" = "${src:$i:$subLen}" ]; then retVal=$i; break; fi
		done
	fi
	#
	echo "$retVal"
}
