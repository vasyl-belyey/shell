#
isInteger() {
	if [ -z "$1" ]; then return 13; fi
	printf "%d" "$1" > /dev/null 2>&1
	return $?
}
#
# eof
