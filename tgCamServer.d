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
. "isIP.fun"
. "name2ip.fun"
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
usageLine="$(basename "$0")"" [--ipME ipME(=\$tgCam00)] [-p portNo(=13717)]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
if ipME=$(parseOption "--ipME" $*); then
	if ! isIP "$ipME"; then ipME=$(name2ip "$ipME"); fi
else
	ipME=$tgCam00
fi
#
if ! portNo=$(parseOption "-p" $*) || ! isInteger "$portNo" || [ $portNo -le 0 ]; then
	portNo=13717
fi
#
# Main:
while sleep 5; do
	if ! pc=$(ps -C tgCamServer.bash); then
		(nohup tgCamServer.bash --ipME $ipME --port $portNo > /dev/null &)
	fi
done
#
# END
# eof
