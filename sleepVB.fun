#! /bin/bash
# if [ "$_" = "$0" ]; then return; fi
# if (sleepVB --nSEC 0 1>/dev/null 2>/dev/null); then return 0; fi
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
sleepVB() {
# Init:
local nameME=sleepVB
local usageLine="Initiate: . ${nameME}.fun\n\tUsage:\n${nameME} [-n nSEC] [-C aCommand]\n\n\tnSEC - to sleep (default 3)\n\taCommand - a command to run in bgr"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	return 13
fi
#
if ! nSEC=$(parseOption "-n" $*); then
	nSEC=3
fi
if ! isInteger "$nSEC" || [ $nSEC -lt 1 ]; then
	printUsage.bash "$usageLine" "Invalid argument -n = '$nSEC': must be positive integer." 1>&2
	return 13
fi
#
local aCommand="" t0=0 t=0
aCommand=$(parseOption "-C" $*)
#
# Main:
t0=$(date +%s); ((t0+=nSEC))
echo
if [ -z "${aCommand}" ]; then
	for((t=t0 - $(date +%s); t>=0; t=t0 - $(date +%s) )); do
		printColored red "\r$(printSeconds $t)                         "
		sleep 1
	done
fi
#
# END
echo
}
# eof
