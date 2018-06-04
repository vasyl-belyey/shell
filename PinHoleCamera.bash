#! /bin/bash
#
if [ ! -d "$dirCameraPath" ]; then
	printf "\n\n\n\t\t\tdirCameraPath = '%s' does not exist.\n\n\n" "$dirCameraPath"
	exit 13
fi
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
. "$(vbShellDir.bash)""/indexOf.fun"
. "$(vbShellDir.bash)""/parseOption.fun"
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
# CMD="java -jar ""$HOME""/VBlibs/Apps/PinHoleCamera/PinHoleCamera.jar"
CMD="gnome-terminal -x ""java -jar ""$dirCameraPath""/PinHoleCamera.jar"
if [ $# -gt 0 ]; then CMD="$CMD"" ""$*"; fi
printf "\t\t\tRUNNING '%s' on '%s'\n\n" "$CMD" "$HOSTNAME"
sleep 13
$CMD
retCode=$?
printf "\t\t\tretCode=%d for '%s' on '%s'\n\n" $retCode "$CMD" "$HOSTNAME"
#
exit $retCode
# END
# eof
