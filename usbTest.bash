#! /bin/bash
#
# Functions:
#
. "$(vbShellDir.bash)""/doCMD.fun"
. "$(vbShellDir.bash)""/exists.fun"
. "$(vbShellDir.bash)""/askYN.fun"
. "$(vbShellDir.bash)""/askYNsilent.fun"
. "$(vbShellDir.bash)""/askProceed.fun"
. "$(vbShellDir.bash)""/printFile.fun"
. "$(vbShellDir.bash)""/isMac.fun"
. "$(vbShellDir.bash)""/stringContains.fun"
#
# Init:
# clear
printf "\n\n\n"
usageLine="$(basename "$0")"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
fAgain=1
retCode=133
while [ $fAgain -ne 0 ]; do
	for((i = 0; i < 2; i++)); do
		filTEST=lsusb"$i".txt
		lsusb > "$filTEST"
		cat "$filTEST"
		if [ $i -eq 0 ]; then
			# askProceed "\t\t\tUSB list created.  Ready to proceed?" Silent
			while ! askYNsilent "\t\t\tUSB list created.  Ready to proceed?"; do
				printColored.bash yellow "\n\t\t\t\t\t\t\tOkay, waiting...\n"
			done
		fi
	done
	printf "\n\n\n"
	#
	if diff lsusb0.txt lsusb1.txt; then
		printColored.bash green "\n\t\t\t\t\t\t\tIDENTICAL!\n\n\n"
		if ! askYNsilent "\t\tTry again?"; then fAgain=0; fi
	else
		fAgain=0
		retCode=0
	fi
done
#
# END
printf "\n\n\n"
exit $retCode
# eof
