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
#
dateTime() {
	echo "$(date -u +%Y-%m-%dT%H:%M:%S)"" UT"
}
#
getTime() {
	local retVal=0
	#
	echo $retVal
}
#
getPID() {
	local retVal=""
	retVal="$(ps -C "$cmdLine")"
	#
	echo $retVal
}
#
# Init:
usageLine="$(basename "$0")"" cmdLine [startTime=hh:mm:ss stopTime=hh:mm:ss]\n\n\tStarts cmdLine on startTime and kills it on stopTime."
myFileName="$(dirName.bash "$0")""/""$(basename "$0")"
zFileName="$myFileName"".times.txt"
#
printf "\n\n\n"
printColored green "\t\t\t""$myFileName"" started on ""$(dateTime)""\n\n\n"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if [ $# -lt 1 ]; then
	printUsage.bash "$usageLine" "cmdLine is missing."
	exit 13
fi
cmdLine="$1"
#
if [ $# -lt 3 ]; then
	if vTimes="$(zFile.bash read "$zFileName")"; then
													printColored yellow "vTimes = '""$vTimes""'\n"
		tStart="$(getTime "$vTimes")"
	else
		printUsage.bash "$usageLine" "startTime and stopTime must be given when run for the first time."
		exit 13
	fi
else
	startTime="$(getTime "$0")"
fi
#
# Main:
printColored yellow "zFileName = '""$zFileName""'\n"
printColored yellow "startTime = '""$startTime""'\n"
printColored yellow "cmdPID = '""$cmdPID""'\n"
#
for((iRun = 1;;iRun++)); do
	if [ -z "$cmdPID" ]; then
		"$cmdLine" &
		cmdPID="$getPID"
printColored yellow "cmdPID = '""$cmdPID""'\n"
	else
		cmdPID=""
printColored yellow "cmdPID = '""$cmdPID""'\n"
		break
	fi
done
#
# END
printColored red "\n\n\n\t\t\t""$myFileName"" exited on ""$(dateTime)""\n"
printf "\n\n\n"
# eof
