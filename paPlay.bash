#! /bin/bash
#
# Functions:
#
# . "$(vbShellDir.bash)""/includeAll.fun"; (includeAll 2>/dev/null)
. "$(vbShellDir.bash)""/paPlay.fun"
#
# Init:
usageLine="$(basename "$0")"" [list of sound filename parts]"
#
# Checks:
if [ "$1" = "-" ]; then
	printUsage.bash "$usageLine"
	exit 13
fi
#
#
# Main:
paPlay $*
#
# END
# eof
