haveTTY() {
	local fileTTY=$(tty)
	local testSymbol="$1"
	if [ -z "$testSymbol" ]; then testSymbol="-c"; fi
# echo "fileTTY='$fileTTY'"
	# if [ -f "$fileTTY" ]; then
	if [ $testSymbol "$fileTTY" ]; then
		return 0
	else
		return 13
	fi
}
