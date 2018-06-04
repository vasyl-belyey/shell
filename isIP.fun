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
isIP() {
# Init:
local usageLine=". isIP.fun\nisIP arg"" \n\n \
	returns 0 if arg can be an IP number or 13 otherwise.
\n"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	return 13
fi
#
local arg="$1"
#
# Main:
local count=0 i
for((i = 0; i < ${#arg}; i++)); do
	if [ "${arg:i:1}" = "." ]; then ((count++)); fi
done
if [ $count -ne 3 ]; then return 13; fi
#
}
# END
# eof
