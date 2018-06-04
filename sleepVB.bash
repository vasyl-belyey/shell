#! /bin/bash
#
# Functions:
#
# Init:
usageLine="$(basename "$0")"" nSeconds"
nSeconds="$1"
#
# Checks:
if [ "$nSeconds" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -lt 1 ]; then
	printUsage.bash "$usageLine" "Argument 1 nSeconds missing."
	exit 13
fi
#
if ! isInteger.bash "$nSeconds"; then
	printUsage.bash "$usageLine" "Argument 1 nSeconds must be integer (not '""$nSeconds""')"
	exit 13
fi
#
#
# Main:
tStart="$(date +%s)"
if ! isInteger.bash "$tStart"; then
	printUsage.bash "$usageLine" "tStart must be integer (not '""$tStart""')"
	exit 13
fi
# printf "\n\n\n\t\t\t'%s'\n\n\n" "$tStart"
tEnd=$((tStart + nSeconds))
if ! isInteger.bash "$tEnd"; then
	printUsage.bash "$usageLine" "tEnd must be integer (not '""$tEnd""')"
	exit 13
fi
# printf "\n\n\n\t\t\t'%s'\n\n\n" "$tEnd"
#
for((i=0; i<195713000; i++)) do
	tNow="$(date +%s)"
	if ! isInteger.bash "$tNow"; then
		printUsage.bash "$usageLine" "tNow must be integer (not '""$tNow""')"
		exit 13
	fi
	tLeft=$((tEnd - tNow))
	if ! isInteger.bash "$tLeft"; then
		printUsage.bash "$usageLine" "tLeft must be integer (not '""$tLeft""')"
		exit 13
	fi
	aColor=red
	if [ $tLeft -gt $((30*60)) ]; then
		aColor=green
	else
		if [ $tLeft -gt $((13*60)) ]; then
			aColor=yellow
		fi
	fi
	aMessage="\r\t\t\t\t\t\t\t""$(printSeconds.bash "$tLeft")"
	printColored.bash $aColor "$aMessage"
	#
	if [ $tLeft -le 0 ]; then
		break
	fi
	#
	answer=""
	read -t 1 -n 1 -s answer
	if [ "$answer" != "" ]; then
		break
	fi
done
printf "\n"
#
# END
# eof
