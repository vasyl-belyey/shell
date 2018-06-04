dirUse() {
	local retVal=0 dirU="$1"
	if [ -z "$dirU" ]; then dirU=$(pwd); fi
	#
	# kb1=$(du -k "$dirCLEANlib" | tail -1); kb1=${kb1/"/"*/""}; kb1=${kb1/ */""}
	if [ -d "$dirU" ]; then
		retVal=( $(du -k "$dirU" | tail -1) ); retVal=${retVal[0]}
	fi
	#
	echo "$retVal"
}
