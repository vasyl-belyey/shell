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
. "$(vbShellDir.bash)""/isInteger.fun"
. "$(vbShellDir.bash)""/stringContains.fun"
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
. "$(vbShellDir.bash)""/printSeconds.fun"
. "$(vbShellDir.bash)""/printColored.fun"
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
#
tNow() {
	printf "%d\n" "$(date +"%s")"
}
#
tLeft() {
	printf "%d\n" $((tNext - $(tNow)))
}
#
# Init:
clear
printf "\n\n\n"
usageLine="$(basename "$0")"" periodSEC aCommandLine"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -lt 2 ]; then
	printUsage.bash "$usageLine" "Too few arguments."
	exit 13
fi
#
tPeriod=$1
if ! isInteger $tPeriod; then
	printUsage.bash "$usageLine" "periodSEC must be integer (now '""$tPeriod""')"
	exit 13
fi
#
shift; CMD="$*"
# printf "CMD = '%s'\n" "$CMD"; exit 13
if [ -z "$CMD" ]; then
	printUsage.bash "$usageLine" "Empty aCommandLine = '""$CMD""'."
	exit 13
fi
#
# Main:
tNext=$(tNow)
tNext=$((tNext + tPeriod))
for((count = 0;; count++)); do
	while [ $(tLeft) -gt 0 ]; do
		answer=""; read -rs -t1 -n1 answer
		if [ "$answer" = "q" ]; then printf "\n\n\n"; exit 0; fi
		printf "\rIn %s '%s'" "$(printSeconds $(tLeft))" "$CMD"
	done
	#
	printf "\n\n\n"
	eSpeakVB.bash $((count + 1))
	if ! $CMD; then printf "\n\n\n"; exit 13; fi
	#
	#
	# printf "count = %d\n" $count
	tNext=$((tNext + tPeriod))
done
#
# END
printf "\n\n\n"
# eof
