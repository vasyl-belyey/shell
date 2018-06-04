#! /bin/bash
name2ip() {
	local retVal=""
	if ! [ -z "$1" ]; then
		eval retVal=\$"$1"
		shift
	fi
#	while ! [ -z "$1" ]; do
#		shift
#	done
	echo "$retVal"
}
# eof
