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
cursorBack() {
	printf "\033[""$1""D"
}
#
# Init:
clear
usageLine="$(basename "$0")"" [-p ipPrefix=10.0.0.] [-i minIPtoPing=0] [-n maxIPtoPing=400]""\n\tPings IPs.  Available - green, unavailable - red.\n\n\tPress q to quit."
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ! ipMin=$(parseOption "-i" $*); then ipMin=0; fi
if ! ipMax=$(parseOption "-n" $*); then ipMax=400; fi
if ! ipPrefix=$(parseOption "-p" $*); then ipPrefix="10.0.0."; fi
if [ "${ipPrefix: -1}" != "." ]; then ipPrefix=$ipPrefix.; fi
#
#
# Main:
printColored yellow "\n\n\t\t\tping-ing ""$ipPrefix""[""$ipMin""-""$ipMax""]"" ...\n"
for((i = ipMin; i <= ipMax; i++)); do
	#
	if [ $((i % 10)) -eq 0 ]; then printf "\n  "; fi
	answer=""; read -s -t1 -n1 answer; if [ "$answer" = "q" ]; then break; fi
	#
	ip="$ipPrefix""$i"
	printColored yellow "$ip"; cursorBack ${#ip}
	if (ping -c1 $ip 2>&1) > /dev/null; then
		printColored green "$ip""  "
	else
		printColored red "$ip""  "
	fi
	#
	if [ $((i % 100)) -eq 99 ]; then printf "\n"; fi
done
#
# END
printf "\n"
Beep.sh 1 done
# eof
