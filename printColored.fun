printColored() {
	local N=$#; N=$((N / 2))
	local i
	for((i = 0; i < N; i++)); do
		if ! (printColored.bash "$1" "$2" 2>/dev/null); then
			printf "$2"
		fi
		shift 2
	done
}
