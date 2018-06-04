#! /bin/bash
#
# Functions:
#
. "doCMD.fun"
. "exists.fun"
. "askYN.fun"
. "askYNsilent.fun"
. "askProceed.fun"
. "printFile.fun"
. "isMac.fun"
. "isInteger.fun"
. "stringContains.fun"
. "indexOf.fun"
. "parseOption.fun"
. "printSeconds.fun"
. "printColored.fun"
. "printColoredOpt.fun"
. "isSudoer.fun"
. "lsofVB.fun"
. "cursorGoTo.fun"
. "paPlay.fun"
. "maxOf.fun"
. "minOf.fun"
. "dirName.fun"
# . "includeAll.fun"; (includeAll 2>/dev/null)
#
# Init:
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
# retVal=( $(gdrive list --max 0 --query "name = 'latest.png'" --name-width 0 --no-header) )
retVal=( $(gdrive list --max 0 --query "name = '$1'" --name-width 0 --no-header) )
for((i = 0; i < ${#retVal[*]}; i += 7)); do
	echo "${retVal[$i]}"
done
#
# END
# eof
