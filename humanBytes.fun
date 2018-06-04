humanBytes() {
	local nB="$1" units="B"
	for((i = 0; i < 4; i++)); do
		if [ $((nB / 1024)) -le 0 ]; then break; fi
		if [ $((nB % 1024)) -ge 512 ]; then
			nB=$((nB / 1024 + 1))
		else
			nB=$((nB / 1024))
		fi
		case "$i" in
			0) units="kB";;
			1) units="MB";;
			2) units="GB";;
			3) units="TB";;
			*) units="?B";;
		esac
	done
	#
	echo "$nB [$units]"
}
