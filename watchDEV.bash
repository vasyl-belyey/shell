#! /bin/bash
#
# F
#
# Init:
usageLine="$(basename "$0")"" [-|suffix_after_tty [iTimeOut=1]];  press 'q' to quit."
arg1="$1"
CMD="ls /dev/tty""$arg1""*"
#
echo $#
if [ $# -gt 0 ] && [ "$arg1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
iTimeOut=1
if [ $# -gt 1 ]; then
	if isInteger.bash $2; then
		iTimeOut=$2
	else
		printUsage.bash "$usageLine" "iTimeOut parameter must be integer (not '$2' as given now)."
		exit 13
	fi
fi
answer=""
#while [ 1 -eq 1 ]; do
while [ "$answer" != "q" ]; do
	clear
	printf "\tDoing '%s' every %d seconds.  Press 'q' to quit.\n\n" "$CMD" $iTimeOut
	$CMD
	#sleep 1
	read -n 1 -t $iTimeOut -s answer
done
#
printf "\n\n\n\t\t\tBye, %s.\n\n\n" "$USER"
#
# eof
