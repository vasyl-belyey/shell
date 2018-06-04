#! /bin/bash
#
# Functions:
usageLine="$(basename "$0")"" promptText item1 item2 [item3 ...]"
#
#
if [ $# -ge 1 ]; then
	arg1="$1"
	if [ "${arg1:0:1}" = "-" ]; then
		printUsage.bash "$usageLine"
		exit 0
	fi
fi
#
if [ $# -lt 3 ]; then
	printUsage.bash "$usageLine" "Too few arguments"
	exit 13
fi
#
nItems=$#
nItems=$((nItems - 1))
#
printf "\n\n\n\t%s\n" "$1"
for ((iItem=1; iItem<=nItems; iItem++))
do
	shift
	printf "%d)  %s\n" $iItem "$1"
done
#
retVal=0
lineUp=""; printf "\n"
while [ $retVal -lt 1 ] || [ $retVal -gt $nItems ]
do
	printf "\e[1A\rSelect item # (1 - %d): " $nItems
	read retVal
	if [ "$retVal" = "" ]; then
		retVal=0
		lineUp="\e[1A"
	else
		if ! isInteger.bash $retVal; then
			retVal=0
			lineUp="\e[1A"
		fi
	fi
done
#
printf "\n\n\n"
exit $retVal
#
# eof
