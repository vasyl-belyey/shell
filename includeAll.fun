includeAll() {
	local vbShell="$(vbShellDir.bash 2>/dev/null)" pFuns=() retCode=0 i
	# vbShell="$(vbShellDir.bash 2>/dev/null)" pFuns=() retCode=0 i
	if [ -d "$vbShell" ]; then
		pFuns=($(ls $vbShell/*.fun)) 2>/dev/null
		for((i = 0; i < ${#pFuns[*]}; i++)); do
			if ! [[ "${pFuns[$i]}" == *shutDownVB.fun ]]; then
echo "${pFuns[$i]}"
				. "${pFuns[$i]}"
			fi
		done
	else
		retCode=13
	fi
	#
	return $retCode
}
