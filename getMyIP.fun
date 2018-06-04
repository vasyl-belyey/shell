getMyIP() {
	local i prefix aDevice retVal="" # $(ifconfig eth0)
	for((iType = 0; iType < 2 && ${#retVal} < 1; iType++)); do
echo "$iType"
		case "$iType" in
			0) prefix="eth";;
			*) prefix="wlan";;
		esac
echo "$prefix"
		for((i = 0; i < 10; i++)); do
			aDevice="$prefix""$i"
echo "$aDevice"
			if retVal=$(ifconfig "$aDevice" 2>/dev/null); then
				break
			fi
			# retVal=""
		done
	done
	echo $retVal
}
