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
clear
usageLine="$(basename "$0")"" [dirToCleanOfFitsFiles]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
dateToday=$(date +%Y-%m-%d)
# printColored.bash red "\n\n\n\t\t\t dateToday = ""$dateToday""\n\n\n"
toRemove=$1$dateToday"*.fits"
# printColored.bash red "\n\n\n\t\t\t toRemove = ""$toRemove""\n\n\n"
#
# doCMD "ls ""$toRemove"
# CMD="ls ""$toRemove"" 2>/dev/null"
CMD="ls ""$toRemove"
retVal=$($CMD)
if [ $? -eq 0 ]; then
	printColored.bash magenta "\n\n\n""$retVal""\n\n\n"
	if askYNsilent "\t\t\tRemove all the ""$toRemove"" files?" "yn" 1; then
		doCMD "rm -v ""$toRemove"
	fi
else
	printColored.bash green "\n\n\n\t\t\t NOTHING toRemove: no ""$toRemove"" files.\n\n\n"
fi
#
# END
# eof
