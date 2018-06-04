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
. "$(vbShellDir.bash)""/printColoredOpt.fun"
. "$(vbShellDir.bash)""/isSudoer.fun"
. "$(vbShellDir.bash)""/lsofVB.fun"
. "$(vbShellDir.bash)""/cursorGoTo.fun"
. "$(vbShellDir.bash)""/paPlay.fun"
. "$(vbShellDir.bash)""/maxOf.fun"
. "$(vbShellDir.bash)""/minOf.fun"
. "$(vbShellDir.bash)""/plotLineVB.fun"
# . "$(vbShellDir.bash)""/includeAll.fun"; (includeAll 2>/dev/null)
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
case "$(uname -s)" in
	Darwin)
		open "/Applications/Android Studio.app"
	;;
	*)
		(/usr/local/android-studio/bin/studio.sh &)
		sleep 13
		(topVB.bash studio.sh)
	;;
esac
#
# END
# eof
