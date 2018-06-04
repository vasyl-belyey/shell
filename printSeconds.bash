#! /bin/bash
#
# Functions:
#
printSeconds() {
	local nS=$1
	local nDays=$(( nS / (3600*24) ))
	nS=$(( nS % (3600*24) ))
	local nH=$(( nS / 3600))
	nS=$(( nS % 3600 ))
	local nM=$(( nS / 60 ))
	nS=$(( nS % 60 ))
	#printf "\r%s%02d:%02d:%02d" "$header" $nH $nM $nS
	if [ $nDays -eq 0 ]; then
		printf "%02d:%02d:%02d" $nH $nM $nS
	else
		printf "%dd+%02d:%02d:%02d" $nDays $nH $nM $nS
	fi
	###
	if [ "$footer" != "" ]; then printf "\n"; fi
	#
	if [ "$2" != "" ]; then
		nS=$2
		let nH=$nS/3600
		let z=$nH*3600
		let nS=$nS-$z
		let nM=$nS/60
		let z=$nM*60
		let nS=$nS-$z
		printf " / %02d:%02d:%02d" $nH $nM $nS
	fi
	#printf "%13s" " "
}
#
Usage() {
	clear
	printf "\n\n\n"
	if [ "$1" != "" ]; then
		printf "\tERROR: %s\n" "$1"
	fi
	#printf "\t\t\tUsage:\n%s nSEC [header [footer==\\\n]]\n\n\n" "$(basename "$0")"
	printf "\t\t\tUsage:\n%s nSEC\n\n\n" "$(basename "$0")"
	exit 13
}
#
#
if [ $# -lt 1 ]; then
	Usage "Too few arguments."
fi
#
if [ $# -gt 1 ]; then
	Usage "Too many arguments."
fi
#
header=""; footer=""
if [ $# -gt 1 ]; then
	header="$2"
	if [ $# -gt 2 ]; then
		footer="$3"
	fi
fi
#
printSeconds $1
#
# eof
